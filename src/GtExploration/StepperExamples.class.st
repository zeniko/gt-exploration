Class {
	#name : #StepperExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

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
