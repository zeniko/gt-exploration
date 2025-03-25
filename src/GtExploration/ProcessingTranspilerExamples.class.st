Class {
	#name : #ProcessingTranspilerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> newTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspiler new.
	self assert: transpiler variables equals: nil.
	^ transpiler
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileAlpinerWanderweg [
	<gtExample>
	| ast transpiler|
	ast := ProcessingParserExamples new parseAlpinerWanderweg.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: 'drawOnto: canvas
	canvas size: 200 by: 200.
	canvas rect: 100 by: 100 at: 50 @ 50.
	canvas fill: (Color r: 255 / 255.0 g: 0 / 255.0 b: 0 / 255.0).
	canvas rect: 100 by: (100/3) at: 50 @ (50+(100/3)).'.
	self assert: transpiler variables size equals: 0.
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileExample02 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample02.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: 'drawOnto: canvas
	canvas size: 200 by: 200.
	a := 0.
	[ (a<200) ] whileTrue: [ 
		canvas fill: (Color r: a / 255.0 g: 128 / 255.0 b: 0 / 255.0).
		canvas rect: 100 by: 100 at: a @ a.
		a := (a+50).
	].
	(a>=200) ifTrue: [ 
		canvas rect: 20 by: 20 at: 0 @ 0.
	].'.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'a'.
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileSize [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseSize.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: 'drawOnto: canvas
	canvas size: 200 by: 200.'.
	self assert: transpiler variables size equals: 0.
]
