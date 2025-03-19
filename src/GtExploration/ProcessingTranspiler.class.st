Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#instVars : [
		'lines',
		'variables',
		'indentation'
	],
	#category : #'GtExploration-Transpiler'
}

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> appendLine: line [
	lines add: (String new: indentation withAll:(Character tab)) , line
]

{ #category : #accessing }
ProcessingTranspiler >> compile: ast [
	| class source nl |
	"Turn the AST into a Smalltalk source string"
	nl := String with: (Character cr).
	variables := Set new.
	lines := OrderedCollection new.
	indentation := 0.
	self appendLine: 'drawOnto: canvas'.
	indentation := indentation + 1.
	ast acceptVisitor: self.
	source := nl join: lines.
	"TODO: temporary names?"
	ProcessingCodeBase
		subclass: #ProcessingCode01
		instanceVariableNames: (' ' join: variables)
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
ProcessingTranspiler >> visitAssignmentStatement: expr [
	| name |
	name := expr lhs nameToken value.
	variables add: name.
	self appendLine: name , ' := ' , (expr tos first acceptVisitor: self) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitBinaryExpression: expr [
	^ '(' ,(expr left acceptVisitor: self) , expr operator value , (expr right acceptVisitor: self) , ')'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	(self acceptNodes: stmt children) do: [ :res |
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res.
		]
	]
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitFile: file [
	self visitExpressionStatement: file
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
ProcessingTranspiler >> visitIfStatement: expr [
	self appendLine: (expr condition acceptVisitor: self) , ' ifTrue: [ '.
	indentation := indentation + 1.
	expr statements do: [ :stmt |
		| res |
		res := stmt acceptVisitor: self.
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res
		].
	].
	indentation := indentation - 1.
	self appendLine: '].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitNumber: num [
	^ num numberToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitVariableExpression: var [
	^ var nameToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitWhileStatement: expr [
	self appendLine: '[ ' , (expr condition acceptVisitor: self) , ' ] whileTrue: [ '.
	indentation := indentation + 1.
	expr statements do: [ :stmt |
		| res |
		res := stmt acceptVisitor: self.
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res.
		].
	].
	indentation := indentation - 1.
	self appendLine: '].'
]
