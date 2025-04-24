Class {
	#name : #ProcessingTranspilationSlice,
	#superclass : #Object,
	#instVars : [
		'astNode',
		'method',
		'startPos',
		'size'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingTranspilationSlice class >> link: aNode method: aName startPos: from endPos: to [
	^ self new link: aNode method: aName startPos: from endPos: to
]

{ #category : #accessing }
ProcessingTranspilationSlice >> astNode [
	^ astNode
]

{ #category : #accessing }
ProcessingTranspilationSlice >> endPos [
	^ startPos + size
]

{ #category : #initalization }
ProcessingTranspilationSlice >> link: aNode method: aName startPos: from endPos: to [
	astNode := aNode.
	method := aName.
	startPos := from.
	endPos := to.
]

{ #category : #accessing }
ProcessingTranspilationSlice >> method [
	^ method
]

{ #category : #accessing }
ProcessingTranspilationSlice >> startPos [
	^ startPos
]
