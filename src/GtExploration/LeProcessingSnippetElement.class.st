Class {
	#name : #LeProcessingSnippetElement,
	#superclass : #LePythonSnippetElement,
	#category : #'GtExploration-Snippet'
}

{ #category : #accessing }
LeProcessingSnippetElement >> coderEditorElementClass [
	^ LeLSPSourceCoderEditorElement
]

{ #category : #initialization }
LeProcessingSnippetElement >> initializeLanguageElement [
	^ BrButton new
		aptitude: BrGlamorousButtonWithLabelAptitude - BrGlamorousButtonExteriorAptitude;
		label: 'Processing';
		beSmallSize;
		yourself
]

{ #category : #accessing }
LeProcessingSnippetElement >> serverStrategy [
	^ nil
]

{ #category : #private }
LeProcessingSnippetElement >> updateLanguageLabel [
	| label |
	label := 'Processing'.
	languageElement label: label.
	dropdownHandleButton ifNotNil: [ dropdownHandleButton label: label ].
	^ label
]
