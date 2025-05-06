Class {
	#name : #ProcessingCodeBase,
	#superclass : #Object,
	#instVars : [
		'gtCanvas',
		'gtAstMaps'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCodeBase >> gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Abstractions' translated;
		priority: 1;
		stencil: [ | element child |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtSourceCodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self gtIntermediaryRepresentationFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self gtOutputFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
			element ]
]

{ #category : #accessing }
ProcessingCodeBase >> gtAstMaps [
	^ gtAstMaps
]

{ #category : #views }
ProcessingCodeBase >> gtBytecodeFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Bytecode' translated;
		priority: 30;
		items: [
			| list |
			list := OrderedCollection new.
			self class methodDict keysAndValuesDo: [ :key :value |
				list add: value; addAll: value symbolicBytecodes
			].
			list
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

{ #category : #accessing }
ProcessingCodeBase >> gtCanvas [
	^ gtCanvas
]

{ #category : #accessing }
ProcessingCodeBase >> gtCanvas: aCanvas [
	gtCanvas := aCanvas.
]

{ #category : #meta }
ProcessingCodeBase >> gtGenerateIR: aSourceCode [
	| trans ast |
	trans := OCASTTranslator new.
	ast := OpalCompiler new parse: aSourceCode.
	ast acceptVisitor: trans.
	"calling IRBuilder>>#ir performs some optimizations, so skip around it"
	^ trans privateMethodBuilder instVarNamed: #ir
]

{ #category : #views }
ProcessingCodeBase >> gtIntermediaryRepresentationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'IR';
		priority: 20;
		items: [
			| list |
			list := OrderedCollection new.
			self class methodDict keysAndValuesDo: [ :key :value |
				| ir |
				list add: value.
				ir := self gtGenerateIR: value sourceCode.
				ir startSequence withAllSuccessors do: [ :seq |
					list addAll: seq sequence
				].
			].
			list
		];
		column: 'Label' translated
			text: [ :each |
				((each isKindOf: CompiledMethod) ifTrue: [
					'----'
				] ifFalse: [
					each sequence sequence first = each ifTrue: [
						each sequence orderNumber asString
					] ifFalse: [
						''
					]
				]) asRopedText foreground: Color gray
			] width: 45;
		column: 'Instruction' translated
			text: [ :each |
				(each isKindOf: CompiledMethod) ifTrue: [
					'FUNCTION ' , ((each sourceCode splitOn: '
') first splitOn: ':') first
				] ifFalse: [
					each gtDisplayText
				]
			].
]

{ #category : #accessing }
ProcessingCodeBase >> gtIsAnimation [
	^ self class methodDict includesKey: #draw
]

{ #category : #views }
ProcessingCodeBase >> gtOutputFor: aView [
	<gtView>
	^ aView explicit
		title: 'Output' translated;
		priority: 40;
		stencil: [ | canvas |
			canvas := ProcessingRunner new
				limitTo: (self gtIsAnimation ifTrue: [ 30 ] ifFalse: [ 2 ]) seconds;
				run: self clone;
				canvas.
			canvas asElement
		]
]

{ #category : #meta }
ProcessingCodeBase >> gtSliceFor: method within: interval [
	| slices |
	slices := gtAstMaps select: [ :slice |
		(slice method sourceCode = method sourceCode) and: [
			slice interval includesAll: interval
		]
	].
	slices ifEmpty: [ ^ nil ].
	^ slices last
]

{ #category : #meta }
ProcessingCodeBase >> gtSlicesAround: aPosition [
	^ gtAstMaps select: [ :slice |
		(slice astNode sourceInterval first - 1 <= aPosition) &
		(slice astNode sourceInterval last >= aPosition)
	]
]

{ #category : #views }
ProcessingCodeBase >> gtSlicesFor: aView [
	<gtView>
	^ ((Stepper for: gtAstMaps view: #gtComparisonFor:) gtListViewFor: aView)
		title: 'Slices' translated;
		priority: 12
]

{ #category : #views }
ProcessingCodeBase >> gtSourceCodeFor: aView [
	<gtView>
	"Adapted from GtPharoMethodsCoderView>>#gtMethodsFor"
	| coder viewModel |
	coder := GtPharoStreamingMethodsCoder forFilter: (GtSearchInheritedMethodsFilter forClass: self class).
	
	viewModel := (GtPharoStreamingMethodsCoderViewModel new streamingCodersModel: coder)
		shouldExpandByDefault: true;
		shouldHaveHeaderByDefault: false.
	
	^ aView explicit
		title: 'Smalltalk';
		priority: 10;
		stencil: [
			"TODO: Find a better way of removing the filter bar"
			(GtPharoStreamingMethodsCoderElement new streamingCodersViewModel: viewModel) children second removeFromParent
		]
]

{ #category : #initialization }
ProcessingCodeBase >> initialize [
	gtAstMaps := OrderedCollection new.
]
