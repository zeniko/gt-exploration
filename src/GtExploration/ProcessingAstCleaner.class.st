Class {
	#name : #ProcessingAstCleaner,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #cleaning }
ProcessingAstCleaner class >> clean: anAst [
	^ anAst acceptVisitor: ProcessingAstCleaner new
]

{ #category : #visiting }
ProcessingAstCleaner >> notImplemented: expr [
	ProcessingNotImplementedException signal: ((expr class name removePrefix: 'Py') removeSuffix: 'Node') withTag: expr.
]

{ #category : #cleaning }
ProcessingAstCleaner >> replace: anExpr with: anotherExpr [
	| parent |
	parent := anExpr parent.
	parent nodeVariables
		select: [ :name | (parent perform: name) = anExpr ]
		thenDo: [ :name | parent perform: name , ':' with: anotherExpr. ].
	parent compositeNodeVariables
		select: [ :name | (parent perform: name) includes: anExpr ]
		thenDo: [ :name | (parent perform: name) at: ((parent perform: name) indexOf: anExpr) put: anotherExpr. ].
	^ anotherExpr
]

{ #category : #visiting }
ProcessingAstCleaner >> visitAssignmentStatement: stmt [
	"Rewrite a += b and friends to a = a + b for Smalltalk"
	stmt assigns size > 1 ifTrue: [ self notImplemented: stmt ].
	(stmt assigns first value size = 2) & (stmt assigns first value last = $=) ifTrue: [ | op |
		op := stmt assigns first value first asString.
		stmt tos at: 1 put: (PyBinaryExpressionNode new
			operator: (SmaCCToken value: op start: stmt assigns first startPosition ids: #());
			left: stmt lhs clone;
			right: stmt tos first
		).
		stmt assigns at: 1 put: (SmaCCToken value: '=' start: stmt assigns first stopPosition ids: #()).
	].
	^ self visitStatement: stmt
]

{ #category : #visiting }
ProcessingAstCleaner >> visitBinaryExpression: expr [
	"GtUnoptimizedConditionalAdvice suggests (a and (b and c)) instead of ((a and b) and c)"
	expr left acceptVisitor: self.
	expr right acceptVisitor: self.
	[ (#('and' 'or') includes: expr operator value) and: [
		(expr left isKindOf: PyBinaryExpressionNode) and: [ expr left operator value = expr operator value ]
	] ] whileTrue: [
		| a b c |
		a := expr left left.
		b := expr left right.
		c := expr right.
		expr right: expr left.
		expr left: a.
		expr right left: b.
		expr right right: c.
	].
	^ expr
]

{ #category : #visiting }
ProcessingAstCleaner >> visitReturnStatement: stmt [
	"Smalltalk doesn't expect statements after a return, so we omit them."
	| index |
	index := stmt parent statements indexOf: stmt.
	[ stmt parent statements size > index ] whileTrue: [
		stmt parent statements removeAt: index + 1.
	].
	^ self visitStatement: stmt
]

{ #category : #visiting }
ProcessingAstCleaner >> visitTupleExpression: expr [
	"PythonParser produces PyTupleExpressionNodes for parenthesized expressions. These nodes aren't necessary for the AST"
	expr expressions size = 1 ifFalse: [ self notImplemented: expr ].
	expr expressions first acceptVisitor: self.
	^ self replace: expr with: expr expressions first
]
