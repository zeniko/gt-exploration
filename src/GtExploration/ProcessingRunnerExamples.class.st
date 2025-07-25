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
	self assert: runner wait equals: true.
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
ProcessingRunnerExamples >> runAnimation [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program runner detected |
	program := ProcessingProgramExamples new programAnimation.
	detected := (program runFor: 0.1 seconds) wait.
	self assert: detected asString equals: 'AsyncFutureCancelled'.

	runner := self newRunner.
	runner
		limitTo: 0.1 seconds;
		run: program compilation;
		wait.
	self assert: runner isDone not.
	self assert: runner canvas isNotNil.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runAnimation2 [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program runner element detected |
	program := ProcessingProgramExamples new programAnimation2.
	runner := program runFor: 0.1 seconds.
	detected := runner wait.
	self assert: detected asString equals: 'AsyncFutureCancelled'.

	element := runner canvas canvasElement.
	self assert: element constraints horizontal resizer size equals: 400.
	self assert: element constraints vertical resizer size equals: 300.
	element := (element parent parent children
			select: [ :el | (el contentElement = self) not ]) first contentElement.
	self assert: element constraints horizontal resizer size equals: 400.
	self assert: element constraints vertical resizer size equals: 300.

	runner := self newRunner.
	runner
		limitTo: 0.1 seconds;
		run: program compilation;
		wait.
	self assert: runner isDone not.
	self assert: runner canvas isNotNil.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runAnimation2Stepwise [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program steps |
	program := ProcessingProgramExamples new programAnimation2.
	steps := program runStepsFor: 0.1 seconds.
	self assert: steps isNotEmpty.
	self
		assert: ((steps last instVarNamed: #slice) isKindOf: ProcessingRunawayProgramException).
	steps allButLast
		do: [ :step | 
			(step gtAbstractionsFor: GtPhlowView empty)
				asElementDo: [ :e | 
					e children
						do: [ :c | self assert: c containerName = 'phlow--exception' equals: false ] ] ].
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runAnimationStepwise [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program steps |
	program := ProcessingProgramExamples new programAnimation.
	steps := program runStepsFor: 0.1 seconds.
	self assert: steps isNotEmpty.
	self
		assert: ((steps last instVarNamed: #slice) isKindOf: ProcessingRunawayProgramException).
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runExample02 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample02.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #a) equals: 200.
	self assert: runner wait equals: true.
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
	"Example03 contains deliberate `delay` calls"

	<gtExample>
	<noTest>
	| program runner |
	program := ProcessingProgramExamples new programExample03.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #x) equals: 0.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample04 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample04.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: 0 <= (program compilation instVarNamed: #x).
	self assert: (program compilation instVarNamed: #x) < 3.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample05 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample05.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #gt_A) equals: 200.
	self assert: (program compilation instVarNamed: #gt_B) equals: 100.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample06 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample06.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #var) equals: 5.
	self assert: (program compilation instVarNamed: #cond) equals: true.
	self assert: runner wait equals: true.
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
ProcessingRunnerExamples >> runExample07 [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programExample07.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone not.
	self assert: (runner wait isKindOf: AssertionFailure).
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runFibonacci [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programFibonacci.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runFibonacciStepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingProgramExamples new programFibonacci.
	runner := self newRunner.
	steps := runner
			limitTo: 2 seconds;
			runStepwise: program compilation.
	self assert: steps size equals: 550.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runImage [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programImage.
	runner := self newRunner.
	runner
		run: program compilation;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runInterrupted [
	"Runaway detection currently takes a few seconds"

	<gtExample>
	<noTest>
	| program runner detected |
	program := ProcessingProgramExamples new programEndlessLoop.
	detected := nil.
	[ program canvas ]
		on: ProcessingRunawayProgramException
		do: [ :ex | detected := ex ].
	self
		assert: detected asString
		equals: 'ProcessingRunawayProgramException: Endless loop detected.'.

	runner := self newRunner.
	runner
		limitTo: 0.1 seconds;
		run: program compilation;
		wait.
	self assert: runner isDone not.
	self assert: runner canvas isNotNil.
	self assert: (runner wait isKindOf: AsyncFutureCancelled).
	^ runner wait
]

{ #category : #example }
ProcessingRunnerExamples >> runInterruptedStepwise [
	"Runaway detection currently takes a few seconds"

	<gtExample>
	<noTest>
	| program runner steps detected |
	program := ProcessingProgramExamples new programEndlessLoop.
	steps := program runSteps.
	self assert: steps size equals: 1.
	self
		assert: ((steps last instVarNamed: #slice) isKindOf: ProcessingRunawayProgramException).

	runner := self newRunner.
	steps := runner
			limitTo: 0.1 seconds;
			runStepwise: program compilation.
	self assert: steps size equals: 0.
	self assert: runner isDone not.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runLists [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programLists.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: '[1, 2, 3] [1, 2, 3, 1, 2, 3] [3, 2, 1, 3, 2, 1] [3, 2, 1, 3, 2] [1, 2, 2, 3, 3] [2, 2, 3] 3 3 [1, 2, 3, 1]'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runMinimal [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programMinimal.
	runner := self newRunner.
	runner
		run: program compilation;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runPrint [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programPrint.
	runner := self newRunner.
	self assert: runner canvas isNil.
	runner
		run: program compilation;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #var) equals: 5.
	self assert: runner wait equals: true.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: 'Hello, world!
2 + 3 = 5'.
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
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runRuntimeError [
	<gtExample>
	| program runner detected |
	program := ProcessingSourceExamples new sourceRuntimeError program.
	detected := nil.
	[ program canvas ]
		on: ProcessingRunTimeException
		do: [ :ex | detected := ex asString ].
	self assert: detected equals: 'ProcessingRunTimeException'.

	runner := self newRunner.
	runner
		limitTo: 0.1 seconds;
		run: program compilation;
		wait.
	self assert: runner isDone not.
	self assert: runner canvas isNotNil.
	self assert: runner canvas canvasElement children size equals: 1.
	self assert: (runner canvas canvasElement children first isKindOf: BrFrame).
	self assert: (runner wait isKindOf: ZeroDivide).
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runShapesStepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingProgramExamples new programShapes.
	runner := self newRunner.
	steps := runner
			limitTo: 2 seconds;
			runStepwise: program compilation.
	self assert: steps size equals: 6.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runSierpinski [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programSierpinski.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runSierpinskiStepwise [
	"Collecting that many samples takes a few seconds"

	<gtExample>
	<noTest>
	| program runner steps |
	program := ProcessingProgramExamples new programSierpinski.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 583.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runSpiral [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programSpiral.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runSpiralStepwise [
	<gtExample>
	<noTest>
	| program runner steps |
	program := ProcessingProgramExamples new programSpiral.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 488.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runTurtleGraphics [
	<gtExample>
	| program runner |
	program := ProcessingProgramExamples new programTurtleGraphics.
	runner := self newRunner.
	runner
		run: program compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #t_x) equals: 0.
	self assert: (program compilation instVarNamed: #t_y) equals: 0.
	self assert: (program compilation instVarNamed: #t_angle) equals: 0.
	self assert: runner wait equals: true.
	^ runner
]
