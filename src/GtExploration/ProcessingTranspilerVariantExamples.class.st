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
	var global
	192 background
	var var 50 50 rect
	$var var 20 + =
	{ var height 50 - > } {
		$var 0 =
	} ifelse
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
	))
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
ProcessingTranspilerVariantExamples >> prefixTranspiler [
	<gtExample>
	| transpiler |
	transpiler := ProcessingTranspilerVariant prefix.
	self assert: transpiler style equals: 'prefix'.
	^ transpiler
]
