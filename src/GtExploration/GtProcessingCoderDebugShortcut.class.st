Class {
	#name : 'GtProcessingCoderDebugShortcut',
	#superclass : 'GtSourceCoderShortcut',
	#category : 'GtExploration-Snippet',
	#package : 'GtExploration',
	#tag : 'Snippet'
}

{ #category : 'accessing' }
GtProcessingCoderDebugShortcut >> description [
	^ 'Starts a GT debugger on the transpiled code.'
]

{ #category : 'initialization' }
GtProcessingCoderDebugShortcut >> initialize [
	super initialize.

	combination := BlKeyCombination builder primary shift d build.
	name := 'Debug'
]

{ #category : 'evaluation' }
GtProcessingCoderDebugShortcut >> performOnEditor: aBrTextEditor element: aBrEditorElement coderViewModel: aSourceCoderViewModel dueTo: aShortcutEvent [
	GtCoderExecutionContextVariable
		element: aBrEditorElement
		do: [ aSourceCoderViewModel doItAndGoAsynchronous ]
]
