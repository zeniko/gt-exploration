Class {
	#name : #ProcessingCanvasElement,
	#superclass : #BlElement,
	#instVars : [
		'graphicalContainer'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvasElement >> addTextCanvasFor: aTranscript [
	self addChild: (aTranscript asElement
		constraintsDo: [ :c |
			c frame vertical weight: 0.3.
			c frame vertical alignBottom.
		]).
	graphicalContainer constraintsDo: [ :c |
		c frame vertical weight: 0.7.
	].
]

{ #category : #initialization }
ProcessingCanvasElement >> addVisualCanvasFor: aProcessingCanvas [
	| canvasElement |
	canvasElement := BlElement new
		background: aProcessingCanvas background;
		size: aProcessingCanvas canvasSize;
		yourself.
	graphicalContainer addChild: canvasElement asScalableElement.
	^ canvasElement
]

{ #category : #initialization }
ProcessingCanvasElement >> initialize [
	super initialize.
	
	graphicalContainer := BlElement new
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent
		];
		yourself.
	
	self
		background: Color white;
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent
		];
		addChild: graphicalContainer.
]
