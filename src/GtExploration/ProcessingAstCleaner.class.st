"
This class is called by {{gtClass:ProcessingTranspiler}} before transpiling. It takes an AST as produced by {{gtClass:ProcessingParser}} and rewrites it to better match Python to Smalltalk syntax:
- assigning to multiple variables is converted into nested form (`a = b = 1` to `a = (b = 1)`)
- `if ...: ... elif ...: ... else: ...` chains are rewritten as nested `if ...: else: ...` chains
- chained boolean `and` and `or` operators are swapped from being left- to being right-associative
- commands after `return` are removed
"
Class {
	#name : #ProcessingAstCleaner,
	#superclass : #Object,
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #cleaning }
ProcessingAstCleaner class >> clean: anAst [
	^ anAst acceptVisitor: ProcessingAstCleaner new
]

{ #category : #visiting }
ProcessingAstCleaner >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : #visiting }
ProcessingAstCleaner >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : #visiting }
ProcessingAstCleaner >> acceptNodes: aCollection [
	aCollection do: [ :each | self acceptNode: each ].
	^ aCollection
]

{ #category : #visiting }
ProcessingAstCleaner >> notImplemented: expr [
	ProcessingNotImplementedException
		signal: 'Unsupported expression type: ' , ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
		withTag: expr
]

{ #category : #cleaning }
ProcessingAstCleaner >> replace: anExpr with: anotherExpr [
	| parent |
	parent := anExpr parent.
	parent nodeVariables
		select: [ :name | (parent perform: name) = anExpr ]
		thenDo: [ :name | parent perform: name , ':' with: anotherExpr ].
	parent compositeNodeVariables
		select: [ :name | (parent perform: name) includes: anExpr ]
		thenDo: [ :name | 
			(parent perform: name)
				at: ((parent perform: name) indexOf: anExpr)
				put: anotherExpr ].
	^ anotherExpr
]

{ #category : #generated }
ProcessingAstCleaner >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : #generated }
ProcessingAstCleaner >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : #generated }
ProcessingAstCleaner >> visitAssertStatement: anAssertStatement [
	^ self visitStatement: anAssertStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitAssignmentExpression: anAssignmentExpression [
	^ self visitExpression: anAssignmentExpression
]

{ #category : #visiting }
ProcessingAstCleaner >> visitAssignmentStatement: stmt [
	"Rewrite `a += b` and friends to `a = a + b` for Smalltalk compatibility.
	Rewrite `a = b = x` to `a = (b := x)`, as `b` isn't a rhs expression
	(cf. https://github.com/feenkcom/gtoolkit/issues/4669)."

	[ stmt assigns size > 1 ]
		whileTrue: [ | node |
			stmt assigns last value = '=' ifFalse: [ self notImplemented: stmt ].
			node := PyAssignmentStatementNode new
					tos: {stmt tos removeLast};
					lhs: stmt tos removeLast;
					assigns: {stmt assigns removeLast};
					parent: stmt.
			stmt tos add: node ].

	stmt assigns first value size = 2 & (stmt assigns first value last = $=)
		ifTrue: [ | op |
			op := stmt assigns first value first asString.
			stmt tos
				at: 1
				put: (PyBinaryExpressionNode new
						operator: (SmaCCToken
								value: op
								start: stmt assigns first startPosition
								ids: #());
						left: stmt lhs clone;
						right: stmt tos first;
						parent: stmt).
			stmt assigns
				at: 1
				put: (SmaCCToken
						value: '='
						start: stmt assigns first stopPosition
						ids: #()) ].
	^ self visitStatement: stmt
]

{ #category : #generated }
ProcessingAstCleaner >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : #visiting }
ProcessingAstCleaner >> visitBinaryExpression: expr [
	"GtUnoptimizedConditionalAdvice suggests (a and (b and c)) instead of ((a and b) and c)"

	expr left: (expr left acceptVisitor: self).
	expr right: (expr right acceptVisitor: self).
	[ (#('and' 'or') includes: expr operator value)
		and: [ (expr left isKindOf: PyBinaryExpressionNode)
				and: [ expr left operator value = expr operator value ] ] ]
		whileTrue: [ | a b c |
			a := expr left left.
			b := expr left right.
			c := expr right.
			expr right: expr left.
			expr left: a.
			expr right left: b.
			expr right right: c.
			a parent: expr.
			b parent: expr right.
			c parent: expr right ].
	^ self visitExpression: expr
]

{ #category : #generated }
ProcessingAstCleaner >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : #generated }
ProcessingAstCleaner >> visitComparisonExpression: aComparisonExpression [
	^ self visitBinaryExpression: aComparisonExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : #generated }
ProcessingAstCleaner >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : #generated }
ProcessingAstCleaner >> visitElif: anElif [
	^ self visitRoot: anElif
]

{ #category : #generated }
ProcessingAstCleaner >> visitEllipsis: anEllipsis [
	^ self visitExpression: anEllipsis
]

{ #category : #generated }
ProcessingAstCleaner >> visitElse: anElse [
	^ self visitRoot: anElse
]

{ #category : #generated }
ProcessingAstCleaner >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : #generated }
ProcessingAstCleaner >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : #generated }
ProcessingAstCleaner >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitExpression: anExpression [
	^ self visitRoot: anExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitExpressionStatement: anExpressionStatement [
	^ self visitStatement: anExpressionStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitFieldAccessExpression: aFieldAccessExpression [
	^ self visitExpression: aFieldAccessExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitFile: aFile [
	^ self visitRoot: aFile
]

{ #category : #generated }
ProcessingAstCleaner >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : #generated }
ProcessingAstCleaner >> visitForStatement: aForStatement [
	^ self visitStatement: aForStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitFunctionCallExpression: aFunctionCallExpression [
	^ self visitExpression: aFunctionCallExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitFunctionDefinition: aFunctionDefinition [
	^ self visitStatement: aFunctionDefinition
]

{ #category : #generated }
ProcessingAstCleaner >> visitGlobalStatement: aGlobalStatement [
	^ self visitStatement: aGlobalStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitIfExpression: anIfExpression [
	^ self visitExpression: anIfExpression
]

{ #category : #visiting }
ProcessingAstCleaner >> visitIfStatement: expr [
	"Turn a if: ... elif: ... else: ... chain into nested if: ... else: ... statements"

	[ expr elsifs notEmpty ]
		whileTrue: [ | node last innerElse |
			last := expr elsifs removeLast.
			innerElse := expr else.
			expr else: PyElseNode new.
			node := PyIfStatementNode new
					condition: last condition;
					statements: last statements;
					ifToken: last elifToken;
					colonToken: last colonToken;
					else: innerElse;
					attributeNamed: #startPosition put: last startPosition;
					yourself.
			expr else statements: {node} ].

	^ self visitStatement: expr
]

{ #category : #generated }
ProcessingAstCleaner >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : #generated }
ProcessingAstCleaner >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : #generated }
ProcessingAstCleaner >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitListExpression: aListExpression [
	^ self visitExpression: aListExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : #generated }
ProcessingAstCleaner >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : #generated }
ProcessingAstCleaner >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : #generated }
ProcessingAstCleaner >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : #generated }
ProcessingAstCleaner >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : #generated }
ProcessingAstCleaner >> visitNumber: aNumber [
	^ self visitExpression: aNumber
]

{ #category : #generated }
ProcessingAstCleaner >> visitParameter: aParameter [
	^ self visitRoot: aParameter
]

{ #category : #generated }
ProcessingAstCleaner >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : #generated }
ProcessingAstCleaner >> visitPassStatement: aPassStatement [
	^ self visitStatement: aPassStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : #visiting }
ProcessingAstCleaner >> visitReturnStatement: stmt [
	"Smalltalk doesn't expect statements after a return, so we omit them."

	| index |
	index := stmt parent statements indexOf: stmt.
	[ stmt parent statements size > index ]
		whileTrue: [ stmt parent statements removeAt: index + 1 ].
	^ self visitStatement: stmt
]

{ #category : #generated }
ProcessingAstCleaner >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : #generated }
ProcessingAstCleaner >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ProcessingAstCleaner >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : #visiting }
ProcessingAstCleaner >> visitSmaCCError: aSmaCCError [
	^ self visitSmaCCParseNode: aSmaCCError
]

{ #category : #visiting }
ProcessingAstCleaner >> visitSmaCCParseNode: aSmaCCParseNode [
	self acceptNodes: aSmaCCParseNode sortedChildren.
	^ aSmaCCParseNode
]

{ #category : #generated }
ProcessingAstCleaner >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitStatement: aStatement [
	^ self visitRoot: aStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitString: aString [
	^ self visitExpression: aString
]

{ #category : #generated }
ProcessingAstCleaner >> visitSubscriptExpression: aSubscriptExpression [
	^ self visitExpression: aSubscriptExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : #visiting }
ProcessingAstCleaner >> visitTupleExpression: expr [
	"PythonParser produces PyTupleExpressionNodes for parenthesized expressions. These nodes aren't necessary for the AST"

	expr expressions size = 1 ifFalse: [ self notImplemented: expr ].
	expr expressions first acceptVisitor: self.
	expr expressions first attributeNamed: #startPosition put: expr startPosition.
	expr expressions first attributeNamed: #stopPosition put: expr stopPosition.
	^ self replace: expr with: expr expressions first
]

{ #category : #generated }
ProcessingAstCleaner >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitUnaryExpression: anUnaryExpression [
	^ self visitExpression: anUnaryExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitVariableExpression: aVariableExpression [
	^ self visitExpression: aVariableExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitWhileStatement: aWhileStatement [
	^ self visitStatement: aWhileStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : #generated }
ProcessingAstCleaner >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
