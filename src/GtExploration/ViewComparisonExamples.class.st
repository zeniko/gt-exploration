Class {
	#name : #ViewComparisonExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ViewComparisonExamples >> compareExample02To03Bytecode [
	<gtExample>
	| comparer |
	comparer := ViewComparison
			newFor: {ProcessingProgramExamples new programExample02 -> #gtBytecodeFor:.
					ProcessingProgramExamples new programExample03 -> #gtBytecodeFor:}.
	^ comparer
]

{ #category : #example }
ViewComparisonExamples >> compareExample02To03SourceBytes [
	<gtExample>
	| comparer |
	comparer := ViewComparison
			newFor: {ProcessingProgramExamples new programExample02 -> #gtSourceBytesFor:.
					ProcessingProgramExamples new programExample03 -> #gtSourceBytesFor:}.
	^ comparer
]

{ #category : #example }
ViewComparisonExamples >> compareExample02To03SourceBytesScripter [
	<gtExample>
	| comparer |
	comparer := self compareExample02To03SourceBytes.
	^ BlScripter new
		element: comparer asElement;
		substeps: 'Select Left Item #2'
			do: [ :step | 
				step set key: [ #mousePosition ] value: [ 40 @ 80 ].
				step
					mouseMove;
					mouseDown;
					mouseUp.
				step check
					value: [ :el | el contentElement children first children first children last selectedIndices ]
					equals: #(2).
				step check
					value: [ :el | el contentElement children first children second children last selectedIndices ]
					equals: #(2) ];
		substeps: 'Select Left Item #17'
			do: [ :step | 
				step set key: [ #mousePosition ] value: [ 340 @ 460 ].
				step
					mouseMove;
					mouseDown;
					mouseUp.
				step check
					value: [ :el | el contentElement children first children first children last selectedIndices ]
					equals: #(17).
				step check
					value: [ :el | el contentElement children first children second children last selectedIndices ]
					equals: #(17) ];
		substeps: 'Select Right Item #9'
			do: [ :step | 
				step set key: [ #mousePosition ] value: [ 520 @ 260 ].
				step
					mouseMove;
					mouseDown;
					mouseUp.
				step check
					value: [ :el | el contentElement children first children first children last selectedIndices ]
					equals: #(9).
				step check
					value: [ :el | el contentElement children first children second children last selectedIndices ]
					equals: #(9) ];
		substeps: 'Scroll Left Side'
			do: [ :step | 
				step mouseWheel
					downBy: 100;
					on: BrInfiniteListElement index: 1.
				step check
					value: [ :el | 
						el contentElement children first children first children last children first
							instVarNamed: #layoutPositionsRange ]
					equals: (40 to: 61).
				step check
					value: [ :el | 
						el contentElement children first children second children last children first
							instVarNamed: #layoutPositionsRange ]
					equals: (39 to: 60) ];
		substeps: 'Scroll Right Side'
			do: [ :step | 
				step mouseWheel
					upBy: 50;
					on: BrInfiniteListElement index: 2.
				step check
					value: [ :el | 
						el contentElement children first children first children last children first
							instVarNamed: #layoutPositionsRange ]
					equals: (40 to: 61).
				step check
					value: [ :el | 
						el contentElement children first children second children last children first
							instVarNamed: #layoutPositionsRange ]
					equals: (19 to: 41) ];
		play
]
