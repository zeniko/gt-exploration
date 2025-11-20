"
This class represents a line drawn onto a {{gtClass:ProcessingCanvas}} (e.g. through {{gtMethod:ProcessingCanvas>>line:y1:x2:y2:}}).
"
Class {
	#name : 'ProcessingCanvasLine',
	#superclass : 'ProcessingCanvasShape',
	#instVars : [
		'fromXy',
		'toXy'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'views' }
ProcessingCanvasLine >> asElement [
	^ BlLineElement new
		fromAnchor: (BlAbsolutePositionAnchor position: fromXy - position);
		toAnchor: (BlAbsolutePositionAnchor position: toXy - position);
		border: border;
		yourself
]

{ #category : 'accessing' }
ProcessingCanvasLine >> fromXy [
	^ fromXy
]

{ #category : 'accessing' }
ProcessingCanvasLine >> fromXy: aFromXy toXy: aToXy [
	fromXy := aFromXy.
	toXy := aToXy.
	position := fromXy min: toXy
]

{ #category : 'accessing' }
ProcessingCanvasLine >> toXy [
	^ toXy
]
