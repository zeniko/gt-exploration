Class {
	#name : #ProcessingProgramExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingProgramExamples >> allViews [
	<gtExample>
	| program views |
	program := self programMinimal.
	views := program class methodDict keys
			select: [ :key | (key beginsWith: 'gt') & (key endsWith: 'For:') ].
	self assert: views size equals: 28.
	views
		do: [ :key | 
			| view element |
			view := program perform: key with: GtPhlowView empty.
			self assert: view isNotNil.
			element := view asElement.
			self assert: element containerName = 'phlow--exception' equals: false ].
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programAlpinerWanderweg [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAlpinerWanderweg program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programAnimation [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAnimation program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programAnimation2 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAnimation2 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programEndlessLoop [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceEndlessLoop program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample02 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample02 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample03 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample03 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample04 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample04 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample05 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample05 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample06 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample06 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programExample07 [
	<gtExample>
	| program message |
	program := ProcessingSourceExamples new sourceExample07 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	message := nil.
	[ program compilation
		gtCanvas: ProcessingCanvas new;
		gtRun ] on: AssertionFailure do: [ :ex | message := ex asString ].
	self assert: message equals: 'AssertionFailure: Done!'.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programFibonacci [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceFibonacci program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programImage [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceImage program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programLists [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceLists program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programLists2 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceLists2 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programMinimal [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceMinimal program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programMouseEvents [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceMouseEvents program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programMouseEvents2 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceMouseEvents2 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programPrecedence [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourcePrecedence program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programPrint [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourcePrint program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programRandom [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceRandom program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programRecursion [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceRecursion program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programShapes [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceShapes program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programSierpinski [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSierpinski program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programSimulation [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSimulation program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programSpiral [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSpiral program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programSwitzerland [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceSwitzerland program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programTransforms [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceTransforms program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : #example }
ProcessingProgramExamples >> programTurtleGraphics [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceTurtleGraphics program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]
