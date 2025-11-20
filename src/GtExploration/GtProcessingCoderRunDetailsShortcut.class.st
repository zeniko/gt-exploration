Class {
	#name : 'GtProcessingCoderRunDetailsShortcut',
	#superclass : 'GtSourceCoderShortcut',
	#category : 'GtExploration-Snippet',
	#package : 'GtExploration',
	#tag : 'Snippet'
}

{ #category : 'accessing' }
GtProcessingCoderRunDetailsShortcut >> description [
	^ 'Evaluates the whole source code and show some intermediary detail steps between source code and result.'
]

{ #category : 'initialization' }
GtProcessingCoderRunDetailsShortcut >> initialize [
	super initialize.

	combination := BlKeyCombination primaryD.
	name := 'Abstractions'
]

{ #category : 'evaluation' }
GtProcessingCoderRunDetailsShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doItAndGo ]
]
