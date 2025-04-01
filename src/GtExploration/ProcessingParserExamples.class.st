Class {
	#name : #ProcessingParserExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> parseAlpinerWanderweg [
	<gtExample>
	| ast |
	ast := ProcessingParser parse: self sourceAlpinerWanderweg.
	self assert: ast statements size equals: 4.
	self assert: (ast statements collect: [ :node | node expression receiver nameToken value ]) equals: (OrderedCollection newFrom: #('size' 'rect' 'fill' 'rect')).
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> parseExample02 [
	<gtExample>
	| ast node |
	ast := ProcessingParser parse: self sourceExample02.
	self assert: ast statements size equals: 4.
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> parseSize [
	<gtExample>
	| ast node |
	ast := ProcessingParser parse: self sourceMinimal.
	self assert: ast statements size equals: 1.
	node := ast statements first.
	self assert: node asString equals: 'a PyExpressionStatementNode(size(200, 200))'.
	self assert: node expression receiver nameToken value equals: 'size'.
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> sourceAlpinerWanderweg [
	<gtExample>
	^ '
size(200, 200)
rect(50, 50, 100, 100)
fill(255, 0, 0)
rect(50, 50 + 100 / 3, 100, 100 / 3)
'
]

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> sourceExample02 [
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
ProcessingParserExamples >> sourceMinimal [
	<gtExample>
	^ 'size(200, 200)'
]
