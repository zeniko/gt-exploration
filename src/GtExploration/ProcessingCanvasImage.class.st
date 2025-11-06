"
This class represents an image drawn onto a {{gtClass:ProcessingCanvas}} (e.g. through {{gtMethod:ProcessingCanvas>>image:x:y:width:height:}}).
"
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
		background: BlBackground transparent;
		size: rectSize;
		yourself
]

{ #category : #accessing }
ProcessingCanvasImage >> image [
	^ image
]

{ #category : #accessing }
ProcessingCanvasImage >> image: anImage [
	image := anImage
]
