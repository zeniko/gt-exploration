Class {
	#name : #ProcessingCompiler,
	#superclass : #Object,
	#instVars : [
		'builder'
	],
	#category : #'GtExploration-Experiments'
}

{ #category : #'as yet unclassified' }
ProcessingCompiler >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #accessing }
ProcessingCompiler >> compile: ast [
	builder := IRBuilder new.
	builder numArgs: 0.
	ast acceptVisitor: self.
	builder pushReceiver; returnTop.
	^ builder ir compiledMethod
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> emitBinaryOp: op lhs: left rhs: right [
	left acceptVisitor: self.
	right acceptVisitor: self.
	builder send: op asSymbol.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> emitFill: args [
	builder pushReceiver; pushDup.
	"TODO: instead of using #colorWithR:g:b: it should be possible to use pushLiteralVariable: Color; send: #r:g:b:"
	(args at: 1) acceptVisitor: self.
	(args at: 2) acceptVisitor: self.
	(args at: 3) acceptVisitor: self.
	builder send: #colorWithR:g:b:; send: #fill:; popTop.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> emitNumber: num [
	builder pushLiteral: num asNumber. 
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> emitRect: args [
	builder pushReceiver.
	(args at: 3) acceptVisitor: self.
	(args at: 4) acceptVisitor: self.
	(args at: 1) acceptVisitor: self.
	(args at: 2) acceptVisitor: self.
	builder send: #@; send: #rect:by:at:; popTop.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> emitSize: args [
	builder pushReceiver.
	(args at: 1) acceptVisitor: self.
	(args at: 2) acceptVisitor: self.
	builder send: #size:by:; popTop.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitBinaryExpression: expr [
	self emitBinaryOp: expr operator value lhs: expr left rhs: expr right.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitExpressionStatement: stmt [
	self visitSmaCCParseNode: stmt.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitFile: file [
	^ self visitSmaCCParseNode: file
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitFunctionCallExpression: fnCall [
	| name |
	name := fnCall receiver nameToken value.
	name = 'size' ifTrue: [ ^ self emitSize: fnCall arguments ].
	name = 'fill' ifTrue: [ ^ self emitFill: fnCall arguments ].
	name = 'rect' ifTrue: [ ^ self emitRect: fnCall arguments ].
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitNumber: num [
	self emitNumber: num numberToken value.
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitSmaCCParseNode: aSmaCCParseNode [
	^ self acceptNodes: aSmaCCParseNode children
]

{ #category : #'as yet unclassified' }
ProcessingCompiler >> visitVariableExpression: var [
	^ self visitSmaCCParseNode: var
]
