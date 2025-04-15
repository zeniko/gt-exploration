Class {
	#name : #ProcessingSourceExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> render [
	<gtExample>
	| source element |
	source := self sourceExample02.
	element := source render.
	self assert: (element isKindOf: BlElement).
	^ element
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceAlpinerWanderweg [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeAlpinerWanderweg.
	self assert: source asString equals: self sourceCodeAlpinerWanderweg.
	self assert: source program isNotNil.
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeAlpinerWanderweg [
	<gtExample>
	^ '
size(200, 200)
rect(50, 50, 100, 100)
fill(255, 0, 0)
rect(50, 50 + 100 / 3, 100, 100 / 3)
'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeEndlessLoop [
	<gtExample>
	^ 'while 1 == 1: loop'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeExample02 [
	<gtExample>
	^ 'size(200, 200)
a = 0
while a < 200:
	fill(a, 128, 0)
	rect(a, a, 100, 100)
	a = a + 50
if a >= 200:
	ellipse(10, 10, 20, 20)'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeExample03 [
	<gtExample>
	^ 'size(200, 200)
# Variable für Farbe und Durchmesser
x = 200
while x > 0:
	# Zeichne konzentrische Kreise in ändernder Farbe
	fill(200 - x, 128, x)
	ellipse(100, 100, x, x)
	x = x - 20
	# Für die Demonstration: 50ms Pause zwischen zwei Kreisen
	delay(50)'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeFibonacci [
	<gtExample>
	^ 'size(200, 200)

def fibonacci(n):
    if n > 2:
        a = fibonacci(n - 1)
        return a + fibonacci(n - 2)
    else:
      return 1

textSize(30)
fill(0, 0, 0)
text("Fibonacci", 20, 75)
textSize(50)
fill(255, 255, 255)
text(fibonacci(10), 20, 125)'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeMinimal [
	<gtExample>
	^ 'size(200, 200)'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceCodeRecursion [
	<gtExample>
	^ 'size(200, 200)

def recursion(n):
    ellipse(100, 100, n, n)
    if n > 20:
        recursion(n - 10)

recursion(200)'
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceEndlessLoop [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeEndlessLoop.
	self assert: source asString equals: self sourceCodeEndlessLoop.
	self assert: source program isNotNil.
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceExample02 [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeExample02.
	self assert: source asString equals: self sourceCodeExample02.
	self assert: source program isNotNil.
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceExample03 [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeExample03.
	self assert: source asString equals: self sourceCodeExample03.
	self assert: source program isNotNil.
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceFibonacci [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeFibonacci.
	self assert: source asString equals: self sourceCodeFibonacci.
	"self assert: source program isNotNil."
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceMinimal [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeMinimal.
	self assert: source asString equals: self sourceCodeMinimal.
	self assert: source program isNotNil.
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourceRecursion [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeRecursion.
	self assert: source asString equals: self sourceCodeRecursion.
	self assert: source program isNotNil.
	^ source
]
