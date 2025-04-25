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

{ #category : #initalization }
ProcessingTranspilationSlice class >> link: aNode method: aName from: from [
	^ self new link: aNode method: aName from: from to: from
]

{ #category : #initialization }
ProcessingTranspilationSlice class >> link: aNode method: aName from: from to: to [
	^ self new link: aNode method: aName from: from to: to
]

{ #category : #accessing }
ProcessingTranspilationSlice >> astNode [
	^ astNode
]

{ #category : #accessing }
ProcessingTranspilationSlice >> endPos [
	^ startPos + size
]

{ #category : #changing }
ProcessingTranspilationSlice >> enlarge: add [
	size := size + add.
]

{ #category : #initalization }
ProcessingTranspilationSlice >> link: aNode method: aName from: from to: to [
	astNode := aNode.
	method := aName.
	startPos := from.
	size := to - from.
]

{ #category : #accessing }
ProcessingTranspilationSlice >> method [
	^ method
]

{ #category : #changing }
ProcessingTranspilationSlice >> move: offset [
	startPos := startPos + offset.
]

{ #category : #'as yet unclassified' }
ProcessingTranspilationSlice >> size [
	^ size
]

{ #category : #accessing }
ProcessingTranspilationSlice >> slice: source [
	^ source copyFrom: startPos to: startPos + size - 1
]

{ #category : #accessing }
ProcessingTranspilationSlice >> startPos [
	^ startPos
]
