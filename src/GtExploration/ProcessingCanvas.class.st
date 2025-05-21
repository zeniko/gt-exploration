Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'canvasElement',
		'textSize',
		'strokeColor',
		'strokeWeight',
		'transcript',
		'frameRate',
		'mousePosition',
		'mousePressed',
		'transforms',
		'startMilliseconds'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvas >> annotate: shape [
	| index |
	"Note the caller for later backreferencing this shape with the creating code."
	index := 1.
	[ (thisContext stack at: index) receiver = self ] whileTrue: [ index := index + 1. ].
	shape userData at: #context put: (thisContext stack at: index) copyStack.
	^ shape
]

{ #category : #views }
ProcessingCanvas >> asElement [
	^ canvasElement asScalableElement
]

{ #category : #shapes }
ProcessingCanvas >> background: color [
	self canvasElement background: color.
	self canvasElement children do: [ :child | child removeFromParent ].
]

{ #category : #shapes }
ProcessingCanvas >> backgroundGray: gray [
	self backgroundR: gray G: gray B: gray.
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

{ #category : #shapes }
ProcessingCanvas >> circle: x y: y d: d [
	^ self ellipse: d by: d at: x @ y
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
	self transform: shape.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> ellipse: x y: y dx: dx dy: dy [
	^ self ellipse: dx by: dy at: x @ y
]

{ #category : #initialization }
ProcessingCanvas >> endFrame [
	"Transforms are reset at the end of a draw-cycle"
	transforms := OrderedCollection new.
	(1 / frameRate) seconds wait.
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
ProcessingCanvas >> fillGray: gray [
	self fillR: gray G: gray B: gray.
]

{ #category : #modifiers }
ProcessingCanvas >> fillR: r G: g B: b [
	self fill: (self colorWithR: r G: g B: b)
]

{ #category : #accessing }
ProcessingCanvas >> frameRate [
	^ frameRate
]

{ #category : #accessing }
ProcessingCanvas >> frameRate: aFrameRate [
	frameRate := aFrameRate.
]

{ #category : #views }
ProcessingCanvas >> gtDisplayOn: aStream [
	aStream nextPutAll: 'Processing Canvas (@' , self basicIdentityHash asString , ')'
]

{ #category : #views }
ProcessingCanvas >> gtViewFor: aView [
	<gtView>
	^ (self asElement gtLiveFor: aView)
		title: 'Output' translated
]

{ #category : #shapes }
ProcessingCanvas >> image: image at: xy [
	^ self image: image at: xy sized: image width @ image height
]

{ #category : #shapes }
ProcessingCanvas >> image: image at: xy sized: size [
	| shape |
	shape := image asElement
		background: fillColor;
		size: size;
		relocate: xy;
		yourself.
	self transform: shape.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> image: image x: x y: y [
	self image: image at: x @ y
]

{ #category : #shapes }
ProcessingCanvas >> image: image x: x y: y width: width height: height [
	self image: image at: x @ y sized: width @ height
]

{ #category : #initialization }
ProcessingCanvas >> initialize [
	canvasElement := BlElement new
		background: Color veryLightGray;
		size: 100 @ 100;
		when: BlMouseMoveEvent do: [ :event |
			mousePosition := event localPosition.
		];
		when: BlMouseDownEvent do: [ :event |
			mousePressed := true.
		];
		when: BlMouseUpEvent do: [ :event |
			mousePressed := false.
		];
		yourself.
	
	fillColor := Color white.
	strokeColor := Color black.
	strokeWeight := 0.5.
	textSize := 12.
	transcript := nil.
	frameRate := 30.
	mousePosition := 0 @ 0.
	mousePressed := false.
	transforms := OrderedCollection new.
	startMilliseconds := Time millisecondClockValue.
]

{ #category : #shapes }
ProcessingCanvas >> line: fromXy to: toXy [
	| shape |
	shape := BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: fromXy);
		toAnchor: (BlAbsolutePositionAnchor position: toXy);
		border: self border;
		yourself.
	self transform: shape.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> line: x1 y1: y1 x2: x2 y2: y2 [
	^ self line: x1 @ y1 to: x2 @ y2
]

{ #category : #initialization }
ProcessingCanvas >> loadImage: path [
	(path beginsWith: 'http') ifTrue: [
		| bytes |
		bytes := ZnClient new get: path.
		^ SkiaImage fromBuffer: bytes start: 0 end: bytes size
	].
	(FileReference / path) exists ifTrue: [
		^ SkiaImage fromFile: FileReference / path
	].
	"Relative paths are relative to `FileLocator documents / 'lepiter'` or `FileLocator gtResource` for now (in that order)"
	(FileLocator documents / 'lepiter' / path) exists ifTrue: [
		^ SkiaImage fromFile: FileLocator documents / 'lepiter' / path
	].
	(FileLocator gtResource / path) exists ifTrue: [
		^ SkiaImage fromFile: FileLocator gtResource / path
	].
	^ nil
]

{ #category : #accessing }
ProcessingCanvas >> millis [
	^ Time millisecondClockValue - startMilliseconds
]

{ #category : #accessing }
ProcessingCanvas >> mousePressed [
	^ mousePressed
]

{ #category : #accessing }
ProcessingCanvas >> mouseX [
	^ mousePosition x rounded
]

{ #category : #accessing }
ProcessingCanvas >> mouseY [
	^ mousePosition y rounded
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
		[ canvasElement children isEmpty ] whileFalse: [
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
		transcript cr.
	].
	
	(text isKindOf: Array) ifTrue: [
		text allButLastDo: [ :part | transcript nextPut: part asString , ' ' ].
		transcript nextPut: text last asString.
	] ifFalse: [
		transcript nextPut: text asString.
	].
]

{ #category : #initialization }
ProcessingCanvas >> random: limit [
	^ SharedRandom globalGenerator next * limit
]

{ #category : #shapes }
ProcessingCanvas >> rect: width by: height at: xy [
	| shape |
	shape := BlElement new
		background: fillColor;
		size: width @ height;
		border: self border;
		yourself.
	self transform: shape position: xy.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> rect: x y: y width: width height: height [
	^ self rect: width by: height at: x @ y
]

{ #category : #modifiers }
ProcessingCanvas >> rotate: angle [
	transforms add: [ :trans | trans rotateBy: angle radiansToDegrees ].
]

{ #category : #modifiers }
ProcessingCanvas >> scale: factor [
	transforms add: [ :trans | trans scaleBy: factor ].
]

{ #category : #modifiers }
ProcessingCanvas >> size: width by: height [
	canvasElement size: width @ height.
]

{ #category : #shapes }
ProcessingCanvas >> square: x y: y side: side [
	^ self rect: side by: side at: x @ y
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
ProcessingCanvas >> strokeGray: gray [
	self strokeR: gray G: gray B: gray.
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
	self transform: shape.
	canvasElement addChild: shape.
	"y-position is of baseline"
	shape relocate: pos x @ (pos y - textSize).
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> text: text x: x y: y [
	^ self text: text at: x @ y
]

{ #category : #accessing }
ProcessingCanvas >> textSize [
	^ textSize
]

{ #category : #modifiers }
ProcessingCanvas >> textSize: size [
	textSize := size.
]

{ #category : #accessing }
ProcessingCanvas >> transcript [
	^ transcript
]

{ #category : #modifiers }
ProcessingCanvas >> transform: shape [
	| transform |
	transform := shape transform.
	transform normalizedOrigin: 0 @ 0.
	transforms reverseDo: [ :tf | tf cull: transform ].
	transform apply.
	^ shape
]

{ #category : #modifiers }
ProcessingCanvas >> transform: shape position: position [
	| transform |
	transform := shape transform.
	transform normalizedOrigin: 0 @ 0.
	transform translateBy: position.
	transforms reverseDo: [ :tf | tf cull: transform ].
	transform apply.
	^ shape
]

{ #category : #modifiers }
ProcessingCanvas >> translate: x y: y [
	transforms add: [ :trans | trans translateBy: x @ y ].
]

{ #category : #shapes }
ProcessingCanvas >> triangle: vertices [
	| shape |
	shape := BlPolygonElement new
		anchors: (vertices collect: [ :xy | BlAbsolutePositionAnchor position: xy ]);
		background: fillColor;
		border: self border;
		yourself.
	self transform: shape.
	canvasElement addChild: shape.
	^ self annotate: shape
]

{ #category : #shapes }
ProcessingCanvas >> triangle: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 [
	^ self triangle: { x1 @ y1. x2 @ y2. x3 @ y3. }
]
