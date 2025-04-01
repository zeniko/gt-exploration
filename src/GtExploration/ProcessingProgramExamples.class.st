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
ProcessingProgramExamples >> programExample02 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample02 program.
	self assert: program ast statements size equals: 4.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> programMinimal [
	<gtExample>
	| program canvas |
	program := ProcessingSourceExamples new sourceMinimal program.
	self assert: program ast statements size equals: 1.
	self assert: program compilation isNotNil.
	^ program
]
