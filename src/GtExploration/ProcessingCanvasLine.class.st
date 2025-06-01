Class {
	#name : #ProcessingCanvasLine,
	#superclass : #ProcessingCanvasShape,
	#instVars : [
		'fromXy',
		'toXy'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasLine >> asElement [
	^ BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: fromXy - position);
		toAnchor: (BlAbsolutePositionAnchor position: toXy - position);
		border: border;
		yourself
]

{ #category : #accessing }
ProcessingCanvasLine >> fromXy [
	^ fromXy
]

{ #category : #accessing }
ProcessingCanvasLine >> fromXy: aFromXy toXy: aToXy [
	fromXy := aFromXy.
	toXy := aToXy.
	position := fromXy min: toXy
]

{ #category : #accessing }
ProcessingCanvasLine >> toXy [
	^ toXy
]
