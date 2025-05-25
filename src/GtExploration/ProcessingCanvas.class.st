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
		'startMilliseconds',
		'canvas',
		'events'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvas >> asElement [
	^ canvasElement asScalableElement
]

{ #category : #shapes }
ProcessingCanvas >> background: color [
	canvas background: color.
	canvas children do: #removeFromParent.
]

{ #category : #shapes }
ProcessingCanvas >> backgroundGray: gray [
	"`gray` is a single number or a single Color"
	(gray isKindOf: Color) ifTrue: [ ^ self background: gray ].
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
	"The canvas element also contains the transcript after the first use of `print`."
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
	| shape topLeft |
	topLeft := xy - ((dx / 2) @ (dy / 2)).
	shape := BlEllipseElement new
		centerAnchor: (BlAbsolutePositionAnchor position: xy - topLeft);
		majorRadius: dx / 2;
		minorRadius: dy / 2;
		background: fillColor;
		border: self border;
		yourself.
	^ self place: shape at: topLeft
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
	"`gray` is a single number or a single Color"
	(gray isKindOf: Color) ifTrue: [ ^ self fill: gray ].
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

{ #category : #events }
ProcessingCanvas >> handleEvents: aEvents for: aProgram [
	events do: [ :event |
		(event isKindOf: BlMouseMoveEvent) & (aEvents includes: #mouseMoved) ifTrue: [
			aProgram perform: #mouseMoved.
		].
		(event isKindOf: BlMouseDownEvent) & (aEvents includes: #mousePressed) ifTrue: [
			aProgram perform: #mousePressed.
		].
		(event isKindOf: BlMouseUpEvent) & (aEvents includes: #mouseReleased) ifTrue: [
			aProgram perform: #mouseReleased.
		].
		(event isKindOf: BlMouseUpEvent) & (aEvents includes: #mouseClicked) ifTrue: [
			aProgram perform: #mouseClicked.
		].
	].
	events removeAll.
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
		yourself.
	^ self place: shape at: xy
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
	events := OrderedCollection new.
	canvasElement := BlElement new
		background: Color veryLightGray;
		size: 100 @ 100;
		when: BlMouseMoveEvent do: [ :event |
			mousePosition := event localPosition.
			events add: event.
		];
		when: BlMouseDownEvent do: [ :event |
			mousePressed := true.
			events add: event.
		];
		when: BlMouseUpEvent do: [ :event |
			mousePressed := false.
			events add: event.
		];
		yourself.
	canvas := canvasElement.
	
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

{ #category : #accessing }
ProcessingCanvas >> innerCanvas [
	"This is the same as `canvasElement` as long as `print` isn't called."
	^ canvas
]

{ #category : #shapes }
ProcessingCanvas >> line: fromXy to: toXy [
	| shape topLeft |
	topLeft := fromXy min: toXy.
	shape := BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: fromXy - topLeft);
		toAnchor: (BlAbsolutePositionAnchor position: toXy - topLeft);
		border: self border;
		yourself.
	^ self place: shape at: topLeft
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
	(path beginsWith: 'data:') ifTrue: [
		| bytes |
		bytes := (ZnDataUrl fromString: path) data.
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

{ #category : #modifiers }
ProcessingCanvas >> noStroke [
	strokeWeight := 0.
]

{ #category : #initialization }
ProcessingCanvas >> place: shape at: position [
	| transform index |
	transform := shape transform
		topLeftOrigin;
		translateBy: position.
	transforms reverseDo: [ :tf | tf cull: transform ].
	transform apply.
	
	canvas addChild: shape.
	
	"Note the caller for later backreferencing this shape with the creating code."
	index := 1.
	[ (thisContext stack at: index) receiver = self ] whileTrue: [ index := index + 1. ].
	shape userData at: #context put: (thisContext stack at: index) copyStack.
	
	^ shape
]

{ #category : #shapes }
ProcessingCanvas >> polygon: vertices [
	| shape topLeft |
	topLeft := vertices reduce: [ :a :b | a min: b ].
	shape := BlPolygonElement new
		anchors: (vertices collect: [ :xy | BlAbsolutePositionAnchor position: xy - topLeft ]);
		background: fillColor;
		border: self border;
		yourself.
	^ self place: shape at: topLeft
]

{ #category : #shapes }
ProcessingCanvas >> print: text [
	transcript ifNil: [
		| shapes |
		transcript := GtTranscript new.
		canvas := BlElement new
			background: canvasElement background;
			size: canvasElement constraints horizontal resizer size @ canvasElement constraints vertical resizer size;
			yourself.
		shapes := canvasElement children collect: [ :el | el ].
		shapes do: [ :el |
			canvasElement removeChild: el.
			canvas addChild: el.
		].
		canvasElement
			background: Color white;
			layout: BlGridLayout vertical;
			constraintsDo: [ :c |
				c vertical matchParent.
				c horizontal matchParent ].
		canvasElement addChild: canvas asScalableElement.
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
	^ self random: 0 to: limit
]

{ #category : #initialization }
ProcessingCanvas >> random: lowerLimit to: upperLimit [
	^ SharedRandom globalGenerator next * (upperLimit - lowerLimit) + lowerLimit
]

{ #category : #shapes }
ProcessingCanvas >> rect: width by: height at: xy [
	| shape |
	shape := BlElement new
		background: fillColor;
		size: width @ height;
		border: self border;
		yourself.
	^ self place: shape at: xy
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
	canvas size: width @ height.
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
	"`gray` is a single number or a single Color"
	(gray isKindOf: Color) ifTrue: [ ^ self stroke: gray ].
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
	"y-position is of baseline"
	^ self place: shape at: pos x @ (pos y - textSize)
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
ProcessingCanvas >> translate: x y: y [
	transforms add: [ :trans | trans translateBy: x @ y ].
]

{ #category : #shapes }
ProcessingCanvas >> triangle: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 [
	^ self polygon: { x1 @ y1. x2 @ y2. x3 @ y3. }
]
