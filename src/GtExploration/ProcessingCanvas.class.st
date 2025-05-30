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
		'startMilliseconds',
		'events',
		'containerElement',
		'canvasBuffer',
		'canvasOutput',
		'transform',
		'canvasSize',
		'backgroundColor'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvas class >> explainShape: aShape as: aTag [
	(aShape children select: [ :child |
		(child isKindOf: BlEllipseElement) and: [
			(child aptitude isKindOf: GtExplainerTargetAptitude) and: [
				child aptitude explanationModel = aTag
			]
		]
	]) size = 0 ifTrue: [
		| marker |
		marker := BlEllipseElement new
			centerAnchor: (BlElementCenterAnchor element: aShape);
			majorRadius: 4; minorRadius: 4;
			aptitude: (GtExplainerTargetAptitude new explanationModel: aTag).
		aShape addChild: marker
	].
]

{ #category : #views }
ProcessingCanvas >> asElement [
	^ containerElement
]

{ #category : #accessing }
ProcessingCanvas >> background [
	^ backgroundColor
]

{ #category : #shapes }
ProcessingCanvas >> background: color [
	"background() is used as a hint to buffer animations"
	canvasBuffer ifNotNil: [
		canvasOutput := canvasBuffer.
	].
	backgroundColor := color.
	canvasOutput background: color.
	canvasOutput children do: #removeFromParent.
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
	strokeColor ifNil: [ ^ BlBorder empty ].
	^ BlBorder paint: strokeColor width: strokeWeight
]

{ #category : #initialization }
ProcessingCanvas >> callerSource [
	| context |
	context := thisContext.
	[ context receiver = self ] whileTrue: [ context := context sender ].
	^ context sourceNodeExecuted
]

{ #category : #accessing }
ProcessingCanvas >> canvasElement [
	^ canvasElement
]

{ #category : #accessing }
ProcessingCanvas >> canvasSize [
	^ canvasSize
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
	self place: (ProcessingCanvasEllipse new
		"Processing by default places ellipses based on their center"
		position: xy - ((dx @ dy) / 2);
		ellipseSize: dx @ dy;
		fillColor: fillColor;
		border: self border;
		transform: transform;
		context: self callerSource)
]

{ #category : #shapes }
ProcessingCanvas >> ellipse: x y: y dx: dx dy: dy [
	^ self ellipse: dx by: dy at: x @ y
]

{ #category : #initialization }
ProcessingCanvas >> endFrame [
	canvasBuffer ifNil: [
		canvasBuffer := (containerElement addVisualCanvasFor: self)
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
		canvasBuffer parent zIndex: -1.
	].
	
	canvasOutput = canvasElement ifFalse: [
		| swap |
		swap := canvasBuffer.
		canvasBuffer := canvasElement.
		canvasElement := swap.
		canvasElement parent zIndex: 1.
		canvasBuffer parent zIndex: -1.
	].
	
	"Transforms are reset at the end of a draw-cycle"
	transform := #yourself.
	
	"The frame rate is adjustable through `frameRate()`"
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
	self place: (ProcessingCanvasImage new
		image: image;
		position: xy;
		rectSize: size;
		fillColor: fillColor;
		transform: transform;
		context: self callerSource)
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
	canvasSize := 100 @ 100.
	backgroundColor := self colorWithR: 192 G: 192 B: 192.
	fillColor := Color white.
	strokeColor := Color black.
	strokeWeight := 0.5.
	textSize := 12.
	transcript := nil.
	frameRate := 30.
	mousePosition := 0 @ 0.
	mousePressed := false.
	transform := #yourself.
	startMilliseconds := Time millisecondClockValue.
	events := OrderedCollection new.
	
	containerElement := ProcessingCanvasElement new.
	canvasElement := (containerElement addVisualCanvasFor: self)
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
	
	"Animations are buffered starting with the second frame."
	canvasBuffer := nil.
	canvasOutput := canvasElement.
]

{ #category : #shapes }
ProcessingCanvas >> line: fromXy to: toXy [
	self place: (ProcessingCanvasLine new
		fromXy: fromXy toXy: toXy;
		border: self border;
		transform: transform;
		context: self callerSource)
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
	strokeColor := nil.
]

{ #category : #initialization }
ProcessingCanvas >> place: shape [
	| element |
	element := shape asElementTransformed.
	
	canvasOutput addChild: element.
	"Add an explanation marker, if explaining has been enabled."
	containerElement dispatchEvent: (ProcessingExplainShape
		newFor: element createdBy: shape context).
	
	^ element
]

{ #category : #shapes }
ProcessingCanvas >> polygon: vertices [
	self place: (ProcessingCanvasPolygon new
		vertices: vertices;
		fillColor: fillColor;
		border: self border;
		transform: transform;
		context: self callerSource)
]

{ #category : #shapes }
ProcessingCanvas >> print: text [
	transcript ifNil: [
		transcript := GtTranscript new.
		containerElement addTextCanvasFor: transcript.
	] ifNotNil: [
		transcript cr.
	].
	
	(text isKindOf: Array) ifTrue: [
		text allButLastDo: [ :part | transcript nextPut: part asString , ' ' ].
		transcript nextPut: text last asString.
	] ifFalse: [
		transcript nextPut: text asString.
	].
	
	"Add an explanation marker, if explaining has been enabled."
	containerElement dispatchEvent: (ProcessingExplainShape
		newFor: containerElement children last createdBy: self callerSource).
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
	self place: (ProcessingCanvasRectangle new
		position: xy;
		fillColor: fillColor;
		rectSize: width @ height;
		border: self border;
		transform: transform;
		context: self callerSource)
]

{ #category : #shapes }
ProcessingCanvas >> rect: x y: y width: width height: height [
	^ self rect: width by: height at: x @ y
]

{ #category : #modifiers }
ProcessingCanvas >> rotate: angle [
	| prev |
	prev := transform.
	transform := [ :trans | prev value: (trans rotateBy: angle radiansToDegrees) ].
]

{ #category : #modifiers }
ProcessingCanvas >> scale: factor [
	| prev |
	prev := transform.
	transform := [ :trans | prev value: (trans scaleBy: factor) ].
]

{ #category : #modifiers }
ProcessingCanvas >> size: width by: height [
	canvasSize := width @ height.
	canvasElement size: canvasSize.
	canvasBuffer ifNotNil: [
		(canvasBuffer constraints horizontal resizer size = width) & (canvasBuffer constraints vertical resizer size = height) ifFalse: [
			ProcessingRunTimeException signal: 'size() may not be called from draw()'.
		].
	].
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
	^ self place: (ProcessingCanvasText new
		"y-position is of baseline"
		position: pos - (0 @ textSize);
		roped: (text asRopedText
			fontSize: textSize;
			foreground: fillColor);
		transform: transform;
		context: self callerSource)
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
	| prev |
	prev := transform.
	transform := [ :trans | prev value: (trans translateBy: x @ y) ].
]

{ #category : #shapes }
ProcessingCanvas >> triangle: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 [
	^ self polygon: { x1 @ y1. x2 @ y2. x3 @ y3. }
]
