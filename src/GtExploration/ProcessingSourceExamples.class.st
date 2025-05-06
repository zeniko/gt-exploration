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

{ #category : #example }
ProcessingSourceExamples >> sourceAnimation [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeAnimation.
	self assert: source asString equals: self sourceCodeAnimation.
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
ProcessingSourceExamples >> sourceCodeAnimation [
	^ 'var = 0

def setup():
	size(200, 200)
	frameRate(2)

def draw():
	global var
	background(192)
	rect(var, var, 50, 50)
	var = var + 20
	if var > height - 50:
		var = 0
'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeEndlessLoop [
	^ 'while True: pass'
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
    x = (random(2) ** 2 * sin(radians(270))) % 3
def setY():
	...
setX()
text(x, 0, 20)'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeExample05 [
	^ 'size(200, 100)
gtA := width; gtB := height'
]

{ #category : #source }
ProcessingSourceExamples >> sourceCodeExample06 [
	^ 'cond = True and False or not 1 == 2 > 3
var = 5 if cond else 3
for x in range(1, var):
	print(x)'
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
	^ 'print("Hello," '' world!'')
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

{ #category : #source }
ProcessingSourceExamples >> sourceCodeTurtleGraphics [
	^ 'size(400, 400)
draw_n_eck(5)

move(0, height / 2, 0)
kochpart(width, int(width / 3 ** 4))

def draw_n_eck(n):
	w = width / n * 3
	move((width - w) / 2, 10, 0)
	i = 0
	while i < n:
		fwd(w)
		turn(360 / n)
		i = i + 1

def kochpart(siz, limit):
	if siz < limit:
		fwd(siz)
		return
	
	kochpart(siz / 3, limit)
	turn(-60)
	kochpart(siz / 3, limit)
	turn(120)
	kochpart(siz / 3, limit)
	turn(-60)
	kochpart(siz / 3, limit)

# ****************************************** #
# Schildkrötenbefehle: move, fwd, turn       #
# ****************************************** #

# x-/y-Koordinate der Schildkröte und Blickrichtung
t_x = 0
t_y = 0
t_angle = 0

# verschiebt die Schildkröte (angle gibt die Blickrichtung an)
def move(x, y, angle):
	global t_x, t_y, t_angle
	t_x = x
	t_y = y
	t_angle = angle

# bewegt die Schildkröte um d nach vorne
def fwd(d):
	global t_x, t_y
	oldX = t_x
	oldY = t_y
	t_x = t_x + d * cos(radians(t_angle))
	t_y = t_y + d * sin(radians(t_angle))
	line(oldX, oldY, t_x, t_y)

# dreht die Schildkröte um angle Grad
def turn(angle):
	global t_angle
	t_angle = t_angle + angle'
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
ProcessingSourceExamples >> sourceExample06 [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeExample06.
	self assert: source asString equals: self sourceCodeExample06.
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

{ #category : #example }
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

{ #category : #example }
ProcessingSourceExamples >> sourceTurtleGraphics [
	<gtExample>
	| source |
	source := ProcessingSource fromString: self sourceCodeTurtleGraphics.
	self assert: source asString equals: self sourceCodeTurtleGraphics.
	self assert: source program isNotNil.
	^ source
]
