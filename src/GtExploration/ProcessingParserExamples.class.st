Class {
	#name : #ProcessingParserExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingParserExamples >> parseAlpinerWanderweg [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programAlpinerWanderweg ast.
	self assert: ast statements size equals: 4.
	self assert: (ast statements collect: [ :node | node expression receiver nameToken value ]) equals: (OrderedCollection newFrom: #('size' 'rect' 'fill' 'rect')).
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseAnimation [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programAnimation ast.
	self assert: ast statements size equals: 3.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseEndlessLoop [
	<gtExample>
	| ast node |
	ast := ProcessingSourceExamples new sourceEndlessLoop program ast.
	self assert: ast statements size equals: 1.
	node := ast statements first.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseExample02 [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programExample02 ast.
	self assert: ast statements size equals: 4.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseExample03 [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programExample03 ast.
	self assert: ast statements size equals: 3.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseExample04 [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programExample04 ast.
	self assert: ast statements size equals: 6.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseExample05 [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programExample05 ast.
	self assert: ast statements size equals: 3.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseExample06 [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programExample06 ast.
	self assert: ast statements size equals: 3.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseFibonacci [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programFibonacci ast.
	self assert: ast statements size equals: 8.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseImage [
	<gtExample>
	| ast |
	ast := ProcessingParser parse: ProcessingSourceExamples new sourceCodeImage.
	self assert: ast statements size equals: 5.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseMinimal [
	<gtExample>
	| ast node |
	ast := ProcessingParser parse: ProcessingSourceExamples new sourceCodeMinimal.
	self assert: ast statements size equals: 1.
	node := ast statements first.
	self assert: node asString equals: 'a PyExpressionStatementNode(size(200, 200))'.
	self assert: node expression receiver nameToken value equals: 'size'.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parsePrint [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programPrint ast.
	self assert: ast statements size equals: 3.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseRecursion [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programRecursion ast.
	self assert: ast statements size equals: 3.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseShapes [
	<gtExample>
	| ast node |
	ast := ProcessingProgramExamples new programShapes ast.
	self assert: ast statements size equals: 6.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseSierpinski [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programSierpinski ast.
	self assert: ast statements size equals: 8.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseSwitzerland [
	<gtExample>
	| ast node |
	ast := ProcessingProgramExamples new programSwitzerland ast.
	self assert: ast statements size equals: 4.
	^ ast
]

{ #category : #example }
ProcessingParserExamples >> parseTurtleGraphics [
	<gtExample>
	| ast |
	ast := ProcessingProgramExamples new programTurtleGraphics ast.
	self assert: ast statements size equals: 12.
	^ ast
]
