Class {
	#name : #ProcessingCanvasRoundedRectangle,
	#superclass : #ProcessingCanvasRectangle,
	#instVars : [
		'cornerRadius'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasRoundedRectangle >> asElement [
	^ super asElement
		geometry: (BlRoundedRectangleGeometry cornerRadius: cornerRadius);
		yourself
]

{ #category : #accessing }
ProcessingCanvasRoundedRectangle >> cornerRadius [
	^ cornerRadius
]

{ #category : #accessing }
ProcessingCanvasRoundedRectangle >> cornerRadius: anObject [
	cornerRadius := anObject
]
