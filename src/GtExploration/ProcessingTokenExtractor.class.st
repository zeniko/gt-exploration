"
This is a helper class used for extracting individual tokens from a Processing/Python AST produced by {{gtClass:ProcessingParser}}.
"
Class {
	#name : 'ProcessingTokenExtractor',
	#superclass : 'Object',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'visiting' }
ProcessingTokenExtractor >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> acceptNodes: aCollection [
	aCollection do: [ :each | self acceptNode: each ].
	^ aCollection
]

{ #category : 'building' }
ProcessingTokenExtractor >> add: values separatedBy: commas to: tokens [
	1
		to: values size - 1
		do: [ :index | 
			tokens add: (values at: index).
			tokens add: (commas at: index) ].
	tokens add: values last
]

{ #category : 'building' }
ProcessingTokenExtractor >> extractTokens: ast [
	^ ((ast acceptVisitor: self)
		collect: [ :item | 
			(item isKindOf: PyRootNode)
				ifTrue: [ self extractTokens: item ]
				ifFalse: [ item ] ]) deepFlatten
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitAssertStatement: stmt [
	stmt values size = 1
		ifTrue: [ ^ {stmt assertToken.
				stmt values first} ].
	^ {stmt assertToken.
		stmt values first.
		stmt values second}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitAssignmentExpression: expr [
	^ {expr variable.
		expr assign.
		expr value}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitAssignmentStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	1
		to: stmt variables size
		do: [ :i | 
			tokens add: (stmt variables at: i).
			tokens add: (stmt assigns at: i) ].
	tokens add: stmt value.
	^ tokens
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitBinaryExpression: expr [
	^ {expr left.
		expr operator.
		expr right}
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitComparisonExpression: expr [
	| tokens chain |
	tokens := OrderedCollection new.
	tokens add: expr left.
	tokens add: expr operator.
	chain := expr right.
	[ chain isKindOf: PyComparisonExpressionNode ]
		whileTrue: [ tokens add: chain left.
			tokens add: chain operator.
			chain := chain right ].
	tokens add: chain.
	^ tokens
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitElif: elif [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: elif elifToken.
	tokens add: elif condition.
	tokens add: elif colonToken.
	tokens addAll: elif statements.
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitEllipsis: expr [
	^ {expr ellipsis}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitElse: else [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: else elseToken.
	tokens add: else colonToken.
	tokens addAll: else statements.
	^ tokens
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitExpression: expr [
	ProcessingNotImplementedException new
		tag: expr;
		signal: 'Unsupported expression type ' , expr asString
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitExpressionStatement: stmt [
	^ stmt children
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitFieldAccessExpression: expr [
	^ {expr receiver.
		expr periodToken.
		expr nameToken}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitFile: file [
	^ self visitExpressionStatement: file
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitForStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt forToken.
	self
		add: stmt exprs
		separatedBy: stmt commaTokens
		to: tokens.
	tokens add: stmt inToken.
	tokens add: stmt inExpression.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitFunctionCallExpression: fnCall [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: fnCall receiver.
	tokens add: fnCall lparenToken.
	fnCall arguments
		ifNotEmpty: [ self
				add: fnCall arguments
				separatedBy: fnCall commaTokens
				to: tokens ].
	tokens add: fnCall rparenToken.
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitFunctionDefinition: def [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: def defToken.
	tokens add: def fname.
	tokens add: def lparenToken.
	def parameters
		ifNotEmpty: [ self
				add: def parameters
				separatedBy: def commaTokens
				to: tokens ].
	tokens add: def rparenToken.
	tokens add: def colonToken.
	tokens addAll: def statements.
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitGlobalStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt globalToken.
	self
		add: stmt nameTokens
		separatedBy: stmt commaTokens
		to: tokens.
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitIfExpression: expr [
	^ {expr if.
		expr ifToken.
		expr condition.
		expr elseToken.
		expr else}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitIfStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt ifToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	stmt elsifs ifNotNil: [ tokens addAll: stmt elsifs ].
	stmt else ifNotNil: [ tokens add: stmt else ].
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitImportStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt importToken.
	self
		add: stmt names
		separatedBy: stmt commaTokens
		to: tokens.
	^ tokens
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitListExpression: list [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: list lbrackToken.
	list expressions
		ifNotEmpty: [ self
				add: list expressions
				separatedBy: list commaTokens
				to: tokens ].
	tokens add: list rbrackToken.
	^ tokens
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitNumber: expr [
	^ {expr numberToken}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitParameter: param [
	^ {param name nameToken}
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitPassStatement: stmt [
	^ {stmt passToken}
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitReturnStatement: stmt [
	stmt expressions ifEmpty: [ ^ {stmt returnToken} ].
	^ {stmt returnToken.
		stmt expressions first}
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitSlice: slice [
	| tokens |
	tokens := OrderedCollection new.
	slice from ifNotNil: [ tokens add: slice from ].
	tokens add: slice colonTokens first.
	slice to ifNotNil: [ tokens add: slice to ].
	slice colonTokens size = 2
		ifTrue: [ tokens add: slice colonTokens second.
			slice step ifNotNil: [ tokens add: slice step ] ].
	^ tokens
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitSmaCCError: aSmaCCError [
	^ self visitSmaCCParseNode: aSmaCCError
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitSmaCCParseNode: aSmaCCParseNode [
	self acceptNodes: aSmaCCParseNode sortedChildren.
	^ aSmaCCParseNode
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitStatement: stmt [
	ProcessingNotImplementedException new
		tag: stmt;
		signal: 'Unsupported statement type ' , stmt asString
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitString: expr [
	^ expr parts
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitSubscriptExpression: subscript [
	^ {subscript receiver.
		subscript lbrackToken.
		subscript subscripts first.
		subscript rbrackToken}
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitTupleExpression: expr [
	^ {expr lparenToken.
		expr expressions first.
		expr rparenToken}
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitUnaryExpression: expr [
	^ {expr operator.
		expr expression}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitVariableExpression: expr [
	^ {expr nameToken}
]

{ #category : 'visiting' }
ProcessingTokenExtractor >> visitWhileStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt whileToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : 'generated' }
ProcessingTokenExtractor >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
