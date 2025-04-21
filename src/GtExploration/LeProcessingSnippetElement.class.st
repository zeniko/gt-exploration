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
LeProcessingSnippetElement >> onAddedToSceneGraph [
	self userData
		at: #lspFile
		ifAbsentPut: [ | element snippetModel file |
			element := self
					allParentsDetect: [ :each | each class = LePageToolElement ]
					ifFound: [ :each | each ]
					ifNone: [ self ].
			snippetModel := element userData
					at: #lspSnippetModel
					ifAbsentPut: [ GtLSPPythonSnippetModel local ].
			file := snippetModel createSnippet.
			file source: self coder currentSourceString.
			file open.
			editorElement addAptitude: (GtLSPEditorAptitude new lspFile: file).
			file ].
	^ super onAddedToSceneGraph
]

{ #category : #accessing }
LeProcessingSnippetElement >> onLanguageLinkStartStop: anAnnouncement [
	self inUIProcessDo: [ self updateLanguageLabel]
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

{ #category : #accessing }
LeProcessingSnippetElement >> updateLspSourceFrom: event [
	(self userData at: #lspFile ifAbsent: [ ^ self ])
		source: event source text asString
]
