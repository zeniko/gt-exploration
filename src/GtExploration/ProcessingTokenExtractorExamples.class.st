Class {
	#name : #ProcessingTokenExtractorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTokenExtractorExamples >> newExtractor [
	<gtExample>
	^ ProcessingTokenExtractor new
]

{ #category : #example }
ProcessingTokenExtractorExamples >> parseMinimal [
	<gtExample>
	| source ast node |
	source := ProcessingSourceExamples new sourceCodeMinimal.
	ast := ProcessingParser parse: source.

	self assert: ast statements size equals: 1.
	node := ast statements first.
	self
		assert: node asString
		equals: 'a PyExpressionStatementNode(size(200, 200))'.
	self assert: node expression receiver nameToken value equals: 'size'.
	^ ast
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensAlpinerWanderweg [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programAlpinerWanderweg ast.
	self assert: ast statements size equals: 4.
	self
		assert: (ast statements collect: [ :node | node expression receiver nameToken value ])
		equals: (OrderedCollection newFrom: #('size' 'rect' 'fill' 'rect')).

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 40.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensAnimation [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programAnimation ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 54.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensAnimation2 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programAnimation2 ast.
	self assert: ast statements size equals: 6.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 98.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensColors [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programColors ast.
	self assert: ast statements size equals: 6.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 44.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensEndlessLoop [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programEndlessLoop ast.
	self assert: ast statements size equals: 1.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 4.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample02 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programExample02 ast.
	self assert: ast statements size equals: 4.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 48.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample03 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programExample03 ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 43.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample04 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programExample04 ast.
	self assert: ast statements size equals: 6.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 53.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample05 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programExample05 ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 16.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample06 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programExample06 ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 33.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample07 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programExample07 ast.
	self assert: ast statements size equals: 6.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 28.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensFibonacci [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programFibonacci ast.
	self assert: ast statements size equals: 8.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 81.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensImage [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programImage ast.
	self assert: ast statements size equals: 5.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 36.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensLists [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programLists ast.
	self assert: ast statements size equals: 11.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 89.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensLists2 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programLists2 ast.
	self assert: ast statements size equals: 5.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 52.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensMinimal [
	<gtExample>
	| ast tokens |
	ast := self parseMinimal.
	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 6.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensMouseEvents [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programMouseEvents ast.
	self assert: ast statements size equals: 2.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 82.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensMouseEvents2 [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programMouseEvents2 ast.
	self assert: ast statements size equals: 5.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 52.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensPrecedence [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programPrecedence ast.
	self assert: ast statements size equals: 8.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 67.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensPrint [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programPrint ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 16.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensRandom [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programRandom ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 18.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensRecurion [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programRecursion ast.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 37.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensShapes [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programShapes ast.
	self assert: ast statements size equals: 6.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 60.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensSierpinski [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programSierpinski ast.
	self assert: ast statements size equals: 8.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 172.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensSimulation [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programSimulation ast.
	self assert: ast statements size equals: 14.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 459.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensSpiral [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programSpiral ast.
	self assert: ast statements size equals: 6.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 109.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensSwitzerland [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programSwitzerland ast.
	self assert: ast statements size equals: 4.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 34.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensTransforms [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programTransforms ast.
	self assert: ast statements size equals: 18.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 119.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensTurtleGraphics [
	<gtExample>
	| ast tokens |
	ast := ProcessingProgramExamples new programTurtleGraphics ast.
	self assert: ast statements size equals: 12.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 246.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]
