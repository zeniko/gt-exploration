Class {
	#name : #GtProcessingCoderViewModel,
	#superclass : #GtPythonCoderViewModel,
	#category : #'GtExploration-Snippet'
}

{ #category : #'as yet unclassified' }
GtProcessingCoderViewModel >> doIt [
	self coder doIt: self evaluationContext.
]

{ #category : #'as yet unclassified' }
GtProcessingCoderViewModel >> doItAndGo [
	self coder doItAndGo: self evaluationContext.
]

{ #category : #'as yet unclassified' }
GtProcessingCoderViewModel >> doItAndGoSerialized [
	self coder doItAndGoSerialized: self evaluationContext.
]
