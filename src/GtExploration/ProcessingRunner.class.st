Class {
	#name : #ProcessingRunner,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'done',
		'promise'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingRunner >> canvas [
	^ canvas
]

{ #category : #initialization }
ProcessingRunner >> canvas: aCanvas [
	canvas := aCanvas
]

{ #category : #running }
ProcessingRunner >> debug: compilation [
	| worker block process session debugger |
	worker := AsyncFutureThreadPoolWorker new.
	worker startup wait.

	canvas isNil ifTrue: [ canvas := ProcessingCanvas new ].
	compilation gtCanvas: canvas.

	done := false.
	block := [ compilation gtRun.
		done := true ].
	process := block newProcess.
	[ process step closure == block ] whileFalse.
	process step.

	session := process
			newDebugSessionNamed: 'ProcessingRunner>>#debug:'
			startedAt: process suspendedContext.	"TODO: the debugger doesn't chatch endless steps."	"The first step could be into an endless loop!"
	self limitTo: 0.5 seconds.
	promise := AsyncFuturePromise new
			future: [ session stepInto.
				done := true ] asAsyncFuture.
	worker schedule: promise.
	promise wait.

	done
		ifFalse: [ ProcessingRunawayProgramException new signal: 'Endless loop detected.' ].
	done := false.

	debugger := GtMoldableDebugger on: session.
	debugger openInPager.
	^ canvas
]

{ #category : #accessing }
ProcessingRunner >> isDone [
	^ done
]

{ #category : #running }
ProcessingRunner >> limitTo: duration [
	"Schedule a (hard) interruption, if the program still runs after the given `duration`."

	^ ([ duration wait ] asAsyncForkedFuture
		then: [ done
				ifFalse: [ promise cancel: AsyncFutureExecutionHardCancellation uniqueInstance ] ])
		await
]

{ #category : #running }
ProcessingRunner >> run: compilation [
	| worker |
	worker := AsyncFutureThreadPoolWorker new.
	worker startup wait.

	canvas isNil ifTrue: [ canvas := ProcessingCanvas new ].
	compilation gtCanvas: canvas.

	done := false.
	promise := AsyncFuturePromise new
			future: [ [ compilation gtRun.
				done := true ]
					on: Exception
					do: [ :ex | 
						(ex isKindOf: AsyncFutureCancelled)
							ifFalse: [ canvas canvasElement
									addChild: ((GtSystemUtility freeze: ex) asDebuggableElement background: Color white) ].
						ex ] ] asAsyncFuture.
	worker schedule: promise.
	^ promise
]

{ #category : #running }
ProcessingRunner >> runStepwise: compilation [
	| worker steps block process session |
	worker := AsyncFutureThreadPoolWorker new.
	worker startup wait.

	canvas isNil ifTrue: [ canvas := ProcessingCanvas new ].
	compilation gtCanvas: canvas.	"TODO: this is a flattened tree - unflatten it?"
	steps := OrderedCollection new.

	done := false.
	block := [ compilation gtRun.
		done := true ].
	process := block newProcess.
	[ process step closure == block ] whileFalse.
	process step.

	session := process
			newDebugSessionNamed: 'ProcessingRunner>>#runStepwise:'
			startedAt: process suspendedContext.

	promise := AsyncFuturePromise new
			future: [ | lastSlice lastStep |
				session stepInto.
				[ session interruptedProcess isTerminated ]
					whileFalse: [ (session interruptedContext methodClass inheritsFrom: ProcessingCodeBase)
							ifTrue: [ | slice |
								slice := compilation
										gtSliceFor: session interruptedContext method
										within: (session pcRangeForContext: session interruptedContext).
								slice isNotNil & (slice = lastSlice) not
									ifTrue: [ lastStep
											ifNotNil: [ lastStep updateCanvas: canvas.
												lastStep := nil ].
										lastStep := ProcessingRunStep
												create: session interruptedContext
												canvas: canvas
												slice: slice.
										steps add: lastStep.
										lastSlice := slice ].
								session stepInto ]
							ifFalse: [ session stepThrough ] ].
				lastStep
					ifNotNil: [ lastStep updateCanvas: canvas.
						lastStep := nil ].
				done := true ] asAsyncFuture.
	worker schedule: promise.
	promise wait.
	^ steps
]

{ #category : #running }
ProcessingRunner >> wait [
	^ promise wait
]
