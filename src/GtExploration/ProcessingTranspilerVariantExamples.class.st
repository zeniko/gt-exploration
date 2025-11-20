Class {
	#name : 'ProcessingTranspilerVariantExamples',
	#superclass : 'Object',
	#category : 'GtExploration-Examples',
	#package : 'GtExploration',
	#tag : 'Examples'
}

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> postfixPresentationDemo [
	<gtExample>
	| transpiler output |
	transpiler := self postfixTranspiler.
	output := transpiler
			transpile: ProcessingSourceExamples new sourcePresentationDemo program ast.
	self
		assert: output
		equals: '$a $b 1 = =
{ a 15 < } {
	$a a b + =
	$b a b - =
} while
a print
'.
	^ output
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> postfixTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspilerVariant postfix.
	self assert: transpiler style equals: 'postfix'.
	^ transpiler
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> prefixPresentationDemo [
	<gtExample>
	| transpiler output |
	transpiler := self prefixTranspiler.
	output := transpiler
			transpile: ProcessingSourceExamples new sourcePresentationDemo program ast.
	self
		assert: output
		equals: '(= a (= b 1))
(while (< a 15) (do
	(= a (+ a b))
	(= b (- a b))
))
(print a)
'.
	^ output
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> prefixTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspilerVariant prefix.
	self assert: transpiler style equals: 'prefix'.
	^ transpiler
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileAnimation [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceAnimation program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= var 0)
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

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$var 0 =
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

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileAnimation2 [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceAnimation2 program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= x 200)
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
	(ellipse x y 50 50)
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

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$x 200 =
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
	x y 50 50 ellipse
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

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileExample03 [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceExample03 program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(size 200 200)
(= x 200)
(while (> x 0) (do
	(fill (- 200 x) 128 x)
	(ellipse 100 100 x x)
	(= x (- x 20))
	(delay 50)
))
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '200 200 size
$x 200 =
{ x 0 > } {
	200 x - 128 x fill
	100 100 x x ellipse
	$x x 20 - =
	50 delay
} while
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileExample05 [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceExample05 program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(size 200 100)
(= gtA width)
(= gtB height)
(print None True False "String" (list "Nested"))
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '200 100 size
$gtA width =
$gtB height =
None True False "String" "Nested" list_1 print_5
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileExample06 [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceExample06 program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= cond (or (and True False) (not (== 1 (> 2 3)))))
(= var (ifelse cond 5 3))
(for_in x (range 1 var) (do
	(print x)
))
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$cond True False and 1 2 3 > == not or =
$var cond 5 3 ifelse =
$x 1 var range {
	x print
} for_in
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileExample07 [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceExample07 program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= a (random 3 7))
(= a (+ a 2))
(assert (<= 5 (< a 9)))
(= a (- a 5))
(assert (< a 4) "Message")
(assert False "Done!")
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$a 3 7 random_2 =
$a a 2 + =
5 a 9 < <= assert
$a a 5 - =
a 4 < "Message" assert_2
False "Done!" assert_2
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileFibonacci [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceFibonacci program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(size 200 200)
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

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '200 200 size
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

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileLists [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceLists program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= a (list 1 2))
((a append) 3)
(= b (+ a a))
(= c (slice b None None (- 1)))
(= d ((c pop)))
(= e (sorted c))
(= f (slice e 1 4 None))
(= g (len f))
(= h (item f 2))
(= j (slice b None (- 2) None))
(= k (slice b None None None))
((k sort))
((k reverse))
(= l (slice b None None (- 2)))
(print a b c d e f g h j k l)
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$a 1 2 list_2 =
3 a append
$b a a + =
$c b None None 1 unary- slice =
$d c pop =
$e c sorted =
$f e 1 4 None slice =
$g f len =
$h f 2 item =
$j b None 2 unary- None slice =
$k b None None None slice =
k sort
k reverse
$l b None None 2 unary- slice =
a b c d e f g h j k l print_11
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileLists2 [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceLists2 program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= a (list 1 2 3))
(= a (+ a (list 4 5 6)))
(put_at a 1 (put_at a 5 8))
(put_at a (- 2) 7)
(print (* a 2) (slice a None 0 None) (slice a (- 1) None None) (* a 0))
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$a 1 2 3 list_3 =
$a a 4 5 6 list_3 + =
a 1 a 5 8 put_at put_at
a 2 unary- 7 put_at
a 2 * a None 0 None slice a 1 unary- None None slice a 0 * print_4
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpilePrecedence [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourcePrecedence program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(assert (== (* (/ 2 3) 4) (/ 8 3)))
(assert (== (+ (- 2 3) 4) 3))
(assert (== (+ (* 2 3) 4) 10))
(assert (== (+ 2 (* 3 4)) 14))
(assert (== (* (+ 2 3) 4) 20))
(assert (== (** 4 (** 3 2)) 262144))
(assert (or (and True False) True))
(assert (not (or (and True False) False)))
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '2 3 / 4 * 8 3 / == assert
2 3 - 4 + 3 == assert
2 3 * 4 + 10 == assert
2 3 4 * + 14 == assert
2 3 + 4 * 20 == assert
4 3 2 ** ** 262144 == assert
True False and True or assert
True False and False or not assert
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileRandom [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceRandom program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(randomSeed 100)
(assert (== (random 10) 0.007826369259425611))
(assert (== (random 3) 0.46133644294987264))
'.

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '100 randomSeed
10 random 0.007826369259425611 == assert
3 random 0.46133644294987264 == assert
'.

	^ prefix
]

{ #category : 'example' }
ProcessingTranspilerVariantExamples >> transpileSierpinski [
	<gtExample>
	| ast postfix prefix |
	ast := ProcessingSourceExamples new sourceSierpinski program ast.

	prefix := self prefixTranspiler transpile: ast.
	self
		assert: prefix
		equals: '(= px 300)
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

	postfix := self postfixTranspiler transpile: ast.
	self
		assert: postfix
		equals: '$px 300 =
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

	^ prefix
]
