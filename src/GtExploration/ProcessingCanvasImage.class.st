Class {
	#name : #ProcessingCanvasImage,
	#superclass : #ProcessingCanvasRectangle,
	#instVars : [
		'image'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasImage >> asElement [
	^ image asElement
		background: fillColor;
		size: rectSize;
		yourself.
]

{ #category : #accessing }
ProcessingCanvasImage >> image [
	^ image
]

{ #category : #accessing }
ProcessingCanvasImage >> image: anImage [
	image := anImage.
]
