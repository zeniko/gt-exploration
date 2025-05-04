Class {
	#name : #ProcessingParser,
	#superclass : #PythonParser,
	#category : #'GtExploration-Processing'
}

{ #category : #bugfix }
ProcessingParser >> reduceActionForor_test2: nodes [
	| result |
	result := PyBinaryExpressionNode new.
	result left: (nodes at: 1).
	"TODO: `opeator` is misspelled in PythonParser"
	result operator: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #bugfix }
ProcessingParser >> reduceActionFortest2: nodes [
	| result |
	result := PyIfExpressionNode new.
	"TODO: `if` and `condition` are swapped in PythonParser"
	result if: (nodes at: 1).
	result ifToken: (nodes at: 2).
	result condition: (nodes at: 3).
	result elseToken: (nodes at: 4).
	result else: (nodes at: 5).
	^ result
]
