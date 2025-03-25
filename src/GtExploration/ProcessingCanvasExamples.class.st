Class {
	#name : #ProcessingCanvasExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingCanvasExamples >> alpinerWanderweg [
	<gtExample>
	| canvas child |
	canvas := self singleSquare.
	
	canvas fill: (canvas colorWithR: 255 g: 0 b: 0).
	self assert: canvas fillColor equals: Color red.
	
	canvas rect: 100 by: 100 / 3 at: 50 @ (50 + (100 / 3)).
	child := canvas canvasElement children last.
	self assert: child measuredBounds position equals: 50 @ (250/3).
	self assert: child background paint color equals: Color red.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	
	self assert: canvas canvasElement children size equals: 2.
	^ canvas

]

{ #category : #example }
ProcessingCanvasExamples >> container [
"How to measure the extent of an element that has not yet been rendered?!"
	<gtExample>
	| canvas |
	canvas := ProcessingCanvas new.
	canvas size: 200 by: 200.
	self assert: canvas fillColor equals: Color white.
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
ProcessingCanvasExamples >> singleSquare [
	<gtExample>
	| canvas child |
	canvas := self container.
	canvas rect: 100 by: 100 at: 50 @ 50.
	child := canvas canvasElement children last.
	self assert: child measuredBounds position equals: 50 @ 50.
	self assert: child background paint color equals: Color white.
	self assert: child border paint color equals: Color black.
	self assert: child border width equals: 0.5.
	^ canvas

]
