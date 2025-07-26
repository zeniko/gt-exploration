Class {
	#name : #ProcessingTranspilerVariantExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixAnimation [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programAnimation ast.
	self assert: output equals: '$var 0 =
$setup () {
	200 200 size
	2 frameRate
} deffun
$draw () {
	$var global
	192 background_1
	var var 50 50 rect
	$var var 20 + =
	{ var height 50 - > } {
		$var 0 =
	} { pass } ifelse
} deffun
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixAnimation2 [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programAnimation2 ast.
	self assert: output equals: '$x 200 =
$y 100 =
$dx 2 =
$dy 0 =
$setup () {
	400 300 size
	noStroke
} deffun
$draw () {
	$x $y $dx $dy global_4
	192 background_1
	x y 50 circle
	$x x dx + =
	$y y dy + =
	{ x 25 < } {
		$dx 2 unary+ =
	} {
		{ x width 25 - > } {
			$dx 2 unary- =
		} { pass } ifelse
	} ifelse
	$dy dy 1 + =
	{ y height 25 - > } {
		$dy 0.9 unary- dy * =
		$y height 25 - =
	} { pass } ifelse
} deffun
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixExample03 [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programExample03 ast.
	self assert: output equals: '200 200 size
$x 200 =
{ x 0 > } {
	200 x - 128 x fill
	100 100 x x ellipse
	$x x 20 - =
	50 delay
} while
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixExample06 [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programExample06 ast.
	self assert: output equals: '$cond True False and 1 2 3 > == not or =
$var cond 5 3 ifelse =
$x 1 var range {
	x print
} for_in
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixExample07 [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programExample07 ast.
	self assert: output equals: '$a 3 7 random_2 =
$a a 2 + =
5 a 9 < <= assert
$a a 5 - =
a 4 < "Message" assert_2
False "Done!" assert_2
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixFibonacci [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programFibonacci ast.
	self assert: output equals: '200 200 size
$fibonacci ($n) {
	{ n 2 > } {
		$a n 1 - fibonacci =
		a n 2 - fibonacci + return
	} {
		1 return
	} ifelse
} deffun
30 textSize
0 0 0 fill
"Fibonacci" 20 75 text
50 textSize
255 255 255 fill
10 fibonacci 20 125 text
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixLists [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programLists ast.
	self assert: output equals: '$a 1 2 list_2 =
$a a 3 append =
$b a a concat =
$c b reverse =
$d c shorten =
$e d sort =
$f e 1 4 slice =
$g f len =
$h f 2 item =
$j b None 2 unary- slice =
a b c d e f g h j print_9
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixLists2 [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programLists2 ast.
	self assert: output equals: '$a 1 2 3 list_3 =
$a a 4 5 list_2 + =
a 1 6 put_at
a 2 unary- 7 put_at
a 2 * a None 0 slice a 1 unary- None slice a 0 * print_4
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixRandom [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programRandom ast.
	self assert: output equals: '100 randomSeed
10 random 0.007826369259425611 == assert
3 random 0.46133644294987264 == assert
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixSierpinski [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programSierpinski ast.
	self assert: output equals: '$px 300 =
px px 60 radians sin * 2 + size
$sierpinski ($n $x $y $side) {
	$th side 60 radians sin * =
	{ n 1 == } {
		x y th + x side + y th + x side 2 / + y triangle
	} {
		{ n 1 > } {
			$side side 2 / =
			$th th 2 / =
			n 1 - x side 2 / + y side sierpinski
			n 1 - x y th + side sierpinski
			n 1 - x side + y th + side sierpinski
		} { pass } ifelse
	} ifelse
} deffun
255 255 255 background
0 0 0 fill
0 0 0 stroke
1 strokeWeight
4 2 2 width 4 - sierpinski
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> postfixTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspilerVariant postfix.
	self assert: transpiler style equals: 'postfix'.
	^ transpiler
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixAnimation [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programAnimation ast.
	self assert: output equals: '(= var 0)
(deffun setup () (do
	(size 200 200)
	(frameRate 2)
))
(deffun draw () (do
	(global var)
	(background 192)
	(rect var var 50 50)
	(= var (+ var 20))
	(ifelse (> var (- height 50)) (do
		(= var 0)
	) )
))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixAnimation2 [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programAnimation2 ast.
	self assert: output equals: '(= x 200)
(= y 100)
(= dx 2)
(= dy 0)
(deffun setup () (do
	(size 400 300)
	(noStroke)
))
(deffun draw () (do
	(global x y dx dy)
	(background 192)
	(circle x y 50)
	(= x (+ x dx))
	(= y (+ y dy))
	(ifelse (< x 25) (do
		(= dx (+ 2))
	) (do
		(ifelse (> x (- width 25)) (do
			(= dx (- 2))
		) )
	))
	(= dy (+ dy 1))
	(ifelse (> y (- height 25)) (do
		(= dy (* (- 0.9) dy))
		(= y (- height 25))
	) )
))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixExample03 [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programExample03 ast.
	self assert: output equals: '(size 200 200)
(= x 200)
(while (> x 0) (do
	(fill (- 200 x) 128 x)
	(ellipse 100 100 x x)
	(= x (- x 20))
	(delay 50)
))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixExample06 [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programExample06 ast.
	self assert: output equals: '(= cond (or (and True False) (not (== 1 (> 2 3)))))
(= var (ifelse cond 5 3))
(for_in x (range 1 var) (do
	(print x)
))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixExample07 [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programExample07 ast.
	self assert: output equals: '(= a (random 3 7))
(= a (+ a 2))
(assert (<= 5 (< a 9)))
(= a (- a 5))
(assert (< a 4) "Message")
(assert False "Done!")
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixFibonacci [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programFibonacci ast.
	self assert: output equals: '(size 200 200)
(deffun fibonacci (n) (do
	(ifelse (> n 2) (do
		(= a (fibonacci (- n 1)))
		(return (+ a (fibonacci (- n 2))))
	) (do
		(return 1)
	))
))
(textSize 30)
(fill 0 0 0)
(text "Fibonacci" 20 75)
(textSize 50)
(fill 255 255 255)
(text (fibonacci 10) 20 125)
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixLists [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programLists ast.
	self assert: output equals: '(= a (list 1 2))
(= a (append a 3))
(= b (concat a a))
(= c (reverse b))
(= d (shorten c))
(= e (sort d))
(= f (slice e 1 4))
(= g (len f))
(= h (item f 2))
(= j (slice b None (- 2)))
(print a b c d e f g h j)
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixLists2 [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programLists2 ast.
	self assert: output equals: '(= a (list 1 2 3))
(= a (+ a (list 4 5)))
(put_at a 1 6)
(put_at a (- 2) 7)
(print (* a 2) (slice a None 0) (slice a (- 1) None) (* a 0))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixRandom [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programRandom ast.
	self assert: output equals: '(randomSeed 100)
(assert (== (random 10) 0.007826369259425611))
(assert (== (random 3) 0.46133644294987264))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixSierpinski [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler transpile: ProcessingProgramExamples new programSierpinski ast.
	self assert: output equals: '(= px 300)
(size px (+ (* px (sin (radians 60))) 2))
(deffun sierpinski (n x y side) (do
	(= th (* side (sin (radians 60))))
	(ifelse (== n 1) (do
		(triangle x (+ y th) (+ x side) (+ y th) (+ x (/ side 2)) y)
	) (do
		(ifelse (> n 1) (do
			(= side (/ side 2))
			(= th (/ th 2))
			(sierpinski (- n 1) (+ x (/ side 2)) y side)
			(sierpinski (- n 1) x (+ y th) side)
			(sierpinski (- n 1) (+ x side) (+ y th) side)
		) )
	))
))
(background 255 255 255)
(fill 0 0 0)
(stroke 0 0 0)
(strokeWeight 1)
(sierpinski 4 2 2 (- width 4))
'.
	^ output
]

{ #category : #example }
ProcessingTranspilerVariantExamples >> prefixTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspilerVariant prefix.
	self assert: transpiler style equals: 'prefix'.
	^ transpiler
]
