Class {
	#name : #ProcessingTreeMondrianCreatorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #'as yet unclassified' }
ProcessingTreeMondrianCreatorExamples >> astMondrianExample03 [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programExample03.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program.
	^ mondrian
]

{ #category : #'as yet unclassified' }
ProcessingTreeMondrianCreatorExamples >> astMondrianMinimal [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programMinimal.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program.
	^ mondrian
]
