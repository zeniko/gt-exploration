Class {
	#name : #ProcessingRunStep,
	#superclass : #Object,
	#instVars : [
		'variables',
		'canvas',
		'visible',
		'method'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initalization }
ProcessingRunStep class >> create: aContext canvas: aCanvas [
	^ ProcessingRunStep new create: aContext canvas: aCanvas
]

{ #category : #initalization }
ProcessingRunStep >> create: aContext canvas: aCanvas [
	canvas := aCanvas.
	visible := aCanvas canvasElement children collect: [ :child | child ].
	variables := Dictionary new.
	aContext receiver ifNotNil: [
		aContext receiver class slots do: [ :slot |
			slot name first = $_ ifTrue: [
				slot name second = $_ ifTrue: [
					variables at: slot name put: (aContext receiver instVarNamed: (slot name copyFrom: 2))
				].
			] ifFalse: [
				variables at: slot name put: (aContext receiver instVarNamed: slot name)
			].
		].
	].
	aContext tempNames do: [ :name | variables at: name put: (aContext tempNamed: name) ].
	method := aContext sourceNodeExecuted.
]

{ #category : #views }
ProcessingRunStep >> gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		priority: 0;
		title: 'Abstractions';
		stencil: [ | element child |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 1).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtVariablesFor: GtPhlowView empty)
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
	canvas canvasElement children do: [ :child |
		child visibility: ((visible includes: child) ifTrue: [ BlVisibility visible ] ifFalse: [ BlVisibility hidden ]).
	].
	^ canvas gtViewFor: aView
]

{ #category : #views }
ProcessingRunStep >> gtSourceCodeFor: aView [
	<gtView>
	^ method gtSourceCodeFor: aView
]

{ #category : #views }
ProcessingRunStep >> gtVariablesFor: aView [
	<gtView>
	^  variables gtItemsFor: aView
]
