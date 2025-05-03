Class {
	#name : #PythonASTBuilder,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#instVars : [
		'tokens',
		'stack'
	],
	#category : #'GtExploration-Tools'
}

{ #category : #building }
PythonASTBuilder >> addToken: tok [
	tokens add: tok.
	stack last add: tok.
]

{ #category : #building }
PythonASTBuilder >> extractTokens: ast [
	tokens := OrderedCollection new.
	stack := OrderedCollection new.
	self pushNode: ast named: 'Root'.
	ast acceptVisitor: self.
	^ tokens
]

{ #category : #building }
PythonASTBuilder >> extractTree: ast [
	tokens := OrderedCollection new.
	stack := OrderedCollection new.
	self pushNode: ast named: 'Root'.
	ast acceptVisitor: self.
	^ stack removeLast
]

{ #category : #building }
PythonASTBuilder >> popNode [
	| node |
	node := stack removeLast.
	^ stack last add: node
]

{ #category : #building }
PythonASTBuilder >> pushNode: aNode named: aName [
	^ stack add: (OrderedCollection new add: aNode -> aName; yourself)
]

{ #category : #building }
PythonASTBuilder >> transform: ast [
	tokens := OrderedCollection new.
	stack := OrderedCollection new.
	self pushNode: ast named: 'Root'.
	ast acceptVisitor: self.
	^ { tokens. stack removeLast. }
]

{ #category : #visiting }
PythonASTBuilder >> visitAssignmentExpression: expr [
	self pushNode: expr named: 'Assignment'.
	expr variable acceptVisitor: self.
	self addToken: expr assign.
	expr value acceptVisitor: self.
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitAssignmentStatement: stmt [
	self pushNode: stmt named: 'Assignment'.
	stmt lhs acceptVisitor: self.
	self addToken: stmt assigns first.
	stmt tos first acceptVisitor: self.
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitBinaryExpression: expr [
	self pushNode: expr named: 'Binary Op'.
	expr left acceptVisitor: self.
	self addToken: expr operator.
	expr right acceptVisitor: self.
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitExpression: expr [
	ProcessingNotImplementedException new tag: expr; signal: 'Unsupported expression type ' , expr asString
]

{ #category : #visiting }
PythonASTBuilder >> visitExpressionStatement: stmt [
	self pushNode: stmt named: 'Expressions'.
	stmt children do: [ :part | part acceptVisitor: self ].
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitFunctionCallExpression: fnCall [
	self pushNode: fnCall named: 'Function Call'.
	fnCall receiver acceptVisitor: self.
	self addToken: fnCall lparenToken.
	fnCall arguments ifNotEmpty: [
		1 to: fnCall arguments size - 1 do: [ :index |
			(fnCall arguments at: index) acceptVisitor: self.
			self addToken: (fnCall commaTokens at: index).
		].
		fnCall arguments last acceptVisitor: self.
	].
	self addToken: fnCall rparenToken.
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitFunctionDefinition: def [
	self pushNode: def named: 'Function Definition'.
	self addToken: def defToken.
	self addToken: def fname.
	self addToken: def lparenToken.
	def parameters ifNotEmpty: [
		1 to: def parameters size - 1 do: [ :index |
			(def parameters at: index) acceptVisitor: self.
			self addToken: (def commaTokens at: index).
		].
		def parameters last acceptVisitor: self.
	].
	self addToken: def rparenToken.
	self addToken: def colonToken.
	def statements do: [ :part | part acceptVisitor: self. ].
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitGlobalStatement: stmt [
	self pushNode: stmt named: 'Global Variables'.
	self addToken: stmt globalToken.
	1 to: stmt nameTokens size - 1 do: [ :index |
		self addToken: (stmt nameTokens at: index).
		self addToken: (stmt commaTokens at: index).
	].
	self addToken: stmt nameTokens last.
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitIfStatement: stmt [
	self pushNode: stmt named: 'If Condition'.
	self addToken: stmt ifToken.
	stmt condition acceptVisitor: self.
	self addToken: stmt colonToken.
	stmt statements do: [ :part | part acceptVisitor: self. ].
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitNumber: expr [
	self addToken: expr numberToken.
]

{ #category : #visiting }
PythonASTBuilder >> visitPassStatement: stmt [
	self addToken: stmt passToken.
]

{ #category : #visiting }
PythonASTBuilder >> visitReturnStatement: stmt [
	self pushNode: stmt named: 'Return'.
	self addToken: stmt returnToken.
	stmt expressions ifNotEmpty: [
		stmt expressions first acceptVisitor: self.
	].
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitStatement: stmt [
	ProcessingNotImplementedException new tag: stmt; signal: 'Unsupported statement type ' , stmt asString
]

{ #category : #visiting }
PythonASTBuilder >> visitString: expr [
	expr parts do: [ :part | self addToken: part ].
]

{ #category : #visiting }
PythonASTBuilder >> visitTupleExpression: expr [
	self pushNode: expr named: 'Tuple'.
	self addToken: expr lparenToken.
	expr expressions first acceptVisitor: self.
	self addToken: expr rparenToken.
	self popNode.
]

{ #category : #visiting }
PythonASTBuilder >> visitUnaryExpression: expr [
	self addToken: expr operator.
	expr expression acceptVisitor: self.
]

{ #category : #visiting }
PythonASTBuilder >> visitVariableExpression: expr [
	self addToken: expr nameToken.
]

{ #category : #visiting }
PythonASTBuilder >> visitWhileStatement: stmt [
	self pushNode: stmt named: 'While Loop'.
	self addToken: stmt whileToken.
	stmt condition acceptVisitor: self.
	self addToken: stmt colonToken.
	stmt statements do: [ :part | part acceptVisitor: self. ].
	self popNode.
]
