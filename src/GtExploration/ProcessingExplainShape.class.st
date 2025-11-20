"
This event is signaled by {{gtClass:ProcessingCanvasPresenter}} to allow a model such as {{gtClass:ProcessingProgram}} to add {{gtClass:GtExplainerActorAptitude}}s to link output to its reason (such as source code).
"
Class {
	#name : 'ProcessingExplainShape',
	#superclass : 'BlEvent',
	#instVars : [
		'sourceNode'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'initialization' }
ProcessingExplainShape class >> newFor: aShape createdBy: aSourceNode [
	^ self new
		source: aShape;
		sourceNode: aSourceNode
]

{ #category : 'accessing' }
ProcessingExplainShape >> sourceNode [
	^ sourceNode
]

{ #category : 'initialization' }
ProcessingExplainShape >> sourceNode: aSourceNode [
	sourceNode := aSourceNode
]
