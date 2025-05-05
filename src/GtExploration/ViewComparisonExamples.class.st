Class {
	#name : #ViewComparisonExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ViewComparisonExamples >> compareExample02To03Bytecode [
	<gtExample>
	| comparer |
	comparer := ViewComparison newFor: {
		ProcessingProgramExamples new programExample02 -> #gtBytecodeFor:.
		ProcessingProgramExamples new programExample03 -> #gtBytecodeFor:.
	}.
	^ comparer
]

{ #category : #example }
ViewComparisonExamples >> compareExample02To03SourceBytes [
	<gtExample>
	| comparer |
	comparer := ViewComparison newFor: {
		ProcessingProgramExamples new programExample02 -> #gtSourceBytesFor:.
		ProcessingProgramExamples new programExample03 -> #gtSourceBytesFor:.
	}.
	^ comparer
]
