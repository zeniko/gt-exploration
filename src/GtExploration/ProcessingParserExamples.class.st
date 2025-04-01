Class {
	#name : #ProcessingParserExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> parseAlpinerWanderweg [
	<gtExample>
	| ast |
	ast := ProcessingParser parse: ProcessingProgramExamples new sourceAlpinerWanderweg.
	self assert: ast statements size equals: 4.
	self assert: (ast statements collect: [ :node | node expression receiver nameToken value ]) equals: (OrderedCollection newFrom: #('size' 'rect' 'fill' 'rect')).
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> parseExample02 [
	<gtExample>
	| ast node |
	ast := ProcessingParser parse: ProcessingProgramExamples new sourceExample02.
	self assert: ast statements size equals: 4.
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingParserExamples >> parseSize [
	<gtExample>
	| ast node |
	ast := ProcessingProgramExamples new testMinimal ast.
	self assert: ast statements size equals: 1.
	node := ast statements first.
	self assert: node asString equals: 'a PyExpressionStatementNode(size(200, 200))'.
	self assert: node expression receiver nameToken value equals: 'size'.
	^ ast
]
