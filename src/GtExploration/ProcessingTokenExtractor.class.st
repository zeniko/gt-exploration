Class {
	#name : #ProcessingTokenExtractor,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #building }
ProcessingTokenExtractor >> add: values separatedBy: commas to: tokens [
	1 to: values size - 1 do: [ :index |
		tokens add: (values at: index).
		tokens add: (commas at: index).
	].
	tokens add: values last.
]

{ #category : #building }
ProcessingTokenExtractor >> extractTokens: ast [
	^ ((ast acceptVisitor: self) collect: [ :item |
		(item isKindOf: PyRootNode) ifTrue: [
			self extractTokens: item
		] ifFalse: [
			item
		]
	]) deepFlatten
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitAssignmentExpression: expr [
	^ { expr variable. expr assign. expr value. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitAssignmentStatement: stmt [
	^ { stmt lhs. stmt assigns first. stmt tos first. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitBinaryExpression: expr [
	^ { expr left. expr operator. expr right. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitComparisonExpression: expr [
	| tokens chain |
	tokens := OrderedCollection new.
	tokens add: expr left.
	tokens add: expr operator.
	chain := expr right.
	[ chain isKindOf: PyComparisonExpressionNode ] whileTrue: [
		tokens add: chain left.
		tokens add: chain operator.
		chain := chain right.
	].
	tokens add: chain.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitElif: elif [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: elif elifToken.
	tokens add: elif condition.
	tokens add: elif colonToken.
	tokens addAll: elif statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitEllipsis: expr [
	^ { expr ellipsis. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitElse: else [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: else elseToken.
	tokens add: else colonToken.
	tokens addAll: else statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitExpression: expr [
	ProcessingNotImplementedException new tag: expr; signal: 'Unsupported expression type ' , expr asString
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitExpressionStatement: stmt [
	^ stmt children
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitFile: file [
	^ self visitExpressionStatement: file
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitForStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt forToken.
	self add: stmt exprs separatedBy: stmt commaTokens to: tokens.
	tokens add: stmt inToken.
	tokens add: stmt inExpression.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitFunctionCallExpression: fnCall [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: fnCall receiver.
	tokens add: fnCall lparenToken.
	fnCall arguments ifNotEmpty: [
		self add: fnCall arguments separatedBy: fnCall commaTokens to: tokens.
	].
	tokens add: fnCall rparenToken.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitFunctionDefinition: def [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: def defToken.
	tokens add: def fname.
	tokens add: def lparenToken.
	def parameters ifNotEmpty: [
		self add: def parameters separatedBy: def commaTokens to: tokens.
	].
	tokens add: def rparenToken.
	tokens add: def colonToken.
	tokens addAll: def statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitGlobalStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt globalToken.
	self add: stmt nameTokens separatedBy: stmt commaTokens to: tokens.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitIfExpression: expr [
	^ { expr if. expr ifToken. expr condition. expr elseToken. expr else. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitIfStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt ifToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	stmt elsifs ifNotNil: [ tokens addAll: stmt elsifs. ].
	stmt else ifNotNil: [ tokens add: stmt else. ].
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitNumber: expr [
	^ { expr numberToken. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitParameter: param [
	^ { param name nameToken. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitPassStatement: stmt [
	^ { stmt passToken. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitReturnStatement: stmt [
	stmt expressions ifEmpty: [ ^ { stmt returnToken. } ].
	^ { stmt returnToken. stmt expressions first. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitStatement: stmt [
	ProcessingNotImplementedException new tag: stmt; signal: 'Unsupported statement type ' , stmt asString
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitString: expr [
	^ expr parts
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitTupleExpression: expr [
	^ { expr lparenToken. expr expressions first. expr rparenToken. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitUnaryExpression: expr [
	^ { expr operator. expr expression }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitVariableExpression: expr [
	^ { expr nameToken. }
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitWhileStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt whileToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]
