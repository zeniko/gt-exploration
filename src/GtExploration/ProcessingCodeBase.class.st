Class {
	#name : #ProcessingCodeBase,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCodeBase >> _gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Abstractions';
		stencil: [ | element child |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self _gtSourceCodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self _gtViewIntermediaryRepresentationFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self _gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self _gtOutputFor: GtPhlowView empty)
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
ProcessingCodeBase >> _gtBytecodeFor: aView [
	<gtView>
	^ aView list
		title: 'Bytecode';
		priority: 11;
		items: [ | codes |
			codes := OrderedCollection new.
			self class methodDict keysAndValuesDo: [ :key :value |
				codes add: 'FUNCTION ' , key; addAll: value symbolicBytecodes
			].
			codes
		];
		itemText: [ :each | each printString ]
]

{ #category : #views }
ProcessingCodeBase >> _gtOutputFor: aView [
	<gtView>
	^ aView explicit
		title: 'Output';
		priority: 20;
		stencil: [ | canvas |
			canvas := ProcessingRunner new run: self; canvas.
			GtInspectorElementLiveViewContainer new
				element: canvas asElement;
				clipChildren: false
		]
]

{ #category : #views }
ProcessingCodeBase >> _gtSelectBytecode: aList at: position [
	| slices indices |
	slices := (self instVarNamed: #_astMaps) select: [ :slice |
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
ProcessingCodeBase >> _gtSliceForItem: byteCode [
	| slices |
	slices := (self instVarNamed: #_astMaps) select: [ :slice |
		(slice method = byteCode method) and: [
			(slice startPos <= byteCode sourceInterval first) &
			(slice endPos >= byteCode sourceInterval last)
		]
	].
	slices size = 0 ifTrue: [ ^ nil ].
	^ slices last
]

{ #category : #views }
ProcessingCodeBase >> _gtSliceForItem: method within: interval [
	| slices |
	slices := (self instVarNamed: #_astMaps) select: [ :slice |
		(slice method = method) and: [
			(slice startPos <= interval first) &
			(slice endPos >= interval last)
		]
	].
	slices size = 0 ifTrue: [ ^ nil ].
	^ slices last
]

{ #category : #views }
ProcessingCodeBase >> _gtSlicesFor: aView [
	<gtView>
	^ aView list
		title: 'Slices';
		priority: 7;
		items: [ self instVarNamed: #_astMaps ];
		itemText: [ :each | each slice: each method sourceCode ]
]

{ #category : #views }
ProcessingCodeBase >> _gtSourceCodeFor: aView [
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
			tooltip: 'Browse class in Coder'
			action: [ self gtBrowse ]
]

{ #category : #views }
ProcessingCodeBase >> _gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ aView text
		title: 'IR';
		priority: 10;
		text: [ | string |
			string := ''.
			self class methodDict keysAndValuesDo: [ :key :value |
				string := string , 'FUNCTION ' , key , '
' , value ast ir longPrintString
			].
			string
		]
]
