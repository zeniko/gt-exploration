Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#instVars : [
		'globalVariables',
		'indentation',
		'functions',
		'localVariables',
		'userDefs',
		'astMap',
		'astMaps',
		'output',
		'nodeStack'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #visiting }
ProcessingTranspiler >> acceptStatements: expr [
	indentation := indentation + 1.
	expr statements do: [ :stmt |
		| res |
		res := stmt acceptVisitor: self.
		(res isKindOf: Number) ifTrue: [
			res > 0 ifTrue: [ self emit: '.
'. ].
		].
	].
	indentation := indentation - 1.
]

{ #category : #compiling }
ProcessingTranspiler >> compile: ast [
	| class source instance _astMaps |
	source := self transpile: ast.
	class := ProcessingCodeBase newAnonymousSubclass.
	class addSlot: '_canvas'.
	class addSlot: '_astMaps'.
	globalVariables do: [ :name | class addSlot: name ].
	(source splitOn: '

') do: [ :method | class compile: method ].
	_astMaps := OrderedCollection new.
	class methodDict keysDo: [ :key |
		(astMaps at: key asString) do: [ :slice |
			_astMaps add: (slice cloneFor: class >> key).
		].
	].
	instance := class new.
	instance instVarNamed: #_astMaps put: _astMaps.
	^ instance
]

{ #category : #emitting }
ProcessingTranspiler >> emit: part [
	"Indent new lines."
	(output = '' or: (output endsWith: '
')) ifTrue: [
		nodeStack select: [ :node | node startPos = (output size + 1) ] thenDo: [ :node | node move: indentation ].
		output := output , (String new: indentation withAll: Character tab).
	].
	
	output := output , part.
]

{ #category : #emitting }
ProcessingTranspiler >> emitBackground: args [
	self emit: '_canvas background: (_canvas colorWithR: '.
	args first acceptVisitor: self.
	self emit: ' g: '.
	args second acceptVisitor: self.
	self emit: ' b: '.
	args third acceptVisitor: self.
	self emit: ')'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitCos: args [
	args first acceptVisitor: self.
	self emit: ' cos'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitDelay: args [
	self emit: '('.
	args first acceptVisitor: self.
	self emit: ' / 1000.0) seconds wait'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitEllipse: args [
	self emit: '_canvas ellipse: '.
	args third acceptVisitor: self.
	self emit: ' by: '.
	args fourth acceptVisitor: self.
	self emit: ' at: '.
	args first acceptVisitor: self.
	self emit: ' @ '.
	args second acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitFill: args [
	self emit: '_canvas fill: (_canvas colorWithR: '.
	args first acceptVisitor: self.
	self emit: ' g: '.
	args second acceptVisitor: self.
	self emit: ' b: '.
	args third acceptVisitor: self.
	self emit: ')'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitFunctionDef: name with: args [
	self emitName: name.
	args size > 0 ifTrue: [
		| argNames |
		argNames := userDefs at: name.
		self emit: ': '.
		args first acceptVisitor: self.
		2 to: args size do: [ :argNo |
			self emit: ' ', (argNames at: argNo) , ': '.
			(args at: argNo) acceptVisitor: self.
		].
	].
]

{ #category : #emitting }
ProcessingTranspiler >> emitLine: args [
	self emit: '_canvas line: '.
	args first acceptVisitor: self.
	self emit: ' @ '.
	args second acceptVisitor: self.
	self emit: ' to: '.
	args third acceptVisitor: self.
	self emit: ' @ '.
	args fourth acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitName: var [
	"Internal variables of ProcessingCodeBase start with a single underscore. Make sure that there's no accidental leakage by doubling a leading underscore."
	var first = $_ ifTrue: [ self emit: '_' , var. ^ '_' , var ].
	self emit: var.
	^ var
]

{ #category : #emitting }
ProcessingTranspiler >> emitPrint: args [
	args size > 1 ifTrue: [
		self emit: '_canvas print: { '.
		args do: [ :arg |
			arg acceptVisitor: self.
			self emit: '. '.
		].
		self emit: ' }'.
	] ifFalse: [
		self emit: '_canvas print: '.
		args first acceptVisitor: self.
	].
]

{ #category : #emitting }
ProcessingTranspiler >> emitRadians: args [
	args first acceptVisitor: self.
	self emit: ' degreesToRadians'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitRandom: args [
	self emit: '(SharedRandom globalGenerator next * '.
	args first acceptVisitor: self.
	self emit: ')'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitRect: args [
	self emit: '_canvas rect: '.
	args third acceptVisitor: self.
	self emit: ' by: '.
	args fourth acceptVisitor: self.
	self emit: ' at: '.
	args first acceptVisitor: self.
	self emit: ' @ '.
	args second acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitSin: args [
	args first acceptVisitor: self.
	self emit: ' sin'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitSize: args [
	self emit: 'width := '.
	args first acceptVisitor: self.
	self emit:'. height := '.
	args second acceptVisitor: self.
	self emit: '. _canvas size: width by: height'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitStroke: args [
	self emit: '_canvas stroke: (_canvas colorWithR: '.
	args first acceptVisitor: self.
	self emit: ' g: '.
	args second acceptVisitor: self.
	self emit: ' b: '.
	args third acceptVisitor: self.
	self emit: ')'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitStrokeWeight: args [
	self emit: '_canvas strokeWeight: '.
	args first acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitTan: args [
	args first acceptVisitor: self.
	self emit: ' tan'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitText: args [
	self emit: '_canvas text: '.
	args first acceptVisitor: self.
	self emit: ' at: '.
	args second acceptVisitor: self.
	self emit: ' @ '.
	args third acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitTextSize: args [
	self emit: '_canvas textSize: '.
	args first acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitTriangle: args [
	self emit: '_canvas triangle: { '.
	args first acceptVisitor: self.
	self emit: ' @ '.
	args second acceptVisitor: self.
	self emit: '. '.
	args third acceptVisitor: self.
	self emit: ' @ '.
	args fourth acceptVisitor: self.
	self emit: '. '.
	args fifth acceptVisitor: self.
	self emit: ' @ '.
	args sixth acceptVisitor: self.
	self emit: '. }'.
]

{ #category : #emitting }
ProcessingTranspiler >> endEmit [
	| node |
	node := nodeStack removeLast.
	node setEnd: output size.
	^ node size
]

{ #category : #emitting }
ProcessingTranspiler >> startEmit: node [
	| slice |
	slice := ProcessingTranspilationSlice link: node from: output size + 1.
	astMap add: slice.
	nodeStack add: slice.
	^ slice
]

{ #category : #compiling }
ProcessingTranspiler >> transpile: ast [
	"Turn the AST into a Smalltalk source string"
	globalVariables := Set new.
	localVariables := Set new.
	functions := ''.
	astMaps := Dictionary new.
	nodeStack := OrderedCollection new.
	
	"Prepare implicit globals"
	globalVariables add: 'width'.
	globalVariables add: 'height'.
	
	"Throw-away values for function signature pre-parsing."
	indentation := 0.
	output := ''.
	astMap := OrderedCollection new.
	"Collect the signatures of user defined functions."
	userDefs := Dictionary new.
	ast statements select: [ :stmt | stmt isKindOf: PyFunctionDefinitionNode ] thenDo: [ :stmt |
		| args |
		stmt parameters do: [ :arg | arg acceptVisitor: self ].
		args := astMap collect: [ :slice | slice slice: output ].
		userDefs at: stmt fname value put: args.
	].
	
	indentation := 0.
	output := ''.
	astMap := OrderedCollection new.
	self emit: '_run
'.
	indentation := indentation + 1.
	ast acceptVisitor: self.
	
	localVariables do: [ :var | globalVariables add: var ].
	astMap do: [ :slice | slice name: '_run' ].
	astMaps at: '_run' put: astMap.
	
	"TODO: only update the canvas at the end of a draw phase (avoid rendering artifacts)"
	^ (output copyFrom: 1 to: output size - 1) , functions
]

{ #category : #compiling }
ProcessingTranspiler >> transpileFunction: ast name: name args: args [
	| saveLocalVariables saveGlobalVariables saveIndentation saveAstMap saveOutput res header methodName |
	"Preserve global state"
	saveLocalVariables := localVariables.
	saveGlobalVariables := globalVariables.
	saveIndentation := indentation.
	saveAstMap := astMap.
	saveOutput := output.
	
	localVariables := Set new.
	globalVariables := Set new.
	indentation := 0.
	astMap := OrderedCollection new.
	
	output := ''.
	self emitFunctionDef: name with: args.
	header := output , '
'.
	
	output := ''.
	astMap := OrderedCollection new.
	self acceptStatements: ast.
	"TODO: assigning to an argument yields a '... is shadowed' warning in the Transcript"
	localVariables size > 0 ifTrue: [
		header := header , Character tab asString , '| ' , (' ' join: localVariables) , ' |
'.
		astMap do: [ :node | node move: header size. ].
	].
	res := header , (output copyFrom: 1 to: output size - 1).
	globalVariables do: [ :var | saveGlobalVariables add: var ].
	
	methodName := name.
	args size > 0 ifTrue: [
		| argNames |
		argNames := userDefs at: name.
		methodName := methodName , ':'.
		2 to: argNames size do: [ :argNo |
			methodName := methodName , (argNames at: argNo) , ':'.
		].
	].
	astMap do: [ :slice | slice name: methodName ].
	astMaps at: methodName put: astMap.
	
	"Restore global state"
	output := saveOutput.
	astMap := saveAstMap.
	indentation := saveIndentation.
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
	self startEmit: expr.
	name := self emitName: expr variable nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self emit: ' := '.
	expr value acceptVisitor: self.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitAssignmentStatement: expr [
	| name |
	name := expr lhs nameToken value.
	self startEmit: expr.
	name := self emitName: expr lhs nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self emit: ' := '.
	expr tos first acceptVisitor: self.
	^ self endEmit.
]

{ #category : #visiting }
ProcessingTranspiler >> visitBinaryExpression: expr [
	| op |
	op := expr operator value.
	"Python compares value equality with `==`, Smalltalk does with `=`"
	op = '==' ifTrue: [ op := '=' ].
	
	self startEmit: expr.
	self emit: '('.
	expr left acceptVisitor: self.
	self emit: ' ' , op , ' '.
	expr right acceptVisitor: self.
	self emit: ')'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #visiting }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	stmt children do: [ :part |
		| res |
		res := part acceptVisitor: self.
		(res isKindOf: Number) ifTrue: [
			res > 0 ifTrue: [ self emit: '.
'. ]
		].
	].
]

{ #category : #visiting }
ProcessingTranspiler >> visitFile: file [
	self visitExpressionStatement: file
]

{ #category : #visiting }
ProcessingTranspiler >> visitFunctionCallExpression: fnCall [
	| name args |
	self startEmit: fnCall.
	name := fnCall receiver nameToken value.
	args := fnCall arguments.
	name = 'background' ifTrue: [ self emitBackground: args. ^ self endEmit ].
	name = 'cos' ifTrue: [ self emitCos: args. ^ self endEmit ].
	name = 'delay' ifTrue: [ self emitDelay: args. ^ self endEmit ].
	name = 'ellipse' ifTrue: [ self emitEllipse: args. ^ self endEmit ].
	name = 'fill' ifTrue: [ self emitFill: args. ^ self endEmit ].
	name = 'line' ifTrue: [ self emitLine: args. ^ self endEmit ].
	name = 'print' ifTrue: [ self emitPrint: args. ^ self endEmit ].
	"`println` is to Processing what `print` is to Python."
	name = 'println' ifTrue: [ self emitPrint: args. ^ self endEmit ].
	name = 'radians' ifTrue: [ self emitRadians: args. ^ self endEmit ].
	name = 'random' ifTrue: [ self emitRandom: args. ^ self endEmit ].
	name = 'rect' ifTrue: [ self emitRect: args. ^ self endEmit ].
	name = 'sin' ifTrue: [ self emitSin: args. ^ self endEmit ].
	name = 'size' ifTrue: [ self emitSize: args. ^ self endEmit ].
	name = 'stroke' ifTrue: [ self emitStroke: args. ^ self endEmit ].
	name = 'strokeWeight' ifTrue: [ self emitStrokeWeight: args. ^ self endEmit ].
	name = 'text' ifTrue: [ self emitText: args. ^ self endEmit ].
	name = 'textSize' ifTrue: [ self emitTextSize: args. ^ self endEmit ].
	name = 'tan' ifTrue: [ self emitTan: args. ^ self endEmit ].
	name = 'triangle' ifTrue: [ self emitTriangle: args. ^ self endEmit ].
	(userDefs includesKey: name) ifTrue: [
		self emit: '(self '.
		self emitFunctionDef: name with: args.
		self emit: ')'.
		^ self endEmit
	].
	ProcessingNotImplementedException new signal: 'Function ' , name , ' not implemented!'
]

{ #category : #visiting }
ProcessingTranspiler >> visitFunctionDefinition: def [
	functions := functions , '

' , (self transpileFunction: def name: def fname value args: (def parameters collect: [ :param | param ])).
	^ 0
]

{ #category : #visiting }
ProcessingTranspiler >> visitGlobalStatement: global [
	global nameTokens do: [ :token | globalVariables add: token value ].
	^ 0
]

{ #category : #visiting }
ProcessingTranspiler >> visitIfStatement: expr [
	self startEmit: expr.
	expr condition acceptVisitor: self.
	self emit: ' ifTrue: [
'.
	self acceptStatements: expr.
	expr elsifs ifNotNil: [
		expr elsifs do: [ :elif |
			self emit: '] ifFalse: [
'.
			indentation := indentation + 1.
			elif condition acceptVisitor: self.
			self emit: ' ifTrue: [
'.
			self acceptStatements: elif.
		].
	].
	expr else ifNotNil: [
		self emit: '] ifFalse: [
'.
		self acceptStatements: expr else.
	].
	expr elsifs ifNotNil: [
		expr elsifs do: [ :elif |
			self emit: '].
'.
			indentation := indentation - 1.
		].
	].
	self emit: ']'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitNumber: num [
	self startEmit: num.
	self emit: num numberToken value.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitParameter: param [
	self startEmit: param.
	self emit: param name nameToken value.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitReturnStatement: expr [
	self startEmit: expr.
	self emit: '^ '.
	expr expressions first acceptVisitor: self.
	self emit: '
'.
	"Explicitly not returning anything in order to prevent a trailing dot."
	self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitString: expr [
	self startEmit: expr.
	self emit: '''' , ('' join: (expr parts collect: [ :part | (part value allButFirst: 1) allButLast: 1 ])) , ''''.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitVariableExpression: var [
	self startEmit: var.
	self emitName: var nameToken value.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitWhileStatement: expr [
	self startEmit: expr.
	self emit: '[ '.
	expr condition acceptVisitor: self.
	self emit: ' ] whileTrue: [
'.
	self acceptStatements: expr.
	self emit: ']'.
	^ self endEmit
]
