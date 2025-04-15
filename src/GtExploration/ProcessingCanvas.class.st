Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'canvasElement'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingCanvas >> asElement [
	^ canvasElement asScalableElement
]

{ #category : #accessing }
ProcessingCanvas >> canvasElement [
	^ canvasElement
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> colorWithR: r g: g b: b [
	"Map 64 to 0.25, 128 to 0.5, 192 to 0.75 but 255 to 1.0 exactly."
	^ Color fromRgbTriplet: {
		((r / 255.5) roundTo: 0.005) .
		((g / 255.5) roundTo: 0.005) .
		((b / 255.5) roundTo: 0.005)
	}

]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> ellipse: dx by: dy at: xy [
	| shape |
	shape := BlEllipseElement new.
	shape background: fillColor.
	shape majorRadius: dx / 2.
	shape minorRadius: dy / 2.
	shape centerAnchor: (BlAbsolutePositionAnchor new position: xy).
	shape border: (BlBorder paint: Color black width: 0.5).
	canvasElement addChild: shape
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
		object: [ self asElement ];
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
ProcessingCanvas >> size: width by: height [
	canvasElement size: (Point x: width y: height).
]
