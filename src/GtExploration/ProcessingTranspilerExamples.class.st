Class {
	#name : #ProcessingTranspilerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTranspilerExamples >> compare: anInstance with: aTranspilation [
	| methods |
	methods := OrderedCollection newFromArray: (anInstance class methods collect: [ :method | method sourceCode ]).
	self assert: methods sorted equals: (aTranspilation splitOn: '

') sorted.
]

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
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas rect: 100 by: 100 at: 50 @ 50.
	gtCanvas fillR: 255 G: 0 B: 0.
	gtCanvas rect: 100 by: (100 / 3) at: 50 @ (50 + (100 / 3)).'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationAnimation [
	^ 'gtRun
	var := 0.
	self setup.
	[ gtCanvas frameRate > 0 ] whileTrue: [
		self draw.
		(1 / gtCanvas frameRate) seconds wait.
	].

setup
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas frameRate: 2.

draw
	gtCanvas backgroundGray: 192.
	gtCanvas rect: 50 by: 50 at: var @ var.
	var := (var + 20).
	(var > (height - 50)) ifTrue: [
		var := 0.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationEndlessLoop [
	^ 'gtRun
	[ true ] whileTrue: [
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample02 [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	a := 0.
	[ (a < 200) ] whileTrue: [
		gtCanvas fillR: a G: 128 B: 0.
		gtCanvas rect: 100 by: 100 at: a @ a.
		a := (a + 50).
	].
	(a >= 200) ifTrue: [
		gtCanvas ellipse: 20 by: 20 at: 10 @ 10.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample03 [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	x := 200.
	[ (x > 0) ] whileTrue: [
		gtCanvas fillR: (200 - x) G: 128 B: x.
		gtCanvas ellipse: x by: x at: 100 @ 100.
		x := (x - 20).
		(50 / 1000.0) seconds wait.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample04 [
	^ 'gtRun
	width := 30. height := 20. gtCanvas size: width by: height.
	x := 0.
	(self setX).
	gtCanvas text: x at: 0 @ 20.

setX
	x := ((((SharedRandom globalGenerator next * 2) ** 2) * 270 degreesToRadians sin) \\ 3).

setY
	PyEllipsis.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample05 [
	^ 'gtRun
	width := 200. height := 100. gtCanvas size: width by: height.
	gt_A := width.
	gt_B := height.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample06 [
	^ 'gtRun
	cond := ((true and: [ false ]) or: [ (1 = 2 and: [ 2 = 3 ]) not ]).
	var := (cond ifTrue: [ 5 ] ifFalse: [ 3 ]).
	1 to: (var - 1) do: [ :x |
		gtCanvas print: x.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationFibonacci [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas textSize: 30.
	gtCanvas fillR: 0 G: 0 B: 0.
	gtCanvas text: ''Fibonacci'' at: 20 @ 75.
	gtCanvas textSize: 50.
	gtCanvas fillR: 255 G: 255 B: 255.
	gtCanvas text: (self fibonacci: 10) at: 20 @ 125.

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
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationPrint [
	^ 'gtRun
	gtCanvas print: ''Hello, world!''.
	var := (2 + 3).
	gtCanvas print: { ''2 + 3 =''. var.  }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationRecursion [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	(self recursion: 200).

recursion: n
	gtCanvas ellipse: n by: n at: 100 @ 100.
	(n > 20) ifTrue: [
		(self recursion: (n - 10)).
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationShapes [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas strokeR: 255 G: 255 B: 255.
	gtCanvas rect: 60 by: 40 at: 20 @ 30.
	gtCanvas ellipse: 60 by: 40 at: 150 @ 50.
	gtCanvas line: 25 @ 150 to: 75 @ 125.
	gtCanvas triangle: { 125 @ 125. 150 @ 175. 175 @ 150. }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationSierpinski [
	^ 'gtRun
	px := 300.
	width := px. height := ((px * 60 degreesToRadians sin) + 2). gtCanvas size: width by: height.
	gtCanvas backgroundR: 255 G: 255 B: 255.
	gtCanvas fillR: 0 G: 0 B: 0.
	gtCanvas strokeR: 0 G: 0 B: 0.
	gtCanvas strokeWeight: 1.
	(self sierpinski: 4 x: 2 y: 2 side: (width - 4)).

sierpinski: n x: x y: y side: side
	| th side |
	th := (side * 60 degreesToRadians sin).
	(n = 1) ifTrue: [
		gtCanvas triangle: { x @ (y + th). (x + side) @ (y + th). (x + (side / 2)) @ y. }.
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
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas backgroundR: 255 G: 0 B: 0.
	gtCanvas rect: 50 by: 150 at: 75 @ 25.
	gtCanvas rect: 150 by: 50 at: 25 @ 75.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationTurtleGraphics [
	^ 'gtRun
	width := 400. height := 400. gtCanvas size: width by: height.
	(self draw_n_eck: 5).
	(self move: 0 y: (height / 2) angle: 0).
	(self kochpart: width limit: (width / (3 ** 4)) rounded).
	t_x := 0.
	t_y := 0.
	t_angle := 0.

draw_n_eck: n
	| w i |
	w := (width / (n * 3)).
	(self move: ((width - w) / 2) y: 10 angle: 0).
	i := 0.
	[ (i < n) ] whileTrue: [
		(self fwd: w).
		(self turn: (360 / n)).
		i := (i + 1).
	].

kochpart: siz limit: limit
	(siz < limit) ifTrue: [
		(self fwd: siz).
		^ nil
	].
	(self kochpart: (siz / 3) limit: limit).
	(self turn: 60 negated).
	(self kochpart: (siz / 3) limit: limit).
	(self turn: 120).
	(self kochpart: (siz / 3) limit: limit).
	(self turn: 60 negated).
	(self kochpart: (siz / 3) limit: limit).

move: x y: y angle: angle
	t_x := x.
	t_y := y.
	t_angle := angle.

fwd: d
	| oldX oldY |
	oldX := t_x.
	oldY := t_y.
	t_x := (t_x + (d * t_angle degreesToRadians cos)).
	t_y := (t_y + (d * t_angle degreesToRadians sin)).
	gtCanvas line: oldX @ oldY to: t_x @ t_y.

turn: angle
	t_angle := (t_angle + angle).'
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
	self compare: (transpiler compile: ast) with: self transpilationAlpinerWanderweg.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileAnimation [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseAnimation.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationAnimation.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables) equals: 'var'.
	self assert: transpiler userDefs size equals: 2.
	self compare: (transpiler compile: ast) with: self transpilationAnimation.
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
	self compare: (transpiler compile: ast) with: self transpilationEndlessLoop.
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
	self compare: (transpiler compile: ast) with: self transpilationExample02.
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
	self compare: (transpiler compile: ast) with: self transpilationExample03.
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
	self assert: transpiler userDefs size equals: 2.
	self compare: (transpiler compile: ast) with: self transpilationExample04.
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
	self assert: (' ' join: transpiler variables) equals: 'gt_A gt_B'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample05.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample06 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseExample06.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample06.
	self assert: transpiler variables size equals: 2.
	self assert: (' ' join: transpiler variables) equals: 'var cond'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample06.
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
	self compare: (transpiler compile: ast) with: self transpilationFibonacci.
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
	self compare: (transpiler compile: ast) with: self transpilationMinimal.
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
	self compare: (transpiler compile: ast) with: self transpilationPrint.
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
	self compare: (transpiler compile: ast) with: self transpilationRecursion.
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
	self compare: (transpiler compile: ast) with: self transpilationShapes.
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
	self compare: (transpiler compile: ast) with:self transpilationSierpinski.
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
	self compare: (transpiler compile: ast) with: self transpilationSwitzerland.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileTurtleGraphics [
	<gtExample>
	| ast transpiler |
	ast := ProcessingParserExamples new parseTurtleGraphics.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationTurtleGraphics.
	self assert: transpiler variables size equals: 3.
	self assert: transpiler userDefs size equals: 5.
	self compare: (transpiler compile: ast) with: self transpilationTurtleGraphics.
	^ transpiler compile: ast
]
