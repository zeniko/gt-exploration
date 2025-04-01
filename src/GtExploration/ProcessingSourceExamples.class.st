Class {
	#name : #ProcessingSourceExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

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
ProcessingSourceExamples >> sourceCodeMinimal [
	<gtExample>
	^ 'size(200, 200)'
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
ProcessingSourceExamples >> sourceMinimal [
	<gtExample>
	| source |
	source := ProcessingSource new fromString: self sourceCodeMinimal.
	self assert: source asString equals: self sourceCodeMinimal.
	self assert: source program isNotNil.
	^ source
]
