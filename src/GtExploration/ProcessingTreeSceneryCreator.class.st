Class {
	#name : #ProcessingTreeSceneryCreator,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #creating }
ProcessingTreeSceneryCreator class >> addSubTree: aNode for: aProgram to: aScenery [
	| node next label item child |
	node := aNode.
	[ (node isKindOf: PyRootNode) and: [ (next := (node acceptVisitor: ProcessingTokenExtractor new)) size = 1 ] ] whileTrue: [
		node := next first.
	].
	label := (node isKindOf: PyRootNode) ifTrue: [
		aProgram gtASTNodeNames at: node class
	] ifFalse: [
		node value
	].
	item := aScenery addItem: (GtSceneryObjectLabelStencil new
		object: node; label: label) asItem.
	
	(aProgram gtGetASTChildren: node) do: [ :childNode |
		child := self addSubTree: childNode for: aProgram to: aScenery.
		aScenery addConnectionWithStencil: (GtSceneryColoredLineStencil new borderColor: Color veryLightGray) from: item to: child.
	].
	
	^ item
]

{ #category : #creating }
ProcessingTreeSceneryCreator class >> sceneryFor: aProgram [
	| scenery root child |
	scenery := GtScenery new.
	root := scenery
		addItem: (GtSceneryObjectLabelStencil new
			object: aProgram ast;
			label: 'Root' translated) asItem.
	
	(aProgram ast acceptVisitor: ProcessingTokenExtractor new) do: [ :childNode |
		child := self addSubTree: childNode for: aProgram to: scenery.
		scenery addConnectionWithStencil: (GtSceneryColoredLineStencil new borderColor: Color veryLightGray) from: root to: child.
	].
	
	scenery onceLayout: GtGradHorizontalTreeLayout new.
	^ scenery
]
