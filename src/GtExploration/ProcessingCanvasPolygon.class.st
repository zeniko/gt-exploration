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
		yourself.
]

{ #category : #accessing }
ProcessingCanvasPolygon >> vertices [
	^ vertices
]

{ #category : #accessing }
ProcessingCanvasPolygon >> vertices: someVertices [
	vertices := someVertices.
	position := vertices reduce: [ :a :b | a min: b ].
]
