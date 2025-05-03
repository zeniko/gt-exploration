Class {
	#name : #PythonTokenExtractor,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Tools'
}

{ #category : #building }
PythonTokenExtractor >> extractTokens: ast [
	^ ((ast acceptVisitor: self) collect: [ :item |
		(item isKindOf: PyRootNode) ifTrue: [
			self extractTokens: item
		] ifFalse: [
			item
		]
	]) deepFlatten
]

{ #category : #visiting }
PythonTokenExtractor >> visitAssignmentExpression: expr [
	^ { expr variable. expr assign. expr value. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitAssignmentStatement: stmt [
	^ { stmt lhs. stmt assigns first. stmt tos first. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitBinaryExpression: expr [
	^ { expr left. expr operator. expr right. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitElif: elif [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: elif elifToken.
	tokens add: elif condition.
	tokens add: elif colonToken.
	tokens addAll: elif statements.
	^ tokens
]

{ #category : #visiting }
PythonTokenExtractor >> visitElse: else [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: else elseToken.
	tokens add: else colonToken.
	tokens addAll: else statements.
	^ tokens
]

{ #category : #visiting }
PythonTokenExtractor >> visitExpression: expr [
	ProcessingNotImplementedException new tag: expr; signal: 'Unsupported expression type ' , expr asString
]

{ #category : #visiting }
PythonTokenExtractor >> visitExpressionStatement: stmt [
	^ stmt children
]

{ #category : #visiting }
PythonTokenExtractor >> visitFile: file [
	^ self visitExpressionStatement: file
]

{ #category : #visiting }
PythonTokenExtractor >> visitFunctionCallExpression: fnCall [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: fnCall receiver.
	tokens add: fnCall lparenToken.
	fnCall arguments ifNotEmpty: [
		1 to: fnCall arguments size - 1 do: [ :index |
			tokens add: (fnCall arguments at: index).
			tokens add: (fnCall commaTokens at: index).
		].
		tokens add: fnCall arguments last.
	].
	tokens add: fnCall rparenToken.
	^ tokens
]

{ #category : #visiting }
PythonTokenExtractor >> visitFunctionDefinition: def [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: def defToken.
	tokens add: def fname.
	tokens add: def lparenToken.
	def parameters ifNotEmpty: [
		1 to: def parameters size - 1 do: [ :index |
			tokens add: (def parameters at: index).
			tokens add: (def commaTokens at: index).
		].
		tokens add: def parameters last.
	].
	tokens add: def rparenToken.
	tokens add: def colonToken.
	tokens addAll: def statements.
	^ tokens
]

{ #category : #visiting }
PythonTokenExtractor >> visitGlobalStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt globalToken.
	1 to: stmt nameTokens size - 1 do: [ :index |
		tokens add: (stmt nameTokens at: index).
		tokens add: (stmt commaTokens at: index).
	].
	tokens add: stmt nameTokens last.
	^ tokens
]

{ #category : #visiting }
PythonTokenExtractor >> visitIfStatement: stmt [
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
PythonTokenExtractor >> visitNumber: expr [
	^ { expr numberToken. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitParameter: param [
	^ { param name nameToken. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitPassStatement: stmt [
	^ { stmt passToken. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitReturnStatement: stmt [
	stmt expressions ifEmpty: [ ^ { stmt returnToken. } ].
	^ { stmt returnToken. stmt expressions first. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitStatement: stmt [
	ProcessingNotImplementedException new tag: stmt; signal: 'Unsupported statement type ' , stmt asString
]

{ #category : #visiting }
PythonTokenExtractor >> visitString: expr [
	^ expr parts
]

{ #category : #visiting }
PythonTokenExtractor >> visitTupleExpression: expr [
	^ { expr lparenToken. expr expressions first. expr rparenToken. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitUnaryExpression: expr [
	^ { expr operator. expr expression }
]

{ #category : #visiting }
PythonTokenExtractor >> visitVariableExpression: expr [
	^ { expr nameToken. }
]

{ #category : #visiting }
PythonTokenExtractor >> visitWhileStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt whileToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]
