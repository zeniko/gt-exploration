Class {
	#name : #ProcessingCodeBase,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingCodeBase >> gtBytecodeFor: aView [
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

{ #category : #'as yet unclassified' }
ProcessingCodeBase >> gtOutputFor: aView [
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

{ #category : #'as yet unclassified' }
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
			tooltip: 'Browse class in Coder'
			action: [ self gtBrowse ]
]

{ #category : #'as yet unclassified' }
ProcessingCodeBase >> gtViewIntermediaryRepresentationFor: aView [
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
