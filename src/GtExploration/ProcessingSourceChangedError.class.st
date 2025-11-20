"
This announcement is sent by {{gtClass:ProcessingSource}} whenever the source code has changed to contain a syntax error.
"
Class {
	#name : 'ProcessingSourceChangedError',
	#superclass : 'ProcessingSourceChanged',
	#instVars : [
		'sourceError'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'accessing' }
ProcessingSourceChangedError >> sourceError [
	^ sourceError
]

{ #category : 'accessing' }
ProcessingSourceChangedError >> sourceError: anObject [
	sourceError := anObject
]
