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

{ #category : #'as yet unclassified' }
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
	"TODO: How to measure the extent of an element that has not yet been rendered?!"
	<gtExample>
	| canvas |
	canvas := ProcessingCanvas new.
	canvas size: 200 by: 200.
	self assert: canvas fillColor equals: Color white.
	self assert: canvas textSize equals: 12.
	self assert: canvas canvasElement background paint color equals: Color veryLightGray.
	self assert: canvas canvasElement children size equals: 0.
	self assert: (canvas asElement isKindOf: BlScalableElement).
	self assert: canvas asElement children first equals: canvas canvasElement.
	"self assert: (canvas canvasElement measuredBounds extent) equals: 200 @ 200."
	^ canvas
]

{ #category : #'as yet unclassified' }
ProcessingCanvasExamples >> createColor [
	<gtExample>
	| canvas |
	canvas := self container.
	self assert: (canvas colorWithR: 128 g: 128 b: 128) equals: Color gray.
	self assert: (canvas colorWithR: 160 g: 160 b: 160) equals: Color lightGray.
	self assert: (canvas colorWithR: 192 g: 192 b: 192) equals: Color veryLightGray.
	self assert: (canvas colorWithR: 255 g: 255 b: 255) equals: Color white.

]

{ #category : #'as yet unclassified' }
ProcessingCanvasExamples >> example02 [
	<gtExample>
	| canvas |
	canvas := ProcessingRunnerExamples new runExample02 canvas.
	self assert: canvas canvasElement children size equals: 5.
	self assert: (canvas canvasElement children select: [ :el | el isKindOf: BlEllipseElement ]) size equals: 1.
	^ canvas
]

{ #category : #'as yet unclassified' }
ProcessingCanvasExamples >> fibonacci [
	<gtExample>
	| program canvas |
	program := ProcessingRunnerExamples new runFibonacci.
	canvas := program canvas.
	self assert: canvas textSize equals: 50.
	self assert: canvas canvasElement children size equals: 2.
	self assert: (canvas canvasElement children first isKindOf: BlTextElement).
	self assert: canvas canvasElement children first text asString equals: 'Fibonacci'.
	self assert: (canvas canvasElement children second isKindOf: BlTextElement).
	self assert: canvas canvasElement children second text asString equals: '55'.
	^ canvas
]

{ #category : #'as yet unclassified' }
ProcessingCanvasExamples >> fillColor [
	<gtExample>
	| canvas |
	canvas := self container .
	canvas fill: Color red.
	self assert: canvas fillColor equals: Color red.
	canvas fill: (Color fromRgbTriplet: #(0.0 0.0 1.0)).
	self assert: canvas fillColor equals: Color blue.
	canvas fill: (canvas colorWithR: 128 g: 128 b: 128).
	self assert: canvas fillColor equals: Color gray.
	^ canvas
]

{ #category : #'as yet unclassified' }
ProcessingCanvasExamples >> recursion [
	<gtExample>
	| program canvas |
	program := ProcessingRunnerExamples new runRecursion.
	canvas := program canvas canvasElement.
	self assert: canvas children size equals: 19.
	self assert: (canvas children select: [ :el | el isKindOf: BlEllipseElement ]) size equals: 19.
	^ program canvas
]

{ #category : #'as yet unclassified' }
ProcessingCanvasExamples >> shapes [
	<gtExample>
	| canvas |
	canvas := ProcessingProgramExamples new programShapes canvas.
	
	self assert: canvas fillColor equals: Color white.
	self assert: canvas canvasElement children size equals: 4.
	self assert: (canvas canvasElement children first isKindOf: BlElement).
	self assert: (canvas canvasElement children second isKindOf: BlEllipseElement).
	self assert: (canvas canvasElement children third isKindOf: BlLineElement).
	self assert: (canvas canvasElement children fourth isKindOf: BlPolygonElement).
	^ canvas
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
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
	^ canvas

]

{ #category : #'as yet unclassified' }
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
	^ canvas

]
