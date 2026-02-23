"
This translates a Processing/Python AST into a Algol68-style syntax.

E.g. `if True: assert 42` is translated to

`if (True) {`
`  assert(42);`
`}`

"
Class {
	#name : 'ProcessingTranspilerVariant2',
	#superclass : 'Object',
	#instVars : [
		'indentation'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> acceptNodes: aCollection [
	^ aCollection collect: [ :each | self acceptNode: each ]
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> acceptStatements: expr [
	| output |
	output := ''.
	indentation := indentation + 1.
	output := ''
			join: (expr statements
					collect: [ :stmt | 
						| res |
						res := stmt acceptVisitor: self.
						(res at: res size) = $} ifFalse: [ res := res , ';' ].
						self indent , res
							, '
' ]).
	indentation := indentation - 1.
	^ output
]

{ #category : 'emitting' }
ProcessingTranspilerVariant2 >> emit: name args: args [
	^ name , '(' , (', ' join: (args collect: [ :arg | arg acceptVisitor: self ]))
		, ')'
]

{ #category : 'emitting' }
ProcessingTranspilerVariant2 >> emitBlock: node [
	^ ' {
' , (self acceptStatements: node) , self indent , '}'
]

{ #category : 'emitting' }
ProcessingTranspilerVariant2 >> indent [
	^ String new: indentation - 1 withAll: Character tab
]

{ #category : 'error handling' }
ProcessingTranspilerVariant2 >> notImplemented: expr [
	ProcessingNotImplementedException
		signal: 'Unsupported expression type: ' , ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
		withTag: expr
]

{ #category : 'emitting' }
ProcessingTranspilerVariant2 >> transpile: anAst [
	indentation := 0.
	^ (ProcessingAstCleaner clean: anAst) acceptVisitor: self
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitAssertStatement: stmt [
	^ self emit: 'assert' args: stmt values
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitAssignmentExpression: expr [
	^ expr variable nameToken value , ' = ' , (expr value acceptVisitor: self)
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitAssignmentStatement: stmt [
	^ (' = ' join: (stmt variables collect: [ :var | var acceptVisitor: self ]))
		, ' = ' , (stmt value acceptVisitor: self)
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitBinaryExpression: expr [
	^ (expr left acceptVisitor: self) , ' ' , expr operator value , ' '
		, (expr right acceptVisitor: self)
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitElif: anElif [
	^ self visitRoot: anElif
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitEllipsis: expr [
	^ 'Ellipsis()'
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitElse: anElse [
	^ self visitRoot: anElse
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitExpression: expr [
	self notImplemented: expr
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitExpressionStatement: stmt [
	^ ' ' join: (stmt children collect: [ :part | part acceptVisitor: self ])
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitFieldAccessExpression: expr [
	^ (expr receiver acceptVisitor: self) , '.' , expr nameToken value
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitFile: file [
	^ self acceptStatements: file
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitForStatement: expr [
	expr exprs size = 1 ifFalse: [ self notImplemented: expr ].
	^ 'foreach (' , (expr exprs first acceptVisitor: self) , ': '
		, (expr inExpression acceptVisitor: self) , ')' , (self emitBlock: expr)
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitFunctionCallExpression: fnCall [
	^ self emit: (fnCall receiver acceptVisitor: self) args: fnCall arguments
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitFunctionDefinition: def [
	^ 'fn ' , def fname value , '('
		, (', ' join: (def parameters collect: [ :param | param acceptVisitor: self ]))
		, ')' , (self emitBlock: def)
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitGlobalStatement: global [
	^ 'global ' , (', ' join: (global nameTokens collect: #value))
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitIfExpression: expr [
	^ 'if (' , (expr condition acceptVisitor: self) , ') { '
		, (expr if acceptVisitor: self) , ' } else { '
		, (expr else acceptVisitor: self) , ' } '
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitIfStatement: expr [
	| output |
	self assert: expr elsifs isEmpty.	"cf. ProcessingAstCleaner>>visitIfStatement:"
	output := 'if (' , (expr condition acceptVisitor: self) , ')'
			, (self emitBlock: expr).
	expr else
		ifNotNil: [ output := output , ' else' , (self emitBlock: expr else) ].
	^ output
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitListExpression: list [
	^ self emit: 'new List' args: list expressions
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitNumber: num [
	^ num numberToken value
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitParameter: param [
	^ param name nameToken value
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitPassStatement: pass [
	^ ''
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitReturnStatement: expr [
	expr expressions size = 0 ifTrue: [ ^ 'return' ].
	expr expressions size > 1 ifTrue: [ self notImplemented: expr ].
	^ 'return ' , (expr expressions first acceptVisitor: self)
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitStatement: stmt [
	self notImplemented: stmt
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitString: expr [
	^ '"'
		, ('' join: (expr parts collect: [ :part | part value allButFirst allButLast ]))
		, '"'
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitSubscriptExpression: subscript [
	| slice |
	(subscript subscripts first isKindOf: PySliceNode)
		ifTrue: [ slice := ''.
			subscript subscripts first from
				ifNotNil: [ slice := slice , (subscript subscripts first from acceptVisitor: self) ].
			slice := slice , ':'.
			subscript subscripts first to
				ifNotNil: [ slice := slice , (subscript subscripts first to acceptVisitor: self) ].
			subscript subscripts first step
				ifNotNil: [ slice := slice , ':' , (subscript subscripts first step acceptVisitor: self) ] ]
		ifFalse: [ slice := subscript subscripts first acceptVisitor: self ].
	^ (subscript receiver acceptVisitor: self) , '[' , slice , ']'
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitTupleExpression: aTupleExpression [
	^ self visitExpression: aTupleExpression
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitUnaryExpression: expr [
	^ expr operator value , (expr expression acceptVisitor: self)
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitVariableExpression: var [
	^ var nameToken value
]

{ #category : 'visiting' }
ProcessingTranspilerVariant2 >> visitWhileStatement: expr [
	expr else ifNotNil: [ self notImplemented: expr ].
	^ 'while (' , (expr condition acceptVisitor: self) , ')'
		, (self emitBlock: expr)
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : 'generated' }
ProcessingTranspilerVariant2 >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
