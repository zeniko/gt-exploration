Class {
	#name : #BrTextEditorReadonlyWithNavigationMode,
	#superclass : #BrTextEditorReadonlyWithSelectionMode,
	#category : #'GtExploration-GtExtensions'
}

{ #category : #initalization }
BrTextEditorReadonlyWithNavigationMode >> createShortcuts [
	^ super createShortcuts , {
		BrEditorShortcut copy.
		BrEditorShortcut moveCursorLeft.
		BrEditorShortcut moveCursorRight.
		BrEditorShortcut moveCursorUp.
		BrEditorShortcut moveCursorDown.
		BrEditorShortcut moveCursorToPreviousWord.
		BrEditorShortcut moveCursorToNextWord.
		BrEditorShortcut moveCursorToLineStart.
		BrEditorShortcut moveCursorToLineEnd.
		BrEditorShortcut moveCursorToBeginning.
		BrEditorShortcut moveCursorToEnd.
		BrEditorShortcut selectAll.
		BrEditorShortcut deselectAll.
		BrEditorShortcut selectLetterAfterCursor.
		BrEditorShortcut selectLetterBeforeCursor.
		BrEditorShortcut selectWordBeforeCursor.
		BrEditorShortcut selectWordAfterCursor.
		BrEditorShortcut selectLineBeforeCursor.
		BrEditorShortcut selectLineAfterCursor.
		BrEditorShortcut selectLineBelowCursor.
		BrEditorShortcut selectLineAboveCursor.
		BrEditorShortcut selectToBeginning.
		BrEditorShortcut selectToEnd.
	}
]
