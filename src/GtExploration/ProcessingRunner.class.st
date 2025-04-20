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

{ #category : #runtime }
ProcessingRunner >> limitTo: duration [
	"Schedule a (hard) interruption, if the program still runs after the given `duration`."
	^ ([ duration wait ] asAsyncForkedFuture then: [
		done ifFalse: [
			promise cancel: AsyncFutureExecutionHardCancellation uniqueInstance.
		]
	]) await
]

{ #category : #runtime }
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

{ #category : #runtime }
ProcessingRunner >> wait [
	^ promise wait
]
