Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'canvasElement',
		'textSize',
		'strokeColor',
		'strokeWeight',
		'transcript'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvas >> annotate: shape [
	"Note the caller for later backreferencing this shape with the creating code."
	shape userData at: #context put: thisContext stack third copyStack.
	^ shape
]

{ #category : #accessing }
ProcessingCanvas >> asElement [
	^ canvasElement asScalableElement
]

{ #category : #shapes }
ProcessingCanvas >> background: color [
	self canvasElement background: color.
	self canvasElement children do: [ :child | child removeFromParent ].
]

{ #category : #shapes }
ProcessingCanvas >> backgroundR: r G: g B: b [
	self background: (self colorWithR: r G: g B: b)
]

{ #category : #initialization }
ProcessingCanvas >> border [
	^ BlBorder paint: strokeColor width: strokeWeight
]

{ #category : #accessing }
ProcessingCanvas >> canvasElement [
	^ canvasElement
]

{ #category : #initialization }
ProcessingCanvas >> colorWithR: r G: g B: b [
	"Map 64 to 0.25, 128 to 0.5, 192 to 0.75 but 255 to 1.0 exactly."
	^ Color fromRgbTriplet: {
		((r / 255.5) roundTo: 0.005) .
		((g / 255.5) roundTo: 0.005) .
		((b / 255.5) roundTo: 0.005)
	}

]

{ #category : #shapes }
ProcessingCanvas >> ellipse: dx by: dy at: xy [
	| shape |
	shape := BlEllipseElement new
		centerAnchor: (BlAbsolutePositionAnchor position: xy);
		majorRadius: dx / 2;
		minorRadius: dy / 2;
		background: fillColor;
		border: self border;
		yourself.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #modifiers }
ProcessingCanvas >> fill: color [
	fillColor := color.
]

{ #category : #accessing }
ProcessingCanvas >> fillColor [
	^ fillColor
]

{ #category : #modifiers }
ProcessingCanvas >> fillR: r G: g B: b [
	self fill: (self colorWithR: r G: g B: b)
]

{ #category : #views }
ProcessingCanvas >> gtViewFor: aView [
	<gtView>
	^ (self asElement gtLiveFor: aView)
		title: 'Output' translated
]

{ #category : #initialization }
ProcessingCanvas >> initialize [
	canvasElement := BlElement new
		background: Color veryLightGray;
		size: 100 @ 100;
		yourself.
	fillColor := Color white.
	strokeColor := Color black.
	strokeWeight := 0.5.
	textSize := 12.
	transcript := nil.
]

{ #category : #shapes }
ProcessingCanvas >> line: fromXy to: toXy [
	| shape |
	shape := BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: fromXy);
		toAnchor: (BlAbsolutePositionAnchor position: toXy);
		border: self border;
		yourself.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> print: text [
	transcript ifNil: [
		| innerCanvas |
		transcript := GtTranscript new.
		innerCanvas := BlElement new
			background: canvasElement background;
			size: canvasElement constraints horizontal resizer size @ canvasElement constraints vertical resizer size;
			yourself.
		[canvasElement children size > 0 ] whileTrue: [
			innerCanvas addChild: (canvasElement removeChildAt: 1).
		].
		canvasElement
			background: Color white;
			layout: BlGridLayout vertical;
			constraintsDo: [ :c | 
				c vertical matchParent.
				c horizontal matchParent ].
		canvasElement addChild: innerCanvas asScalableElement.
		canvasElement addChild: transcript asElement.
	] ifNotNil: [
		transcript nextPut: '
'.
	].
	
	(text isKindOf: Array) ifTrue: [
		text allButLastDo: [ :part | transcript nextPut: part asString , ' ' ].
		transcript nextPut: text last asString.
	] ifFalse: [
		transcript nextPut: text asString.
	].
]

{ #category : #shapes }
ProcessingCanvas >> rect: width by: height at: xy [
	| shape |
	shape := BlElement new
		background: fillColor;
		size: width @ height;
		relocate: xy;
		border: self border;
		yourself.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #modifiers }
ProcessingCanvas >> size: width by: height [
	canvasElement size: width @ height.
]

{ #category : #modifiers }
ProcessingCanvas >> stroke: color [
	strokeColor := color.
]

{ #category : #accessing }
ProcessingCanvas >> strokeColor [
	^ strokeColor
]

{ #category : #modifiers }
ProcessingCanvas >> strokeR: r G: g B: b [
	self stroke: (self colorWithR: r G: g B: b)
]

{ #category : #accessing }
ProcessingCanvas >> strokeWeight [
	^ strokeWeight
]

{ #category : #modifiers }
ProcessingCanvas >> strokeWeight: weight [
	strokeWeight := weight.
]

{ #category : #shapes }
ProcessingCanvas >> text: text at: pos [
	| roped shape |
	roped := text asRopedText
		fontSize: textSize;
		foreground: fillColor.
	shape := BlTextElement new text: roped.
	canvasElement addChild: shape.
	"y-position is of baseline"
	shape relocate: pos x @ (pos y - textSize).
	^ self annotate: shape
]

{ #category : #accessing }
ProcessingCanvas >> textSize [
	^ textSize
]

{ #category : #modifiers }
ProcessingCanvas >> textSize: size [
	textSize := size.
]

{ #category : #shapes }
ProcessingCanvas >> triangle: vertices [
	| shape |
	shape := BlPolygonElement new
		anchors: (vertices collect: [ :xy | BlAbsolutePositionAnchor position: xy ]);
		background: fillColor;
		border: self border;
		yourself.
	canvasElement addChild: shape.
	^ self annotate: shape
]
