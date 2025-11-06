"
This announcement is sent by {{gtClass:ProcessingSource}} whenever the source changed and is syntactically valid.
"
Class {
	#name : #ProcessingASTChanged,
	#superclass : #ProcessingSourceChanged,
	#instVars : [
		'ast'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingASTChanged >> ast [
	^ ast ifNil: [ ProcessingParser parse: source asString ]
]

{ #category : #accessing }
ProcessingASTChanged >> ast: anAst [
	ast := anAst
]
