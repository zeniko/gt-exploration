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
ProcessingTokenExtractorExamples >> tokensAlpinerWanderweg [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseAlpinerWanderweg.
	self assert: tokens size equals: 40.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensAnimation [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseAnimation.
	self assert: tokens size equals: 54.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample02 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample02.
	self assert: tokens size equals: 48.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample03 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample03.
	self assert: tokens size equals: 43.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample04 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample04.
	self assert: tokens size equals: 53.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample05 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample05.
	self assert: tokens size equals: 12.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensExample06 [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseExample06.
	self assert: tokens size equals: 33.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensFibonacci [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseFibonacci.
	self assert: tokens size equals: 81.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensImage [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseImage.
	self assert: tokens size equals: 36.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensMinimal [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseMinimal.
	self assert: tokens size equals: 6.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensMouseEvents [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseMouseEvents.
	self assert: tokens size equals: 82.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensPrint [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parsePrint.
	self assert: tokens size equals: 16.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensSierpinski [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseSierpinski.
	self assert: tokens size equals: 172.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensTransforms [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseTransforms.
	self assert: tokens size equals: 119.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensTurtleGraphics [
	<gtExample>
	| tokens |
	tokens := self newExtractor extractTokens: ProcessingParserExamples new parseTurtleGraphics.
	self assert: tokens size equals: 246.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]
