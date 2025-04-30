Class {
	#name : #ProcessingSourceChanged,
	#superclass : #Announcement,
	#instVars : [
		'source'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingSourceChanged >> source [
	^ source
]

{ #category : #accessing }
ProcessingSourceChanged >> source: aSource [
	source := aSource.
]
