Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'canvasElement',
		'textSize'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingCanvas >> asElement [
	^ canvasElement asScalableElement
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> background: color [
	self canvasElement background: color.
	self canvasElement children do: [ :child | child removeFromParent ].
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
	shape := BlEllipseElement new
		centerAnchor: (BlAbsolutePositionAnchor position: xy);
		majorRadius: dx / 2;
		minorRadius: dy / 2;
		background: fillColor;
		border: (BlBorder paint: Color black width: 0.5);
		yourself.
	canvasElement addChild: shape.
	^ shape
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> fill: color [
	fillColor := color.
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
	canvasElement := BlElement new
		background: Color veryLightGray;
		size: 100 @ 100;
		yourself.
	fillColor := Color white.
	textSize := 12.
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> line: fromXy to: toXy [
	| shape |
	shape := BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: fromXy);
		toAnchor: (BlAbsolutePositionAnchor position: toXy);
		border: (BlBorder paint: Color black width: 0.5);
		yourself.
	canvasElement addChild: shape.
	^ shape
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> rect: width by: height at: xy [
	| shape |
	shape := BlElement new
		background: fillColor;
		size: (Point x: width y: height);
		relocate: xy;
		border: (BlBorder paint: Color black width: 0.5);
		yourself.
	canvasElement addChild: shape.
	^ shape
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> size: width by: height [
	canvasElement size: width @ height.
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> text: text at: pos [
	| roped shape |
	roped := text asRopedText
		fontSize: textSize;
		foreground: fillColor.
	shape := BlTextElement new text: roped.
	canvasElement addChild: shape.
	"y-position is of baseline"
	shape relocate: pos x @ (pos y - textSize).
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> textSize [
	^ textSize
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> textSize: size [
	textSize := size.
]

{ #category : #'as yet unclassified' }
ProcessingCanvas >> triangle: vertices [
	| shape |
	shape := BlPolygonElement new
		anchors: (vertices collect: [ :xy | BlAbsolutePositionAnchor position: xy ]);
		background: fillColor;
		border: (BlBorder paint: Color black width: 0.5);
		yourself.
	canvasElement addChild: shape.
	^ shape
]
