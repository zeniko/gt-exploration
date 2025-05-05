Class {
	#name : #ProcessingRunnerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingRunnerExamples >> newRunner [
	<gtExample>
	| runner |
	runner := ProcessingRunner new.
	self assert: runner canvas equals: nil.
	self assert: runner isDone equals: nil.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runAlpinerWanderweg [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programAlpinerWanderweg.
	runner := program run.
	self assert: runner canvas isNotNil.
	self assert: runner isDone not.
	runner wait.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runAlpinerWanderwegStepwise [
	<gtExample>
	| program steps |
	program := ProcessingProgramExamples new programAlpinerWanderweg.
	steps := program runSteps.
	self assert: steps size equals: 7.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runExample02 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample02.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait; yourself.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #a) equals: 200.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample02Stepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingProgramExamples new programExample02.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 25.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runExample03 [
	<gtExample>
	<noTest> "Example03 contains deliberate `delay` calls"
	| program runner |
	program := ProcessingProgramExamples new programExample03.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #x) equals: 0.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample04 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample04.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample05 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample05.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #gt_A) equals: 200.
	self assert: (program compilation instVarNamed: #gt_B) equals: 100.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample06 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample06.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #var) equals: 5.
	self assert: (program compilation instVarNamed: #cond) equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample06Stepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingProgramExamples new programExample06.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 13.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runFibonacci [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programFibonacci.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runFibonacciStepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingProgramExamples new programFibonacci.
	runner := self newRunner.
	steps := runner limitTo: 2 seconds; runStepwise: program compilation.
	self assert: steps size equals: 550.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runInterrupted [
	<gtExample>
	<noTest> "Runaway detection currently takes a few seconds"
	| program runner detected |
	program := ProcessingProgramExamples new programEndlessLoop.
	detected := nil.
	[ program canvas ] on: ProcessingRunawayProgramException do: [ :ex | detected := ex ].
	self assert: detected asString equals: 'ProcessingRunawayProgramException: Endless loop detected.'.
	
	runner := self newRunner.
	runner limitTo: 0.1 seconds; run: program compilation; wait.
	self assert: runner isDone not.
	self assert: runner canvas isNotNil.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runInterruptedStepwise [
	<gtExample>
	<noTest> "Runaway detection currently takes a few seconds"
	| program runner steps detected |
	program := ProcessingProgramExamples new programEndlessLoop.
	detected := nil.
	[ steps := program runSteps ] on: ProcessingRunawayProgramException do: [ :ex | detected := ex ].
	self assert: detected asString equals: 'ProcessingRunawayProgramException: Endless loop detected.'.
	self assert: steps isNil.
	
	runner := self newRunner.
	steps := runner limitTo: 0.1 seconds; runStepwise: program compilation.
	self assert: steps isNotNil.
	self assert: runner isDone not.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runMinimal [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programMinimal.
	runner := self newRunner.
	runner run: program compilation; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runPrint [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programPrint.
	runner := self newRunner.
	self assert: runner canvas isNil.
	runner run: program compilation; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runRecursion [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programRecursion.
	runner := program runFor: 2 seconds.
	self assert: runner canvas isNotNil.
	self assert: runner isDone not.
	runner wait.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runSierpinski [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programSierpinski.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runSierpinskiStepwise [
	<gtExample>
	<noTest> "Collecting that many samples takes a few seconds"
	| program runner steps |
	program := ProcessingProgramExamples new programSierpinski.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 637.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runTurtleGraphics [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programTurtleGraphics.
	runner := self newRunner.
	runner run: program compilation; limitTo: 2 seconds; wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	^ runner
]
