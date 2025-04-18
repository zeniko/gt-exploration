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
	<noTest> "Runaway detection currently takes a few seconds"
	| program detected |
	program := ProcessingSourceExamples new sourceEndlessLoop program.
	self assert: program ast statements size equals: 1.
	self assert: program compilation isNotNil.
	detected := nil.
	[program canvas] on: ProcessingRunawayProgramException do: [ :ex | detected := ex asString ].
	self assert: detected equals: 'ProcessingRunawayProgramException: Endless loop detected.'.
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
ProcessingProgramExamples >> programSwitzerland [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSwitzerland program.
	self assert: program compilation isNotNil.
	^ program
]
