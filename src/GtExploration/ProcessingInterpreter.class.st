Class {
	#name : #ProcessingInterpreter,
	#superclass : #Object,
	#category : #GtExploration
}

{ #category : #accessing }
ProcessingInterpreter >> interpret: ast onto: canvas [
	"TODO: turn into tree walker?"
	"TODO: handle semantic errors"
	ast statements do: [ :node |
		| name args |
		name := node expression receiver nameToken value.
		args := node expression arguments collect: [ :arg | arg numberToken value asNumber ].
		({
			'size' -> [ canvas
				size: (args at: 1)
				by: (args at: 2)
			] .
			'rect' -> [ canvas
				rect: (args at: 3)
				by: (args at: 4)
				at: (args at: 1) @ (args at: 2)
			] .
			'fill' -> [ canvas
				fill: (Color fromRgbTriplet: (args collect: [ :v | v / 255.0 ]))
			]
		} asDictionary at: name) value.
	]
]
