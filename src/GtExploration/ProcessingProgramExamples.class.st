Class {
	#name : #ProcessingProgramExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingProgramExamples >> programAlpinerWanderweg [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAlpinerWanderweg program.
	self assert: program ast statements size equals: 4.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programAnimation [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAnimation program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programEndlessLoop [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceEndlessLoop program.
	self assert: program ast statements size equals: 1.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample02 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample02 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample03 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample03 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample04 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample04 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample05 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample05 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample06 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample06 program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programFibonacci [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceFibonacci program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programImage [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceImage program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programMinimal [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceMinimal program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programPrint [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourcePrint program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programRecursion [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceRecursion program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programShapes [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceShapes program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programSierpinski [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSierpinski program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programSwitzerland [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSwitzerland program.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programTurtleGraphics [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceTurtleGraphics program.
	self assert: program compilation isNotNil.
	^ program
]
