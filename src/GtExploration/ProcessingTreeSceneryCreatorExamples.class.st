Class {
	#name : #ProcessingTreeSceneryCreatorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingTreeSceneryCreatorExamples >> astSceneryExample03 [
	<gtExample>
	| scenery program |
	program := ProcessingProgramExamples new programExample03.
	scenery := ProcessingTreeSceneryCreator sceneryFor: program.
	self assert: scenery items size equals: 54.
	self assert: scenery items size > ProcessingTokenExtractorExamples new tokensExample03 size.
	self assert: scenery connections size equals: scenery items size - 1.
	self assert: scenery items first stencil label equals: 'Root' translated.
	self assert: (scenery connections select: [ :conn | conn from = scenery items first ]) size equals: program ast children size.
	^ scenery
]

{ #category : #'as yet unclassified' }
ProcessingTreeSceneryCreatorExamples >> astSceneryMinimal [
	<gtExample>
	| scenery program |
	program := ProcessingProgramExamples new programMinimal.
	scenery := ProcessingTreeSceneryCreator sceneryFor: program.
	self assert: scenery items size equals: 8.
	self assert: scenery items size > ProcessingTokenExtractorExamples new tokensMinimal size.
	self assert: scenery connections size equals: scenery items size - 1.
	self assert: scenery items first stencil label equals: 'Root' translated.
	self assert: (scenery connections select: [ :conn | conn from = scenery items first ]) size equals: program ast children size.
	^ scenery
]
