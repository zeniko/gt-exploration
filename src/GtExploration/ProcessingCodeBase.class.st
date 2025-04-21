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
		title: 'Abstractions';
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
			tooltip: 'Browse class in Coder'
			action: [ self gtBrowse ]
]

{ #category : #views }
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
