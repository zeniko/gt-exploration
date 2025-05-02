Class {
	#name : #ProcessingCodeBase,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCodeBase >> gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Abstractions' translated;
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
			
			(self gtViewIntermediaryRepresentationFor: GtPhlowView empty)
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

{ #category : #views }
ProcessingCodeBase >> gtBytecodeFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Bytecode' translated;
		priority: 12;
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
					each bytes do: [ :byte | byteStr add: ((byte radix: 16) padLeftTo: 2 with: $0) ].
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
ProcessingCodeBase >> gtGenerateIR: aSourceCode [
	| trans ast |
	trans := OCASTTranslator new.
	ast := OpalCompiler new parse: aSourceCode.
	ast acceptVisitor: trans.
	"calling IRBuilder>>#ir performs some optimizations, so skip around it"
	^ trans privateMethodBuilder instVarNamed: #ir
]

{ #category : #views }
ProcessingCodeBase >> gtOutputFor: aView [
	<gtView>
	^ aView explicit
		title: 'Output' translated;
		priority: 20;
		stencil: [ | canvas |
			canvas := ProcessingRunner new run: self clone; canvas.
			GtInspectorElementLiveViewContainer new
				element: canvas asElement;
				clipChildren: false
		]
]

{ #category : #views }
ProcessingCodeBase >> gtSelectBytecode: aList at: position [
	| slices indices |
	slices := (self instVarNamed: #gtAstMaps) select: [ :slice |
		(slice astNode sourceInterval first - 1 <= position) &
		(slice astNode sourceInterval last >= position)
	].
	slices size = 0 ifTrue: [ ^ nil ].
	
	indices := (1 to: aList items size) select: [ :index |
		| item |
		item := aList items at: index.
		(item isKindOf: SymbolicBytecode) and: [
			(item method name = slices last method name) &
			(item sourceInterval first >= slices last startPos) &
			(item sourceInterval last <= slices last endPos)
		]
	].
	indices size > 0 ifTrue: [
		aList selectOne: indices last.
		aList scrollToSelection.
	].
]

{ #category : #views }
ProcessingCodeBase >> gtSelectIRNode: aList at: position [
	| slices indices |
	slices := (self instVarNamed: #gtAstMaps) select: [ :slice |
		(slice astNode sourceInterval first - 1 <= position) &
		(slice astNode sourceInterval last >= position)
	].
	slices size = 0 ifTrue: [ ^ nil ].
	
	indices := (1 to: aList items size) select: [ :index |
		| item |
		item := aList items at: index.
		(item isKindOf: IRInstruction) and: [
			item sourceNode ifNotNil: [
				(item sourceNode methodNode sourceCode = slices last method sourceCode) &
				(item sourceNode sourceInterval first >= slices last startPos) &
				(item sourceNode sourceInterval last <= slices last endPos)
			] ifNil: [ false ]
		]
	].
	indices size > 0 ifTrue: [
		aList selectOne: indices last.
		aList scrollToSelection.
	].
]

{ #category : #views }
ProcessingCodeBase >> gtSliceForIRItem: irNode [
	| slices |
	slices := (self instVarNamed: #gtAstMaps) select: [ :slice |
		irNode sourceNode ifNotNil: [
			(slice method sourceCode = irNode sourceNode methodNode sourceCode) and: [
				(slice startPos <= irNode sourceNode sourceInterval first) &
				(slice endPos >= irNode sourceNode sourceInterval last)
			]
		] ifNil: [ false ]
	].
	slices size = 0 ifTrue: [ ^ nil ].
	^ slices last
]

{ #category : #views }
ProcessingCodeBase >> gtSliceForItem: byteCode [
	| slices |
	slices := (self instVarNamed: #gtAstMaps) select: [ :slice |
		(slice method = byteCode method) and: [
			(slice startPos <= byteCode sourceInterval first) &
			(slice endPos >= byteCode sourceInterval last)
		]
	].
	slices size = 0 ifTrue: [ ^ nil ].
	^ slices last
]

{ #category : #views }
ProcessingCodeBase >> gtSliceForItem: method within: interval [
	| slices |
	slices := (self instVarNamed: #gtAstMaps) select: [ :slice |
		(slice method = method) and: [
			(slice startPos <= interval first) &
			(slice endPos >= interval last)
		]
	].
	slices size = 0 ifTrue: [ ^ nil ].
	^ slices last
]

{ #category : #views }
ProcessingCodeBase >> gtSlicesFor: aView [
	<gtView>
	^ ((Stepper for: (self instVarNamed: #gtAstMaps) view: #gtComparisonFor:) gtListViewFor: aView)
		title: 'Slices' translated;
		priority: 7
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
		priority: 5;
		stencil: [
			"TODO: Find a better way of removing the filter bar"
			(GtPharoStreamingMethodsCoderElement new streamingCodersViewModel: viewModel) children second removeFromParent
		];
		actionButtonIcon: BrGlamorousVectorIcons browse
			tooltip: 'Browse class in Coder' translated
			action: [ self gtBrowse ]
]

{ #category : #views }
ProcessingCodeBase >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ aView columnedList
		title: 'IR';
		priority: 10;
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
