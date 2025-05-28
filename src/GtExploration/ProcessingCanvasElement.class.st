Class {
	#name : #ProcessingCanvasElement,
	#superclass : #BlElement,
	#instVars : [
		'model'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvasElement class >> newFor: aModel [
	^ self new model: aModel
]

{ #category : #initialization }
ProcessingCanvasElement >> initialize [
	super initialize.
	"TODO: cleaner separation of model, viewModel and view"
]

{ #category : #accessing }
ProcessingCanvasElement >> model [
	^ model
]

{ #category : #accessing }
ProcessingCanvasElement >> model: aModel [
	model := aModel.
]
