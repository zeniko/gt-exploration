Class {
	#name : #ProcessingSourceChanged,
	#superclass : #Announcement,
	#instVars : [
		'source',
		'ast'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingSourceChanged >> ast [
	^ ast ifNil: [ ProcessingParser parse: source asString ]
]

{ #category : #accessing }
ProcessingSourceChanged >> ast: anAst [
	ast := anAst
]

{ #category : #accessing }
ProcessingSourceChanged >> source [
	^ source
]

{ #category : #accessing }
ProcessingSourceChanged >> source: aSource [
	source := aSource.
]
