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

{ #category : #'as yet unclassified' }
ProcessingTreeMondrianCreatorExamples >> astMondrianSierpinski [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programSierpinski.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program.
	^ mondrian
]

{ #category : #'as yet unclassified' }
ProcessingTreeMondrianCreatorExamples >> astMondrianSpiral [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programSpiral.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program.
	^ mondrian
]

{ #category : #'as yet unclassified' }
ProcessingTreeMondrianCreatorExamples >> astMondrianTurtleGraphics [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programTurtleGraphics.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program.
	^ mondrian
]
