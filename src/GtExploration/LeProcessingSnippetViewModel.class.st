Class {
	#name : #LeProcessingSnippetViewModel,
	#superclass : #LePythonSnippetViewModel,
	#category : #'GtExploration-Snippet'
}

{ #category : #'filter view' }
LeProcessingSnippetViewModel >> parserClass [
	^ ProcessingParser
]

{ #category : #accessing }
LeProcessingSnippetViewModel >> snippetElementClass [
	^ LeProcessingSnippetElement
]
