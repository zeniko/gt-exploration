Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#category : #GtExploration
}

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #accessing }
ProcessingTranspiler >> compile: ast [
	| class source nl |
	"Turn the AST into a Smalltalk source string"
	nl := String with: (Character cr).
	source := 'drawOnto: canvas' , nl , (nl join: (ast acceptVisitor: self)).
	"TODO: temporary names?"
	ProcessingCodeBase
		subclass: #ProcessingCode01
		instanceVariableNames: ''
		classVariableNames: ''
		category: (self class category).
	class := Smalltalk at: #ProcessingCode01.
	class compile: source.
	^ (class perform: #new) setAst: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitFill: args [
	^ 'canvas fill: (Color r: ' , (args at: 1) , ' / 255.0 g: ' , (args at: 2) , ' / 255.0 b: ' , (args at: 3) , ' / 255.0).'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitRect: args [
	^ 'canvas rect: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitSize: args [
	^ 'canvas size: ' , (args at: 1) , ' by: ' , (args at: 2) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitBinaryExpression: expr [
	^ '(' ,(expr left acceptVisitor: self) , expr operator value , (expr right acceptVisitor: self) , ')'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	^ (self visitSmaCCParseNode: stmt) first
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitFile: file [
	^ self visitSmaCCParseNode: file
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitFunctionCallExpression: fnCall [
	| name args |
	name := fnCall receiver nameToken value.
	args := self acceptNodes: fnCall arguments.
	name = 'size' ifTrue: [ ^ self emitSize: args ].
	name = 'fill' ifTrue: [ ^ self emitFill: args ].
	name = 'rect' ifTrue: [ ^ self emitRect: args ].
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitNumber: num [
	^ num numberToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitSmaCCParseNode: aSmaCCParseNode [
	^ self acceptNodes: aSmaCCParseNode children
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitVariableExpression: var [
	^ self visitSmaCCParseNode: var
]
