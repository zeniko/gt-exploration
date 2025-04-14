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

{ #category : #'as yet unclassified' }
ProcessingRunner >> canvas [
	^ canvas
]

{ #category : #'as yet unclassified' }
ProcessingRunner >> canvas: aCanvas [
	canvas := aCanvas
]

{ #category : #'as yet unclassified' }
ProcessingRunner >> isDone [
	^ done
]

{ #category : #'as yet unclassified' }
ProcessingRunner >> limitTo: duration [
	"Schedule a (hard) interruption, if the program still runs after the given `duration`."
	^ ([ duration wait ] asAsyncForkedFuture then: [
		done ifFalse: [
			promise cancel: AsyncFutureExecutionHardCancellation uniqueInstance.
		]
	]) await
]

{ #category : #'as yet unclassified' }
ProcessingRunner >> run: program [
	| worker |
	worker := AsyncFutureThreadPoolWorker new.
	worker startup wait.
	
	canvas isNil ifTrue: [ canvas := ProcessingCanvas new. ].
	
	done := false.
	"TODO: handle errors"
	promise := AsyncFuturePromise new future: [
		program compilation drawOnto: canvas.
		done := true.
	] asAsyncFuture.
	worker schedule: promise.
	
	^ promise
]

{ #category : #'as yet unclassified' }
ProcessingRunner >> wait [
	^ promise wait
]
