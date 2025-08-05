Class {
	#name : #ProcessingTreeMondrianCreatorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianExample03 [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programExample03.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianLists [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programLists.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianMinimal [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programMinimal.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianSierpinski [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programSierpinski.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianSpiral [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programSpiral.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianTurtleGraphics [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programTurtleGraphics.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]
