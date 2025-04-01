Class {
	#name : #ProcessingProgramExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> sourceAlpinerWanderweg [
	<gtExample>
	^ '
size(200, 200)
rect(50, 50, 100, 100)
fill(255, 0, 0)
rect(50, 50 + 100 / 3, 100, 100 / 3)
'
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> sourceExample02 [
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
ProcessingProgramExamples >> sourceMinimal [
	<gtExample>
	^ 'size(200, 200)'
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> testAlpinerWanderweg [
	<gtExample>
	| program |
	program := ProcessingProgram new source: self sourceAlpinerWanderweg.
	self assert: program source equals: self sourceAlpinerWanderweg.
	self assert: program ast statements size equals: 4.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> testExample02 [
	<gtExample>
	| program |
	program := ProcessingProgram new source: self sourceExample02.
	self assert: program source equals: self sourceExample02.
	self assert: program ast statements size equals: 4.
	self assert: program compilation isNotNil.
	^ program
]

{ #category : #'as yet unclassified' }
ProcessingProgramExamples >> testMinimal [
	<gtExample>
	| program canvas |
	program := ProcessingProgram new source: self sourceMinimal.
	self assert: program source equals: self sourceMinimal.
	self assert: program ast statements size equals: 1.
	self assert: program compilation isNotNil.
	^ program
]
