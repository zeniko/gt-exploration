"
This class represents an ellipse drawn onto a {{gtClass:ProcessingCanvas}} (e.g. through {{gtMethod:ProcessingCanvas>>ellipse:y:dx:dy:}}).
"
Class {
	#name : 'ProcessingCanvasEllipse',
	#superclass : 'ProcessingCanvasShape',
	#instVars : [
		'ellipseSize'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'views' }
ProcessingCanvasEllipse >> asElement [
	^ BlEllipseElement new
		centerAnchor: (BlAbsolutePositionAnchor position: ellipseSize / 2);
		majorRadius: ellipseSize x / 2;
		minorRadius: ellipseSize y / 2;
		background: fillColor;
		border: border;
		yourself
]

{ #category : 'accessing' }
ProcessingCanvasEllipse >> ellipseSize [
	^ ellipseSize
]

{ #category : 'accessing' }
ProcessingCanvasEllipse >> ellipseSize: anEllipseSize [
	ellipseSize := anEllipseSize
]
