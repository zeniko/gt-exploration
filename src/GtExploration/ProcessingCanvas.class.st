Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'output',
		'fillColor'
	],
	#category : #GtExploration
}

{ #category : #'as yet unclassified' }
ProcessingCanvas >> colorWithR: r g: g b: b [
	^ Color fromRgbTriplet: { r / 255.0 . g / 255.0 . b / 255.0 }
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> fill: color [
	fillColor:=color.
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> initialize [
	output := BlElement new.
	output background: Color veryLightGray.
	output size: 100 @ 100.
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
	output addChild: shape
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> render [
	^ output asScalableElement
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> size: width by: height [
	output size: (Point x: width y: height).
]
