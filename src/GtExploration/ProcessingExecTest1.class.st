"
This is a discarded, very basic command forwarder meant to pass serialized commands from a Python interpreter to {{gtClass:ProcessingCanvas}} (see {{gtPage:Running Python Step-by-Step|db=5rgxfv9r684digmpw7ph7kbt4}}).
"
Class {
	#name : #ProcessingExecTest1,
	#superclass : #Object,
	#instVars : [
		'canvas'
	],
	#category : #'GtExploration-Experiments'
}

{ #category : #'as yet unclassified' }
ProcessingExecTest1 >> canvas: canv [
	canvas := canv
]

{ #category : #'as yet unclassified' }
ProcessingExecTest1 >> exec: cmd [
	| op args |
	op := cmd at: 1.
	args := cmd copyFrom: 2 to: cmd size.
	op = 'size' ifTrue: [ canvas size: (args at: 1) by: (args at: 2) ].
	op = 'rect'
		ifTrue: [ canvas
				rect: (args at: 3)
				by: (args at: 4)
				at: (args at: 1) @ (args at: 2) ].
	op = 'fill'
		ifTrue: [ canvas fill: (Color fromRgbTriplet: (args collect: [ :v | v / 255.0 ])) ]
]
