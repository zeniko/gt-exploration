"
A subclass of this announcement is sent by {{gtClass:ProcessingSource}} whenever the source code has changed.
"
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
	source := aSource
]
