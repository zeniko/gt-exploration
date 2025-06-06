Class {
	#name : #StepperExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
StepperExamples >> animation2Stepper [
	<gtExample>
	| stepper |
	stepper := Stepper
			for: [ ProcessingRunnerExamples new runAnimation2Stepwise ]
			view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 8.
	self assert: stepper index equals: 8.
	^ stepper
]

{ #category : #example }
StepperExamples >> example02Stepper [
	<gtExample>
	| stepper |
	stepper := Stepper
			for: [ ProcessingRunnerExamples new runExample02Stepwise ]
			view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 13.
	self assert: stepper index equals: 13.
	stepper stepTo: 0.
	self assert: stepper index equals: 1.
	^ stepper
]

{ #category : #example }
StepperExamples >> sierpinskiStepper [
	"Collecting that many samples takes a few seconds"

	<gtExample>
	<noTest>
	| stepper |
	stepper := Stepper
			for: ProcessingRunnerExamples new runSierpinskiStepwise
			view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 211.
	self assert: stepper index equals: 211.
	^ stepper
]

{ #category : #example }
StepperExamples >> spiralStepper [
	"Collecting that many samples takes a few seconds"

	<gtExample>
	<noTest>
	| stepper |
	stepper := Stepper
			for: ProcessingRunnerExamples new runSpiralStepwise
			view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 74.
	self assert: stepper index equals: 74.
	^ stepper
]
