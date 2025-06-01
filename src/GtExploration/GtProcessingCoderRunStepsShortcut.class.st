Class {
	#name : #GtProcessingCoderRunStepsShortcut,
	#superclass : #GtSourceCoderShortcut,
	#category : #'GtExploration-Snippet'
}

{ #category : #accessing }
GtProcessingCoderRunStepsShortcut >> description [
	^ 'Evaluates the whole source code and show its execution step by step.'
]

{ #category : #initialization }
GtProcessingCoderRunStepsShortcut >> initialize [
	super initialize.

	combination := BlKeyCombination primaryG.
	name := 'Run Steps'
]

{ #category : #evaluation }
GtProcessingCoderRunStepsShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doItAndGoSerialized ]
]
