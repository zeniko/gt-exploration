Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#instVars : [
		'globalVariables',
		'indentation',
		'functions',
		'localVariables',
		'userDefs',
		'astMap',
		'astMaps',
		'output',
		'nodeStack',
		'constants'
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
			res > 0 ifTrue: [ self emit: '.'; cr. ].
		].
	].
	indentation := indentation - 1.
]

{ #category : #compiling }
ProcessingTranspiler >> compile: ast [
	| class source instance |
	source := self transpile: ast.
	class := ProcessingCodeBase newAnonymousSubclass.
	globalVariables do: [ :name | class addSlot: name ].
	(source splitOn: '

') do: [ :method | class compile: method ].
	instance := class new.
	class methodDict keysDo: [ :key |
		(astMaps at: key asString) do: [ :slice |
			instance gtAstMaps add: (slice cloneFor: class >> key).
		].
	].
	^ instance
]

{ #category : #emitting }
ProcessingTranspiler >> cr [
	self emit: '
'.
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
	args size = 1 ifTrue: [
		self emit: 'gtCanvas backgroundGray: '.
		^ args first acceptVisitor: self.
	].
	self emit: 'gtCanvas backgroundR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitCircle: args [
	self emit: 'gtCanvas circle: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self.
	self emit: ' d: '.
	args third acceptVisitor: self.
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
	self emit: 'gtCanvas ellipse: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self.
	self emit: ' dx: '.
	args third acceptVisitor: self.
	self emit: ' dy: '.
	args fourth acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitFill: args [
	args size = 1 ifTrue: [
		self emit: 'gtCanvas fillGray: '.
		^ args first acceptVisitor: self.
	].
	self emit: 'gtCanvas fillR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitFrameRate: args [
	self emit: 'gtCanvas frameRate: '.
	args first acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitFunctionDef: name with: args [
	self emitName: name.
	args ifNotEmpty: [
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
ProcessingTranspiler >> emitImage: args [
	self emit: 'gtCanvas image: '.
	args first acceptVisitor: self.
	self emit: ' x: '.
	args second acceptVisitor: self.
	self emit: ' y: '.
	args third acceptVisitor: self.
	args size > 3 ifTrue: [
		self emit: ' width: '.
		args fourth acceptVisitor: self.
		self emit: ' height: '.
		args fifth acceptVisitor: self.
	].
]

{ #category : #emitting }
ProcessingTranspiler >> emitInt: args [
	args first acceptVisitor: self.
	self emit: ' rounded'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitLine: args [
	self emit: 'gtCanvas line: '.
	args first acceptVisitor: self.
	self emit: ' y1: '.
	args second acceptVisitor: self.
	self emit: ' x2: '.
	args third acceptVisitor: self.
	self emit: ' y2: '.
	args fourth acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitLoadImage: args [
	self emit: '(gtCanvas loadImage: '.
	args first acceptVisitor: self.
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emitName: var [
	| name |
	name := var.
	"Internal variables of ProcessingCodeBase start with a the letters 'gt'. Make sure that there's no accidental leakage by inserting an underscore ('gtVar' -> 'gt_Var')."
	(name beginsWith: 'gt') ifTrue: [ name := 'gt_' , (name removePrefix: 'gt') ].
	self emit: name.
	^ name
]

{ #category : #emitting }
ProcessingTranspiler >> emitPrint: args [
	args size > 1 ifTrue: [
		self emit: 'gtCanvas print: { '.
		args do: [ :arg |
			arg acceptVisitor: self.
			self emit: '. '.
		].
		self emit: '}'.
	] ifFalse: [
		self emit: 'gtCanvas print: '.
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
	self emit: '(gtCanvas random: '.
	args first acceptVisitor: self.
	self emit: ')'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitRect: args [
	self emit: 'gtCanvas rect: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self.
	self emit: ' width: '.
	args third acceptVisitor: self.
	self emit: ' height: '.
	args fourth acceptVisitor: self.
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
	self emit: '. gtCanvas size: width by: height'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitSqrt: args [
	args first acceptVisitor: self.
	self emit: ' sqrt'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitSquare: args [
	self emit: 'gtCanvas square: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self.
	self emit: ' side: '.
	args third acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitStr: args [
	args first acceptVisitor: self.
	self emit: ' asString'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitStroke: args [
	args size = 1 ifTrue: [
		self emit: 'gtCanvas strokeGray: '.
		^ args first acceptVisitor: self.
	].
	self emit: 'gtCanvas strokeR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitStrokeWeight: args [
	self emit: 'gtCanvas strokeWeight: '.
	args first acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitTan: args [
	args first acceptVisitor: self.
	self emit: ' tan'.
]

{ #category : #emitting }
ProcessingTranspiler >> emitText: args [
	self emit: 'gtCanvas text: '.
	args first acceptVisitor: self.
	self emit: ' x: '.
	args second acceptVisitor: self.
	self emit: ' y: '.
	args third acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitTextSize: args [
	self emit: 'gtCanvas textSize: '.
	args first acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> emitTriangle: args [
	self emit: 'gtCanvas triangle: '.
	args first acceptVisitor: self.
	self emit: ' y1: '.
	args second acceptVisitor: self.
	self emit: ' x2: '.
	args third acceptVisitor: self.
	self emit: ' y2: '.
	args fourth acceptVisitor: self.
	self emit: ' x3: '.
	args fifth acceptVisitor: self.
	self emit: ' y3: '.
	args sixth acceptVisitor: self.
]

{ #category : #emitting }
ProcessingTranspiler >> endEmit [
	| node |
	node := nodeStack removeLast.
	node setEnd: output size.
	^ node size
]

{ #category : #visiting }
ProcessingTranspiler >> isStringConcatenation: expr [
	(expr isKindOf: PyStringNode) ifTrue: [ ^ true ].
	(expr isKindOf: PyFunctionCallExpressionNode) ifTrue: [ ^ expr receiver nameToken value = 'str' ].
	(expr isKindOf: PyBinaryExpressionNode) ifFalse: [ ^ false ].
	expr operator value = '+' ifFalse: [ ^ false ].
	^ (self isStringConcatenation: expr left) or: [ self isStringConcatenation: expr right ]
]

{ #category : #emitting }
ProcessingTranspiler >> notImplemented: expr [
	ProcessingNotImplementedException new tag: expr; signal.
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
	
	constants := Dictionary newFrom: {
		'True' -> 'true'.
		'False' -> 'false'.
		'None' -> 'nil'.
		'PI' -> Float pi asString.
		"The following implicit constants are internally treated like global variables."
		'width' -> 'width'. 'height' -> 'height'.
		'mouseX' -> 'mouseX'. 'mouseY' -> 'mouseY'.
		'mousePressed' -> 'mousePressed'.
	}.
	
	"Prepare implicit globals"
	globalVariables addAll: { 'width'. 'height'. }.
	
	"Throw-away values for function signature pre-parsing."
	output := ''.
	indentation := 0.
	
	"Collect the signatures of user defined functions."
	userDefs := Dictionary new.
	ast statements select: [ :stmt | stmt isKindOf: PyFunctionDefinitionNode ] thenDo: [ :stmt |
		| args |
		astMap := OrderedCollection new.
		stmt parameters do: [ :arg | arg acceptVisitor: self ].
		args := astMap collect: [ :slice | slice slice: output ].
		userDefs at: stmt fname value put: args.
	].
	
	output := ''.
	astMap := OrderedCollection new.
	self emit: 'gtRun'; cr.
	indentation := indentation + 1.
	ast acceptVisitor: self.
	
	userDefs at: 'setup' ifPresent: [ :args |
		args ifEmpty: [
			self emit: 'self setup.'; cr.
		].
	].
	userDefs at: 'draw' ifPresent: [ :args |
		args ifEmpty: [
			globalVariables addAll: { 'mouseX'. 'mouseY'. 'mousePressed'. }.
			self emit: '[ gtCanvas frameRate > 0 ] whileTrue: ['; cr.
			indentation := indentation + 1.
			self emit: 'mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.'; cr.
			self emit: 'self draw.'; cr.
			self emit: '(1 / gtCanvas frameRate) seconds wait.'; cr.
			indentation := indentation - 1.
			self emit: '].'; cr.
		].
	].
	
	localVariables do: [ :var | globalVariables add: var ].
	astMap do: [ :slice | slice name: 'gtRun' ].
	astMaps at: 'gtRun' put: astMap.
	
	"TODO: only update the canvas at the end of a draw phase (avoid rendering artifacts)"
	^ output allButLast , functions
]

{ #category : #compiling }
ProcessingTranspiler >> transpileFunction: ast name: name args: args [
	| saveLocalVariables saveGlobalVariables saveIndentation saveAstMap saveOutput res methodName |
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
	self emitFunctionDef: name with: args; cr.
	res := output.
	
	output := ''.
	astMap := OrderedCollection new.
	self acceptStatements: ast.
	"TODO: assigning to an argument yields a '... is shadowed' warning in the Transcript"
	localVariables ifNotEmpty: [
		res := res , Character tab asString , '| ' , (' ' join: localVariables) , ' |
'.
	].
	astMap do: [ :node | node move: res size. ].
	
	output size > 0 ifTrue: [
		res := res , output allButLast.
	].
	globalVariables do: [ :var | saveGlobalVariables add: var ].
	
	methodName := name.
	args ifNotEmpty: [
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

{ #category : #emitting }
ProcessingTranspiler >> unescape: str [
	| special in |
	special := Dictionary newFrom: {
		$n -> Character lf.
		$r -> Character cr.
		$t -> Character tab.
		$\ -> $\. $' -> $'. $" -> $".
		"TODO: octal, hex and unicode escapes"
	}.
	in := str allButFirst allButLast readStream.
	^ String new: str size streamContents: [ :out |
		[ in atEnd ] whileFalse: [ | char |
			out nextPut: ((char := in next) = $\ ifTrue: [
				special at: (char := in next) ifAbsent: [ out nextPut: $\. char ]
			] ifFalse: [
				char
			]).
		].
	]
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
	(constants includesKey: expr variable nameToken value) ifTrue: [
		ProcessingCompileTimeException new tag: expr; signal: 'Can''t assign to constant.'.
	].
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
	expr lhs nameToken ifNil: [ self notImplemented: expr ].
	name := expr lhs nameToken value.
	(constants includesKey: name) ifTrue: [
		ProcessingCompileTimeException new tag: expr; signal: 'Can''t assign to constant.'.
	].
	self startEmit: expr.
	name := self emitName: expr lhs nameToken value.
	(globalVariables includes: name) ifFalse: [
		localVariables add: name.
	].
	self emit: ' := '.
	expr tos size > 1 ifTrue: [ self notImplemented: expr ].
	expr tos first acceptVisitor: self.
	^ self endEmit.
]

{ #category : #visiting }
ProcessingTranspiler >> visitBinaryExpression: expr [
	| op |
	op := expr operator value.
	"Modulo is `%` in Python but `\\` in Smalltalk"
	op = '%' ifTrue: [ op := '\\' ].
	
	"`and` and `or` are short-circuiting in Python"
	((op = 'and') | (op = 'or')) ifTrue: [
		self startEmit: expr.
		self emit: '('.
		expr left acceptVisitor: self.
		self emit: ' ' , op , ': [ '.
		expr right acceptVisitor: self.
		self emit: ' ])'.
		^ self endEmit		
	].
	
	(op = '+' and: [ self isStringConcatenation: expr ]) ifTrue: [ op := ','. ].
	
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
	| op chain depth |
	op := expr operator value.
	"Python compares value equality with `==`, Smalltalk does with `=`"
	op = '==' ifTrue: [ op := '=' ].
	
	self startEmit: expr.
	self emit: '('.
	expr left acceptVisitor: self.
	self emit: ' ' , op , ' '.
	chain := expr right.
	depth := 0.
	[ chain isKindOf: PyComparisonExpressionNode ] whileTrue: [
		"TODO: for correctness, `chain left` should be stored in a temporary variable so that its value isn't calculated twice"
		chain left acceptVisitor: self.
		self emit: ' and: [ '.
		chain left acceptVisitor: self.
		self emit: ' ' , op , ' '.
		chain := chain right.
		depth := depth + 1.
	].
	chain acceptVisitor: self.
	1 to: depth do: [ :n | self emit: ' ]'. ].
	self emit: ')'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitEllipsis: expr [
	self startEmit: expr.
	self emit: 'PyEllipsis'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitExpression: expr [
	self notImplemented: expr
]

{ #category : #visiting }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	stmt children do: [ :part |
		| res |
		res := part acceptVisitor: self.
		(res isKindOf: Number) ifTrue: [
			res > 0 ifTrue: [ self emit: '.'; cr. ]
		].
	].
]

{ #category : #visiting }
ProcessingTranspiler >> visitFile: file [
	self visitExpressionStatement: file
]

{ #category : #visiting }
ProcessingTranspiler >> visitForStatement: expr [
	| from to by |
	"only `for ... in range(...):` is currently supported"
	(expr inExpression isKindOf: PyFunctionCallExpressionNode) ifFalse: [ self notImplemented: expr ].
	(expr inExpression receiver isKindOf: PyVariableExpressionNode) ifFalse: [ self notImplemented: expr ].
	expr inExpression receiver nameToken value = 'range' ifFalse: [ self notImplemented: expr ].
	expr exprs size > 1 ifTrue: [ self notImplemented: expr ].
	expr else ifNotNil: [ self notImplemented: expr ].
	
	from := expr inExpression arguments size > 1 ifTrue: [ expr inExpression arguments first ].
	to := expr inExpression arguments size > 1 ifTrue: [ expr inExpression arguments second ] ifFalse: [ expr inExpression arguments first ].
	by := expr inExpression arguments size > 2 ifTrue: [ expr inExpression arguments third ].
	
	self startEmit: expr.
	from ifNotNil: [ from acceptVisitor: self. ] ifNil: [ self emit: '0'. ].
	self emit: ' to: ('.
	to acceptVisitor: self.
	by ifNil: [
		self emit: ' - 1)'.
	] ifNotNil: [
		self emit: ' - '.
		"TODO: omit double-evaluationg step expression"
		by acceptVisitor: self.
		self emit: ' sign) by: '.
		by acceptVisitor: self.
	].
	self emit: ' do: [ :'.
	expr exprs first acceptVisitor: self.
	self emit: ' |'; cr.
	self acceptStatements: expr.
	self emit: ']'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitFunctionCallExpression: fnCall [
	| name args |
	self startEmit: fnCall.
	name := fnCall receiver nameToken value.
	args := fnCall arguments.
	name = 'background' ifTrue: [ self emitBackground: args. ^ self endEmit ].
	name = 'circle' ifTrue: [ self emitCircle: args. ^ self endEmit ].
	name = 'cos' ifTrue: [ self emitCos: args. ^ self endEmit ].
	name = 'delay' ifTrue: [ self emitDelay: args. ^ self endEmit ].
	name = 'ellipse' ifTrue: [ self emitEllipse: args. ^ self endEmit ].
	name = 'fill' ifTrue: [ self emitFill: args. ^ self endEmit ].
	name = 'frameRate' ifTrue: [ self emitFrameRate: args. ^ self endEmit ].
	name = 'image' ifTrue: [ self emitImage: args. ^ self endEmit ].
	name = 'int' ifTrue: [ self emitInt: args. ^ self endEmit ].
	name = 'line' ifTrue: [ self emitLine: args. ^ self endEmit ].
	name = 'loadImage' ifTrue: [ self emitLoadImage: args. ^ self endEmit ].
	name = 'print' ifTrue: [ self emitPrint: args. ^ self endEmit ].
	"`println` is to Processing what `print` is to Python."
	name = 'println' ifTrue: [ self emitPrint: args. ^ self endEmit ].
	name = 'radians' ifTrue: [ self emitRadians: args. ^ self endEmit ].
	name = 'random' ifTrue: [ self emitRandom: args. ^ self endEmit ].
	name = 'rect' ifTrue: [ self emitRect: args. ^ self endEmit ].
	name = 'sin' ifTrue: [ self emitSin: args. ^ self endEmit ].
	name = 'size' ifTrue: [ self emitSize: args. ^ self endEmit ].
	name = 'square' ifTrue: [ self emitSquare: args. ^ self endEmit ].
	name = 'sqrt' ifTrue: [ self emitSqrt: args. ^ self endEmit ].
	name = 'str' ifTrue: [ self emitStr: args. ^ self endEmit ].
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
	self notImplemented: fnCall
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
ProcessingTranspiler >> visitIfExpression: expr [
	self startEmit: expr.
	self emit: '('.
	expr condition acceptVisitor: self.
	self emit: ' ifTrue: [ '.
	expr if acceptVisitor: self.
	self emit: ' ] ifFalse: [ '.
	expr else acceptVisitor: self.
	self emit: ' ])'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitIfStatement: expr [
	self startEmit: expr.
	expr condition acceptVisitor: self.
	self emit: ' ifTrue: ['; cr.
	self acceptStatements: expr.
	expr elsifs ifNotNil: [
		expr elsifs do: [ :elif |
			self emit: '] ifFalse: ['; cr.
			indentation := indentation + 1.
			elif condition acceptVisitor: self.
			self emit: ' ifTrue: ['; cr.
			self acceptStatements: elif.
		].
	].
	expr else ifNotNil: [
		self emit: '] ifFalse: ['; cr.
		self acceptStatements: expr else.
	].
	expr elsifs ifNotNil: [
		expr elsifs do: [ :elif |
			self emit: '].'; cr.
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
ProcessingTranspiler >> visitPassStatement: pass [
	"no-op" ^ 0
]

{ #category : #visiting }
ProcessingTranspiler >> visitReturnStatement: expr [
	self startEmit: expr.
	self emit: '^ '.
	expr expressions size > 1 ifTrue: [ self notImplemented: expr ].
	expr expressions size = 1 ifTrue: [
		expr expressions first acceptVisitor: self.
	] ifFalse: [
		self emit: 'nil'.
	].
	self endEmit.
	self cr.
	"Explicitly not returning anything in order to prevent a trailing dot."
]

{ #category : #visiting }
ProcessingTranspiler >> visitStatement: stmt [
	self notImplemented: stmt
]

{ #category : #visiting }
ProcessingTranspiler >> visitString: expr [
	self startEmit: expr.
	self emit: '''' , ('' join: (expr parts collect: [ :part | self unescape: part value ])) , ''''.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitTupleExpression: expr [
	expr expressions size = 1 ifFalse: [ self notImplemented: expr ].
	expr expressions first acceptVisitor: self.
]

{ #category : #visiting }
ProcessingTranspiler >> visitUnaryExpression: expr [
	expr operator value = '-' ifTrue: [
		self startEmit: expr.
		expr expression acceptVisitor: self.
		self emit: ' negated'.
		^ self endEmit
	].
	expr operator value = '+' ifTrue: [
		"Force number"
		self startEmit: expr.
		self emit: '(0 + '.
		expr expression acceptVisitor: self.
		self emit: ')'.
		^ self endEmit
	].
	expr operator value = 'not' ifTrue: [
		self startEmit: expr.
		expr expression acceptVisitor: self.
		self emit: ' not'.
		^ self endEmit
	].
	self notImplemented: expr
]

{ #category : #visiting }
ProcessingTranspiler >> visitVariableExpression: var [
	self startEmit: var.
	(constants includesKey: var nameToken value) ifTrue: [
		self emit: (constants at: var nameToken value).
	] ifFalse: [
		self emitName: var nameToken value.
	].
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitWhileStatement: expr [
	expr else ifNotNil: [ self notImplemented: expr ].
	self startEmit: expr.
	self emit: '[ '.
	expr condition acceptVisitor: self.
	self emit: ' ] whileTrue: ['; cr.
	self acceptStatements: expr.
	self emit: ']'.
	^ self endEmit
]
