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
		object: node; label: label; width: 7 * label size + 8) asItem.
	
	(aProgram gtGetASTChildren: node) do: [ :childNode |
		child := self addSubTree: childNode for: aProgram to: aScenery.
		aScenery addConnectionWithStencil: (GtSceneryStraightArcStencil new arrowHeadType: #none) from: item to: child.
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
			label: 'Root' translated;
			width: 40) asItem.
	
	(aProgram ast acceptVisitor: ProcessingTokenExtractor new) do: [ :childNode |
		child := self addSubTree: childNode for: aProgram to: scenery.
		scenery addConnectionWithStencil: (GtSceneryStraightArcStencil new arrowHeadType: #none) from: root to: child.
	].
	
	scenery onceLayout: GtGradHorizontalTreeLayout new.
	^ scenery
]
