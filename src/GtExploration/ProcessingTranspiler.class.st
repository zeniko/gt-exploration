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
ProcessingTranspiler >> emitBackground: args [
	^ 'canvas background: (Color r: ' , (args at: 1) , ' / 255.0 g: ' , (args at: 2) , ' / 255.0 b: ' , (args at: 3) , ' / 255.0)'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitCos: args [
	^ '(' , (args at: 1) , ' cos)'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitDelay: args [
	^ '(' , args first , ' / 1000.0) seconds wait'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitEllipse: args [
	^ 'canvas ellipse: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2)
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitFill: args [
	^ 'canvas fill: (Color r: ' , (args at: 1) , ' / 255.0 g: ' , (args at: 2) , ' / 255.0 b: ' , (args at: 3) , ' / 255.0)'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitFunctionDef: name with: args [
	| defLine argNames |
	defLine := name , ': canvas'.
	argNames := userDefs at: name.
	1 to: args size do: [ :argNo |
		defLine := defLine , ' '  , (argNames at: argNo) , ': ' , (args at: argNo).
	].
	^ defLine
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitLine: args [
	^ 'canvas line: ' , (args at: 1) , ' @ ' , (args at: 2) , ' to: ' , (args at: 3) , ' @ ' , (args at: 4)
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitRadians: args [
	^ '(' , (args at: 1) , ' * Float pi / 180)'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitRandom: args [
	^ '(SharedRandom globalGenerator next * ' , (args at: 1) , ')'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitRect: args [
	^ 'canvas rect: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2)
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitSin: args [
	^ '(' , (args at: 1) , ' sin)'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitSize: args [
	^ 'canvas size: ' , (args at: 1) , ' by: ' , (args at: 2)
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitTan: args [
	^ '(' , (args at: 1) , ' tan)'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitText: args [
	^ 'canvas text: ' , (args at: 1) , ' at: ' , (args at: 2) , ' @ ' , (args at: 3)
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitTextSize: args [
	^ 'canvas textSize: ' , (args at: 1)
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> emitTriangle: args [
	^ 'canvas triangle: { ' , (args at: 1) , ' @ ' , (args at: 2) , '. ' , (args at: 3) , ' @ ' , (args at: 4) , '. ' , (args at: 5) , ' @ ' , (args at: 6) , '. }'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> transpile: ast [
	"Turn the AST into a Smalltalk source string"
	globalVariables := Set new.
	localVariables := Set new.
	functions := ''.
	
	userDefs := Dictionary new.
	ast statements select: [ :stmt | stmt isKindOf: PyFunctionDefinitionNode ] thenDo: [ :stmt |
		| args |
		args := self acceptNodes: stmt parameters.
		userDefs at: stmt fname value put: args.
	].
	
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
ProcessingTranspiler >> transpileFunction: ast name: name args: args [
	| saveLocalVariables saveGlobalVariables saveLines saveIndentation res |
	"Preserve global state"
	saveLocalVariables := localVariables.
	saveGlobalVariables := globalVariables.
	saveLines := lines.
	saveIndentation := indentation.
	
	localVariables := Set new.
	globalVariables := Set new.
	lines := OrderedCollection new.
	indentation := 0.
	self appendLine: ''.
	self appendLine: (self emitFunctionDef: name with: args).
	self acceptStatements: ast.
	localVariables size > 0 ifTrue: [
		lines insert: (Character tab asString , '| ' , (' ' join: localVariables) , ' |') before: 3.
	].
	res := '
' , ('
' join: lines).
	globalVariables do: [ :var | saveGlobalVariables add: var ].
	
	"Restore global state"
	indentation := saveIndentation.
	lines := saveLines.
	globalVariables := saveGlobalVariables.
	localVariables := saveLocalVariables.
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
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self appendLine: name , ' := ' , (expr tos first acceptVisitor: self) , '.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitBinaryExpression: expr [
	| op |
	op := expr operator value.
	"Python compares value equality with `==`, Smalltalk does with `=`"
	op = '==' ifTrue: [ op := '=' ].
	^ '(' ,(expr left acceptVisitor: self) , ' ' , op , ' ' , (expr right acceptVisitor: self) , ')'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	(self acceptNodes: stmt children) do: [ :res |
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res , '.'.
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
	name = 'background' ifTrue: [ ^ self emitBackground: args ].
	name = 'cos' ifTrue: [ ^ self emitCos: args ].
	name = 'delay' ifTrue: [ ^ self emitDelay: args ].
	name = 'ellipse' ifTrue: [ ^ self emitEllipse: args ].
	name = 'fill' ifTrue: [ ^ self emitFill: args ].
	name = 'line' ifTrue: [ ^ self emitLine: args ].
	name = 'radians' ifTrue: [ ^ self emitRadians: args ].
	name = 'random' ifTrue: [ ^ self emitRandom: args ].
	name = 'rect' ifTrue: [ ^ self emitRect: args ].
	name = 'sin' ifTrue: [ ^ self emitSin: args ].
	name = 'size' ifTrue: [ ^ self emitSize: args ].
	name = 'text' ifTrue: [ ^ self emitText: args ].
	name = 'textSize' ifTrue: [ ^ self emitTextSize: args ].
	name = 'tan' ifTrue: [ ^ self emitTan: args ].
	name = 'triangle' ifTrue: [ ^ self emitTriangle: args ].
	(userDefs includesKey: name) ifTrue: [ ^ '(self ' , (self emitFunctionDef: name with: args) , ')' ].
	ProcessingNotImplementedException new signal: 'Function ' , name , ' not implemented!'
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitFunctionDefinition: def [
	| name args |
	name := def fname value.
	args := self acceptNodes: def parameters.
	^ self transpileFunction: def name: name args: args
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitGlobalStatement: global [
	global nameTokens do: [ :token | globalVariables add: token value ].
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitIfStatement: expr [
	self appendLine: (expr condition acceptVisitor: self) , ' ifTrue: ['.
	self acceptStatements: expr.
	expr else ifNotNil: [
		self appendLine: '] ifFalse: ['.
		self acceptStatements: expr else.
	].
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
ProcessingTranspiler >> visitReturnStatement: expr [
	^ '^ ' , (self acceptNodes: expr expressions) first.
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitString: expr [
	^ '''' , ('' join: (expr parts collect: [ :part | (part value allButFirst: 1) allButLast: 1 ])) , ''''
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitVariableExpression: var [
	^ var nameToken value
]

{ #category : #'as yet unclassified' }
ProcessingTranspiler >> visitWhileStatement: expr [
	self appendLine: '[ ' , (expr condition acceptVisitor: self) , ' ] whileTrue: ['.
	self acceptStatements: expr.
	self appendLine: '].'
]
