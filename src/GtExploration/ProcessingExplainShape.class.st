Class {
	#name : #ProcessingExplainShape,
	#superclass : #BlEvent,
	#instVars : [
		'sourceNode'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingExplainShape class >> newFor: aShape createdBy: aSourceNode [
	^ self new
		source: aShape;
		sourceNode: aSourceNode
]

{ #category : #accessing }
ProcessingExplainShape >> sourceNode [
	^ sourceNode
]

{ #category : #initialization }
ProcessingExplainShape >> sourceNode: aSourceNode [
	sourceNode := aSourceNode
]
