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

{ #category : #accessing }
ProcessingRunner >> isDone [
	^ done
]

{ #category : #running }
ProcessingRunner >> limitTo: duration [
	"Schedule a (hard) interruption, if the program still runs after the given `duration`."
	^ ([ duration wait ] asAsyncForkedFuture then: [
		done ifFalse: [
			promise cancel: AsyncFutureExecutionHardCancellation uniqueInstance.
		]
	]) await
]

{ #category : #running }
ProcessingRunner >> run: compilation [
	| worker |
	worker := AsyncFutureThreadPoolWorker new.
	worker startup wait.
	
	canvas isNil ifTrue: [ canvas := ProcessingCanvas new. ].
	compilation instVarNamed: #_canvas put: canvas.
	
	done := false.
	"TODO: handle errors"
	promise := AsyncFuturePromise new future: [
		compilation _run.
		done := true.
	] asAsyncFuture.
	worker schedule: promise.
	
	^ promise
]

{ #category : #running }
ProcessingRunner >> runStepwise: compilation [
	| steps block process session lastSlice lastStep |
	"TODO: this is a flattened tree - unflatten it?"
	steps := OrderedCollection new.
	
	canvas isNil ifTrue: [ canvas := ProcessingCanvas new. ].
	compilation instVarNamed: #_canvas put: canvas.
	
	block := [ compilation _run. done := true. ].
	process := block newProcess.
	[process step closure == block] whileFalse.
	process step.
	
	session := process newDebugSessionNamed: 'ProcessingRunner>>#runStepwise:' startedAt: process suspendedContext.
	session stepInto.
	
	lastSlice := nil.
	lastStep := nil.
	[ session interruptedProcess isTerminated ] whileFalse: [
		(session interruptedContext methodClass inheritsFrom: ProcessingCodeBase) ifTrue: [
			| slice |
			slice := compilation _gtSliceForItem: session interruptedContext method within: (session pcRangeForContext: session interruptedContext).
			slice isNotNil & (slice = lastSlice) not ifTrue: [
				lastStep ifNotNil: [
					lastStep updateCanvas: canvas.
					lastStep := nil.
				].
				lastStep := ProcessingRunStep create: session interruptedContext canvas: canvas slice: slice.
				steps add: lastStep.
				lastSlice := slice.
			].
			session stepInto.
		] ifFalse: [
			session stepThrough.
		].
	].
	lastStep ifNotNil: [
		lastStep updateCanvas: canvas.
		lastStep := nil.
	].
	
	^ steps
]

{ #category : #running }
ProcessingRunner >> wait [
	^ promise wait
]
