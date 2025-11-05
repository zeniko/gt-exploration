"
This translates a Processing/Python AST into an artificial Lisp-like prefix or Postscript-like postfix language for educational purposes.

E.g. `print(22)` is translated to either `22 print` (postfix) or `(print 22)` (prefix).
"
Class {
	#name : #ProcessingTranspilerVariant,
	#superclass : #Object,
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#instVars : [
		'indentation',
		'style'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingTranspilerVariant class >> postfix [
	^ ProcessingTranspilerVariant new style: 'postfix'
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> prefix [
	^ ProcessingTranspilerVariant new style: 'prefix'
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> smalltalk [
	^ ProcessingTranspiler new
]

{ #category : #visiting }
ProcessingTranspilerVariant >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : #visiting }
ProcessingTranspilerVariant >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : #visiting }
ProcessingTranspilerVariant >> acceptNodes: aCollection [
	^ aCollection collect: [ :each | self acceptNode: each ]
]

{ #category : #visiting }
ProcessingTranspilerVariant >> acceptStatements: expr [
	| output |
	output := ''.
	indentation := indentation + 1.
	output := ''
			join: (expr statements
					collect: [ :stmt | 
						self indent , (stmt acceptVisitor: self)
							, '
' ]).
	indentation := indentation - 1.
	^ output
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emit: op args: args [
	^ style = 'postfix'
		ifTrue: [ ('' join: (args collect: [ :arg | arg , ' ' ])) , op ]
		ifFalse: [ '(' , op , ('' join: (args collect: [ :arg | ' ' , arg ])) , ')' ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitBlockCond: args [
	^ style = 'postfix' ifTrue: [ '{ ' , args , ' }' ] ifFalse: [ args ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitBlockDo: args [
	^ style = 'postfix'
		ifTrue: [ '{
' , args , self indent , '}' ]
		ifFalse: [ '(do
' , args , self indent , ')' ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitCall: name size: size [
	| defaultSizes |
	defaultSizes := {'background' -> 3.
			'color' -> 3.
			'cos' -> 1.
			'delay' -> 1.
			'ellipse' -> 4.
			'fill' -> 3.
			'frameRate' -> 1.
			'image' -> 5.
			'int' -> 1.
			'line' -> 4.
			'loadImage' -> 1.
			'max' -> 2.
			'millis' -> 0.
			'min' -> 2.
			'noStroke' -> 0.
			'print' -> 1.
			'println' -> 1.
			'radians' -> 1.
			'random' -> 1.
			'randomSeed' -> 1.
			'rect' -> 4.
			'reverse' -> 1.
			'reversed' -> 1.
			'rotate' -> 1.
			'scale' -> 1.
			'sin' -> 1.
			'size' -> 2.
			'sort' -> 1.
			'sorted' -> 1.
			'sqrt' -> 1.
			'str' -> 1.
			'stroke' -> 3.
			'strokeWeight' -> 1.
			'tan' -> 1.
			'text' -> 3.
			'textSize' -> 1.
			'translate' -> 2.
			'triangle' -> 6.
			'assert' -> 1.
			'global' -> 1.
			'list' -> 0.
			'range' -> 2} asDictionary.
	style = 'postfix'
		ifTrue: [ size = (defaultSizes at: name ifAbsent: size)
				ifFalse: [ ^ name , '_' , size asString ] ].
	^ name
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitField: field of: obj [
	^ style = 'postfix'
		ifTrue: [ obj , ' ' , field ]
		ifFalse: [ '(' , obj , ' ' , field , ')' ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitSymbol: name [
	^ style = 'postfix' ifTrue: [ '$' , name ] ifFalse: [ name ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> indent [
	^ String new: indentation - 1 withAll: Character tab
]

{ #category : #'error handling' }
ProcessingTranspilerVariant >> notImplemented: expr [
	ProcessingNotImplementedException
		signal: 'Unsupported expression type: ' , ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
		withTag: expr
]

{ #category : #accessing }
ProcessingTranspilerVariant >> style [
	^ style
]

{ #category : #accessing }
ProcessingTranspilerVariant >> style: anObject [
	style := anObject
]

{ #category : #emitting }
ProcessingTranspilerVariant >> transpile: anAst [
	indentation := 0.
	^ (ProcessingAstCleaner clean: anAst) acceptVisitor: self
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssertStatement: stmt [
	^ self
		emit: (self emitCall: 'assert' size: stmt values size)
		args: (self acceptNodes: stmt values)
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssignmentExpression: expr [
	^ self
		emit: '='
		args: {self emitSymbol: expr variable nameToken value.
				expr value acceptVisitor: self}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssignmentStatement: stmt [
	^ self visitAssignmentStatement: stmt part: 1
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssignmentStatement: stmt part: ix [
	| varExpr |
	ix > stmt variables size ifTrue: [ ^ stmt value acceptVisitor: self ].

	varExpr := stmt variables at: ix.
	(varExpr isKindOf: PySubscriptExpressionNode)
		ifTrue: [ ^ self
				emit: 'put_at'
				args: {varExpr receiver acceptVisitor: self.
						varExpr subscripts first acceptVisitor: self.
						self visitAssignmentStatement: stmt part: ix + 1} ].

	(varExpr isKindOf: PyVariableExpressionNode)
		ifFalse: [ self notImplemented: stmt ].
	^ self
		emit: (stmt assigns at: ix) value
		args: {self emitSymbol: varExpr nameToken value.
				self visitAssignmentStatement: stmt part: ix + 1}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitBinaryExpression: expr [
	^ self
		emit: expr operator value
		args: {expr left acceptVisitor: self.
				expr right acceptVisitor: self}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitElif: anElif [
	^ self visitRoot: anElif
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitEllipsis: expr [
	^ '...'
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitElse: anElse [
	^ self visitRoot: anElse
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitExpression: expr [
	self notImplemented: expr
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitExpressionStatement: stmt [
	^ ' ' join: (stmt children collect: [ :part | part acceptVisitor: self ])
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFieldAccessExpression: expr [
	^ self emitField: expr nameToken value of: (expr receiver acceptVisitor: self)
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFile: file [
	^ self acceptStatements: file
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitForStatement: expr [
	expr exprs size = 1 ifFalse: [ self notImplemented: expr ].
	(expr exprs first isKindOf: PyVariableExpressionNode)
		ifFalse: [ self notImplemented: expr ].
	expr else ifNotNil: [ self notImplemented: expr ].
	^ self
		emit: 'for_in'
		args: {self emitSymbol: expr exprs first nameToken value.
				expr inExpression acceptVisitor: self.
				self emitBlockDo: (self acceptStatements: expr)}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFunctionCallExpression: fnCall [
	^ self
		emit: (self
				emitCall: (fnCall receiver acceptVisitor: self)
				size: fnCall arguments size)
		args: (self acceptNodes: fnCall arguments)
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFunctionDefinition: def [
	^ self
		emit: 'deffun'
		args: {self emitSymbol: def fname value.
				'('
					, (' ' join: (def parameters collect: [ :param | param acceptVisitor: self ]))
					, ')'.
				self emitBlockDo: (self acceptStatements: def)}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitGlobalStatement: global [
	^ self
		emit: (self emitCall: 'global' size: global nameTokens size)
		args: (global nameTokens collect: [ :token | self emitSymbol: token value ])
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitIfExpression: expr [
	^ self
		emit: 'ifelse'
		args: {expr condition acceptVisitor: self.
				expr if acceptVisitor: self.
				expr else acceptVisitor: self}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitIfStatement: expr [
	| output |
	self assert: expr elsifs isEmpty.	"cf. ProcessingAstCleaner>>visitIfStatement:"
	output := expr else
			ifNotNil: [ self emitBlockDo: (self acceptStatements: expr else) ]
			ifNil: [ style = 'postfix' ifTrue: [ self emitBlockCond: 'pass' ] ifFalse: [ '' ] ].
	output := self
			emit: 'ifelse'
			args: {self emitBlockCond: (expr condition acceptVisitor: self).
					self emitBlockDo: (self acceptStatements: expr).
					output}.
	^ output
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitListExpression: list [
	^ self
		emit: (self emitCall: 'list' size: list expressions size)
		args: (self acceptNodes: list expressions)
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitNumber: num [
	^ num numberToken value
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitParameter: param [
	^ self emitSymbol: param name nameToken value
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitPassStatement: pass [
	^ self emit: 'pass' args: #()
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitReturnStatement: expr [
	expr expressions size = 0 ifTrue: [ ^ self emit: 'return' args: #('None') ].
	expr expressions size > 1 ifTrue: [ self notImplemented: expr ].
	^ self emit: 'return' args: {expr expressions first acceptVisitor: self}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitStatement: stmt [
	self notImplemented: stmt
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitString: expr [
	^ '"'
		, ('' join: (expr parts collect: [ :part | part value allButFirst allButLast ]))
		, '"'
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitSubscriptExpression: subscript [
	(subscript subscripts first isKindOf: PySliceNode)
		ifTrue: [ ^ self
				emit: 'slice'
				args: {subscript receiver acceptVisitor: self.
						subscript subscripts first from
							ifNotNil: [ subscript subscripts first from acceptVisitor: self ]
							ifNil: [ 'None' ].
						subscript subscripts first to
							ifNotNil: [ subscript subscripts first to acceptVisitor: self ]
							ifNil: [ 'None' ].
						subscript subscripts first step
							ifNotNil: [ subscript subscripts first step acceptVisitor: self ]
							ifNil: [ 'None' ]} ].
	^ self
		emit: 'item'
		args: (self
				acceptNodes: {subscript receiver.
						subscript subscripts first})
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitTupleExpression: aTupleExpression [
	^ self visitExpression: aTupleExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitUnaryExpression: expr [
	| op |
	op := expr operator value.
	style = 'postfix' & (op size = 1) ifTrue: [ op := 'unary' , op ].
	^ self emit: op args: {expr expression acceptVisitor: self}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitVariableExpression: var [
	^ var nameToken value
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitWhileStatement: expr [
	expr else ifNotNil: [ self notImplemented: expr ].
	^ self
		emit: 'while'
		args: {self emitBlockCond: (expr condition acceptVisitor: self).
				self emitBlockDo: (self acceptStatements: expr)}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
