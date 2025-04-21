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

{ #category : #visiting }
ProcessingTranspiler >> acceptNodes: nodes [
	^ nodes collect: [ :each | each acceptVisitor: self ]
]

{ #category : #visiting }
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

{ #category : #emitting }
ProcessingTranspiler >> appendLine: line [
	lines add: (String new: indentation withAll:(Character tab)) , line
]

{ #category : #compiling }
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

{ #category : #emitting }
ProcessingTranspiler >> emitBackground: args [
	^ '_canvas background: (_canvas colorWithR: ' , (args at: 1) , ' g: ' , (args at: 2) , ' b: ' , (args at: 3) , ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emitCos: args [
	^ (args at: 1) , ' cos'
]

{ #category : #emitting }
ProcessingTranspiler >> emitDelay: args [
	^ '(' , args first , ' / 1000.0) seconds wait'
]

{ #category : #emitting }
ProcessingTranspiler >> emitEllipse: args [
	^ '_canvas ellipse: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2)
]

{ #category : #emitting }
ProcessingTranspiler >> emitFill: args [
	^ '_canvas fill: (_canvas colorWithR: ' , (args at: 1) , ' g: ' , (args at: 2) , ' b: ' , (args at: 3) , ')'
]

{ #category : #emitting }
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

{ #category : #emitting }
ProcessingTranspiler >> emitLine: args [
	^ '_canvas line: ' , (args at: 1) , ' @ ' , (args at: 2) , ' to: ' , (args at: 3) , ' @ ' , (args at: 4)
]

{ #category : #emitting }
ProcessingTranspiler >> emitName: var [
	"Internal variables of ProcessingCodeBase start with a single underscore. Make sure that there's no accidental leakage by doubling a leading underscore."
	var first = $_ ifTrue: [ ^ '_' , var ].
	^ var
]

{ #category : #emitting }
ProcessingTranspiler >> emitRadians: args [
	^ (args at: 1) , ' degreesToRadians'
]

{ #category : #emitting }
ProcessingTranspiler >> emitRandom: args [
	^ '(SharedRandom globalGenerator next * ' , (args at: 1) , ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emitRect: args [
	^ '_canvas rect: ' , (args at: 3) , ' by: ' , (args at: 4) , ' at: ' , (args at: 1) , ' @ ' , (args at: 2)
]

{ #category : #emitting }
ProcessingTranspiler >> emitSin: args [
	^ (args at: 1) , ' sin'
]

{ #category : #emitting }
ProcessingTranspiler >> emitSize: args [
	^ 'width := ' , (args at: 1) , '. height := ' , (args at: 2) , '. _canvas size: width by: height'
]

{ #category : #emitting }
ProcessingTranspiler >> emitStroke: args [
	^ '_canvas stroke: (_canvas colorWithR: ' , (args at: 1) , ' g: ' , (args at: 2) , ' b: ' , (args at: 3) , ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emitStrokeWeight: args [
	^ '_canvas strokeWeight: ' , (args at: 1)
]

{ #category : #emitting }
ProcessingTranspiler >> emitTan: args [
	^ (args at: 1) , ' tan'
]

{ #category : #emitting }
ProcessingTranspiler >> emitText: args [
	^ '_canvas text: ' , (args at: 1) , ' at: ' , (args at: 2) , ' @ ' , (args at: 3)
]

{ #category : #emitting }
ProcessingTranspiler >> emitTextSize: args [
	^ '_canvas textSize: ' , (args at: 1)
]

{ #category : #emitting }
ProcessingTranspiler >> emitTriangle: args [
	^ '_canvas triangle: { ' , (args at: 1) , ' @ ' , (args at: 2) , '. ' , (args at: 3) , ' @ ' , (args at: 4) , '. ' , (args at: 5) , ' @ ' , (args at: 6) , '. }'
]

{ #category : #compiling }
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

{ #category : #compiling }
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
	self appendLine: (self emitFunctionDef: name with: args).
	self acceptStatements: ast.
	"TODO: assigning to an argument yields a '... is shadowed' warning in the Transcript"
	localVariables size > 0 ifTrue: [
		lines insert: (Character tab asString , '| ' , (' ' join: localVariables) , ' |') before: 2.
	].
	res := '
' join: lines.
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

{ #category : #visiting }
ProcessingTranspiler >> visitAssignmentExpression: expr [
	| name |
	name := self emitName: expr variable nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self appendLine: name , ' := ' , (expr value acceptVisitor: self) , '.'
]

{ #category : #visiting }
ProcessingTranspiler >> visitAssignmentStatement: expr [
	| name |
	name := self emitName: expr lhs nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self appendLine: name , ' := ' , (expr tos first acceptVisitor: self) , '.'
]

{ #category : #visiting }
ProcessingTranspiler >> visitBinaryExpression: expr [
	| op |
	op := expr operator value.
	"Python compares value equality with `==`, Smalltalk does with `=`"
	op = '==' ifTrue: [ op := '=' ].
	^ '(' ,(expr left acceptVisitor: self) , ' ' , op , ' ' , (expr right acceptVisitor: self) , ')'
]

{ #category : #visiting }
ProcessingTranspiler >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #visiting }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	(self acceptNodes: stmt children) do: [ :res |
		(res isKindOf: ProcessingTranspiler) ifFalse: [
			self appendLine: res , '.'.
		]
	]
]

{ #category : #visiting }
ProcessingTranspiler >> visitFile: file [
	self visitExpressionStatement: file
]

{ #category : #visiting }
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

{ #category : #visiting }
ProcessingTranspiler >> visitFunctionDefinition: def [
	| name args |
	name := def fname value.
	args := self acceptNodes: def parameters.
	functions := functions , '

' , (self transpileFunction: def name: name args: args).
]

{ #category : #visiting }
ProcessingTranspiler >> visitGlobalStatement: global [
	global nameTokens do: [ :token | globalVariables add: token value ].
]

{ #category : #visiting }
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

{ #category : #visiting }
ProcessingTranspiler >> visitNumber: num [
	^ num numberToken value
]

{ #category : #visiting }
ProcessingTranspiler >> visitParameter: param [
	^ param name nameToken value
]

{ #category : #visiting }
ProcessingTranspiler >> visitReturnStatement: expr [
	^ '^ ' , (self acceptNodes: expr expressions) first.
]

{ #category : #visiting }
ProcessingTranspiler >> visitString: expr [
	^ '''' , ('' join: (expr parts collect: [ :part | (part value allButFirst: 1) allButLast: 1 ])) , ''''
]

{ #category : #visiting }
ProcessingTranspiler >> visitVariableExpression: var [
	^ self emitName: var nameToken value
]

{ #category : #visiting }
ProcessingTranspiler >> visitWhileStatement: expr [
	self appendLine: '[ ' , (expr condition acceptVisitor: self) , ' ] whileTrue: ['.
	self acceptStatements: expr.
	self appendLine: '].'
]
