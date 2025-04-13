Class {
	#name : #ProcessingRunnerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingRunnerExamples >> newRunner [
	<gtExample>
	| runner |
	runner := ProcessingRunner new.
	^ runner
]

{ #category : #'as yet unclassified' }
ProcessingRunnerExamples >> runInterrupted [
	<gtExample>
	| program runner canvas promise |
	program := ProcessingProgramExamples new programEndlessLoop.
	runner := self newRunner.
	canvas := ProcessingCanvasExamples new container.
	"TODO: this doesn't yet cancel the endless loop"
	promise := runner run: program with: canvas for: 0.1 seconds.
	self assert: (promise wait isKindOf: AsyncFutureCancelled) equals: true.
	^ promise
]

{ #category : #'as yet unclassified' }
ProcessingRunnerExamples >> runMinimal [
	<gtExample>
	| program runner canvas promise |
	program := ProcessingProgramExamples new programMinimal.
	runner := self newRunner.
	canvas := ProcessingCanvasExamples new container.
	promise := runner run: program with: canvas for: 2 seconds.
	self assert: promise wait equals: true.
	^ promise
]
