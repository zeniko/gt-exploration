Class {
	#name : #ProcessingInterpreter,
	#superclass : #Object,
	#category : #GtExploration
}

{ #category : #accessing }
ProcessingInterpreter >> interpret: ast onto: canvas [ 
	ast statements do: [ :node |
		| name args |
		name := node expression receiver nameToken value.
		args := node expression arguments.
		name = 'size' ifTrue: [
			canvas
				size: (args at: 1) numberToken value asNumber
				by: (args at: 2) numberToken value asNumber
		].
		name = 'rect' ifTrue: [
			canvas
				rect: (args at: 3) numberToken value asNumber
				by: (args at: 4) numberToken value asNumber
				at: (args at: 1) numberToken value asNumber @ (args at: 2) numberToken value asNumber
		]
	]
]
