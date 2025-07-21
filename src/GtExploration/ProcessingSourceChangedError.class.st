Class {
	#name : #ProcessingSourceChangedError,
	#superclass : #ProcessingSourceChanged,
	#instVars : [
		'sourceError'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingSourceChangedError >> sourceError [
	^ sourceError
]

{ #category : #accessing }
ProcessingSourceChangedError >> sourceError: anObject [
	sourceError := anObject
]
