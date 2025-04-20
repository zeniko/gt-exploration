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
	width := 200. height := 200. canvas size: width by: height.
	canvas rect: 100 by: 100 at: 50 @ 50.
	canvas fill: (Color r: 255 / 255.0 g: 0 / 255.0 b: 0 / 255.0).
	canvas rect: 100 by: (100 / 3) at: 50 @ (50 + (100 / 3)).'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationEndlessLoop [
	<gtExample>
	^ 'drawOnto: canvas
	[ (1 = 1) ] whileTrue: [
		loop.
	].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationExample02 [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.
	a := 0.
	[ (a < 200) ] whileTrue: [
		canvas fill: (Color r: a / 255.0 g: 128 / 255.0 b: 0 / 255.0).
		canvas rect: 100 by: 100 at: a @ a.
		a := (a + 50).
	].
	(a >= 200) ifTrue: [
		canvas ellipse: 20 by: 20 at: 10 @ 10.
	].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationExample03 [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.
	x := 200.
	[ (x > 0) ] whileTrue: [
		canvas fill: (Color r: (200 - x) / 255.0 g: 128 / 255.0 b: x / 255.0).
		canvas ellipse: x by: x at: 100 @ 100.
		x := (x - 20).
		(50 / 1000.0) seconds wait.
	].'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationExample04 [
	<gtExample>
	^ 'drawOnto: canvas
	width := 30. height := 20. canvas size: width by: height.
	x := 0.
	(self setX: canvas).
	canvas text: x at: 0 @ 20.
	

setX: canvas
	x := (((SharedRandom globalGenerator next * 2) ** 2) * 270 degreesToRadians sin)..'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationExample05 [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 100. canvas size: width by: height.
	__a := width.
	__b := height.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationFibonacci [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.
	canvas textSize: 30.
	canvas fill: (Color r: 0 / 255.0 g: 0 / 255.0 b: 0 / 255.0).
	canvas text: ''Fibonacci'' at: 20 @ 75.
	canvas textSize: 50.
	canvas fill: (Color r: 255 / 255.0 g: 255 / 255.0 b: 255 / 255.0).
	canvas text: (self fibonacci: canvas n: 10) at: 20 @ 125.
	

fibonacci: canvas n: n
	| a |
	(n > 2) ifTrue: [
		a := (self fibonacci: canvas n: (n - 1)).
		^ (a + (self fibonacci: canvas n: (n - 2)))
	] ifFalse: [
		^ 1
	]..'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationMinimal [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationRecursion [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.
	(self recursion: canvas n: 200).
	

recursion: canvas n: n
	canvas ellipse: n by: n at: 100 @ 100.
	(n > 20) ifTrue: [
		(self recursion: canvas n: (n - 10)).
	]..'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationShapes [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.
	canvas rect: 60 by: 40 at: 20 @ 30.
	canvas ellipse: 60 by: 40 at: 150 @ 50.
	canvas line: 25 @ 150 to: 75 @ 125.
	canvas triangle: { 125 @ 125. 150 @ 175. 175 @ 150. }.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpilationSwitzerland [
	<gtExample>
	^ 'drawOnto: canvas
	width := 200. height := 200. canvas size: width by: height.
	canvas background: (Color r: 255 / 255.0 g: 0 / 255.0 b: 0 / 255.0).
	canvas rect: 50 by: 150 at: 75 @ 25.
	canvas rect: 150 by: 50 at: 25 @ 75.'
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileAlpinerWanderweg [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseAlpinerWanderweg.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationAlpinerWanderweg.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
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
	self assert: transpiler userDefs size equals: 0.
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
	self assert: transpiler userDefs size equals: 0.
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
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationExample03.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileExample04 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample04.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample04.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'x'.
	self assert: transpiler userDefs size equals: 1.
	self assert: ('

' join: ((transpiler compile: ast) class methods collect: [ :method | method sourceCode ]) sorted) equals: self transpilationExample04.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileExample05 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample05.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample05.
	self assert: transpiler variables size equals: 2.
	self assert: (' ' join: transpiler variables) equals: '__a __b'.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationExample05.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileFibonacci [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseFibonacci.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationFibonacci.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 1.
	self assert: ('

' join: ((transpiler compile: ast) class methods collect: [ :method | method sourceCode ]) sorted) equals: self transpilationFibonacci.
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
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationMinimal.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileRecursion [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseRecursion.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationRecursion.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 1.
	self assert: ('

' join: ((transpiler compile: ast) class methods collect: [ :method | method sourceCode ]) sorted) equals: self transpilationRecursion.
	^ "transpiler compile:" ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileShapes [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseShapes.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationShapes.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationShapes.
	^ transpiler compile: ast
]

{ #category : #'as yet unclassified' }
ProcessingTranspilerExamples >> transpileSwitzerland [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseSwitzerland.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSwitzerland.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #drawOnto:) sourceCode equals: self transpilationSwitzerland.
	^ transpiler compile: ast
]
