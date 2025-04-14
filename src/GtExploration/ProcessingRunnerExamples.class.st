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
	self assert: runner canvas equals: nil.
	self assert: runner isDone equals: nil.
	^ runner
]

{ #category : #'as yet unclassified' }
ProcessingRunnerExamples >> runExample03 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample03.
	runner := self newRunner.
	runner run: program; limitTo: 2 seconds; wait.
	self assert: runner canvas isNil equals: false.
	self assert: runner isDone equals: true.
	^ runner
]

{ #category : #'as yet unclassified' }
ProcessingRunnerExamples >> runInterrupted [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programEndlessLoop.
	runner := self newRunner.
	runner limitTo: 0.1 seconds; run: program; wait.
	self assert: runner canvas isNil equals: false.
	self assert: runner isDone equals: false.
	^ runner
]

{ #category : #'as yet unclassified' }
ProcessingRunnerExamples >> runMinimal [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programMinimal.
	runner := self newRunner.
	runner run: program; wait.
	self assert: runner canvas isNil equals: false.
	self assert: runner isDone equals: true.
	^ runner
]
