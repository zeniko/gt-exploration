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
	| steps block process session |
	steps := OrderedCollection new.
	
	canvas isNil ifTrue: [ canvas := ProcessingCanvas new. ].
	compilation instVarNamed: #_canvas put: canvas.
	
	block := [ compilation _run. done := true. ].
	process := block newProcess.
	[process step closure == block] whileFalse.
	process step.
	
	session := process newDebugSessionNamed: 'ProcessingRunner>>#runStepwise:' startedAt: process suspendedContext.
	session stepInto.
	
	[ session interruptedProcess isTerminated ] whileFalse: [
		(session interruptedContext methodClass inheritsFrom: ProcessingCodeBase) ifTrue: [
			"TODO: only add one step per Python line"
			steps add: (ProcessingRunStep create: session interruptedContext canvas: canvas).
			session stepInto.
		] ifFalse: [
			session stepThrough.
		].
	].
	
	^ steps
]

{ #category : #running }
ProcessingRunner >> wait [
	^ promise wait
]
