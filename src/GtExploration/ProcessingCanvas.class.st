Class {
	#name : #ProcessingCanvas,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'textSize',
		'strokeColor',
		'strokeWeight',
		'transcript',
		'frameRate',
		'mousePosition',
		'mousePressed',
		'startMilliseconds',
		'events',
		'transform',
		'canvasSize',
		'backgroundColor',
		'shapes',
		'frameCount',
		'presenter'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvas >> asElement [
	^ presenter containerElement
]

{ #category : #accessing }
ProcessingCanvas >> background [
	^ backgroundColor
]

{ #category : #shapes }
ProcessingCanvas >> background: color [
	shapes removeAll.
	presenter clearWithBackground: color.
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
	^ presenter canvasElement
]

{ #category : #accessing }
ProcessingCanvas >> canvasSize [
	^ canvasSize
]

{ #category : #shapes }
ProcessingCanvas >> circle: x y: y d: d [
	self ellipse: d by: d at: x @ y.
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
	self output: (ProcessingCanvasEllipse new
		"Processing by default places ellipses based on their center"
		position: xy - ((dx @ dy) / 2);
		ellipseSize: dx @ dy).
]

{ #category : #shapes }
ProcessingCanvas >> ellipse: x y: y dx: dx dy: dy [
	self ellipse: dx by: dy at: x @ y.
]

{ #category : #initialization }
ProcessingCanvas >> endFrame [
	presenter updateOutput.
	"The frame rate is adjustable through `frameRate()`"
	(1 / frameRate) seconds wait.
	frameCount := frameCount + 1.
	"Transforms are reset at the end of a draw-cycle"
	transform := #yourself.
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
	self fill: (self colorWithR: r G: g B: b).
]

{ #category : #accessing }
ProcessingCanvas >> frameCount [
	^ frameCount
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
	aStream nextPutAll: 'Processing Canvas (@' , self basicIdentityHash asString , ')'.
]

{ #category : #views }
ProcessingCanvas >> gtShapesFor: aView [
	<gtView>
	^ ((Stepper for: shapes view: #gtLiveFor:) background: backgroundColor; gtListViewFor: aView)
		title: 'Shapes' translated;
		priority: 20
]

{ #category : #views }
ProcessingCanvas >> gtViewFor: aView [
	<gtView>
	^ (self asElement gtLiveFor: aView)
		title: 'Output' translated;
		priority: 10
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
	self image: image at: xy sized: image width @ image height.
]

{ #category : #shapes }
ProcessingCanvas >> image: image at: xy sized: size [
	self output: (ProcessingCanvasImage new
		image: image;
		position: xy;
		rectSize: size).
]

{ #category : #shapes }
ProcessingCanvas >> image: image x: x y: y [
	self image: image at: x @ y.
]

{ #category : #shapes }
ProcessingCanvas >> image: image x: x y: y width: width height: height [
	self image: image at: x @ y sized: width @ height.
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
	frameCount := 0.
	events := OrderedCollection new.
	shapes := OrderedCollection new.
	presenter := ProcessingCanvasPresenter newFor: self.
]

{ #category : #shapes }
ProcessingCanvas >> line: fromXy to: toXy [
	self output: (ProcessingCanvasLine new fromXy: fromXy toXy: toXy).
]

{ #category : #shapes }
ProcessingCanvas >> line: x1 y1: y1 x2: x2 y2: y2 [
	self line: x1 @ y1 to: x2 @ y2.
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

{ #category : #events }
ProcessingCanvas >> onMouseDown: anEvent [
	mousePressed := true.
	events add: anEvent.
]

{ #category : #events }
ProcessingCanvas >> onMouseMove: anEvent [
	mousePosition := anEvent localPosition.
	events add: anEvent.
]

{ #category : #events }
ProcessingCanvas >> onMouseUp: anEvent [
	mousePressed := false.
	events add: anEvent.
]

{ #category : #shapes }
ProcessingCanvas >> output: shape [
	shape
		fillColor: fillColor;
		border: self border;
		transform: transform;
		context: self callerSource.
	shapes add: shape.
	presenter display: shape.
]

{ #category : #shapes }
ProcessingCanvas >> polygon: vertices [
	self output: (ProcessingCanvasPolygon new vertices: vertices).
]

{ #category : #accessing }
ProcessingCanvas >> presenter [
	^ presenter
]

{ #category : #shapes }
ProcessingCanvas >> print: text [
	transcript ifNil: [
		transcript := GtTranscript new.
	] ifNotNil: [
		transcript cr.
	].
	
	(text isKindOf: Array) ifTrue: [
		text allButLastDo: [ :part | transcript nextPut: part asString , ' ' ].
		transcript nextPut: text last asString.
	] ifFalse: [
		transcript nextPut: text asString.
	].
	
	presenter displayTranscript: transcript for: self callerSource.
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
	self output: (ProcessingCanvasRectangle new
		position: xy;
		rectSize: width @ height).
]

{ #category : #shapes }
ProcessingCanvas >> rect: x y: y width: width height: height [
	self rect: width by: height at: x @ y.
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

{ #category : #accessing }
ProcessingCanvas >> shapes [
	^ shapes
]

{ #category : #modifiers }
ProcessingCanvas >> size: width by: height [
	(frameCount = 0 or: [ canvasSize = (width @ height) ]) ifFalse: [
		ProcessingRunTimeException signal: 'size() may not be called from draw()'.
	].
	canvasSize := width @ height.
	presenter outputSize: canvasSize.
]

{ #category : #shapes }
ProcessingCanvas >> square: x y: y side: side [
	self rect: side by: side at: x @ y.
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
	self stroke: (self colorWithR: r G: g B: b).
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
	self output: (ProcessingCanvasText new
		"y-position is of baseline"
		position: pos - (0 @ textSize);
		text: text;
		textSize: textSize).
]

{ #category : #shapes }
ProcessingCanvas >> text: text x: x y: y [
	self text: text at: x @ y.
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
	self polygon: { x1 @ y1. x2 @ y2. x3 @ y3. }.
]
