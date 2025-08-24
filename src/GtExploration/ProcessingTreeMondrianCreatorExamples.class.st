Class {
	#name : #ProcessingTreeMondrianCreatorExamples,
	#superclass : #Object,
	#category : #'GtExploration-Examples'
}

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> allMondrianTrees [
	<gtExample>
	^ #(#Example03 #Lists #Minimal #PresentationDemo #Print #Sierpinski #Spiral #TurtleGraphics)
		collect: [ :name | 
			| ast mondrian |
			ast := ProcessingSourceExamples astFor: name.
			mondrian := ProcessingTreeMondrianCreator mondrianFor: ast.
			mondrian ]
]

{ #category : #example }
ProcessingTreeMondrianCreatorExamples >> astMondrianPresentationDemo [
	<gtExample>
	| mondrian program |
	program := ProcessingProgramExamples new programPresentationDemo.
	mondrian := ProcessingTreeMondrianCreator mondrianFor: program ast.
	^ mondrian
]
