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

{ #category : #visitor }
ProcessingTranspiler >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #visitor }
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

{ #category : #emitter }
ProcessingTranspiler >> appendLine: line [
	lines add: (String new: indentation withAll:(Character tab)) , line
]

{ #category : #compiler }
ProcessingTranspiler >> compile: ast [
	| class source |
	source := self transpile: ast.
	class := ProcessingCodeBase newAnonymousSubclass.
	class addSlot: '_canvas'.
	globalVariables do: [ :name | class addSlot: name ].
	(source splitOn: '

') do: [ :method | class compile: method ].
	^ class new
]

{ #category : #emitter }
ProcessingTranspiler >> emitBackground: args [
	^ '_canvas background: (Color r: ' , (args at: 1) , ' / 255.0 g: ' , (args at: 2) , ' / 255.0 b: ' , (args at: 3) , ' / 255.0)'
]

{ #category : #emitter }
ProcessingTranspiler >> emitCos: args [
	^ (args at: 1) , ' cos'
]

{ #category : #emitter }
ProcessingTranspiler >> emitDelay: args [
	^ '(' , args first , ' / 1000.0) seconds wait'
]

{ #category : #emitter }
ProcessingTranspiler >> emitEllipse: args [
	^ '_canvas ellipse: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2)
]

{ #category : #emitter }
ProcessingTranspiler >> emitFill: args [
	^ '_canvas fill: (_canvas colorWithR: ' , (args at: 1) , ' g: ' , (args at: 2) , ' b: ' , (args at: 3) , ')'
]

{ #category : #emitter }
ProcessingTranspiler >> emitFunctionDef: name with: args [
	| defLine argNames |
	args size = 0 ifTrue: [ ^ name ].
	defLine := name , ': ' , (args at: 1).
	argNames := userDefs at: name.
	2 to: args size do: [ :argNo |
		defLine := defLine , ' '  , (argNames at: argNo) , ': ' , (args at: argNo).
	].
	^ defLine
]

{ #category : #emitter }
ProcessingTranspiler >> emitLine: args [
	^ '_canvas line: ' , (args at: 1) , ' @ ' , (args at: 2) , ' to: ' , (args at: 3) , ' @ ' , (args at: 4)
]

{ #category : #emitter }
ProcessingTranspiler >> emitName: var [
	"Internal variables of ProcessingCodeBase start with a single underscore. Make sure that there's no accidental leakage by doubling a leading underscore."
	var first = $_ ifTrue: [ ^ '_' , var ].
	^ var
]

{ #category : #emitter }
ProcessingTranspiler >> emitRadians: args [
	^ (args at: 1) , ' degreesToRadians'
]

{ #category : #emitter }
ProcessingTranspiler >> emitRandom: args [
	^ '(SharedRandom globalGenerator next * ' , (args at: 1) , ')'
]

{ #category : #emitter }
ProcessingTranspiler >> emitRect: args [
	^ '_canvas rect: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2)
]

{ #category : #emitter }
ProcessingTranspiler >> emitSin: args [
	^ (args at: 1) , ' sin'
]

{ #category : #emitter }
ProcessingTranspiler >> emitSize: args [
	^ 'width := ' , (args at: 1) , '. height := ' , (args at: 2) , '. _canvas size: width by: height'
]

{ #category : #emitter }
ProcessingTranspiler >> emitStroke: args [
	^ '_canvas stroke: (_canvas colorWithR: ' , (args at: 1) , ' g: ' , (args at: 2) , ' b: ' , (args at: 3) , ')'
]

{ #category : #emitter }
ProcessingTranspiler >> emitStrokeWeight: args [
	^ '_canvas strokeWeight: ' , (args at: 1)
]

{ #category : #emitter }
ProcessingTranspiler >> emitTan: args [
	^ (args at: 1) , ' tan'
]

{ #category : #emitter }
ProcessingTranspiler >> emitText: args [
	^ '_canvas text: ' , (args at: 1) , ' at: ' , (args at: 2) , ' @ ' , (args at: 3)
]

{ #category : #emitter }
ProcessingTranspiler >> emitTextSize: args [
	^ '_canvas textSize: ' , (args at: 1)
]

{ #category : #emitter }
ProcessingTranspiler >> emitTriangle: args [
	^ '_canvas triangle: { ' , (args at: 1) , ' @ ' , (args at: 2) , '. ' , (args at: 3) , ' @ ' , (args at: 4) , '. ' , (args at: 5) , ' @ ' , (args at: 6) , '. }'
]

{ #category : #compiler }
ProcessingTranspiler >> transpile: ast [
	"Turn the AST into a Smalltalk source string"
	globalVariables := Set new.
	localVariables := Set new.
	functions := ''.
	
	"Prepare implicit globals"
	globalVariables add: 'width'.
	globalVariables add: 'height'.
	"Collect the signatures of user defined functions."
	userDefs := Dictionary new.
	ast statements select: [ :stmt | stmt isKindOf: PyFunctionDefinitionNode ] thenDo: [ :stmt |
		| args |
		args := self acceptNodes: stmt parameters.
		userDefs at: stmt fname value put: args.
	].
	
	lines := OrderedCollection new.
	indentation := 0.
	self appendLine: '_run'.
	indentation := indentation + 1.
	ast acceptVisitor: self.
	
	localVariables do: [ :var | globalVariables add: var ].
	
	"TODO: only update the canvas at the end of a draw phase (avoid rendering artifacts)"
	^ ('
' join: lines) , functions
]

{ #category : #compiler }
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
	"TODO: functions seem to end on a double dot."
	res := res copyFrom: 1 to: res size - 1.
	globalVariables do: [ :var | saveGlobalVariables add: var ].
	
	"Restore global state"
	indentation := saveIndentation.
	lines := saveLines.
	globalVariables := saveGlobalVariables.
	localVariables := saveLocalVariables.
	^ res
]

{ #category : #accessing }
ProcessingTranspiler >> userDefs [
	^ userDefs
]

{ #category : #accessing }
ProcessingTranspiler >> variables [
	"This doesn't contain implicit globals such as `width` and `height`."
	^ localVariables
]

{ #category : #visitor }
ProcessingTranspiler >> visitAssignmentExpression: expr [
	| name |
	name := self emitName: expr variable nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self appendLine: name , ' := ' , (expr value acceptVisitor: self) , '.'
]

{ #category : #visitor }
ProcessingTranspiler >> visitAssignmentStatement: expr [
	| name |
	name := self emitName: expr lhs nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self appendLine: name , ' := ' , (expr tos first acceptVisitor: self) , '.'
]

{ #category : #visitor }
ProcessingTranspiler >> visitBinaryExpression: expr [
	| op |
	op := expr operator value.
	"Python compares value equality with `==`, Smalltalk does with `=`"
	op = '==' ifTrue: [ op := '=' ].
	^ '(' ,(expr left acceptVisitor: self) , ' ' , op , ' ' , (expr right acceptVisitor: self) , ')'
]

{ #category : #visitor }
ProcessingTranspiler >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #visitor }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	(self acceptNodes: stmt children) do: [ :res |
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res , '.'.
		]
	]
]

{ #category : #visitor }
ProcessingTranspiler >> visitFile: file [
	self visitExpressionStatement: file
]

{ #category : #visitor }
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
	name = 'stroke' ifTrue: [ ^ self emitStroke: args ].
	name = 'strokeWeight' ifTrue: [ ^ self emitStrokeWeight: args ].
	name = 'text' ifTrue: [ ^ self emitText: args ].
	name = 'textSize' ifTrue: [ ^ self emitTextSize: args ].
	name = 'tan' ifTrue: [ ^ self emitTan: args ].
	name = 'triangle' ifTrue: [ ^ self emitTriangle: args ].
	(userDefs includesKey: name) ifTrue: [ ^ '(self ' , (self emitFunctionDef: name with: args) , ')' ].
	ProcessingNotImplementedException new signal: 'Function ' , name , ' not implemented!'
]

{ #category : #visitor }
ProcessingTranspiler >> visitFunctionDefinition: def [
	| name args |
	name := def fname value.
	args := self acceptNodes: def parameters.
	^ self transpileFunction: def name: name args: args
]

{ #category : #visitor }
ProcessingTranspiler >> visitGlobalStatement: global [
	global nameTokens do: [ :token | globalVariables add: token value ].
]

{ #category : #visitor }
ProcessingTranspiler >> visitIfStatement: expr [
	self appendLine: (expr condition acceptVisitor: self) , ' ifTrue: ['.
	self acceptStatements: expr.
	expr elsifs ifNotNil: [
		expr elsifs do: [ :elif |
			self appendLine: '] ifFalse: ['.
			indentation := indentation + 1.
			self appendLine: (elif condition acceptVisitor: self) , ' ifTrue: ['.
			self acceptStatements: elif.
		].
	].
	expr else ifNotNil: [
		self appendLine: '] ifFalse: ['.
		self acceptStatements: expr else.
	].
	expr elsifs ifNotNil: [
		expr elsifs do: [ :elif |
			self appendLine: '].'.
			indentation := indentation - 1.
		].
	].
	self appendLine: '].'
]

{ #category : #visitor }
ProcessingTranspiler >> visitNumber: num [
	^ num numberToken value
]

{ #category : #visitor }
ProcessingTranspiler >> visitParameter: param [
	^ param name nameToken value
]

{ #category : #visitor }
ProcessingTranspiler >> visitReturnStatement: expr [
	^ '^ ' , (self acceptNodes: expr expressions) first.
]

{ #category : #visitor }
ProcessingTranspiler >> visitString: expr [
	^ '''' , ('' join: (expr parts collect: [ :part | (part value allButFirst: 1) allButLast: 1 ])) , ''''
]

{ #category : #visitor }
ProcessingTranspiler >> visitVariableExpression: var [
	^ self emitName: var nameToken value
]

{ #category : #visitor }
ProcessingTranspiler >> visitWhileStatement: expr [
	self appendLine: '[ ' , (expr condition acceptVisitor: self) , ' ] whileTrue: ['.
	self acceptStatements: expr.
	self appendLine: '].'
]
