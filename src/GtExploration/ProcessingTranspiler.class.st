Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#instVars : [
		'lines',
		'globalVariables',
		'indentation',
		'functions',
		'localVariables',
		'userDefs'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> acceptStatements: expr [
	indentation := indentation + 1.
	expr statements do: [ :stmt |
		| res |
		res := stmt acceptVisitor: self.
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res
		].
	].
	indentation := indentation - 1.
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> appendLine: line [
	lines add: (String new: indentation withAll:(Character tab)) , line
]

{ #category : #accessing }
ProcessingTranspiler >> compile: ast [
	| class source |
	source := self transpile: ast.
	class := ProcessingCodeBase newAnonymousSubclass.
	localVariables do: [ :name | class addSlot: name ].
	(source splitOn: '

') do: [ :method | class compile: method ].
	^ class new
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitDelay: args [
	^ '(' , args first , ' / 1000.0) seconds wait.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitEllipse: args [
	^ 'canvas ellipse: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitFill: args [
	^ 'canvas fill: (Color r: ' , (args at: 1) , ' / 255.0 g: ' , (args at: 2) , ' / 255.0 b: ' , (args at: 3) , ' / 255.0).'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitFunctionDef: name with: args [
	| defLine argNo |
	defLine := name , ': canvas'.
	argNo := 1.
	[ argNo <= args size ] whileTrue: [
		defLine := defLine , ' arg' , argNo asString , ': ' , (args at: argNo).
		argNo := argNo + 1.
	].
	^ defLine
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
ProcessingTranspiler >> transpile: ast [
	"Turn the AST into a Smalltalk source string"
	globalVariables := Set new.
	localVariables := Set new.
	functions := ''.
	userDefs := ast statements select: [ :stmt | stmt isKindOf: PyFunctionDefinitionNode ] thenCollect: [ :stmt | stmt fname value ].
	lines := OrderedCollection new.
	indentation := 0.
	self appendLine: 'drawOnto: canvas'.
	indentation := indentation + 1.
	ast acceptVisitor: self.
	"TODO: only update the canvas at the end of drawOnto (avoid rendering artifacts)"
	^ ('
' join: lines) , functions
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> transpileFunction: ast named: name args: args [
	| globalLines globalIndentation res |
	"Preserve global state"
	localVariables do: [ :var | globalVariables add: var ].
	globalLines := lines.
	globalIndentation := indentation.
	
	localVariables := Set new.
	lines := OrderedCollection new.
	indentation := 0.
	self appendLine: ''.
	self appendLine: (self emitFunctionDef: name with: args).
	self acceptStatements: ast.
	localVariables size > 0 ifTrue: [
		lines insert: (Character tab , '| ' , (localVariables join: ' ') , ' |') at: 2.
	].
	res := '
' , ('
' join: lines).
	
	"Restore global state"
	indentation := globalIndentation.
	lines := globalLines.
	localVariables := globalVariables.
	^ res
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> userDefs [
	^ userDefs
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> variables [
	^ localVariables
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitAssignmentStatement: expr [
	| name |
	name := expr lhs nameToken value.
	localVariables add: name.
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
	name = 'ellipse' ifTrue: [ ^ self emitEllipse: args ].
	name = 'delay' ifTrue: [ ^ self emitDelay: args ].
	(userDefs includes: name) ifTrue: [ ^ 'self ' , (self emitFunctionDef: name with: args) ].
	ProcessingNotImplementedException new signal: 'Function ' , name , ' not implemented!'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitFunctionDefinition: def [
	| name args |
	name := def fname value.
	args := self acceptNodes: def parameters.
	^ self transpileFunction: def named: name args: args
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitIfStatement: expr [
	self appendLine: (expr condition acceptVisitor: self) , ' ifTrue: [ '.
	self acceptStatements: expr.
	self appendLine: '].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitNumber: num [
	^ num numberToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitParameter: param [
	^ param name nameToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitVariableExpression: var [
	^ var nameToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitWhileStatement: expr [
	self appendLine: '[ ' , (expr condition acceptVisitor: self) , ' ] whileTrue: [ '.
	self acceptStatements: expr.
	self appendLine: '].'
]
