Class {
	#name : #StepperExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
StepperExamples >> sierpinskiStepper [
	<gtExample>
	| stepper |
	stepper := Stepper for: ProcessingRunnerExamples new runSierpinskiStepwise view: #gtAbstractionsFor:.
	self assert: stepper index equals: 1.
	stepper stepTo: 211.
	self assert: stepper index equals: 211.
	^ stepper
]
