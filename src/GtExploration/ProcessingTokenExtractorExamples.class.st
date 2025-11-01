Class {
	#name : #ProcessingTokenExtractorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTokenExtractorExamples >> allTokens [
	<gtExample>
	| allTokens |
	allTokens := OrderedCollection new.
	self testData
		keysAndValuesDo: [ :name :data | 
			| ast tokens |
			ast := ProcessingSourceExamples astFor: name.
			self assert: ast statements size equals: data first.

			tokens := self newExtractor extractTokens: ast.
			self assert: tokens size equals: data second.
			self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
			allTokens add: tokens ].
	^ allTokens
]

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
ProcessingTokenExtractorExamples >> testData [
	"Map source code from ProgramSourceExamples to number of top-level statements and number of tokens"

	<gtExample>
	| testData |
	testData := {#AlpinerWanderweg -> #(4 40).
			#Animation -> #(3 54).
			#Animation2 -> #(6 100).
			#Colors -> #(6 44).
			#EndlessLoop -> #(1 4).
			#Example02 -> #(4 52).
			#Example03 -> #(3 43).
			#Example04 -> #(6 53).
			#Example05 -> #(4 30).
			#Example06 -> #(3 33).
			#Example07 -> #(6 28).
			#Fibonacci -> #(8 81).
			#Image -> #(5 36).
			#Lists -> #(15 117).
			#Lists2 -> #(5 59).
			#Minimal -> #(1 6).
			#MouseEvents -> #(2 82).
			#MouseEvents2 -> #(5 52).
			#Precedence -> #(8 67).
			#PresentationDemo -> #(3 22).
			#Print -> #(3 18).
			#Random -> #(3 18).
			#Recursion -> #(3 37).
			#RuntimeError -> #(1 3).
			#Shapes -> #(6 60).
			#Sierpinski -> #(8 172).
			#Simulation -> #(14 459).
			#Spiral -> #(6 109).
			#Switzerland -> #(4 34).
			#Transforms -> #(18 119).
			#TurtleGraphics -> #(12 246)} asDictionary.
	self
		assert: testData keys sorted
		equals: ProcessingSourceExamples new sourceNames.
	^ testData
]

{ #category : #example }
ProcessingTokenExtractorExamples >> tokensPresentationDemo [
	<gtExample>
	| ast tokens |
	ast := ProcessingSourceExamples astFor: #PresentationDemo.
	self assert: ast statements size equals: 3.

	tokens := self newExtractor extractTokens: ast.
	self assert: tokens size equals: 22.
	self assert: (tokens allSatisfy: [ :item | item isKindOf: SmaCCToken ]).
	^ tokens
]
