Class {
	#name : #ProcessingCode01,
	#superclass : #ProcessingCodeBase,
	#instVars : [
		'a'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingCode01 >> drawOnto: canvas [
	canvas size: 200 by: 200.
	a := 0.
	[ (a<200) ] whileTrue: [ 
		canvas fill: (Color r: a / 255.0 g: 128 / 255.0 b: 0 / 255.0).
		canvas rect: 100 by: 100 at: a @ a.
		a := (a+50).
	].
	(a>=200) ifTrue: [ 
		canvas rect: 20 by: 20 at: 0 @ 0.
	].
]
