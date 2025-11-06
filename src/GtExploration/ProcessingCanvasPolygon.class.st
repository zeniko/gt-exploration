"
This class represents a polygon drawn onto a {{gtClass:ProcessingCanvas}} (e.g. through {{gtMethod:ProcessingCanvas>>triangle:y1:x2:y2:x3:y3:}}).
"
Class {
	#name : #ProcessingCanvasPolygon,
	#superclass : #ProcessingCanvasShape,
	#instVars : [
		'vertices'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasPolygon >> asElement [
	^ BlPolygonElement new
		anchors: (vertices collect: [ :xy | BlAbsolutePositionAnchor position: xy - position ]);
		background: fillColor;
		border: border;
		yourself
]

{ #category : #accessing }
ProcessingCanvasPolygon >> vertices [
	^ vertices
]

{ #category : #accessing }
ProcessingCanvasPolygon >> vertices: someVertices [
	vertices := someVertices.
	position := vertices reduce: [ :a :b | a min: b ]
]
