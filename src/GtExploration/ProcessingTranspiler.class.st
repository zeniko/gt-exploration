"
This translates a Processing/Python AST into Smalltalk code and is used by {{gtClass:ProcessingProgram}} for compiling Processing code to a runnable subclass of {{gtClass:ProcessingCodeBase}}.
"
Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
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
		'nodeStack'
	],
	#classVars : [
		'constants',
		'implicitVariables'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingTranspiler class >> constants [
	^ constants
]

{ #category : #accessing }
ProcessingTranspiler class >> implicitVariables [
	^ implicitVariables
]

{ #category : #initialization }
ProcessingTranspiler class >> initialize [
	"When modifying these lists, run the following line (Ctrl+D):
	ProcessingTranspiler initialize
	"

	constants := {'True' -> 'true'.
			'False' -> 'false'.
			'None' -> 'nil'.
			'PI' -> Float pi asString} asDictionary.
	implicitVariables := #(#width #height #mouseX #mouseY #mousePressed)
]

{ #category : #visiting }
ProcessingTranspiler >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : #visiting }
ProcessingTranspiler >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : #visiting }
ProcessingTranspiler >> acceptNodes: aCollection [
	aCollection do: [ :each | self acceptNode: each ].
	^ aCollection
]

{ #category : #visiting }
ProcessingTranspiler >> acceptStatements: expr [
	indentation := indentation + 1.
	expr statements
		do: [ :stmt | 
			| res |
			res := stmt acceptVisitor: self.
			(res isKindOf: Number)
				ifTrue: [ res > 0
						ifTrue: [ self
								emit: '.';
								cr ] ] ].
	indentation := indentation - 1
]

{ #category : #compiling }
ProcessingTranspiler >> compile: ast [
	| class source instance lastInterval |
	source := self transpile: ast.

	class := ProcessingCodeBase newAnonymousSubclass.
	globalVariables do: [ :name | class addSlot: name ].
	(source
		splitOn: '

') do: [ :method | class compile: method ].

	lastInterval := nil.
	instance := class new.
	class methodDict
		keysDo: [ :key | 
			(astMaps at: key asString)
				do: [ :slice | 
					slice astNodeInterval = lastInterval
						ifFalse: [ instance gtAstMaps add: (slice cloneFor: class >> key).
							lastInterval := slice astNodeInterval ] ] ].
	^ instance
]

{ #category : #emitting }
ProcessingTranspiler >> cr [
	self
		emit: '
'
]

{ #category : #emitting }
ProcessingTranspiler >> emit: part [
	"Indent new lines."

	(output = ''
		or: (output
				endsWith: '
'))
		ifTrue: [ nodeStack
				select: [ :node | node startPos = (output size + 1) ]
				thenDo: [ :node | node move: indentation ].
			output := output , (String new: indentation withAll: Character tab) ].

	output := output , part
]

{ #category : #emitting }
ProcessingTranspiler >> emitAuxVar: aTag [
	| name |
	name := 'gt' , (localVariables size + 1) asString , '_' , aTag.
	self emit: name.
	localVariables add: name.
	^ name
]

{ #category : #emitting }
ProcessingTranspiler >> emitFunctionDef: name with: args [
	self emitName: name.
	args
		ifNotEmpty: [ | argNames |
			argNames := userDefs at: name.
			self emit: ': '.
			args first acceptVisitor: self.
			2
				to: args size
				do: [ :argNo | 
					self emit: ' ' , (argNames at: argNo) , ': '.
					(args at: argNo) acceptVisitor: self ] ]
]

{ #category : #emitting }
ProcessingTranspiler >> emitName: var [
	| name |
	name := var.
	(name beginsWith: 'gt') ifTrue: [ name := 'gt_' , (name removePrefix: 'gt') ].	"Internal variables of ProcessingCodeBase start with a the letters 'gt'. Make sure that there's no accidental leakage by inserting an underscore ('gtVar' -> 'gt_Var')."
	self emit: name.
	^ name
]

{ #category : #emitting }
ProcessingTranspiler >> emitNewVar: aExpr [
	| name |
	name := aExpr nameToken value.
	(ProcessingTranspiler constants includesKey: name)
		ifTrue: [ ProcessingCompileTimeException
				signal: 'Can''t assign to constant.'
				withTag: aExpr ].

	name := self emitName: name.
	(globalVariables includes: name) ifFalse: [ localVariables add: name ].
	^ name
]

{ #category : #emitting }
ProcessingTranspiler >> emit_background: args [
	args size = 1
		ifTrue: [ self emit: 'gtCanvas backgroundGray: '.
			^ args first acceptVisitor: self ].
	self expect: 3 argumentsFor: args.
	self emit: 'gtCanvas backgroundR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_color: args [
	args size = 1
		ifTrue: [ self emit: '(gtCanvas colorWithGray: '.
			args first acceptVisitor: self.
			^ self emit: ')' ].
	self expect: 3 argumentsFor: args.
	self emit: '(gtCanvas colorWithR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self.
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_cos: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' cos'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_delay: args [
	self expect: 1 argumentsFor: args.
	self emit: '('.
	args first acceptVisitor: self.
	self emit: ' / 1000.0) seconds wait'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_ellipse: args [
	self expect: 4 argumentsFor: args.
	self emit: 'gtCanvas ellipse: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self.
	self emit: ' dx: '.
	args third acceptVisitor: self.
	self emit: ' dy: '.
	args fourth acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_fill: args [
	args size = 1
		ifTrue: [ self emit: 'gtCanvas fillGray: '.
			^ args first acceptVisitor: self ].
	self expect: 3 argumentsFor: args.
	self emit: 'gtCanvas fillR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_frameRate: args [
	self expect: 1 argumentsFor: args.
	self emit: 'gtCanvas frameRate: '.
	args first acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_image: args [
	self expect: (args size > 3 ifTrue: [ 5 ] ifFalse: [ 3 ]) argumentsFor: args.
	self emit: 'gtCanvas image: '.
	args first acceptVisitor: self.
	self emit: ' x: '.
	args second acceptVisitor: self.
	self emit: ' y: '.
	args third acceptVisitor: self.
	args size > 3
		ifTrue: [ self emit: ' width: '.
			args fourth acceptVisitor: self.
			self emit: ' height: '.
			args fifth acceptVisitor: self ]
]

{ #category : #emitting }
ProcessingTranspiler >> emit_int: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' rounded'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_len: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' size'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_line: args [
	self expect: 4 argumentsFor: args.
	self emit: 'gtCanvas line: '.
	args first acceptVisitor: self.
	self emit: ' y1: '.
	args second acceptVisitor: self.
	self emit: ' x2: '.
	args third acceptVisitor: self.
	self emit: ' y2: '.
	args fourth acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_loadImage: args [
	self expect: 1 argumentsFor: args.
	self emit: '(gtCanvas loadImage: '.
	args first acceptVisitor: self.
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_max: args [
	args size = 1
		ifTrue: [ args first acceptVisitor: self.
			^ self emit: ' max' ].
	self expect: 2 argumentsFor: args.
	self emit: '('.
	args first acceptVisitor: self.
	self emit: ' max: '.
	args second acceptVisitor: self.
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_millis: args [
	self expect: 0 argumentsFor: args.
	self emit: 'gtCanvas millis'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_min: args [
	args size = 1
		ifTrue: [ args first acceptVisitor: self.
			^ self emit: ' min' ].
	self expect: 2 argumentsFor: args.
	self emit: '('.
	args first acceptVisitor: self.
	self emit: ' min: '.
	args second acceptVisitor: self.
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_noStroke: args [
	self expect: 0 argumentsFor: args.
	self emit: 'gtCanvas noStroke'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_print: args [
	args size > 1
		ifTrue: [ self emit: 'gtCanvas print: { '.
			args
				do: [ :arg | 
					arg acceptVisitor: self.
					self emit: '. ' ].
			self emit: '}' ]
		ifFalse: [ self emit: 'gtCanvas print: '.
			args first acceptVisitor: self ]
]

{ #category : #emitting }
ProcessingTranspiler >> emit_println: args [
	"`println` is to Processing what `print` is to Python."

	self emit_print: args
]

{ #category : #emitting }
ProcessingTranspiler >> emit_radians: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' degreesToRadians'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_random: args [
	self expect: (args size > 1 ifTrue: [ 2 ] ifFalse: [ 1 ]) argumentsFor: args.
	self emit: '(gtCanvas random: '.
	args first acceptVisitor: self.
	args size > 1
		ifTrue: [ self emit: ' to: '.
			args second acceptVisitor: self ].
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_randomSeed: args [
	self expect: 1 argumentsFor: args.
	self emit: '(gtCanvas randomSeed: '.
	args first acceptVisitor: self.
	self emit: ')'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_rect: args [
	self expect: (args size = 5 ifTrue: [ 5 ] ifFalse: [ 4 ]) argumentsFor: args.
	self emit: 'gtCanvas rect: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self.
	self emit: ' width: '.
	args third acceptVisitor: self.
	self emit: ' height: '.
	args fourth acceptVisitor: self.
	args size = 5
		ifTrue: [ self emit: ' cornerRadius: '.
			args fifth acceptVisitor: self ]
]

{ #category : #emitting }
ProcessingTranspiler >> emit_reversed: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' reversed'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_rotate: args [
	self expect: 1 argumentsFor: args.
	self emit: 'gtCanvas rotate: '.
	args first acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_scale: args [
	self expect: 1 argumentsFor: args.
	self emit: 'gtCanvas scale: '.
	args first acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_sin: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' sin'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_size: args [
	self expect: 2 argumentsFor: args.
	self emit: 'width := '.
	args first acceptVisitor: self.
	self emit: '. height := '.
	args second acceptVisitor: self.
	self emit: '. gtCanvas size: width by: height'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_sorted: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' sorted'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_sqrt: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' sqrt'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_str: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' asString'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_stroke: args [
	args size = 1
		ifTrue: [ self emit: 'gtCanvas strokeGray: '.
			^ args first acceptVisitor: self ].
	self expect: 3 argumentsFor: args.
	self emit: 'gtCanvas strokeR: '.
	args first acceptVisitor: self.
	self emit: ' G: '.
	args second acceptVisitor: self.
	self emit: ' B: '.
	args third acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_strokeWeight: args [
	self expect: 1 argumentsFor: args.
	self emit: 'gtCanvas strokeWeight: '.
	args first acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_tan: args [
	self expect: 1 argumentsFor: args.
	args first acceptVisitor: self.
	self emit: ' tan'
]

{ #category : #emitting }
ProcessingTranspiler >> emit_text: args [
	self expect: 3 argumentsFor: args.
	self emit: 'gtCanvas text: '.
	args first acceptVisitor: self.
	self emit: ' x: '.
	args second acceptVisitor: self.
	self emit: ' y: '.
	args third acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_textSize: args [
	self expect: 1 argumentsFor: args.
	self emit: 'gtCanvas textSize: '.
	args first acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_translate: args [
	self expect: 2 argumentsFor: args.
	self emit: 'gtCanvas translate: '.
	args first acceptVisitor: self.
	self emit: ' y: '.
	args second acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> emit_triangle: args [
	self expect: 6 argumentsFor: args.
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
	args sixth acceptVisitor: self
]

{ #category : #emitting }
ProcessingTranspiler >> endEmit [
	| node |
	node := nodeStack removeLast.
	node setEnd: output size.
	^ node size
]

{ #category : #'error handling' }
ProcessingTranspiler >> expect: num argumentsFor: args [
	num = args size
		ifFalse: [ ProcessingCompileTimeException
				signal: 'Expected ' , num asString , ' arguments but got ' , args size asString
				withTag: (args ifNotEmpty: [ args first ] ifEmpty: [ nil ]) ]
]

{ #category : #'error handling' }
ProcessingTranspiler >> expect: aClass for: expr [
	(expr isKindOf: aClass)
		ifFalse: [ ProcessingCompileTimeException
				signal: 'Expected: ' , ((aClass name removePrefix: 'Py') removeSuffix: 'Node')
						, ' but got: '
						, ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
				withTag: expr ]
]

{ #category : #visiting }
ProcessingTranspiler >> isStringConcatenation: expr [
	(expr isKindOf: PyStringNode) ifTrue: [ ^ true ].
	(expr isKindOf: PyFunctionCallExpressionNode)
		ifTrue: [ ^ expr receiver nameToken value = 'str' ].
	(expr isKindOf: PyBinaryExpressionNode) ifFalse: [ ^ false ].
	expr operator value = '+' ifFalse: [ ^ false ].
	^ (self isStringConcatenation: expr left)
		or: [ self isStringConcatenation: expr right ]
]

{ #category : #'error handling' }
ProcessingTranspiler >> notImplemented: expr [
	ProcessingNotImplementedException
		signal: 'Unsupported expression type: ' , ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
		withTag: expr
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
ProcessingTranspiler >> transpile: anAst [
	| ast |
	"Turn the AST into a Smalltalk source string"
	ast := ProcessingAstCleaner clean: anAst.

	globalVariables := Set new.
	localVariables := Set new.
	functions := ''.
	astMaps := Dictionary new.
	nodeStack := OrderedCollection new.
	globalVariables
		addAll: {'width'.
				'height'}.	"Prepare implicit globals"
	output := ''.	"Throw-away values for function signature pre-parsing."
	indentation := 0.
	userDefs := Dictionary new.	"Collect the signatures of user defined functions."
	ast statements
		select: [ :stmt | stmt isKindOf: PyFunctionDefinitionNode ]
		thenDo: [ :stmt | 
			| args |
			astMap := OrderedCollection new.
			stmt parameters do: [ :arg | arg acceptVisitor: self ].
			args := astMap collect: [ :slice | slice slice: output ].
			userDefs at: stmt fname value put: args ].

	output := ''.
	astMap := OrderedCollection new.
	self
		emit: 'gtRun';
		cr.
	indentation := indentation + 1.
	ast acceptVisitor: self.

	userDefs
		at: 'setup'
		ifPresent: [ :args | 
			args
				ifEmpty: [ self
						emit: 'self setup.';
						cr ] ].
	userDefs
		at: 'draw'
		ifPresent: [ :args | 
			args
				ifEmpty: [ globalVariables
						addAll: {'mouseX'.
								'mouseY'.
								'mousePressed'}.
					self
						emit: '[ gtCanvas frameRate > 0 ] whileTrue: [';
						cr.
					indentation := indentation + 1.
					self
						emit: 'mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.';
						cr.

					(#('mousePressed' 'mouseReleased' 'mouseClicked' 'mouseMoved')
						select: [ :evt | (userDefs includesKey: evt) and: [ (userDefs at: evt) isEmpty ] ])
						ifNotEmpty: [ :evts | 
							self emit: 'gtCanvas handleEvents: #( '.
							evts do: [ :evt | self emit: '#' , evt , ' ' ].
							self
								emit: ') for: self.';
								cr ].

					self
						emit: 'self draw.';
						cr.
					self
						emit: 'gtCanvas endFrame.';
						cr.
					indentation := indentation - 1.
					self
						emit: '].';
						cr ] ].

	localVariables do: [ :var | globalVariables add: var ].
	astMap do: [ :slice | slice name: 'gtRun' ].
	astMaps at: 'gtRun' put: astMap.
	^ output allButLast , functions
]

{ #category : #compiling }
ProcessingTranspiler >> transpileFunction: ast name: name args: args [
	| saveLocalVariables saveGlobalVariables saveIndentation saveAstMap saveOutput res methodName modifiedArgs |
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
	self
		emitFunctionDef: name with: args;
		cr.
	res := output.

	output := ''.
	astMap := OrderedCollection new.
	self acceptStatements: ast.
	modifiedArgs := (userDefs at: name)
			select: [ :arg | localVariables includes: arg ].	"Python allows assigning to arguments whereas Smalltalk doesn't"
	modifiedArgs
		do: [ :arg | 
			res := res
					copyWithRegex: '\b' , arg , '\b(?!\:)'
					matchesReplacedWith: 'gt0_' , arg ].

	localVariables
		ifNotEmpty: [ res := res , Character tab asString , '| ' , (' ' join: localVariables)
					, ' |
' ].
	modifiedArgs
		do: [ :arg | 
			res := res , '	' , arg , ' := gt0_' , arg
					, '.
' ].
	astMap do: [ :node | node move: res size ].

	output size > 0 ifTrue: [ res := res , output allButLast ].
	globalVariables do: [ :var | saveGlobalVariables add: var ].

	methodName := name.
	args
		ifNotEmpty: [ | argNames |
			argNames := userDefs at: name.
			methodName := methodName , ':'.
			2
				to: argNames size
				do: [ :argNo | methodName := methodName , (argNames at: argNo) , ':' ] ].
	astMap do: [ :slice | slice name: methodName ].
	astMaps at: methodName put: astMap.
	output := saveOutput.	"Restore global state"
	astMap := saveAstMap.
	indentation := saveIndentation.
	globalVariables := saveGlobalVariables.
	localVariables := saveLocalVariables.
	^ res
]

{ #category : #emitting }
ProcessingTranspiler >> unescape: str [
	| special in |
	special := {$n -> Character lf.
			$r -> Character cr.
			$t -> Character tab.
			$\ -> $\.
			$' -> $'.
			$" -> $"} asDictionary.	"TODO: octal, hex and unicode escapes"
	in := str allButFirst allButLast readStream.
	^ String
		new: str size
		streamContents: [ :out | 
			[ in atEnd ]
				whileFalse: [ | char |
					out
						nextPut: ((char := in next) = $\
								ifTrue: [ special
										at: (char := in next)
										ifAbsent: [ out nextPut: $\.
											char ] ]
								ifFalse: [ char ]) ] ]
]

{ #category : #accessing }
ProcessingTranspiler >> userDefs [
	^ userDefs
]

{ #category : #accessing }
ProcessingTranspiler >> variables [
	"This doesn't contain implicit globals such as `width` and `height` (cf. implicitVariables)."

	^ localVariables
]

{ #category : #generated }
ProcessingTranspiler >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : #generated }
ProcessingTranspiler >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : #visiting }
ProcessingTranspiler >> visitAssertStatement: stmt [
	self startEmit: stmt.
	self emit: '[ '.
	stmt values first acceptVisitor: self.
	self emit: ' ] '.
	stmt values size = 1
		ifTrue: [ self emit: 'assert' ]
		ifFalse: [ self emit: 'assertWithDescription: '.
			stmt values second acceptVisitor: self ].
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitAssignmentExpression: expr [
	self startEmit: expr.
	self expect: PyVariableExpressionNode for: expr variable.
	self emitNewVar: expr variable.
	self emit: ' := '.
	expr value acceptVisitor: self.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitAssignmentStatement: stmt [
	| closers |
	self startEmit: stmt.
	closers := ''.
	1
		to: stmt variables size
		do: [ :ix | 
			| varExpr |
			(stmt assigns at: ix) value = '=' ifFalse: [ self notImplemented: stmt ].

			varExpr := stmt variables at: ix.
			(varExpr isKindOf: PySubscriptExpressionNode)
				ifTrue: [ varExpr acceptVisitor: self.
					closers := closers , output last asString.
					output := output allButLast , ' '.	"TODO: self unemit:?"
					self emit: 'put: ' ]
				ifFalse: [ self expect: PyVariableExpressionNode for: varExpr.
					self emitNewVar: varExpr.
					self emit: ' := ' ] ].
	stmt value acceptVisitor: self.
	self emit: closers.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : #generated }
ProcessingTranspiler >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : #visiting }
ProcessingTranspiler >> visitBinaryExpression: expr [
	| op |
	op := expr operator value.
	op = '%' ifTrue: [ op := '\\' ].	"Modulo is `%` in Python but `\\` in Smalltalk"
	op = 'and' | (op = 'or')
		ifTrue: [ self startEmit: expr.
			self emit: '('.
			expr left acceptVisitor: self.
			self emit: ' ' , op , ': [ '.
			expr right acceptVisitor: self.
			self emit: ' ])'.
			^ self endEmit ].	"`and` and `or` are short-circuiting in Python"

	(op = '+' and: [ self isStringConcatenation: expr ]) ifTrue: [ op := ',' ].

	self startEmit: expr.
	self emit: '('.
	expr left acceptVisitor: self.
	self emit: ' ' , op , ' '.
	expr right acceptVisitor: self.
	self emit: ')'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : #visiting }
ProcessingTranspiler >> visitComparisonExpression: expr [
	| op chain depth |
	op := expr operator value.
	op = '==' ifTrue: [ op := '=' ].	"Python compares value equality with `==`, Smalltalk does with `=`"

	self startEmit: expr.
	self emit: '('.
	expr left acceptVisitor: self.
	self emit: ' ' , op , ' '.
	chain := expr right.
	depth := 0.
	[ chain isKindOf: PyComparisonExpressionNode ]
		whileTrue: [ chain left acceptVisitor: self.	"TODO: for correctness, `chain left` should be stored in a temporary variable so that its value isn't calculated twice"
			self emit: ' and: [ '.
			chain left acceptVisitor: self.
			self emit: ' ' , op , ' '.
			chain := chain right.
			depth := depth + 1 ].
	chain acceptVisitor: self.
	1 to: depth do: [ :n | self emit: ' ]' ].
	self emit: ')'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : #generated }
ProcessingTranspiler >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : #generated }
ProcessingTranspiler >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : #generated }
ProcessingTranspiler >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : #generated }
ProcessingTranspiler >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : #generated }
ProcessingTranspiler >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
ProcessingTranspiler >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : #generated }
ProcessingTranspiler >> visitElif: anElif [
	^ self visitRoot: anElif
]

{ #category : #visiting }
ProcessingTranspiler >> visitEllipsis: expr [
	self startEmit: expr.
	self emit: 'ProcessingEllipsis'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitElse: anElse [
	^ self visitRoot: anElse
]

{ #category : #generated }
ProcessingTranspiler >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : #generated }
ProcessingTranspiler >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : #generated }
ProcessingTranspiler >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : #visiting }
ProcessingTranspiler >> visitExpression: expr [
	self notImplemented: expr
]

{ #category : #visiting }
ProcessingTranspiler >> visitExpressionStatement: stmt [
	stmt children
		do: [ :part | 
			| res |
			res := part acceptVisitor: self.
			(res isKindOf: Number)
				ifTrue: [ res > 0
						ifTrue: [ self
								emit: '.';
								cr ] ] ]
]

{ #category : #visiting }
ProcessingTranspiler >> visitFieldAccessExpression: expr [
	self startEmit: expr.
	expr receiver acceptVisitor: self.
	self emit: ' '.
	self emitName: expr nameToken value.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitFile: file [
	self visitExpressionStatement: file
]

{ #category : #generated }
ProcessingTranspiler >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : #visiting }
ProcessingTranspiler >> visitForStatement: expr [
	| from to by name fromVar toVar byVar countVar |
	"only `for ... in range(...):` is currently supported"
	self expect: PyFunctionCallExpressionNode for: expr inExpression.
	self expect: PyVariableExpressionNode for: expr inExpression receiver.
	expr inExpression receiver nameToken value = 'range'
		ifFalse: [ self notImplemented: expr ].
	expr exprs size > 1 ifTrue: [ self notImplemented: expr ].
	self expect: PyVariableExpressionNode for: expr exprs first.
	expr else ifNotNil: [ self notImplemented: expr ].

	from := expr inExpression arguments size > 1
			ifTrue: [ expr inExpression arguments first ].
	to := expr inExpression arguments size > 1
			ifTrue: [ expr inExpression arguments second ]
			ifFalse: [ expr inExpression arguments first ].
	by := expr inExpression arguments size > 2
			ifTrue: [ expr inExpression arguments third ].

	self startEmit: expr.
	from
		ifNotNil: [ (from isKindOf: PyNumberNode)
				ifTrue: [ fromVar := from numberToken value ]
				ifFalse: [ fromVar := self emitAuxVar: 'from'.
					self emit: ' := '.
					from acceptVisitor: self.
					self
						emit: '.';
						cr ] ]
		ifNil: [ fromVar := '0' ].
	(to isKindOf: PyNumberNode)
		ifTrue: [ toVar := to numberToken value ]
		ifFalse: [ toVar := self emitAuxVar: 'to'.
			self emit: ' := '.
			to acceptVisitor: self.
			self
				emit: '.';
				cr ].
	by
		ifNotNil: [ (by isKindOf: PyNumberNode)
				ifTrue: [ byVar := by numberToken value ]
				ifFalse: [ byVar := self emitAuxVar: 'step'.
					self emit: ' := '.
					by acceptVisitor: self.
					self
						emit: '.';
						cr ] ]
		ifNil: [ byVar := '1' ].

	self emit: fromVar , ' to: (' , toVar , ' - ' , byVar , ')'.
	by ifNotNil: [ self emit: ' by: ' , byVar ].
	self emit: ' do: [ :'.
	countVar := (self emitAuxVar: '') , 'loop'.
	self emit: 'loop | '.
	name := self emitNewVar: expr exprs first.
	self
		emit: ' := ' , countVar , '.';
		cr.
	self acceptStatements: expr.
	self emit: ']'.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitFunctionCallExpression: fnCall [
	| name builtin |
	self startEmit: fnCall.
	(fnCall receiver isKindOf: PyFieldAccessExpressionNode)
		ifTrue: [ self emit: '('.
			fnCall receiver acceptVisitor: self.
			fnCall arguments size = 1
				ifTrue: [ self emit: ': '.
					fnCall arguments first acceptVisitor: self ]
				ifFalse: [ self expect: 0 argumentsFor: fnCall arguments ].
			self emit: ')'.
			^ self endEmit ].
	self expect: PyVariableExpressionNode for: fnCall receiver.
	name := fnCall receiver nameToken value.	"TODO: disallow overriding builtin functions?"
	(userDefs includesKey: name)
		ifTrue: [ self emit: '(self '.
			self emitFunctionDef: name with: fnCall arguments.
			self emit: ')'.
			^ self endEmit ].
	builtin := ('emit_' , name , ':') asSymbol.
	(self class methodDict includesKey: builtin)
		ifTrue: [ self perform: builtin with: fnCall arguments.
			^ self endEmit ].
	ProcessingNotImplementedException
		signal: 'Unsupported function: ' , name
		withTag: fnCall
]

{ #category : #visiting }
ProcessingTranspiler >> visitFunctionDefinition: def [
	functions := functions
			, '

'
			, (self
					transpileFunction: def
					name: def fname value
					args: def parameters).
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
	self assert: expr elsifs isEmpty.	"cf. ProcessingAstCleaner>>visitIfStatement:"
	self startEmit: expr.
	expr condition acceptVisitor: self.
	self
		emit: ' ifTrue: [';
		cr.
	self acceptStatements: expr.
	expr else
		ifNotNil: [ self
				emit: '] ifFalse: [';
				cr.
			self acceptStatements: expr else ].
	self emit: ']'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : #generated }
ProcessingTranspiler >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : #generated }
ProcessingTranspiler >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : #visiting }
ProcessingTranspiler >> visitListExpression: list [
	self startEmit: list.
	self emit: '(ProcessingList newFrom: { '.
	list expressions
		do: [ :expr | 
			expr acceptVisitor: self.
			self emit: '. ' ].
	self emit: '})'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : #generated }
ProcessingTranspiler >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : #generated }
ProcessingTranspiler >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : #generated }
ProcessingTranspiler >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : #generated }
ProcessingTranspiler >> visitName: aName [
	^ self visitRoot: aName
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

{ #category : #generated }
ProcessingTranspiler >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : #visiting }
ProcessingTranspiler >> visitPassStatement: pass [
	"no-op"

	^ 0
]

{ #category : #generated }
ProcessingTranspiler >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : #visiting }
ProcessingTranspiler >> visitReturnStatement: expr [
	self startEmit: expr.
	self emit: '^ '.
	expr expressions size > 1 ifTrue: [ self notImplemented: expr ].
	expr expressions size = 1
		ifTrue: [ expr expressions first acceptVisitor: self ]
		ifFalse: [ self emit: 'nil' ].
	self endEmit.
	self cr	"Explicitly not returning anything in order to prevent a trailing dot."
]

{ #category : #generated }
ProcessingTranspiler >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : #generated }
ProcessingTranspiler >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ProcessingTranspiler >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : #generated }
ProcessingTranspiler >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : #generated }
ProcessingTranspiler >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : #visiting }
ProcessingTranspiler >> visitStatement: stmt [
	self notImplemented: stmt
]

{ #category : #visiting }
ProcessingTranspiler >> visitString: expr [
	self startEmit: expr.
	self
		emit: '''' , ('' join: (expr parts collect: [ :part | self unescape: part value ]))
				, ''''.
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitSubscriptExpression: subscript [
	"Note: Processing is 0-based and right opened
	(whereas Smalltalk prefers 1-based, right closed indexing)"

	subscript subscripts size = 1 ifFalse: [ self notImplemented: subscript ].
	self startEmit: subscript.
	self emit: '('.
	subscript receiver acceptVisitor: self.
	(subscript subscripts first isKindOf: PySliceNode)
		ifTrue: [ (#(1 2) includes: subscript subscripts first colonTokens size)
				ifFalse: [ self notImplemented: subscript ].
			subscript subscripts first from
				ifNotNil: [ self emit: ' sliceFrom0: '.
					subscript subscripts first from acceptVisitor: self ]
				ifNil: [ self emit: ' sliceFrom0: 0' ].
			subscript subscripts first to
				ifNotNil: [ self emit: ' to: '.
					subscript subscripts first to acceptVisitor: self ].
			subscript subscripts first colonTokens size = 2
				ifTrue: [ self emit: ' stepBy: '.
					subscript subscripts first step acceptVisitor: self ] ]
		ifFalse: [ self emit: ' at0: '.
			subscript subscripts first acceptVisitor: self ].
	self emit: ')'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitTupleExpression: aTupleExpression [
	^ self visitExpression: aTupleExpression
]

{ #category : #generated }
ProcessingTranspiler >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : #visiting }
ProcessingTranspiler >> visitUnaryExpression: expr [
	expr operator value = '-'
		ifTrue: [ self startEmit: expr.
			expr expression acceptVisitor: self.
			self emit: ' negated'.
			^ self endEmit ].
	expr operator value = '+'
		ifTrue: [  "Force number"self startEmit: expr.
			self emit: '(0 + '.
			expr expression acceptVisitor: self.
			self emit: ')'.
			^ self endEmit ].
	expr operator value = 'not'
		ifTrue: [ self startEmit: expr.
			expr expression acceptVisitor: self.
			self emit: ' not'.
			^ self endEmit ].
	self notImplemented: expr
]

{ #category : #visiting }
ProcessingTranspiler >> visitVariableExpression: var [
	self startEmit: var.
	(ProcessingTranspiler constants includesKey: var nameToken value)
		ifTrue: [ self emit: (constants at: var nameToken value) ]
		ifFalse: [ | name |
			name := self emitName: var nameToken value.
			(var parent isKindOf: PyExpressionStatementNode)
				ifTrue: [ (globalVariables includes: name) | (localVariables includes: name)
						ifFalse: [ ProcessingCompileTimeException
								signal: 'Unknown variable name: ' , name
								withTag: var ] ] ].	"Throw a compile time exception instead of a runtime exception so that live views aren't updated with an error message"
	^ self endEmit
]

{ #category : #visiting }
ProcessingTranspiler >> visitWhileStatement: expr [
	expr else ifNotNil: [ self notImplemented: expr ].
	self startEmit: expr.
	self emit: '[ '.
	expr condition acceptVisitor: self.
	self
		emit: ' ] whileTrue: [';
		cr.
	self acceptStatements: expr.
	self emit: ']'.
	^ self endEmit
]

{ #category : #generated }
ProcessingTranspiler >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : #generated }
ProcessingTranspiler >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : #generated }
ProcessingTranspiler >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : #generated }
ProcessingTranspiler >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
