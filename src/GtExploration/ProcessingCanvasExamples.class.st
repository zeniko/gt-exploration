Class {
	#name : #ProcessingCanvasExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingCanvasExamples >> alpinerWanderweg [
	"To be further decomposed."
	<gtExample>
	| canvas |
	canvas := self container.
	canvas
		rect: 100
			by: 100
			at: 50 @ 50;
		fill: Color red;
		rect: 100
			by: 100 / 3
			at: 50 @ (50 + (100 / 3)).
	^ canvas
]

{ #category : #example }
ProcessingCanvasExamples >> container [
"How to measure the extent of an element that has not yet been rendered?!"
	<gtExample>
	| canvas |
	canvas := ProcessingCanvas new.
	canvas size: 200 by: 200.
	self assert: canvas fillColor equals: Color white.	"self assert: (canvas canvasElement extent closeTo: 200@200)."
	^ canvas
]
