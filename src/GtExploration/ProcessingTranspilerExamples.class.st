Class {
	#name : #ProcessingTranspilerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTranspilerExamples >> newTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspiler new.
	self assert: transpiler variables equals: nil.
	^ transpiler
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationAlpinerWanderweg [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	_canvas rect: 100 by: 100 at: 50 @ 50.
	_canvas fill: (_canvas colorWithR: 255 g: 0 b: 0).
	_canvas rect: 100 by: (100 / 3) at: 50 @ (50 + (100 / 3)).'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationEndlessLoop [
	^ '_run
	[ (1 = 1) ] whileTrue: [
		(1 + 1).
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample02 [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	a := 0.
	[ (a < 200) ] whileTrue: [
		_canvas fill: (_canvas colorWithR: a g: 128 b: 0).
		_canvas rect: 100 by: 100 at: a @ a.
		a := (a + 50).
	].
	(a >= 200) ifTrue: [
		_canvas ellipse: 20 by: 20 at: 10 @ 10.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample03 [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	x := 200.
	[ (x > 0) ] whileTrue: [
		_canvas fill: (_canvas colorWithR: (200 - x) g: 128 b: x).
		_canvas ellipse: x by: x at: 100 @ 100.
		x := (x - 20).
		(50 / 1000.0) seconds wait.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample04 [
	^ '_run
	width := 30. height := 20. _canvas size: width by: height.
	x := 0.
	(self setX).
	_canvas text: x at: 0 @ 20.

setX
	x := (((SharedRandom globalGenerator next * 2) ** 2) * 270 degreesToRadians sin).'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample05 [
	^ '_run
	width := 200. height := 100. _canvas size: width by: height.
	__a := width.
	__b := height.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationFibonacci [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	_canvas textSize: 30.
	_canvas fill: (_canvas colorWithR: 0 g: 0 b: 0).
	_canvas text: ''Fibonacci'' at: 20 @ 75.
	_canvas textSize: 50.
	_canvas fill: (_canvas colorWithR: 255 g: 255 b: 255).
	_canvas text: (self fibonacci: 10) at: 20 @ 125.

fibonacci: n
	| a |
	(n > 2) ifTrue: [
		a := (self fibonacci: (n - 1)).
		^ (a + (self fibonacci: (n - 2)))
	] ifFalse: [
		^ 1
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationMinimal [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationPrint [
	^ '_run
	_canvas print: ''Hello, world!''.
	var := (2 + 3).
	_canvas print: { ''2 + 3 =''. var.  }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationRecursion [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	(self recursion: 200).

recursion: n
	_canvas ellipse: n by: n at: 100 @ 100.
	(n > 20) ifTrue: [
		(self recursion: (n - 10)).
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationShapes [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	_canvas stroke: (_canvas colorWithR: 255 g: 255 b: 255).
	_canvas rect: 60 by: 40 at: 20 @ 30.
	_canvas ellipse: 60 by: 40 at: 150 @ 50.
	_canvas line: 25 @ 150 to: 75 @ 125.
	_canvas triangle: { 125 @ 125. 150 @ 175. 175 @ 150. }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationSierpinski [
	^ '_run
	px := 300.
	width := px. height := ((px * 60 degreesToRadians sin) + 2). _canvas size: width by: height.
	_canvas background: (_canvas colorWithR: 255 g: 255 b: 255).
	_canvas fill: (_canvas colorWithR: 0 g: 0 b: 0).
	_canvas stroke: (_canvas colorWithR: 0 g: 0 b: 0).
	_canvas strokeWeight: 1.
	(self sierpinski: 4 x: 2 y: 2 side: (width - 4)).

sierpinski: n x: x y: y side: side
	| th side |
	th := (side * 60 degreesToRadians sin).
	(n = 1) ifTrue: [
		_canvas triangle: { x @ (y + th). (x + side) @ (y + th). (x + (side / 2)) @ y. }.
	] ifFalse: [
		(n > 1) ifTrue: [
			side := (side / 2).
			th := (th / 2).
			(self sierpinski: (n - 1) x: (x + (side / 2)) y: y side: side).
			(self sierpinski: (n - 1) x: x y: (y + th) side: side).
			(self sierpinski: (n - 1) x: (x + side) y: (y + th) side: side).
		].
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationSwitzerland [
	^ '_run
	width := 200. height := 200. _canvas size: width by: height.
	_canvas background: (_canvas colorWithR: 255 g: 0 b: 0).
	_canvas rect: 50 by: 150 at: 75 @ 25.
	_canvas rect: 150 by: 50 at: 25 @ 75.'
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileAlpinerWanderweg [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseAlpinerWanderweg.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationAlpinerWanderweg.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationAlpinerWanderweg.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileEndlessLoop [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseEndlessLoop.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationEndlessLoop.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationEndlessLoop.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample02 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample02.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample02.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'a'.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationExample02.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample03 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample03.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample03.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'x'.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationExample03.
	^ transpiler compile: ast
]

{ #category : #example }
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

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample05 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample05.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample05.
	self assert: transpiler variables size equals: 2.
	self assert: (' ' join: transpiler variables) equals: '__a __b'.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationExample05.
	^ transpiler compile: ast
]

{ #category : #example }
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

{ #category : #example }
ProcessingTranspilerExamples >> transpileMinimal [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseMinimal.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationMinimal.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationMinimal.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpilePrint [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parsePrint.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationPrint.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'var'.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationPrint.
	^ transpiler compile: ast
]

{ #category : #example }
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
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileShapes [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseShapes.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationShapes.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationShapes.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileSierpinski [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseSierpinski.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSierpinski.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'px'.
	self assert: transpiler userDefs size equals: 1.
	self assert: ('

' join: ((transpiler compile: ast) class methods collect: [ :method | method sourceCode ]) sorted) equals: self transpilationSierpinski.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileSwitzerland [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseSwitzerland.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSwitzerland.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self assert: ((transpiler compile: ast) class >> #_run) sourceCode equals: self transpilationSwitzerland.
	^ transpiler compile: ast
]
