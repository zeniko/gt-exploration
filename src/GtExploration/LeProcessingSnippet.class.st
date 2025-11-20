Class {
	#name : 'LeProcessingSnippet',
	#superclass : 'LePythonSnippet',
	#category : 'GtExploration-Snippet',
	#package : 'GtExploration',
	#tag : 'Snippet'
}

{ #category : 'api - accessing menu' }
LeProcessingSnippet class >> contextMenuItemSpecification [
	<leSnippetSpecification>
	^ LeContextMenuItemSpecification new
		snippetClass: self;
		title: self description
]

{ #category : 'api - accessing menu' }
LeProcessingSnippet class >> description [
	^ 'Processing/Python'
]

{ #category : 'lepiter-store' }
LeProcessingSnippet class >> leJsonV3Name [
	^ 'processingSnippet'
]

{ #category : 'lepiter-store' }
LeProcessingSnippet class >> leJsonV4Name [
	^ 'processingSnippet'
]

{ #category : 'visiting' }
LeProcessingSnippet >> acceptVisitor: aVisitor [
	^ aVisitor visitPythonSnippet: self
]

{ #category : 'converting' }
LeProcessingSnippet >> asSnippetViewModel [
	<return: #LeSnippetViewModel>
	^ LeProcessingSnippetViewModel new snippetModel: self
]

{ #category : 'initialization' }
LeProcessingSnippet >> newCoder [
	^ GtProcessingCoderModel new
]
