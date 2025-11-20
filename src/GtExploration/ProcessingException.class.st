"
This is the base for all exceptions thrown by {{gtClass:ProcessingTranspiler}} during compilation and {{gtClass:ProcessingRunner}} during runtime.
"
Class {
	#name : 'ProcessingException',
	#superclass : 'Error',
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'accessing' }
ProcessingException >> tag [
	"Exception>>tag unexpectedly returns messageText if tag is nil"

	^ tag
]
