Class {
	#name : #ProcessingViewSelectionChanged,
	#superclass : #Announcement,
	#instVars : [
		'interval',
		'source'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingViewSelectionChanged >> interval [
	^ interval
]

{ #category : #accessing }
ProcessingViewSelectionChanged >> interval: anObject [
	interval := anObject
]

{ #category : #accessing }
ProcessingViewSelectionChanged >> source [
	^ source
]

{ #category : #accessing }
ProcessingViewSelectionChanged >> source: anObject [
	source := anObject
]
