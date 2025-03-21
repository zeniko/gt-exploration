Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'canvasElement'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingCanvas >> canvasElement [
	^ canvasElement
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> colorWithR: r g: g b: b [
	^ Color fromRgbTriplet: { r / 255.0 . g / 255.0 . b / 255.0 }
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> fill: color [
	fillColor:=color.
]

{ #category : #accessing }
ProcessingCanvas >> fillColor [
	^ fillColor
]

{ #category : #views }
ProcessingCanvas >> gtViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Live';
		object: [ self render ];
		view: #gtLiveFor:
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> initialize [
	canvasElement := BlElement new.
	canvasElement background: Color veryLightGray.
	canvasElement size: 100 @ 100.
	fillColor := Color white.
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> rect: width by: height at: xy [
	| shape |
	shape := BlElement new.
	shape background: fillColor.
	shape size: (Point x: width y: height).
	shape relocate: xy.
	shape border: (BlBorder paint: Color black width: 0.5).
	canvasElement addChild: shape
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> render [
	^ canvasElement asScalableElement
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> size: width by: height [
	canvasElement size: (Point x: width y: height).
]
