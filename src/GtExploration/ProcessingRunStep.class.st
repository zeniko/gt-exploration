Class {
	#name : #ProcessingRunStep,
	#superclass : #Object,
	#instVars : [
		'variables',
		'canvas',
		'visible',
		'method',
		'stack',
		'slice',
		'transcript'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initalization }
ProcessingRunStep class >> create: aContext canvas: aCanvas slice: aSlice [
	^ ProcessingRunStep new create: aContext canvas: aCanvas slice: aSlice
]

{ #category : #views }
ProcessingRunStep >> asString [
	^ 'Step: ' , slice asString
]

{ #category : #initalization }
ProcessingRunStep >> canvasTranscript [
	^ canvas transcript ifNotNil: [ canvas transcript textDo: [ :text | text asString ] ] ifNil: [ '' ]
]

{ #category : #initalization }
ProcessingRunStep >> create: aContext canvas: aCanvas slice: aSlice [
	canvas := aCanvas.
	visible := aCanvas canvasElement children collect: [ :child | child ].
	transcript := self canvasTranscript.
	variables := Dictionary new.
	aContext receiver ifNotNil: [
		aContext receiver class slots do: [ :slot |
			(slot name beginsWith: 'gt_') ifTrue: [
				variables at: ('gt' , (slot name removePrefix: 'gt_')) asSymbol put: (aContext receiver instVarNamed: slot name)
			].
			(slot name beginsWith: 'gt') ifFalse: [
				((slot name = #width) | (slot name = #height)) ifFalse: [
					variables at: slot name put: (aContext receiver instVarNamed: slot name)
				].
			].
		].
	].
	aContext tempNames do: [ :name | variables at: name put: (aContext tempNamed: name) ].
	method := aContext sourceNodeExecuted.
	stack := (1 to: aContext size) collect: [ :ix | aContext at: ix ].
	slice := aSlice.
]

{ #category : #views }
ProcessingRunStep >> gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Abstractions' translated;
		stencil: [ | element child inner |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			child := BlElement new.
			slice ifNotNil: [
				(slice gtSourceFor: GtPhlowView empty)
					asElementDo: [ :e | child := e ].
				child
					background: Color white;
					margin: (BlInsets all: 5).
			].
			element addChild: child.
			
			(self gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
			inner := BlElement new.
			inner layout: BlLinearLayout vertical.
			inner
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtVariablesFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			inner addChild: child.
			
			(self gtStackFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			inner addChild: child.
			element addChild: inner.
			
			(self gtOutputFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			element ]
]

{ #category : #views }
ProcessingRunStep >> gtBytecodeFor: aView [
	"Adapted from ProcessingCodeBase>>#gtBytecodeFor:"
	<gtView>
	^ aView columnedList
		title: 'Bytecode' translated;
		priority: 30;
		items: [
			method methodNode method symbolicBytecodes select: [ :item |
				slice interval includesAll: item sourceInterval
			]
		];
		column: 'Address' translated
			text: [ :each |
				((each isKindOf: CompiledMethod) ifTrue: [
					'----'
				] ifFalse: [
					each offset
				]) asRopedText foreground: Color gray
			] width: 50;
		column: 'Code' translated
			text: [ :each |
				((each isKindOf: CompiledMethod) ifTrue: [
					'----'
				] ifFalse: [
					| byteStr |
					byteStr := OrderedCollection new.
					each bytes do: [ :byte | byteStr add: ((byte radix: 10) padLeftTo: 2 with: $0) ].
					' ' join: byteStr
				]) asRopedText foreground: Color blue
			] width: 45;
		column: 'Mnemonic' translated
			text: [ :each |
				(each isKindOf: CompiledMethod) ifTrue: [
					'FUNCTION ' , ((each sourceCode splitOn: '
') first splitOn: ':') first
				] ifFalse: [
					each description
				]
			]
]

{ #category : #views }
ProcessingRunStep >> gtOutputFor: aView [
	<gtView>
	"since the canvas can't be (easily) cloned, reuse it and just show only elements visible at this step"
	canvas canvasElement children do: [ :child |
		child visibility: ((visible includes: child) ifTrue: [ BlVisibility visible ] ifFalse: [ BlVisibility hidden ]).
	].
	canvas transcript ifNotNil: [
		"TODO: Clearing an empty GtTranscript raises an exception."
		self canvasTranscript ifNotEmpty: [
			canvas transcript clear.
		].
		canvas transcript nextPutAll: transcript.
	].
	^ (canvas gtViewFor: aView)
		title: 'Output' translated;
		priority: 20
]

{ #category : #views }
ProcessingRunStep >> gtSourceCodeFor: aView [
	<gtView>
	^ (slice gtComparisonFor: aView)
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
		column: 'Stack' text: [ :each :index | index asRopedText foreground: Color gray ] width: 45;
		column: 'Value' translated text: [ :each | each gtDisplayText ];
		column: '"Pointer"' text: [ :each | each basicIdentityHash asString ]
]

{ #category : #views }
ProcessingRunStep >> gtVariablesFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'Variables' translated;
		priority: 10;
		items: [ variables associations sort: (#key collatedBy: #asString) ];
		column: 'Name' translated text: [ :assoc | assoc key ];
		column: 'Variable value' translated text: [ :assoc | assoc value ] weight: 3;
		send: [ :assoc | assoc value ]
]

{ #category : #initalization }
ProcessingRunStep >> updateCanvas: aCanvas [
	visible := aCanvas canvasElement children collect: [ :child | child ].
	transcript := self canvasTranscript.
]
