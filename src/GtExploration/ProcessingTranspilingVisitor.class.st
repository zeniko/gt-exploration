Class {
	#name : #ProcessingTranspilingVisitor,
	#superclass : #Object,
	#category : #GtExploration
}

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> emitFill: args [
	^ 'canvas fill: (Color r: ' , (args at: 1) , ' / 255.0 g: ' , (args at: 2) , ' / 255.0 b: ' , (args at: 3) , ' / 255.0).'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> emitRect: args [
	^ 'canvas rect: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> emitSize: args [
	^ 'canvas size: ' , (args at: 1) , ' by: ' , (args at: 2) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitBinaryExpression: expr [
	^ '(' ,(expr left acceptVisitor: self) , expr operator value , (expr right acceptVisitor: self) , ')'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitExpressionStatement: stmt [
	^ (self visitSmaCCParseNode: stmt) first
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitFile: file [
	^ self visitSmaCCParseNode: file
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitFunctionCallExpression: fnCall [
	| name args |
	name := fnCall receiver nameToken value.
	args := self acceptNodes: fnCall arguments.
	name = 'size' ifTrue: [ ^ self emitSize: args ].
	name = 'fill' ifTrue: [ ^ self emitFill: args ].
	name = 'rect' ifTrue: [ ^ self emitRect: args ].
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitNumber: num [
	^ num numberToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitSmaCCParseNode: aSmaCCParseNode [
	^ self acceptNodes: aSmaCCParseNode children
]

{ #category : #'as yet unclassified' }
ProcessingTranspilingVisitor >> visitVariableExpression: var [
	^ self visitSmaCCParseNode: var
]
