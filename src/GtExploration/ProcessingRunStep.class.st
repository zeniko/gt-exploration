Class {
	#name : #ProcessingRunStep,
	#superclass : #Object,
	#instVars : [
		'variables',
		'canvas',
		'visible',
		'method',
		'stack',
		'slice'
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
ProcessingRunStep >> create: aContext canvas: aCanvas slice: aSlice [
	canvas := aCanvas.
	visible := aCanvas canvasElement children collect: [ :child | child ].
	variables := Dictionary new.
	aContext receiver ifNotNil: [
		aContext receiver class slots do: [ :slot |
			(slot name beginsWith: '__') ifTrue: [
				variables at: slot name put: (aContext receiver instVarNamed: (slot name copyFrom: 2))
			].
			(slot name beginsWith: '_') ifFalse: [
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
		title: 'Abstractions';
		stencil: [ | element child |
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
			
			(self gtVariablesFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self gtStackFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
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
ProcessingRunStep >> gtOutputFor: aView [
	<gtView>
	"since the canvas can't be (easily) cloned, reuse it and just show only elements visible at this step"
	canvas canvasElement children do: [ :child |
		child visibility: ((visible includes: child) ifTrue: [ BlVisibility visible ] ifFalse: [ BlVisibility hidden ]).
	].
	^ (canvas gtViewFor: aView)
		title: 'Output';
		priority: 20
]

{ #category : #views }
ProcessingRunStep >> gtSourceCodeFor: aView [
	<gtView>
	^ (slice gtComparisonFor: aView)
		title: 'Source';
		priority: 5
]

{ #category : #views }
ProcessingRunStep >> gtStackFor: aView [
	<gtView>
	^ (stack gtItemsFor: aView)
		title: 'Stack';
		priority: 15
]

{ #category : #views }
ProcessingRunStep >> gtVariablesFor: aView [
	<gtView>
	^ (variables gtItemsFor: aView)
		title: 'Variables';
		priority: 10
]

{ #category : #initalization }
ProcessingRunStep >> updateCanvas: aCanvas [
	visible := aCanvas canvasElement children collect: [ :child | child ].
]
