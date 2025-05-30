Class {
	#name : #ProcessingCanvasText,
	#superclass : #ProcessingCanvasShape,
	#instVars : [
		'roped'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasText >> asElement [
	^ BlTextElement new text: roped
]

{ #category : #accessing }
ProcessingCanvasText >> roped [
	^ roped
]

{ #category : #accessing }
ProcessingCanvasText >> roped: someText [
	roped := someText.
]
