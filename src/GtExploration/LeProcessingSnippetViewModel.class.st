Class {
	#name : 'LeProcessingSnippetViewModel',
	#superclass : 'LePythonSnippetViewModel',
	#category : 'GtExploration-Snippet',
	#package : 'GtExploration',
	#tag : 'Snippet'
}

{ #category : 'filter view' }
LeProcessingSnippetViewModel >> parserClass [
	^ ProcessingParser
]

{ #category : 'accessing' }
LeProcessingSnippetViewModel >> snippetElementClass [
	^ LeProcessingSnippetElement
]
