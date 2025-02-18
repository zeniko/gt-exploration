Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'output'
	],
	#category : #GtExploration
}

{ #category : #'as yet unclassified' }
ProcessingCanvas >> rect: width by: height at: xy [
	| shape |
	shape := BlElement new.
	shape background: Color white.
	shape size: (Point x: width y: height).
	shape relocate: xy.
	shape border: (BlBorder paint: Color black width: 0.5).
	output addChild: shape
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> render [
	^ output asScalableElement
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> size: width by: height [
	output := BlElement new.
	output background: Color veryLightGray.
	output size: (Point x: width y: height).
]
