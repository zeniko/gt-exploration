Class {
	#name : 'ProcessingTranspilerExamples',
	#superclass : 'Object',
	#category : 'GtExploration-Examples',
	#package : 'GtExploration',
	#tag : 'Examples'
}

{ #category : 'example' }
ProcessingTranspilerExamples >> allTranspilations [
	<gtExample>
	| compilations |
	compilations := OrderedCollection new.
	self testData
		keysAndValuesDo: [ :name :data | 
			| ast transpiler compilation |
			ast := ProcessingSourceExamples astFor: name.
			transpiler := self newTranspiler.
			self
				assert: (transpiler transpile: ast)
				equals: (self perform: #transpilation , name).
			self assert: (' ' join: transpiler variables sorted) equals: data first.
			self assert: (' ' join: transpiler userDefs keys sorted) equals: data second.
			compilation := transpiler compile: ast.
			self compare: compilation with: (self perform: #transpilation , name).
			compilations add: compilation ].
	^ compilations
]

{ #category : 'example' }
ProcessingTranspilerExamples >> allViews [
	<gtExample>
	| compilation views |
	compilation := self transpilePresentationDemo.
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

{ #category : 'example' }
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

{ #category : 'example' }
ProcessingTranspilerExamples >> newTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspiler new.
	self assert: transpiler variables equals: nil.
	^ transpiler
]

{ #category : 'example' }
ProcessingTranspilerExamples >> testData [
	"Map source code from ProgramSourceExamples to global variables and user defined functions"

	<gtExample>
	| testData |
	testData := {#AlpinerWanderweg -> #('' '').
			#Animation -> #('var' 'draw setup').
			#Animation2 -> #('dx dy x y' 'draw setup').
			#Colors -> #('c' '').
			#EndlessLoop -> #('' '').
			#Example02 -> #('a' '').
			#Example03 -> #('x' '').
			#Example04 -> #('x' 'setX setY').
			#Example05 -> #('gt_A gt_B' '').
			#Example06 -> #('cond gt3_to gt4_ var x' '').
			#Example07 -> #('a' '').
			#Fibonacci -> #('' 'fibonacci').
			#ForLoop -> #('a gt3_from gt4_to gt5_step gt6_ res x' '').
			#Image -> #('img' '').
			#Lists -> #('a b c d e f g h j k l' '').
			#Lists2 -> #('a' '').
			#Lists3 -> #('a' '').
			#Minimal -> #('' '').
			#MouseEvents -> #('' 'draw setup').
			#MouseEvents2 -> #('' 'draw mouseMoved mousePressed mouseReleased setup').
			#Precedence -> #('' '').
			#PresentationDemo -> #('a b' '').
			#Print -> #('var' '').
			#Random -> #('' '').
			#Recursion -> #('' 'recursion').
			#RuntimeError -> #('' '').
			#Shapes -> #('' '').
			#Sierpinski -> #('px' 'sierpinski').
			#Simulation
				-> #('anzahl_kranke anzahl_personen genesung groesse risiko x_koordinaten y_koordinaten zustand' 'draw krankheit_uebertragen personen_anzeigen personen_bewegen personen_platzieren setup').
			#Spiral -> #('_ gt1_' '').
			#Switzerland -> #('' '').
			#Transforms -> #('' '').
			#TurtleGraphics -> #('t_angle t_x t_y' 'draw_n_eck fwd kochpart move turn')}
			asDictionary.
	self
		assert: testData keys sorted
		equals: ProcessingSourceExamples new sourceNames.
	^ testData
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationAlpinerWanderweg [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas rect: 50 y: 50 width: 100 height: 100.
	gtCanvas fillR: 255 G: 0 B: 0.
	gtCanvas rect: 50 y: (50 + (100 / 3)) width: 100 height: (100 / 3).'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationColors [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	c := (gtCanvas colorWithR: 224 G: 224 B: 224).
	[ (c = (gtCanvas colorWithGray: 224)) ] assert.
	gtCanvas fillGray: c.
	gtCanvas strokeGray: (gtCanvas colorWithGray: 192).
	gtCanvas rect: 50 y: 50 width: 100 height: 100.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationEndlessLoop [
	^ 'gtRun
	[ true ] whileTrue: [
	].'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationExample05 [
	^ 'gtRun
	width := 200. height := 100. gtCanvas size: width by: height.
	gt_A := width.
	gt_B := height.
	gtCanvas print: { nil. true. false. ''String''. (ProcessingList newFrom: { ''Nested''. }). }.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationExample06 [
	^ 'gtRun
	cond := ((true and: [ false ]) or: [ (1 = 2 and: [ 2 = 3 ]) not ]).
	var := (cond ifTrue: [ 5 ] ifFalse: [ 3 ]).
	gt3_to := var.
	1 to: (gt3_to - 1) do: [ :gt4_loop | x := gt4_loop.
		gtCanvas print: x.
	].'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationExample07 [
	^ 'gtRun
	a := (gtCanvas random: 3 to: 7).
	a := (a + 2).
	[ (5 <= a and: [ a <= 9 ]) ] assert.
	a := (a - 5).
	[ (a < 4) ] assertWithDescription: ''Message''.
	[ false ] assertWithDescription: ''Done!''.'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationForLoop [
	^ 'gtRun
	a := 1.
	res := (ProcessingList newFrom: { }).
	gt3_from := a := (a + 1).
	gt4_to := a := (a + 15).
	gt5_step := a := (a - 14).
	gt3_from to: (gt4_to - gt5_step) by: gt5_step do: [ :gt6_loop | x := gt6_loop.
		(res append: x).
	].
	gtCanvas print: { res. a. x. }.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationImage [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	img := (gtCanvas loadImage: ''zeniko/gt-exploration/data/sample/thumbs-up.png'').
	gtCanvas image: img x: 0 y: 0.
	gtCanvas fillGray: 0.
	gtCanvas image: img x: 150 y: 150 width: 50 height: 50.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationLists [
	^ 'gtRun
	a := (ProcessingList newFrom: { 1. 2. }).
	(a append: 3).
	b := (a + a).
	c := (b sliceFrom0: 0 stepBy: 1 negated).
	d := (c pop).
	e := c sorted.
	f := (e sliceFrom0: 1 to: 4).
	g := f size.
	h := (f at0: 2).
	j := (b sliceFrom0: 0 to: 2 negated).
	k := (b sliceFrom0: 0).
	(k sort).
	(k reverse).
	l := (b sliceFrom0: 0 stepBy: 2 negated).
	gtCanvas print: { a. b. c. d. e. f. g. h. j. k. l. }.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationLists2 [
	^ 'gtRun
	a := (ProcessingList newFrom: { 1. 2. 3. }).
	a := (a + (ProcessingList newFrom: { 4. 5. 6. })).
	(a at0: 1 put: (a at0: 5 put: 8)).
	(a at0: 2 negated put: 7).
	gtCanvas print: { (a * 2). (a sliceFrom0: 0 to: 0). (a sliceFrom0: 1 negated). (a * 0). }.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationLists3 [
	^ 'gtRun
	a := (ProcessingList newFrom: { 1. }).
	(a append: a).
	[ (a size = 2) ] assert.
	[ (a asString = ''[1, [...]]'') ] assert.
	(a reverse).
	gtCanvas print: a.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationMinimal [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationPresentationDemo [
	^ 'gtRun
	a := b := 1.
	[ (a < 15) ] whileTrue: [
		a := (a + b).
		b := (a - b).
	].
	gtCanvas print: a.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationPrint [
	^ 'gtRun
	gtCanvas print: ''Hello, world!''.
	var := (2 + (3 / 4)).
	gtCanvas print: { ''2 + 3 / 4 =''. var. }.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationRandom [
	^ 'gtRun
	(gtCanvas randomSeed: 100).
	[ ((gtCanvas random: 3) = 0.8673620908521116) ] assert.
	[ ((gtCanvas random: 10) = 8.950381418690085) ] assert.'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationRuntimeError [
	^ 'gtRun
	(1 / 0).'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationShapes [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas strokeR: 255 G: 255 B: 255.
	gtCanvas rect: 20 y: 30 width: 60 height: 40 cornerRadius: 5.
	gtCanvas ellipse: 150 y: 50 dx: 60 dy: 40.
	gtCanvas line: 25 y1: 150 x2: 75 y2: 125.
	gtCanvas triangle: 125 y1: 125 x2: 150 y2: 175 x3: 175 y3: 150.'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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
		(x_koordinaten at0: p put: (gtCanvas random: width)).
		(y_koordinaten at0: p put: (gtCanvas random: height)).
		(zustand at0: p put: 0.0).
		p := (p + 1).
	].
	p := 0.
	[ (p < anzahl_kranke) ] whileTrue: [
		(zustand at0: p put: 1.0).
		p := (p + 1).
	].

krankheit_uebertragen
	| p q |
	p := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		((zustand at0: p) < 1) ifTrue: [
			q := 0.
			[ (q < anzahl_personen) ] whileTrue: [
				(((zustand at0: q) >= 1) and: [ ((zustand at0: q) < 2) ]) ifTrue: [
					(((((x_koordinaten at0: p) - (x_koordinaten at0: q)) ** 2) + (((y_koordinaten at0: p) - (y_koordinaten at0: q)) ** 2)) < (groesse ** 2)) ifTrue: [
						(zustand at0: p put: ((zustand at0: p) + risiko)).
					].
				].
				q := (q + 1).
			].
			((zustand at0: p) > 1) ifTrue: [
				(zustand at0: p put: 1).
			].
		] ifFalse: [
			(zustand at0: p put: ((zustand at0: p) + (gtCanvas random: genesung))).
		].
		p := (p + 1).
	].

personen_bewegen
	| p |
	p := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		(x_koordinaten at0: p put: ((((x_koordinaten at0: p) + ((groesse / 2.0) * ((gtCanvas random: 2) - 1))) max: 0) min: width)).
		(y_koordinaten at0: p put: ((((y_koordinaten at0: p) + ((groesse / 2.0) * ((gtCanvas random: 2) - 1))) max: 0) min: height)).
		p := (p + 1).
	].

personen_anzeigen
	| p infizierte |
	gtCanvas backgroundR: 0 G: 0 B: 0.
	p := 0.
	infizierte := 0.
	[ (p < anzahl_personen) ] whileTrue: [
		((zustand at0: p) < 1) ifTrue: [
			gtCanvas fillR: 255 G: 255 B: 255.
		] ifFalse: [
			((zustand at0: p) < 2) ifTrue: [
				gtCanvas fillR: 255 G: 0 B: 0.
				infizierte := (infizierte + 1).
			] ifFalse: [
				gtCanvas fillR: 170 G: 170 B: 170.
			].
		].
		gtCanvas ellipse: (x_koordinaten at0: p) y: (y_koordinaten at0: p) dx: groesse dy: groesse.
		p := (p + 1).
	].
	gtCanvas fillR: 255 G: 0 B: 0.
	gtCanvas textSize: 20.
	gtCanvas text: (''Infizierte: '' , infizierte asString) x: 20 y: 30.'
]

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationSpiral [
	^ 'gtRun
	width := 600. height := 600. gtCanvas size: width by: height.
	gtCanvas backgroundGray: 255.
	gtCanvas translate: (width / 2) y: (height / 2).
	gtCanvas scale: 0.95.
	gtCanvas strokeWeight: 2.
	0 to: (20 - 1) do: [ :gt1_loop | _ := gt1_loop.
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

{ #category : 'transpilation' }
ProcessingTranspilerExamples >> transpilationSwitzerland [
	^ 'gtRun
	width := 200. height := 200. gtCanvas size: width by: height.
	gtCanvas backgroundR: 255 G: 0 B: 0.
	gtCanvas rect: 75 y: 25 width: 50 height: 150.
	gtCanvas rect: 25 y: 75 width: 150 height: 50.'
]

{ #category : 'transpilation' }
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

{ #category : 'transpilation' }
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

{ #category : 'example' }
ProcessingTranspilerExamples >> transpileExample02 [
	<gtExample>
	| ast transpiler |
	ast := ProcessingSourceExamples new sourceExample02 program ast.
	transpiler := self newTranspiler.
	self
		assert: (transpiler transpile: ast)
		equals: self transpilationExample02.
	self assert: transpiler variables size equals: 1.
	self assert: (' ' join: transpiler variables sorted) equals: 'a'.
	self assert: transpiler userDefs size equals: 0.
	self
		compare: (transpiler compile: ast)
		with: self transpilationExample02.
	^ transpiler compile: ast
]

{ #category : 'example' }
ProcessingTranspilerExamples >> transpilePresentationDemo [
	<gtExample>
	| ast transpiler |
	ast := ProcessingSourceExamples new sourcePresentationDemo program ast.
	transpiler := self newTranspiler.
	self
		assert: (transpiler transpile: ast)
		equals: self transpilationPresentationDemo.
	self assert: transpiler variables size equals: 2.
	self assert: (' ' join: transpiler variables sorted) equals: 'a b'.
	self assert: transpiler userDefs size equals: 0.
	self
		compare: (transpiler compile: ast)
		with: self transpilationPresentationDemo.
	^ transpiler compile: ast
]

{ #category : 'example' }
ProcessingTranspilerExamples >> transpileRecursion [
	<gtExample>
	| ast transpiler |
	ast := ProcessingSourceExamples new sourceRecursion program ast.
	transpiler := self newTranspiler.
	self assert: (transpiler transpile: ast) equals: self transpilationRecursion.
	self assert: transpiler variables size equals: 0.
	self assert: transpiler userDefs size equals: 1.
	self compare: (transpiler compile: ast) with: self transpilationRecursion.
	^ transpiler compile: ast
]
