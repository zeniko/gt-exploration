Class {
	#name : #ProcessingRunnerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingRunnerExamples >> doAllRun [
	<gtExample>
	| sourceNames runNames missing |
	sourceNames := ProcessingSourceExamples new sourceNames.
	runNames := self class methodDict keys
			select: [ :name | name beginsWith: #run ]
			thenCollect: [ :name | name removePrefix: #run ].
	missing := sourceNames select: [ :name | (runNames includes: name) not ].
	self assert: missing equals: #().
	^ runNames sorted
]

{ #category : #example }
ProcessingRunnerExamples >> doRun: aProgram [
	| runner |
	runner := self newRunner.
	runner
		run: aProgram compilation;
		limitTo: 2 seconds;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	^ runner
]

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
	program := ProcessingSourceExamples new sourceAlpinerWanderweg program.
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
	program := ProcessingSourceExamples new sourceAlpinerWanderweg program.
	steps := program runSteps.
	self assert: steps size equals: 7.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runAnimation [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program runner detected |
	program := ProcessingSourceExamples new sourceAnimation program.
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
	| program runner detected |
	program := ProcessingSourceExamples new sourceAnimation2 program.
	runner := program runFor: 0.1 seconds.
	detected := runner wait.
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
ProcessingRunnerExamples >> runAnimation2Stepwise [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	<noTest>
	| program steps |
	program := ProcessingSourceExamples new sourceAnimation2 program.
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
	program := ProcessingSourceExamples new sourceAnimation program.
	steps := program runStepsFor: 0.1 seconds.
	self assert: steps isNotEmpty.
	self
		assert: ((steps last instVarNamed: #slice) isKindOf: ProcessingRunawayProgramException).
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runColors [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceColors program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runEndlessLoop [
	"Runaway detection currently takes a few seconds"

	<gtExample>
	<noTest>
	| program runner detected |
	program := ProcessingSourceExamples new sourceEndlessLoop program.
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
ProcessingRunnerExamples >> runEndlessLoopStepwise [
	"Runaway detection currently takes a few seconds"

	<gtExample>
	<noTest>
	| program runner steps |
	program := ProcessingSourceExamples new sourceEndlessLoop program.
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
ProcessingRunnerExamples >> runExample02 [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceExample02 program.
	runner := self doRun: program.
	self assert: (program compilation instVarNamed: #a) equals: 200.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample02Stepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourceExample02 program.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 25.
	self assert: runner isDone.
	self
		assert: (steps collect: [ :s | s variables at: 'a' ])
		equals: #(nil nil 0 0 0 0 0 50 50 50 50 50 100 100 100 100 100 150 150 150 150 150 200 200 200)
				asOrderedCollection.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runExample03 [
	"Example03 contains deliberate `delay` calls"

	<gtExample>
	<noTest>
	| program runner |
	program := ProcessingSourceExamples new sourceExample03 program.
	runner := self doRun: program.
	self assert: (program compilation instVarNamed: #x) equals: 0.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample04 [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceExample04 program.
	runner := self doRun: program.
	self assert: 0 <= (program compilation instVarNamed: #x).
	self assert: (program compilation instVarNamed: #x) < 3.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample05 [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceExample05 program.
	runner := self doRun: program.
	self assert: (program compilation instVarNamed: #gt_A) equals: 200.
	self assert: (program compilation instVarNamed: #gt_B) equals: 100.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: 'None True False String ["Nested"]'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample06 [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceExample06 program.
	runner := self doRun: program.
	self assert: (program compilation instVarNamed: #var) equals: 5.
	self assert: (program compilation instVarNamed: #cond) equals: true.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample06Stepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourceExample06 program.
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
	program := ProcessingSourceExamples new sourceExample07 program.
	runner := self newRunner.
	runner
		run: program compilation;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone not.
	self assert: (runner wait isKindOf: AssertionFailure).
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runExample07Stepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourceExample07 program.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 7.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runFibonacci [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceFibonacci program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runFibonacciStepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourceFibonacci program.
	runner := self newRunner.
	steps := runner
			limitTo: 2 seconds;
			runStepwise: program compilation.
	self assert: steps size equals: 550.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runForLoop [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceForLoop program.
	runner := self doRun: program.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: '[2, 5, 8, 11, 14] 3 14'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runImage [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceImage program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runLists [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceLists program.
	runner := self doRun: program.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: '[1, 2, 3] [1, 2, 3, 1, 2, 3] [3, 2, 1, 3, 2] 1 [1, 2, 2, 3, 3] [2, 2, 3] 3 3 [1, 2, 3, 1] [3, 3, 2, 2, 1, 1] [3, 1, 2]'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runLists2 [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceLists2 program.
	runner := self doRun: program.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: '[1, 8, 3, 4, 7, 8, 1, 8, 3, 4, 7, 8] [] [8] []'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runLists2Stepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourceLists2 program.
	runner := self newRunner.
	steps := runner
			limitTo: 2 seconds;
			runStepwise: program compilation.
	self assert: steps size equals: 17.
	self assert: runner isDone.
	self assert: runner wait equals: true.
	self
		assert: (steps at: 4) stack first
		equals: (ProcessingList
				newFrom: {1.
						2.
						3}).
	self
		assert: (steps at: 5) stack first
		equals: (ProcessingList
				newFrom: {1.
						2.
						3.
						4.
						5.
						6}).
	self
		assert: ((steps at: 4) variables at: 'a')
		equals: (ProcessingList
				newFrom: {1.
						2.
						3}).
	self
		assert: ((steps at: 6) variables at: 'a')
		equals: (ProcessingList
				newFrom: {1.
						2.
						3.
						4.
						5.
						6}).
	self
		assert: ((steps at: 8) variables at: 'a')
		equals: (ProcessingList
				newFrom: {1.
						2.
						3.
						4.
						5.
						8}).
	self assert: (steps at: 16) transcript equals: nil.
	self
		assert: (steps at: 17) transcript
		equals: '[1, 8, 3, 4, 7, 8, 1, 8, 3, 4, 7, 8] [] [8] []'.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runMinimal [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceMinimal program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runMouseEvents [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program runner detected |
	program := ProcessingSourceExamples new sourceMouseEvents program.
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
ProcessingRunnerExamples >> runMouseEvents2 [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program runner detected |
	program := ProcessingSourceExamples new sourceMouseEvents2 program.
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
ProcessingRunnerExamples >> runPrecedence [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourcePrecedence program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runPresentationDemo [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourcePresentationDemo program.
	runner := self doRun: program.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: '21'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runPresentationDemoStepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourcePresentationDemo program.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 28.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runPrint [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourcePrint program.
	runner := self newRunner.
	self assert: runner canvas isNil.
	runner
		run: program compilation;
		wait.
	self assert: runner canvas isNotNil.
	self assert: runner isDone.
	self assert: (program compilation instVarNamed: #var) equals: 11 / 4.
	self assert: runner wait equals: true.
	self
		assert: (runner canvas transcript textDo: [ :text | text asString ])
		equals: 'Hello, world!
2 + 3 / 4 = 2.75'.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runRandom [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceRandom program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runRecursion [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceRecursion program.
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
ProcessingRunnerExamples >> runShapes [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceShapes program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runShapesStepwise [
	<gtExample>
	| program runner steps |
	program := ProcessingSourceExamples new sourceShapes program.
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
	program := ProcessingSourceExamples new sourceSierpinski program.
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
	program := ProcessingSourceExamples new sourceSierpinski program.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 583.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runSimulation [
	"The animation is currently considered to be an endless loop"

	<gtExample>
	| program runner detected |
	program := ProcessingSourceExamples new sourceSimulation program.
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
ProcessingRunnerExamples >> runSpiral [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceSpiral program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runSpiralStepwise [
	<gtExample>
	<noTest>
	| program runner steps |
	program := ProcessingSourceExamples new sourceSpiral program.
	runner := self newRunner.
	steps := runner runStepwise: program compilation.
	self assert: steps size equals: 488.
	self assert: runner isDone.
	^ steps
]

{ #category : #example }
ProcessingRunnerExamples >> runSwitzerland [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceSwitzerland program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runTransforms [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceTransforms program.
	runner := self doRun: program.
	^ runner
]

{ #category : #example }
ProcessingRunnerExamples >> runTurtleGraphics [
	<gtExample>
	| program runner |
	program := ProcessingSourceExamples new sourceTurtleGraphics program.
	runner := self doRun: program.
	self assert: (program compilation instVarNamed: #t_x) equals: 0.
	self assert: (program compilation instVarNamed: #t_y) equals: 0.
	self assert: (program compilation instVarNamed: #t_angle) equals: 0.
	^ runner
]
