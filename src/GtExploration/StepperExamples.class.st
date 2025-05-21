Class {
	#name : #StepperExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
StepperExamples >> example02Stepper [
	<gtExample>
	| stepper |
	stepper := Stepper for: [ ProcessingRunnerExamples new runExample02Stepwise ] view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 13.
	self assert: stepper index equals: 13.
	stepper stepTo: 0.
	self assert: stepper index equals: 1.
	^ stepper
]

{ #category : #example }
StepperExamples >> sierpinskiStepper [
	<gtExample>
	<noTest> "Collecting that many samples takes a few seconds"
	| stepper |
	stepper := Stepper for: ProcessingRunnerExamples new runSierpinskiStepwise view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 211.
	self assert: stepper index equals: 211.
	^ stepper
]

{ #category : #example }
StepperExamples >> spiralStepper [
	<gtExample>
	<noTest> "Collecting that many samples takes a few seconds"
	| stepper |
	stepper := Stepper for: ProcessingRunnerExamples new runSpiralStepwise view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 74.
	self assert: stepper index equals: 74.
	^ stepper
]
