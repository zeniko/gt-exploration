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
ProcessingTranspilerExamples >> transpilationAlpinerWanderweg [
	<gtExample>
	^ 'drawOnto: canvas
	canvas size: 200 by: 200.
	canvas rect: 100 by: 100 at: 50 @ 50.
	canvas fill: (Color r: 255 / 255.0 g: 0 / 255.0 b: 0 / 255.0).
	canvas rect: 100 by: (100/3) at: 50 @ (50+(100/3)).'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationEndlessLoop [
	<gtExample>
	^ 'drawOnto: canvas
	[ (1==1) ] whileTrue: [ 
		loop
	].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationExample02 [
	<gtExample>
	^ 'drawOnto: canvas
	canvas size: 200 by: 200.
	a := 0.
	[ (a<200) ] whileTrue: [ 
		canvas fill: (Color r: a / 255.0 g: 128 / 255.0 b: 0 / 255.0).
		canvas rect: 100 by: 100 at: a @ a.
		a := (a+50).
	].
	(a>=200) ifTrue: [ 
		canvas ellipse: 20 by: 20 at: 10 @ 10.
	].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationExample03 [
	<gtExample>
	^ 'drawOnto: canvas
	canvas size: 200 by: 200.
	x := 200.
	[ (x>0) ] whileTrue: [ 
		canvas fill: (Color r: (200-x) / 255.0 g: 128 / 255.0 b: x / 255.0).
		canvas ellipse: x by: x at: 100 @ 100.
		x := (x-20).
	].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationMinimal [
	<gtExample>
	^ 'drawOnto: canvas
	canvas size: 200 by: 200.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileAlpinerWanderweg [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseAlpinerWanderweg.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationAlpinerWanderweg.
	self assert: transpiler variables size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationAlpinerWanderweg.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileEndlessLoop [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseEndlessLoop.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationEndlessLoop.
	self assert: transpiler variables size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationEndlessLoop.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileExample02 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample02.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample02.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'a'.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationExample02.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileExample03 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample03.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample03.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'x'.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationExample03.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileMinimal [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseMinimal.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationMinimal.
	self assert: transpiler variables size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationMinimal.
	^ transpiler compile: ast
]
