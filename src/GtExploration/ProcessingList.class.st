Class {
	#name : #ProcessingList,
	#superclass : #OrderedCollection,
	#category : #'GtExploration-Processing'
}

{ #category : #arithmetic }
ProcessingList >> * arg [
	| res |
	res := ProcessingList new.
	1 to: arg do: [ :x | res addAll: self ].
	^ res
]

{ #category : #arithmetic }
ProcessingList >> + arg [
	^ self clone
		addAll: arg;
		yourself
]

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

{ #category : #accessing }
ProcessingList >> sliceFrom: startIndex to: endIndex [
	^ super
		sliceFrom: (startIndex <= 0 ifTrue: [ self size + startIndex ] ifFalse: [ startIndex ])
		to: endIndex
]
