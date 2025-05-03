Class {
	#name : #PythonTokenExtractorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
PythonTokenExtractorExamples >> newExtractor [
	<gtExample>
	^ PythonTokenExtractor new
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensAlpinerWanderweg [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseAlpinerWanderweg.
	self assert: tokens size equals: 40.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 40.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensExample02 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample02.
	self assert: tokens size equals: 52.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 52.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensExample03 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample03.
	self assert: tokens size equals: 43.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 43.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensExample04 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample04.
	self assert: tokens size equals: 53.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 53.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensExample05 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample05.
	self assert: tokens size equals: 12.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 12.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensFibonacci [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseFibonacci.
	self assert: tokens size equals: 81.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 81.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensSierpinski [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseSierpinski.
	self assert: tokens size equals: 172.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 172.
	^ tokens
]

{ #category : #example }
PythonTokenExtractorExamples >> tokensTurtleGraphics [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseTurtleGraphics.
	self assert: tokens size equals: 246.
	self assert: (tokens select: [ :item | item isKindOf: SmaCCToken ]) size equals: 246.
	^ tokens
]
