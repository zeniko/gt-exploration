Class {
	#name : #ProcessingSourceExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingSourceExamples >> render [
	<gtExample>
	| source element |
	source := self sourceExample02.
	element := source render.
	self assert: (element isKindOf: BlElement).
	^ element
]

{ #category : #example }
ProcessingSourceExamples >> sourceAlpinerWanderweg [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeAlpinerWanderweg.
	self assert: source asString equals: self sourceCodeAlpinerWanderweg.
	self assert: source program isNotNil.
	^ source
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeAlpinerWanderweg [
	^ 'size(200, 200)
rect(50, 50, 100, 100)
fill(255, 0, 0)
rect(50, 50 + 100 / 3, 100, 100 / 3)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeEndlessLoop [
	^ 'while 1 == 1: 1+1'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeExample02 [
	^ 'size(200, 200)
a = 0
while a < 200:
	fill(a, 128, 0)
	rect(a, a, 100, 100)
	a = a + 50
if a >= 200:
	ellipse(10, 10, 20, 20)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeExample03 [
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

{ #category : #source }
ProcessingSourceExamples >> sourceCodeExample04 [
	^ 'size(30, 20)
x = 0
def setX():
    global x
    x = random(2) ** 2 * sin(radians(270))
setX()
text(x, 0, 20)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeExample05 [
	^ 'size(200, 100)
_a := width; _b := height'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeFibonacci [
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

{ #category : #source }
ProcessingSourceExamples >> sourceCodeMinimal [
	^ 'size(200, 200)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodePrint [
	^ 'print("Hello, world!")
var = 2 + 3
print("2 + 3 =", var)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeRecursion [
	^ 'size(200, 200)

def recursion(n):
    ellipse(100, 100, n, n)
    if n > 20:
        recursion(n - 10)

recursion(200)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeShapes [
	^ 'size(200, 200)
stroke(255, 255, 255)
rect(20, 30, 60, 40)
ellipse(150, 50, 60, 40)
line(25, 150, 75, 125)
triangle(125, 125, 150, 175, 175, 150)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeSierpinski [
	^ 'px = 300
size(px, px * sin(radians(60)) + 2)

def sierpinski(n, x, y, side):
	th = side * sin(radians(60))
	if n == 1:
		triangle(x, y + th, x + side, y + th, x + side / 2, y)
	elif n > 1:
		side = side / 2
		th = th / 2
		sierpinski(n - 1, x + side / 2, y, side)
		sierpinski(n - 1, x, y + th, side)
		sierpinski(n - 1, x + side, y + th, side)

background(255, 255, 255)
fill(0, 0, 0)
stroke(0, 0, 0)
strokeWeight(1)

sierpinski(4, 2, 2, width - 4)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeSwitzerland [
	"This is an example from the introductionary course and thus inaccurate in both color and proportion"
	^ 'size(200, 200)
background(255, 0, 0)
rect(75, 25, 50, 150)
rect(25, 75, 150, 50)'
]

{ #category : #example }
ProcessingSourceExamples >> sourceEndlessLoop [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeEndlessLoop.
	self assert: source asString equals: self sourceCodeEndlessLoop.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceExample02 [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeExample02.
	self assert: source asString equals: self sourceCodeExample02.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceExample03 [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeExample03.
	self assert: source asString equals: self sourceCodeExample03.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceExample04 [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeExample04.
	self assert: source asString equals: self sourceCodeExample04.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceExample05 [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeExample05.
	self assert: source asString equals: self sourceCodeExample05.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceFibonacci [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeFibonacci.
	self assert: source asString equals: self sourceCodeFibonacci.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceMinimal [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeMinimal.
	self assert: source asString equals: self sourceCodeMinimal.
	self assert: source program isNotNil.
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingSourceExamples >> sourcePrint [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodePrint.
	self assert: source asString equals: self sourceCodePrint.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceRecursion [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeRecursion.
	self assert: source asString equals: self sourceCodeRecursion.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceShapes [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeShapes.
	self assert: source asString equals: self sourceCodeShapes.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceSierpinski [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeSierpinski.
	self assert: source asString equals: self sourceCodeSierpinski.
	self assert: source program isNotNil.
	^ source
]

{ #category : #example }
ProcessingSourceExamples >> sourceSwitzerland [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeSwitzerland.
	self assert: source asString equals: self sourceCodeSwitzerland.
	self assert: source program isNotNil.
	^ source
]
