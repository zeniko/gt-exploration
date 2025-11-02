"
This contains data for a single runstep and is produced by {{gtClass:ProcessingRunner}}.

```
(ProcessingSource fromString: 's = ""Hello""; print(s)')
	program runSteps last
```
"
Class {
	#name : #ProcessingRunStep,
	#superclass : #Object,
	#instVars : [
		'variables',
		'method',
		'stack',
		'slice',
		'transcript',
		'shapes',
		'canvasSize',
		'canvasColor',
		'copies'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initalization }
ProcessingRunStep class >> create: aContext canvas: aCanvas slice: aSlice [
	^ ProcessingRunStep new
		create: aContext
		canvas: aCanvas
		slice: aSlice
]

{ #category : #views }
ProcessingRunStep >> asString [
	^ 'Step' translated , ': ' , slice asString
]

{ #category : #initalization }
ProcessingRunStep >> copyObj: anObject [
	"Makes a copy of mutable objects (for now: lists), reuses that copy in case the object occurs multiple times in a single step (different variables or on the stack)"

	(anObject isKindOf: ProcessingList)
		ifTrue: [ ^ copies at: anObject asString ifAbsentPut: [ ProcessingList newFrom: anObject ] ].
	^ anObject	"assume that the object is immutable (or doesn't matter)"
]

{ #category : #initalization }
ProcessingRunStep >> create: aContext canvas: aCanvas slice: aSlice [
	self updateCanvas: aCanvas.
	copies := Dictionary new.
	variables := Dictionary new.
	aContext receiver
		ifNotNil: [ aContext receiver class slots
				do: [ :slot | 
					(slot name beginsWith: 'gt_')
						ifTrue: [ variables
								at: ('gt' , (slot name removePrefix: 'gt_')) asSymbol
								put: (self copyObj: (aContext receiver instVarNamed: slot name)) ].
					(slot name beginsWith: 'gt')
						ifFalse: [ (ProcessingTranspiler implicitVariables includes: slot name)
								ifFalse: [ variables
										at: slot name
										put: (self copyObj: (aContext receiver instVarNamed: slot name)) ] ] ] ].
	aContext tempNames
		do: [ :name | variables at: name put: (self copyObj: (aContext tempNamed: name)) ].
	method := aContext sourceNodeExecuted.
	stack := (1 to: aContext size)
			collect: [ :ix | self copyObj: (aContext at: ix) ].
	slice := aSlice
]

{ #category : #views }
ProcessingRunStep >> getInnerView: aView [
	^ (self perform: aView with: GtPhlowView empty) asElement
		background: Color white;
		margin: (BlInsets all: 5);
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		yourself
]

{ #category : #views }
ProcessingRunStep >> gtAbstractionsFor: aView [
	<gtView>
	(slice isKindOf: ProcessingRunawayProgramException)
		ifTrue: [  "ProcessingProgram>>#runStepsFor: adds an unthrown exception as a last step, if the program runs too long"^ aView
				forward object: [ slice signal ] ].
	^ aView explicit
		priority: 1;
		title: 'Abstractions' translated;
		stencil: [ BlElement new
				layout: (BlGridLayout new columnCount: 2);
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				addChild: (self getInnerView: #gtSourceCodeFor:);
				addChild: (self getInnerView: #gtBytecodeFor:);
				addChild: (BlElement new
						layout: BlLinearLayout vertical;
						constraintsDo: [ :c | 
							c vertical matchParent.
							c horizontal matchParent ];
						addChild: (self getInnerView: #gtVariablesFor:);
						addChild: (self getInnerView: #gtStackFor:);
						yourself);
				addChild: (self getInnerView: #gtOutputFor:);
				yourself ]
]

{ #category : #views }
ProcessingRunStep >> gtBytecodeFor: aView [
	"Adapted from ProcessingCodeBase>>#gtBytecodeFor:"

	<gtView>
	^ aView columnedList
		title: 'Bytecode' translated;
		priority: 20;
		items: [ method methodNode method symbolicBytecodes
				select: [ :item | slice interval includesAll: item sourceInterval ] ];
		column: 'Address' translated
			text: [ :each | 
				((each isKindOf: CompiledMethod) ifTrue: [ '----' ] ifFalse: [ each offset ])
					asRopedText foreground: Color gray ]
			width: 50;
		column: 'Code' translated
			text: [ :each | 
				((each isKindOf: CompiledMethod)
					ifTrue: [ '----' ]
					ifFalse: [ | byteStr |
						byteStr := OrderedCollection new.
						each bytes
							do: [ :byte | byteStr add: ((byte radix: 10) padLeftTo: 2 with: $0) ].
						' ' join: byteStr ]) asRopedText foreground: Color blue ]
			width: 45;
		column: 'Mnemonic' translated
			text: [ :each | 
				(each isKindOf: CompiledMethod)
					ifTrue: [ 'FUNCTION '
							, ((each sourceCode
									splitOn: '
') first splitOn: ':') first ]
					ifFalse: [ each description ] ]
]

{ #category : #views }
ProcessingRunStep >> gtOutputFor: aView [
	<gtView>
	| containerElement visualOutput |
	containerElement := ProcessingCanvasElement new.
	visualOutput := containerElement
			addVisualCanvas: canvasSize
			colored: canvasColor.
	visualOutput
		size: canvasSize;
		background: canvasColor.

	shapes do: [ :shape | visualOutput addChild: shape asElementTransformed ].

	transcript
		ifNotNil: [ | transcr |
			transcr := GtTranscript new.
			transcr nextPutAll: transcript.
			containerElement addTextCanvas: transcr ].
	^ (containerElement gtLiveFor: aView)
		title: 'Output' translated;
		priority: 30
]

{ #category : #views }
ProcessingRunStep >> gtOverviewFor: aView [
	<gtView>
	(slice isKindOf: ProcessingRunawayProgramException)
		ifTrue: [  "ProcessingProgram>>#runStepsFor: adds an unthrown exception as a last step, if the program runs too long"^ aView
				forward object: [ slice signal ] ].
	^ aView explicit
		priority: 40;
		title: 'Overview' translated;
		stencil: [ BlElement new
				layout: (BlGridLayout new columnCount: 2);
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				addChild: (self getInnerView: #gtSourceCodeFor:);
				addChild: (self getInnerView: #gtVariablesFor:);
				addChild: (self getInnerView: #gtOutputFor:);
				yourself ]
]

{ #category : #views }
ProcessingRunStep >> gtSourceCodeFor: aView [
	"<gtView>"
	slice ifNil: [ ^ GtPhlowView empty ].
	^ (slice gtSourceCodeFor: aView)
		title: 'Source' translated;
		priority: 5
]

{ #category : #views }
ProcessingRunStep >> gtStackFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Stack';
		priority: 15;
		items: [ stack reverse ];
		column: 'Stack'
			text: [ :each :index | index asRopedText foreground: Color gray ]
			width: 45;
		column: 'Value' translated text: [ :each | each gtDisplayText ];
		column: '"Pointer"'
			text: [ :each | 
				| pointer |
				pointer := each basicIdentityHash.	"Fake pointers with a hash (except for small, unsigned integers)."
				(pointer = (pointer clampBetween: 0 and: 2 ** 16)
					ifTrue: [ pointer ]
					ifFalse: [ each identityHash ]) asString ]
]

{ #category : #views }
ProcessingRunStep >> gtTranspilationPlusSourceFor: aView [
	<gtView>
	slice ifNil: [ ^ GtPhlowView empty ].
	^ (slice gtTranspilationPlusSourceFor: aView)
		title: 'Sources' translated;
		priority: 5
]

{ #category : #views }
ProcessingRunStep >> gtVariablesFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Variables' translated;
		priority: 10;
		items: [ variables associations sort: (#key collatedBy: #asString) ];
		column: 'Name' translated text: [ :assoc | assoc key ];
		column: 'Variable value' translated
			text: [ :assoc | assoc value asString ]
			weight: 3;
		column: 'Type' translated text: [ :assoc | self typeName: assoc value ];
		send: [ :assoc | assoc value ]
]

{ #category : #accessing }
ProcessingRunStep >> stack [
	^ stack
]

{ #category : #accessing }
ProcessingRunStep >> transcript [
	^ transcript
]

{ #category : #accessing }
ProcessingRunStep >> typeName: obj [
	obj = nil ifTrue: [ ^ '?' ].	"undefined; most likely an unitialized slot (or rarely an explicit use of None)"
	(obj isKindOf: Integer) ifTrue: [ ^ 'int' ].
	(obj isKindOf: Float) ifTrue: [ ^ 'float' ].
	(obj isKindOf: String) ifTrue: [ ^ 'str' ].
	(obj isKindOf: Boolean) ifTrue: [ ^ 'bool' ].
	(obj isKindOf: ProcessingList) ifTrue: [ ^ 'list' ].
	(obj isKindOf: Dictionary) ifTrue: [ ^ 'dict' ].
	(obj isKindOf: SkiaImage) ifTrue: [ ^ 'Image' ].
	(obj isKindOf: ProcessingEllipsis) ifTrue: [ ^ 'Ellipsis' ].
	^ obj class name
]

{ #category : #initalization }
ProcessingRunStep >> updateCanvas: aCanvas [
	shapes := aCanvas shapes clone.
	transcript := aCanvas transcript
			ifNotNil: [ aCanvas transcript textDo: #asString ].
	canvasSize := aCanvas canvasSize.
	canvasColor := aCanvas background
]

{ #category : #accessing }
ProcessingRunStep >> variables [
	^ variables
]
