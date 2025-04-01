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
		items: [ (self class >> #drawOnto:) symbolicBytecodes ];
		itemText: [ :each | each printString ]
]

{ #category : #'as yet unclassified' }
ProcessingCodeBase >> gtOutputFor: aView [
	"copy/paste from BlElement > #gtLiveFor:"
	<gtView>
	^ aView explicit
		title: 'Output';
		priority: 20;
		stencil: [ | canvas |
			canvas := ProcessingCanvas new.
			self perform: #drawOnto: with: canvas.
			GtInspectorElementLiveViewContainer new
				element: canvas render;
				clipChildren: false
		]
]

{ #category : #'as yet unclassified' }
ProcessingCodeBase >> gtSourceCodeFor: aView [
	<gtView>
	^ aView explicit
		title: 'Smalltalk';
		priority: 5;
		actionButtonIcon: BrGlamorousVectorIcons browse
			tooltip: 'Browse method'
			action: [ self gtBrowse ];
		stencil: [ (GtPharoMethodCoder forMethod: (self class >> #drawOnto:)) asExpandedOnlyElement vFitContentLimited ]
]

{ #category : #'as yet unclassified' }
ProcessingCodeBase >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ aView text
		title: 'IR';
		priority: 10;
		text: [ | string |
			string := (self class >> #drawOnto:) ast ir longPrintString.
			string copyFrom: 2 to: string size
		]
]
