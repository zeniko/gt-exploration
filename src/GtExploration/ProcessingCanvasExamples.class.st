Class {
	#name : #ProcessingCanvasExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingCanvasExamples >> alpinerWanderweg [
	<gtExample>
	| canvas child |
	canvas := ProcessingRunnerExamples new runAlpinerWanderweg canvas.
	
	self assert: canvas fillColor equals: Color red.
	
	child := canvas canvasElement children last.
	self assert: child measuredBounds position equals: 50 @ (250/3).
	self assert: child background paint color equals: Color red.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: canvas canvasElement children size equals: 2.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> blueBackground [
	<gtExample>
	| canvas |
	canvas := self singleSquare.
	canvas background: Color blue.
	self assert: canvas canvasElement background paint color equals: Color blue.
	self assert: canvas canvasElement children size equals: 0.
	^ canvas
	
]

{ #category : #example }
ProcessingCanvasExamples >> container [
	<gtExample>
	| canvas |
	canvas := ProcessingCanvas new.
	self assert: canvas canvasElement constraints horizontal resizer size equals: 100.
	self assert: canvas canvasElement constraints vertical resizer size equals: 100.
	
	canvas size: 200 by: 200.
	self assert: canvas fillColor equals: Color white.
	self assert: canvas strokeColor equals: Color black.
	self assert: canvas strokeWeight equals: 0.5.
	self assert: canvas textSize equals: 12.
	self assert: canvas frameRate equals: 30.
	
	self assert: canvas canvasElement background paint color equals: Color veryLightGray.
	self assert: canvas canvasElement children size equals: 0.
	self assert: (canvas asElement isKindOf: BlScalableElement).
	self assert: canvas asElement children first equals: canvas canvasElement.
	self assert: canvas canvasElement constraints horizontal resizer size equals: 200.
	self assert: canvas canvasElement constraints vertical resizer size equals: 200.
	
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> createColor [
	<gtExample>
	| canvas |
	canvas := self container.
	self assert: (canvas colorWithR: 128 G: 128 B: 128) equals: Color gray.
	self assert: (canvas colorWithR: 160 G: 160 B: 160) equals: Color lightGray.
	self assert: (canvas colorWithR: 192 G: 192 B: 192) equals: Color veryLightGray.
	self assert: (canvas colorWithR: 255 G: 255 B: 255) equals: Color white.
]

{ #category : #example }
ProcessingCanvasExamples >> example02 [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runExample02 canvas.
	self assert: canvas canvasElement children size equals: 5.
	self assert: (canvas canvasElement children select: [ :el | el isKindOf: BlEllipseElement ]) size equals: 1.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> examplePrint [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runPrint canvas.
	self assert: canvas canvasElement children size equals: 2.
	self assert: canvas asElement children size equals: 1.
	self assert: (canvas canvasElement children last isKindOf: GtTranscriptElement).
	self assert: (canvas canvasElement children last transcript textDo: [ :text | text asString ]) equals: 'Hello, world!
2 + 3 = 5'.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> fibonacci [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runFibonacci canvas.
	self assert: canvas textSize equals: 50.
	self assert: canvas canvasElement children size equals: 2.
	self assert: (canvas canvasElement children first isKindOf: BlTextElement).
	self assert: canvas canvasElement children first text asString equals: 'Fibonacci'.
	self assert: (canvas canvasElement children second isKindOf: BlTextElement).
	self assert: canvas canvasElement children second text asString equals: '55'.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> fillColor [
	<gtExample>
	| canvas |
	canvas := self container .
	canvas fill: Color red.
	self assert: canvas fillColor equals: Color red.
	canvas fill: (Color fromRgbTriplet: #(0.0 0.0 1.0)).
	self assert: canvas fillColor equals: Color blue.
	canvas fill: (canvas colorWithR: 128 G: 128 B: 128).
	self assert: canvas fillColor equals: Color gray.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> image [
	<gtExample>
	| canvas image |
	canvas := self container.
	image := canvas loadImage: 'nowhere/missing.ext'.
	self assert: image isNil.
	image := canvas loadImage: 'zeniko/gt-exploration/data/sample/thumbs-up.png'.
	self assert: image isNotNil.
	self assert: image width @ image height equals: 240 @ 168.
	canvas
		image: image
		at: 50 @ 50
		sized: 100 @ 100.
	self assert: canvas canvasElement children size equals: 1.
	self assert: (canvas canvasElement children first isKindOf: BlSkiaImageElement).
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> recursion [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runRecursion canvas.
	self assert: canvas canvasElement children size equals: 19.
	self assert: (canvas canvasElement children select: [ :el | el isKindOf: BlEllipseElement ]) size equals: 19.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> shapes [
	<gtExample>
	| canvas |
	canvas := ProcessingProgramExamples new programShapes canvas.
	
	self assert: canvas fillColor equals: Color white.
	self assert: canvas strokeColor equals: Color white.
	self assert: canvas strokeWeight equals: 0.5.
	self assert: canvas canvasElement children size equals: 4.
	self assert: (canvas canvasElement children first isKindOf: BlElement).
	self assert: (canvas canvasElement children second isKindOf: BlEllipseElement).
	self assert: (canvas canvasElement children third isKindOf: BlLineElement).
	self assert: (canvas canvasElement children fourth isKindOf: BlPolygonElement).
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> sierpinski [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runSierpinski canvas.
	self assert: canvas canvasElement children size equals: 27.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> singleCircle [
	<gtExample>
	| canvas child |
	canvas := self container.
	canvas ellipse: 100 by: 100 at: 50 @ 50.
	child := canvas canvasElement children last.
	self assert: child class equals: BlEllipseElement.
	self assert: child measuredBounds position equals: 0 @ 0.
	self assert: child background paint color equals: Color white.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: (child userData at: #context) method equals: thisContext method.
	self assert: (child userData at: #context) sourceNodeExecuted asString equals: 'RBMessageNode(canvas
	ellipse: 100
	by: 100
	at: 50 @ 50)'.
	
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> singleLine [
	<gtExample>
	| canvas child |
	canvas := self container.
	canvas line: 0@100 to: 200@0.
	child := canvas canvasElement children last.
	self assert: child class equals: BlLineElement.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: (child userData at: #context) method equals: thisContext method.
	self assert: (child userData at: #context) sourceNodeExecuted asString equals: 'RBMessageNode(canvas line: 0 @ 100 to: 200 @ 0)'.
	
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> singleSquare [
	<gtExample>
	| canvas child |
	canvas := self container.
	canvas rect: 100 by: 100 at: 50 @ 50.
	self assert: canvas canvasElement children size equals: 1.
	child := canvas canvasElement children last.
	self assert: (child isKindOf: BlElement).
	self assert: child measuredBounds position equals: 50 @ 50.
	self assert: child background paint color equals: Color white.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: (child userData at: #context) method equals: thisContext method.
	self assert: (child userData at: #context) sourceNodeExecuted asString equals: 'RBMessageNode(canvas
	rect: 100
	by: 100
	at: 50 @ 50)'.
	
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> singleTriangle [
	<gtExample>
	| canvas child |
	canvas := self container.
	canvas triangle: { 0@200. 200@200. 100@0. }.
	child := canvas canvasElement children last.
	self assert: child class equals: BlPolygonElement.
	self assert: child background paint color equals: Color white.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: (child userData at: #context) method equals: thisContext method.
	self assert: (child userData at: #context) sourceNodeExecuted asString equals: 'RBMessageNode(canvas
	triangle: {0 @ 200.
			200 @ 200.
			100 @ 0})'.
	
	^ canvas
]
