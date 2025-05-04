Class {
	#name : #GtProcessingCoderRunShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GtExploration-Snippet'
}

{ #category : #accessing }
GtProcessingCoderRunShortcut >> description [
	^ 'Evaluates the whole source code (method) and show only its visual output.'
]

{ #category : #initialization }
GtProcessingCoderRunShortcut >> initialize [
	super initialize.
	
	combination := BlKeyCombination primaryR.
	name := 'Run'.
]

{ #category : #evaluation }
GtProcessingCoderRunShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doIt ]
]
