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
	self assert: child background paint color equals: Color red.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: canvas canvasElement children size equals: 2.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> alpinerWanderwegScripter [
	<gtExample>
	| canvas |
	canvas := self alpinerWanderweg.
	^ BlScripter new
		element: canvas canvasElement;
		substeps: 'Square' do: [ :step |
			step check value: [ :el | el children first bounds inParent topLeft ] equals: 50 @ 50.
			step check value: [ :el | el children first bounds inParent bottomRight ] equals: 150 @ 150.
		];
		substeps: 'Rectangle' do: [ :step |
			step check value: [ :el | el children second bounds inParent topLeft closeTo: 50 @ (50 + (100/3)) ] equals: true.
			step check value: [ :el | el children second bounds inParent bottomRight closeTo: 150 @ (150 - (100 / 3)) ] equals: true.
			step check value: [ :el | el children second background paint color ] equals: Color red.
		];
		play
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
	self assert: (canvas asElement children first isKindOf: BlScalableElement).
	self assert: canvas asElement children first children first equals: canvas canvasElement.
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
ProcessingCanvasExamples >> example02Scripter [
	<gtExample>
	| canvas scripter |
	canvas := ProcessingCanvasExamples new example02.
	scripter := BlScripter new.
	scripter element: canvas canvasElement.
	#(1 2 3 4) do: [ :ix |
		scripter substeps: ('Square ' , ix asString) do: [ :step |
			step check value: [ :el |
				(el children at: ix) bounds inParent topLeft
			] equals: (50 * (ix - 1)) @ (50 * (ix - 1)).
			step check value: [ :el |
				(el children at: ix) bounds inParent bottomRight
			] equals: (50 * (ix - 1) + 100) @ (50 * (ix - 1) + 100).
			step check value: [ :el | (el children at: ix) background paint color ] equals: (canvas colorWithR: (50 * (ix - 1)) G: 128 B: 0).
		].
	].
	scripter substeps: 'Circle' do: [ :step |
			step check value: [ :el |
				el children fifth bounds inParent topLeft
			] equals: 0 @ 0.
			step check value: [ :el |
				el children fifth bounds inParent bottomRight
			] equals: 20 @ 20.
			step check value: [ :el |
				el children fifth background paint color
			] equals: (canvas colorWithR: 150 G: 128 B: 0).
		].
	^ scripter play
]

{ #category : #example }
ProcessingCanvasExamples >> examplePrint [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runPrint canvas.
	self assert: canvas canvasElement children size equals: 0.
	self assert: canvas asElement children size equals: 2.
	self assert: (canvas asElement children last isKindOf: GtTranscriptElement).
	self assert: (canvas asElement children last transcript textDo: #asString) equals: 'Hello, world!
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
	| canvas |
	canvas := self container.
	canvas image: self loadImage at: 50 @ 50 sized: 100 @ 100.
	self assert: canvas canvasElement children size equals: 1.
	self assert: (canvas canvasElement children last isKindOf: BlSkiaImageElement).
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> loadImage [
	<gtExample>
	| canvas image |
	canvas := self container.
	image := canvas loadImage: 'nowhere/missing.ext'.
	self assert: image isNil.
	image := canvas loadImage: 'zeniko/gt-exploration/data/sample/thumbs-up.png'.
	self assert: image isNotNil.
	self assert: image width @ image height equals: 240 @ 168.
	^ image
]

{ #category : #example }
ProcessingCanvasExamples >> mouseEvents2Scripter [
	<gtExample>
	| canvas |
	canvas := ProcessingProgramExamples new programMouseEvents2 run canvas.
	^ BlScripter new
		element: canvas canvasElement;
		substeps: 'Mouse move' do: [ :step |
			step set key: [ #mousePosition ] value: [ 50 @ 30 ].
			step mouseMove.
			step check value: [ :el | 0.1 seconds wait. el background paint color ] equals: (canvas colorWithR: 50 G: 0 B: 30).
		];
		substeps: 'Mouse click' do: [ :step |
			step mouseDown.
			step check value: [ :el | 0.1 seconds wait. el background paint color ] equals: (canvas colorWithR: 0 G: 255 B: 0).
			step mouseUp.
			step check value: [ :el | 0.1 seconds wait. el background paint color ] equals: (canvas colorWithR: 192 G: 192 B: 192).
		];
		play
]

{ #category : #example }
ProcessingCanvasExamples >> mouseEventsScripter [
	<gtExample>
	| canvas |
	canvas := self container.
	^ BlScripter new
		element: canvas canvasElement;
		substeps: 'Mouse move' do: [ :step |
			step set key: [ #mousePosition ] value: [ 50 @ 30 ].
			step check value: [:_| canvas mouseX @ canvas mouseY ] equals: 0 @ 0.
			step mouseMove.
			step check value: [:_| canvas mouseX @ canvas mouseY ] equals: 50 @ 30.
		];
		substeps: 'Mouse click' do: [ :step |
			step set key: [ #mousePosition ] value: [ 100 @ 100 ].
			step check value: [:_| canvas mousePressed ] equals: false.
			step mouseDown.
			step check value: [:_| canvas mousePressed ] equals: true.
			step mouseUp.
			step check value: [:_| canvas mousePressed ] equals: false.
			"Mouse clicks don't modify the mouse position"
			step check value: [:_| canvas mouseX @ canvas mouseY ] equals: 50 @ 30.
		];
		play
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
	"self assert: child measuredBounds position equals: 50 @ 50."
	self assert: child background paint color equals: Color white.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> singleTriangle [
	<gtExample>
	| canvas child |
	canvas := self container.
	canvas polygon: { 0@200. 200@200. 100@0. }.
	child := canvas canvasElement children last.
	self assert: child class equals: BlPolygonElement.
	self assert: child background paint color equals: Color white.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> transforms [
	<gtExample>
	| canvas |
	canvas := self container.
	canvas rotate: 20 degreesToRadians.
	canvas scale: 0.5.
	canvas square: 50 y: 50 side: 100.
	canvas ellipse: 100 y: 125 dx: 100 dy: 50.
	canvas polygon: { 50 @ 50. 150 @ 50. 100 @ 150. }.
	canvas image: self loadImage at: 200 @ 50.
	canvas line: 200 @ 50 to: 440 @ 218.
	canvas line: 200 @ 218 to: 440 @ 50.
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> transformsScripter [
	<gtExample>
	| canvas |
	canvas := self transforms.
	^ BlScripter new
		element: canvas canvasElement;
		substeps: 'Square' do: [ :step |
			step check value: [ :el | el children first bounds inParent topLeft closeTo: -2.159195 @32.0428191 ] equals: true.
			step check value: [ :el | el children first bounds inParent bottomRight closeTo: 61.926443 @ 96.128457 ] equals: true.
		];
		substeps: 'Ellipse' do: [ :step |
			step check value: [ :el | el children second bounds inParent topLeft closeTo: -2.159195 @ 55.535135 ] equals: true.
			step check value: [ :el | el children second bounds inParent bottomRight closeTo: 53.3759394 @ 96.128457 ] equals: true.
		];
		substeps: 'Triangle' do: [ :step |
			step check value: [ :el | el children third bounds inParent topLeft closeTo: -2.159195 @ 32.042819 ] equals: true.
			step check value: [ :el | el children third bounds inParent bottomRight closeTo: 61.926443 @ 96.128457 ] equals: true.
		];
		substeps: 'Image' do: [ :step |
			step check value: [ :el | el children fourth bounds inParent topLeft closeTo: 56.689066 @ 57.69433 ] equals: true.
			step check value: [ :el | el children fourth bounds inParent bottomRight closeTo: 198.181873 @ 177.670927 ] equals: true.
		];
		substeps: 'Line' do: [ :step |
			step check value: [ :el | el children fifth bounds inParent topLeft closeTo: 56.689066 @ 57.69433 ] equals: true.
			step check value: [ :el | el children fifth bounds inParent bottomRight closeTo: 198.181873 @ 177.670927 ] equals: true.
		];
		play
]
