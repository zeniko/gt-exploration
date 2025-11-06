"
This is a discarded, very basic tree walking interpreter for Processing (see {{gtPage:Interpreting Processing|db=5rgxfv9r684digmpw7ph7kbt4}}).
"
Class {
	#name : #ProcessingInterpreter,
	#superclass : #Object,
	#category : #'GtExploration-Experiments'
}

{ #category : #'as yet unclassified' }
ProcessingInterpreter >> execFill: args onto: canvas [
	canvas fill: (Color fromRgbTriplet: (args collect: [ :v | v / 255.0 ]))
]

{ #category : #'as yet unclassified' }
ProcessingInterpreter >> execRect: args onto: canvas [
	canvas
		rect: (args at: 3)
		by: (args at: 4)
		at: (args at: 1) @ (args at: 2)
]

{ #category : #'as yet unclassified' }
ProcessingInterpreter >> execSize: args onto: canvas [
	canvas size: (args at: 1) by: (args at: 2)
]

{ #category : #accessing }
ProcessingInterpreter >> interpret: ast onto: canvas [
	"TODO: turn into tree walker?"

	"TODO: handle semantic errors"

	ast statements
		do: [ :node | 
			| name args |
			name := node expression receiver nameToken value.
			args := node expression arguments
					collect: [ :arg | arg numberToken value asNumber ].
			({'size' -> [ self execSize: args onto: canvas ].
				'rect' -> [ self execRect: args onto: canvas ].
				'fill' -> [ self execFill: args onto: canvas ]} asDictionary at: name) value ]
]
