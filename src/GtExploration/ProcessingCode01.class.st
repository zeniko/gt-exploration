Class {
	#name : #ProcessingCode01,
	#superclass : #ProcessingCodeBase,
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingCode01 >> drawOnto: canvas [
	canvas size: 200 by: 200.
	canvas rect: 100 by: 100 at: 50 @ 50.
	canvas fill: (Color r: 255 / 255.0 g: 0 / 255.0 b: 0 / 255.0).
	canvas rect: 100 by: (100/3) at: 50 @ (50+(100/3)).
]
