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
LeProcessingSnippetElement >> initializeTextEditor [
	super initializeTextEditor.
	editorElement editor
		when: BrTextEditorInsertedEvent
			do: [ :event | self updateLspSourceFrom: event ];
		when: BrTextEditorDeletedEvent
			do: [ :event | self updateLspSourceFrom: event ];
		when: BlInfiniteDataSourceChanged
			do: [ :event | self updateLspSourceFrom: event ].
	editorElement
		addEditorShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryR;
				action: [ GtLSPRenameRefactoringController new
						editor: editorElement;
						lspFile: (self userData at: #lspFile);
						execute ])
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
