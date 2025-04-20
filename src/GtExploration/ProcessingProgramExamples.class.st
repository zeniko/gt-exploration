Class {
	#name : #ProcessingProgramExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programAlpinerWanderweg [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAlpinerWanderweg program.
	self assert: program ast statements size equals: 4.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programEndlessLoop [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceEndlessLoop program.
	self assert: program ast statements size equals: 1.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programExample02 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample02 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programExample03 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample03 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programExample04 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample04 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programExample05 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample05 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programFibonacci [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceFibonacci program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programMinimal [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceMinimal program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programRecursion [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceRecursion program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programShapes [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceShapes program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programSwitzerland [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSwitzerland program.
	self assert: program compilation isNotNil.
	^ program
]
