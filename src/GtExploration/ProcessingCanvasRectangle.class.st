Class {
	#name : #ProcessingCanvasRectangle,
	#superclass : #ProcessingCanvasShape,
	#instVars : [
		'rectSize'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasRectangle >> asElement [
	^ BlElement new
		background: fillColor;
		size: rectSize;
		border: border;
		yourself
]

{ #category : #accessing }
ProcessingCanvasRectangle >> rectSize [
	^ rectSize
]

{ #category : #accessing }
ProcessingCanvasRectangle >> rectSize: aSize [
	rectSize := aSize
]
