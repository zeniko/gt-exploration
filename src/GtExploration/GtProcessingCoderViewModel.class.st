Class {
	#name : 'GtProcessingCoderViewModel',
	#superclass : 'GtPythonCoderViewModel',
	#category : 'GtExploration-Snippet',
	#package : 'GtExploration',
	#tag : 'Snippet'
}

{ #category : 'api - actions' }
GtProcessingCoderViewModel >> doIt [
	self coder doIt: self evaluationContext
]

{ #category : 'api - actions' }
GtProcessingCoderViewModel >> doItAndGo [
	self coder doItAndGo: self evaluationContext
]

{ #category : 'api - actions' }
GtProcessingCoderViewModel >> doItAndGoAsynchronous [
	self coder doItAndGoAsynchronous: self evaluationContext
]

{ #category : 'api - actions' }
GtProcessingCoderViewModel >> doItAndGoSerialized [
	self coder doItAndGoSerialized: self evaluationContext
]
