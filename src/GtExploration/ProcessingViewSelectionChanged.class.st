"
This announcement is sent by various views whenever the selection changed, allowing other views to adjust their selection to the corresponding items.
"
Class {
	#name : 'ProcessingViewSelectionChanged',
	#superclass : 'Announcement',
	#instVars : [
		'interval',
		'source'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'accessing' }
ProcessingViewSelectionChanged >> interval [
	^ interval
]

{ #category : 'accessing' }
ProcessingViewSelectionChanged >> interval: anObject [
	interval := anObject
]

{ #category : 'accessing' }
ProcessingViewSelectionChanged >> source [
	^ source
]

{ #category : 'accessing' }
ProcessingViewSelectionChanged >> source: anObject [
	source := anObject
]
