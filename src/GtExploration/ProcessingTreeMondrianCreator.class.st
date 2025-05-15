Class {
	#name : #ProcessingTreeMondrianCreator,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #creating }
ProcessingTreeMondrianCreator class >> addSubTree: aNode for: aProgram to: aMondrian [
	| node next label |
	node := aNode.
	[ (node isKindOf: PyRootNode)
		and: [ (next := node acceptVisitor: ProcessingTokenExtractor new) size = 1 ] ]
		whileTrue: [ node := next first ].
	label := (node isKindOf: PyRootNode)
			ifTrue: [ (aProgram gtASTNodeNames at: node class) asRopedText foreground: Color lightGray ]
			ifFalse: [ node value asRopedText ].
	
	aMondrian nodes
		shape: [ :n | BlTextElement new
			text: label;
			padding: (BlInsets all: 3) ];
		with: { node. }.
	
	(aProgram gtGetASTChildren: node)
		do: [ :childNode |
			| child |
			child := self addSubTree: childNode for: aProgram to: aMondrian.
			aMondrian edges connect: { child. } from: [ :x | node ].
		].
	
	^ node
]

{ #category : #creating }
ProcessingTreeMondrianCreator class >> mondrianFor: aProgram [
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :n | BlTextElement new
			text: ('Root' translated asRopedText foreground: Color lightGray);
			padding: (BlInsets all: 5) ];
		with: { aProgram ast. }.
	
	(aProgram ast acceptVisitor: ProcessingTokenExtractor new)
		do: [ :childNode |
			| child |
			child := self addSubTree: childNode for: aProgram to: view.
			view edges connect: { child. } from: [ :x | aProgram ast ].
		].
	
	view layout horizontalTree nodeDistance: 7.
	^ view
]
