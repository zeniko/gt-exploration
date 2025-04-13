Class {
	#name : #ProcessingRunner,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingRunner >> run: program with: canvas for: duration [
	| worker promise done |
	worker := AsyncFutureThreadPoolWorker new.
	worker startup wait.
	
	done := false.
	"TODO: handle errors"
	promise := AsyncFuturePromise new future: [
		"Delay just for demonstration purposes (TODO: remove)"
		0.5 second wait.
		program compilation drawOnto: canvas.
		done := true.
	] asAsyncFuture.
	worker schedule: promise.
	
	"Schedule a (hard) interruption, if the program still runs after the given `duration`."
	([ duration wait ] asAsyncForkedFuture then: [
		done ifFalse: [
			promise cancel: AsyncFutureExecutionHardCancellation uniqueInstance.
		]
	]) await.
	
	^ promise
]
