Class {
	#name : #ProcessingTranspilerExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTranspilerExamples >> allViews [
	<gtExample>
	| compilation views |
	compilation := self transpileMinimal.
	views := ProcessingCodeBase methodDict keys
			select: [ :key | (key beginsWith: 'gt') & (key endsWith: 'For:') ].
	self assert: views size equals: 7.
	views
		do: [ :key | 
			| view element |
			view := compilation perform: key with: GtPhlowView empty.
			self assert: view isNotNil.
			element := view asElement.
			self assert: element containerName = 'phlow--exception' equals: false ].
	self assert: (' ' join: views sorted) equals: 'gtAbstractionsFor: gtBytecodeFor: gtHexDumpFor: gtIntermediaryRepresentationFor: gtOutputFor: gtSlicesFor: gtTranspilationFor:'.
	^ compilation
]

{ #category : #example }
ProcessingTranspilerExamples >> compare: anInstance with: aTranspilation [
	| methods |
	methods := OrderedCollection
			newFromArray: (anInstance class methods collect: #sourceCode).
	self
		assert: methods sorted
		equals: (aTranspilation
				splitOn: '

') sorted
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
	gtCanvas rect: 50 y: 50 width: 100 height: 100.
	gtCanvas fillR: 255 G: 0 B: 0.
	gtCanvas rect: 50 y: (50 + (100 / 3)) width: 100 height: (100 / 3).'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationAnimation [
	^ 'gtRun
	var := 0.
	self setup.
	[ gtCanvas frameRate > 0 ] whileTrue: [
		mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.
		self draw.
		gtCanvas endFrame.
	].

setup
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas frameRate: 2.

draw
	gtCanvas backgroundGray: 192.
	gtCanvas rect: var y: var width: 50 height: 50.
	var := (var + 20).
	(var > (height - 50)) ifTrue: [
		var := 0.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationAnimation2 [
	^ 'gtRun
	x := 200.
	y := 100.
	dx := 2.
	dy := 0.
	self setup.
	[ gtCanvas frameRate > 0 ] whileTrue: [
		mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.
		self draw.
		gtCanvas endFrame.
	].

setup
	width := 400. height := 300. gtCanvas size: width by: height.
	gtCanvas noStroke.

draw
	gtCanvas backgroundGray: 192.
	gtCanvas ellipse: x y: y dx: 50 dy: 50.
	x := (x + dx).
	y := (y + dy).
	(x < 25) ifTrue: [
		dx := (0 + 2).
	] ifFalse: [
		(x > (width - 25)) ifTrue: [
			dx := 2 negated.
		].
	].
	dy := (dy + 1).
	(y > (height - 25)) ifTrue: [
		dy := (0.9 negated * dy).
		y := (height - 25).
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationColors [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	c := (gtCanvas colorWithR: 224 G: 224 B: 224).
	[ (c = (gtCanvas colorWithGray: 224)) ] assert.
	gtCanvas fillGray: c.
	gtCanvas strokeGray: (gtCanvas colorWithGray: 192).
	gtCanvas rect: 50 y: 50 width: 100 height: 100.'
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
		gtCanvas rect: a y: a width: 100 height: 100.
		a := (a + 50).
	].
	(a >= 200) ifTrue: [
		gtCanvas ellipse: 10 y: 10 dx: 20 dy: 20.
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample03 [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	x := 200.
	[ (x > 0) ] whileTrue: [
		gtCanvas fillR: (200 - x) G: 128 B: x.
		gtCanvas ellipse: 100 y: 100 dx: x dy: x.
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
	gtCanvas text: x x: 0 y: 20.

setX
	x := ((((gtCanvas random: 2) ** 2) * 270 degreesToRadians sin) \\ 3).

setY
	ProcessingEllipsis.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationExample05 [
	^ 'gtRun
	width := 200. height := 100. gtCanvas size: width by: height.
	gt_A := width.
	gt_B := height.
	gtCanvas print: { nil. true. false. ''String''. (ProcessingList newFrom: { ''Nested''. }). }.'
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
ProcessingTranspilerExamples >> transpilationExample07 [
	^ 'gtRun
	a := (gtCanvas random: 3 to: 7).
	a := (a + 2).
	[ (5 <= a and: [ a <= 9 ]) ] assert.
	a := (a - 5).
	[ (a < 4) ] assertWithDescription: ''Message''.
	[ false ] assertWithDescription: ''Done!''.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationFibonacci [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas textSize: 30.
	gtCanvas fillR: 0 G: 0 B: 0.
	gtCanvas text: ''Fibonacci'' x: 20 y: 75.
	gtCanvas textSize: 50.
	gtCanvas fillR: 255 G: 255 B: 255.
	gtCanvas text: (self fibonacci: 10) x: 20 y: 125.

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
ProcessingTranspilerExamples >> transpilationImage [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	img := (gtCanvas loadImage: ''zeniko/gt-exploration/data/sample/thumbs-up.png'').
	gtCanvas image: img x: 0 y: 0.
	gtCanvas fillGray: 0.
	gtCanvas image: img x: 150 y: 150 width: 50 height: 50.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationLists [
	^ 'gtRun
	a := (ProcessingList newFrom: { 1. 2. }).
	(a append: 3).
	b := (a + a).
	c := (b sliceFrom: 1 stepBy: 1 negated).
	d := (c pop).
	e := c sorted.
	f := (e sliceFrom: (1 + 1) to: 4).
	g := f size.
	h := (f at: (2 + 1)).
	j := (b sliceFrom: 1 to: 2 negated).
	k := (b sliceFrom: 1).
	(k sort).
	(k reverse).
	l := (b sliceFrom: 1 stepBy: 2 negated).
	gtCanvas print: { a. b. c. d. e. f. g. h. j. k. l. }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationLists2 [
	^ 'gtRun
	a := (ProcessingList newFrom: { 1. 2. 3. }).
	a := (a + (ProcessingList newFrom: { 4. 5. })).
	(a at: (1 + 1) put: 6).
	(a at: (2 negated + 1) put: 7).
	gtCanvas print: { (a * 2). (a sliceFrom: 1 to: 0). (a sliceFrom: (1 negated + 1)). (a * 0). }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationMinimal [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationMouseEvents [
	^ 'gtRun
	self setup.
	[ gtCanvas frameRate > 0 ] whileTrue: [
		mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.
		self draw.
		gtCanvas endFrame.
	].

setup
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas fillGray: 0.
	gtCanvas textSize: 20.

draw
	gtCanvas backgroundGray: 192.
	gtCanvas text: (((''Mouse: '' , mouseX asString) , '' @ '') , mouseY asString) x: 10 y: 70.
	gtCanvas text: ((''('' , (mousePressed not ifTrue: [ ''not '' ] ifFalse: [ '''' ])) , ''pressed)'') x: 78 y: 100.
	gtCanvas text: (''Time: '' , gtCanvas millis asString) x: 10 y: 190.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationMouseEvents2 [
	^ 'gtRun
	self setup.
	[ gtCanvas frameRate > 0 ] whileTrue: [
		mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.
		gtCanvas handleEvents: #( #mousePressed #mouseReleased #mouseMoved ) for: self.
		self draw.
		gtCanvas endFrame.
	].

setup
	width := 200. height := 200. gtCanvas size: width by: height.

draw
	ProcessingEllipsis.

mousePressed
	gtCanvas backgroundR: 0 G: 255 B: 0.

mouseReleased
	gtCanvas backgroundGray: 192.

mouseMoved
	gtCanvas backgroundR: mouseX G: 0 B: mouseY.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationPrecedence [
	^ 'gtRun
	[ (((2 / 3) * 4) = (8 / 3)) ] assert.
	[ (((2 - 3) + 4) = 3) ] assert.
	[ (((2 * 3) + 4) = 10) ] assert.
	[ ((2 + (3 * 4)) = 14) ] assert.
	[ (((2 + 3) * 4) = 20) ] assert.
	[ ((4 ** (3 ** 2)) = 262144) ] assert.
	[ ((true and: [ false ]) or: [ true ]) ] assert.
	[ ((true and: [ false ]) or: [ false ]) not ] assert.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationPrint [
	^ 'gtRun
	gtCanvas print: ''Hello, world!''.
	var := (2 + (3 / 4)).
	gtCanvas print: { ''2 + 3 / 4 =''. var. }.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationRandom [
	^ 'gtRun
	(gtCanvas randomSeed: 100).
	[ ((gtCanvas random: 10) = 0.007826369259425611) ] assert.
	[ ((gtCanvas random: 3) = 0.46133644294987264) ] assert.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationRecursion [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	(self recursion: 200).

recursion: n
	gtCanvas ellipse: 100 y: 100 dx: n dy: n.
	(n > 20) ifTrue: [
		(self recursion: (n - 10)).
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationShapes [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas strokeR: 255 G: 255 B: 255.
	gtCanvas rect: 20 y: 30 width: 60 height: 40 cornerRadius: 5.
	gtCanvas ellipse: 150 y: 50 dx: 60 dy: 40.
	gtCanvas line: 25 y1: 150 x2: 75 y2: 125.
	gtCanvas triangle: 125 y1: 125 x2: 150 y2: 175 x3: 175 y3: 150.'
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

sierpinski: n x: x y: y side: gt0_side
	| th side |
	side := gt0_side.
	th := (side * 60 degreesToRadians sin).
	(n = 1) ifTrue: [
		gtCanvas triangle: x y1: (y + th) x2: (x + side) y2: (y + th) x3: (x + (side / 2)) y3: y.
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
ProcessingTranspilerExamples >> transpilationSimulation [
	^ 'gtRun
	anzahl_personen := 100.
	anzahl_kranke := 1.
	groesse := 30.
	risiko := 0.25.
	genesung := 0.05.
	x_koordinaten := ((ProcessingList newFrom: { 1 negated. }) * anzahl_personen).
	y_koordinaten := ((ProcessingList newFrom: { 1 negated. }) * anzahl_personen).
	zustand := ((ProcessingList newFrom: { 1 negated. }) * anzahl_personen).
	self setup.
	[ gtCanvas frameRate > 0 ] whileTrue: [
		mouseX := gtCanvas mouseX. mouseY := gtCanvas mouseY. mousePressed := gtCanvas mousePressed.
		self draw.
		gtCanvas endFrame.
	].

setup
	width := 500. height := 500. gtCanvas size: width by: height.
	gtCanvas frameRate: 10.
	(self personen_platzieren).

draw
	(self krankheit_uebertragen).
	(self personen_bewegen).
	(self personen_anzeigen).

personen_platzieren
	| p |
	p := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		(x_koordinaten at: (p + 1) put: (gtCanvas random: width)).
		(y_koordinaten at: (p + 1) put: (gtCanvas random: height)).
		(zustand at: (p + 1) put: 0.0).
		p := (p + 1).
	].
	p := 0.
	[ (p < anzahl_kranke) ] whileTrue: [
		(zustand at: (p + 1) put: 1.0).
		p := (p + 1).
	].

krankheit_uebertragen
	| p q |
	p := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		((zustand at: (p + 1)) < 1) ifTrue: [
			q := 0.
			[ (q < anzahl_personen) ] whileTrue: [
				(((zustand at: (q + 1)) >= 1) and: [ ((zustand at: (q + 1)) < 2) ]) ifTrue: [
					(((((x_koordinaten at: (p + 1)) - (x_koordinaten at: (q + 1))) ** 2) + (((y_koordinaten at: (p + 1)) - (y_koordinaten at: (q + 1))) ** 2)) < (groesse ** 2)) ifTrue: [
						(zustand at: (p + 1) put: ((zustand at: (p + 1)) + risiko)).
					].
				].
				q := (q + 1).
			].
			((zustand at: (p + 1)) > 1) ifTrue: [
				(zustand at: (p + 1) put: 1).
			].
		] ifFalse: [
			(zustand at: (p + 1) put: ((zustand at: (p + 1)) + (gtCanvas random: genesung))).
		].
		p := (p + 1).
	].

personen_bewegen
	| p |
	p := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		(x_koordinaten at: (p + 1) put: ((((x_koordinaten at: (p + 1)) + ((groesse / 2.0) * ((gtCanvas random: 2) - 1))) max: 0) min: width)).
		(y_koordinaten at: (p + 1) put: ((((y_koordinaten at: (p + 1)) + ((groesse / 2.0) * ((gtCanvas random: 2) - 1))) max: 0) min: height)).
		p := (p + 1).
	].

personen_anzeigen
	| p infizierte |
	gtCanvas backgroundR: 0 G: 0 B: 0.
	p := 0.
	infizierte := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		((zustand at: (p + 1)) < 1) ifTrue: [
			gtCanvas fillR: 255 G: 255 B: 255.
		] ifFalse: [
			((zustand at: (p + 1)) < 2) ifTrue: [
				gtCanvas fillR: 255 G: 0 B: 0.
				infizierte := (infizierte + 1).
			] ifFalse: [
				gtCanvas fillR: 170 G: 170 B: 170.
			].
		].
		gtCanvas ellipse: (x_koordinaten at: (p + 1)) y: (y_koordinaten at: (p + 1)) dx: groesse dy: groesse.
		p := (p + 1).
	].
	gtCanvas fillR: 255 G: 0 B: 0.
	gtCanvas textSize: 20.
	gtCanvas text: (''Infizierte: '' , infizierte asString) x: 20 y: 30.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationSpiral [
	^ 'gtRun
	width := 600. height := 600. gtCanvas size: width by: height.
	gtCanvas backgroundGray: 255.
	gtCanvas translate: (width / 2) y: (height / 2).
	gtCanvas scale: 0.95.
	gtCanvas strokeWeight: 2.
	0 to: (20 - 1) do: [ :_ |
		gtCanvas fillGray: 255.
		gtCanvas strokeGray: 0.
		gtCanvas rect: (width negated / 2) y: (width negated / 2) width: width height: width.
		gtCanvas fillGray: 0.
		gtCanvas strokeGray: 255.
		gtCanvas triangle: (width negated / 2) y1: (width negated / 2) x2: (width negated / 2) y2: 0 x3: 0 y3: (width negated / 2).
		gtCanvas scale: (1 / 2 sqrt).
		gtCanvas rotate: (3.141592653589793 / 4).
	].'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationSwitzerland [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas backgroundR: 255 G: 0 B: 0.
	gtCanvas rect: 75 y: 25 width: 50 height: 150.
	gtCanvas rect: 25 y: 75 width: 150 height: 50.'
]

{ #category : #transpilation }
ProcessingTranspilerExamples >> transpilationTransforms [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas fillGray: 0.
	gtCanvas rect: 0 y: 0 width: 30 height: 30.
	gtCanvas fillGray: 51.
	gtCanvas translate: 50 y: 100.
	gtCanvas rect: 0 y: 0 width: 30 height: 30.
	gtCanvas fillGray: 102.
	gtCanvas rotate: (3.141592653589793 / 8).
	gtCanvas rect: 0 y: 0 width: 30 height: 30.
	gtCanvas fillGray: 153.
	gtCanvas translate: 20 y: 50.
	gtCanvas rect: 0 y: 0 width: 30 height: 30.
	gtCanvas fillGray: 204.
	gtCanvas rotate: (3.141592653589793 / 8).
	gtCanvas rect: 0 y: 0 width: 30 height: 30.
	gtCanvas fillGray: 255.
	gtCanvas scale: 2.
	gtCanvas rect: 15 y: 70 negated width: 20 height: 20.'
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
	w := ((width / n) * 3).
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
	gtCanvas line: oldX y1: oldY x2: t_x y2: t_y.

turn: angle
	t_angle := (t_angle + angle).'
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileAlpinerWanderweg [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programAlpinerWanderweg ast.
	transpiler := self newTranspiler.
	self
		assert: (transpiler transpile: ast)
		equals: self transpilationAlpinerWanderweg.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self
		compare: (transpiler compile: ast)
		with: self transpilationAlpinerWanderweg.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileAnimation [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programAnimation ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationAnimation.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'var'.
	self assert: transpiler userDefs size equals: 2.
	self compare: (transpiler compile: ast) with: self transpilationAnimation.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileAnimation2 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programAnimation2 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationAnimation2.
	self assert: transpiler variables size equals: 4.
	self assert: (' ' join: transpiler variables sorted) equals: 'dx dy x y'.
	self assert: transpiler userDefs size equals: 2.
	self compare: (transpiler compile: ast) with: self transpilationAnimation2.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileColors [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programColors ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationColors.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'c'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationColors.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileEndlessLoop [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programEndlessLoop ast.
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
	ast := ProcessingProgramExamples new programExample02 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample02.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'a'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample02.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample03 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programExample03 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample03.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'x'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample03.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample04 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programExample04 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample04.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'x'.
	self assert: transpiler userDefs size equals: 2.
	self compare: (transpiler compile: ast) with: self transpilationExample04.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample05 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programExample05 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample05.
	self assert: transpiler variables size equals: 2.
	self assert: (' ' join: transpiler variables sorted) equals: 'gt_A gt_B'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample05.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample06 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programExample06 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample06.
	self assert: transpiler variables size equals: 2.
	self assert: (' ' join: transpiler variables sorted) equals: 'cond var'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample06.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileExample07 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programExample07 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationExample07.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'a'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationExample07.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileFibonacci [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programFibonacci ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationFibonacci.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 1.
	self compare: (transpiler compile: ast) with: self transpilationFibonacci.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileImage [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programImage ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationImage.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'img'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationImage.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileLists [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programLists ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationLists.
	self assert: transpiler variables size equals: 11.
	self assert: (' ' join: transpiler variables sorted) equals: 'a b c d e f g h j k l'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationLists.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileLists2 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programLists2 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationLists2.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'a'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationLists2.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileMinimal [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programMinimal ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationMinimal.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationMinimal.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileMouseEvents [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programMouseEvents ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationMouseEvents.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 2.
	self compare: (transpiler compile: ast) with: self transpilationMouseEvents.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileMouseEvents2 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programMouseEvents2 ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationMouseEvents2.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 5.
	self compare: (transpiler compile: ast) with: self transpilationMouseEvents2.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpilePrecedence [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programPrecedence ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationPrecedence.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationPrecedence.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpilePrint [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programPrint ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationPrint.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'var'.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationPrint.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileRandom [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programRandom ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationRandom.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationRandom.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileRecursion [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programRecursion ast.
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
	ast := ProcessingProgramExamples new programShapes ast.
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
	ast := ProcessingProgramExamples new programSierpinski ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSierpinski.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'px'.
	self assert: transpiler userDefs size equals: 1.
	self compare: (transpiler compile: ast) with: self transpilationSierpinski.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileSimulation [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programSimulation ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSimulation.
	self assert: transpiler variables size equals: 8.
	self assert: (' ' join: transpiler variables sorted) equals: 'anzahl_kranke anzahl_personen genesung groesse risiko x_koordinaten y_koordinaten zustand'.
	self assert: transpiler userDefs size equals: 6.
	self compare: (transpiler compile: ast) with: self transpilationSimulation.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileSpiral [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programSpiral ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSpiral.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationSpiral.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileSwitzerland [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programSwitzerland ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationSwitzerland.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationSwitzerland.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileTransforms [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programTransforms ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationTransforms.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 0.
	self compare: (transpiler compile: ast) with: self transpilationTransforms.
	^ transpiler compile: ast
]

{ #category : #example }
ProcessingTranspilerExamples >> transpileTurtleGraphics [
	<gtExample>
	| ast transpiler |
	ast := ProcessingProgramExamples new programTurtleGraphics ast.
	transpiler := self newTranspiler.
	self
		assert: (transpiler transpile: ast)
		equals: self transpilationTurtleGraphics.
	self assert: transpiler variables size equals: 3.
	self assert: (' ' join: transpiler variables sorted) equals: 't_angle t_x t_y'.
	self assert: transpiler userDefs size equals: 5.
	self compare: (transpiler compile: ast) with: self transpilationTurtleGraphics.
	^ transpiler compile: ast
]
