Class {
	#name : #ProcessingList,
	#superclass : #OrderedCollection,
	#category : #'GtExploration-Processing'
}

{ #category : #converting }
ProcessingList >> asString [
	^ '[' , (', ' join: (self collect: #asString)) , ']'
]

{ #category : #accessing }
ProcessingList >> at: anInteger [
	^ super
		at: (anInteger <= 0 ifTrue: [ self size + anInteger ] ifFalse: [ anInteger ])
]

{ #category : #accessing }
ProcessingList >> at: anInteger put: anObject [
	^ super
		at: (anInteger <= 0 ifTrue: [ self size + anInteger ] ifFalse: [ anInteger ])
		put: anObject
]
