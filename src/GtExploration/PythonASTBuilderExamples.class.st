Class {
	#name : #PythonASTBuilderExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
PythonASTBuilderExamples >> buildAlpinerWanderweg [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseAlpinerWanderweg.
	self assert: tokens size equals: 40.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 40.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseAlpinerWanderweg.
	self assert: tree size equals: 5.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildExample02 [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseExample02.
	self assert: tokens size equals: 52.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 52.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseExample02.
	self assert: tree size equals: 5.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildExample03 [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseExample03.
	self assert: tokens size equals: 43.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 43.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseExample03.
	self assert: tree size equals: 4.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildExample04 [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseExample04.
	self assert: tokens size equals: 53.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 53.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseExample04.
	self assert: tree size equals: 7.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildExample05 [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseExample05.
	self assert: tokens size equals: 12.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 12.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseExample05.
	self assert: tree size equals: 4.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildFibonacci [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseFibonacci.
	self assert: tokens size equals: 77.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 77.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseFibonacci.
	self assert: tree size equals: 9.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildSierpinski [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseSierpinski.
	self assert: tokens size equals: 111.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 111.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseSierpinski.
	self assert: tree size equals: 9.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> buildTurtleGraphics [
	<gtExample>
	| tokens tree |
	tokens := self newBuilder extractTokens: ProcessingParserExamples new parseTurtleGraphics.
	self assert: tokens size equals: 246.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 246.
	
	tree := self newBuilder extractTree: ProcessingParserExamples new parseTurtleGraphics.
	self assert: tree size equals: 13.
	self assert: tree first value equals: 'Root'.
	^ tree
]

{ #category : #example }
PythonASTBuilderExamples >> newBuilder [
	<gtExample>
	^ PythonASTBuilder new
]
