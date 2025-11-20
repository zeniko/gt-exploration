"
This helper class creates a Mondrian tree from a Processing/Python AST.
"
Class {
	#name : 'ProcessingTreeMondrianCreator',
	#superclass : 'Object',
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'creating' }
ProcessingTreeMondrianCreator class >> addSubTree: aNode for: ast to: aMondrian [
	| node next label |
	node := aNode.
	[ (node isKindOf: PyRootNode)
		and: [ (next := node acceptVisitor: ProcessingTokenExtractor new) size = 1 ] ]
		whileTrue: [ node := next first ].
	label := (node isKindOf: PyRootNode)
			ifTrue: [ (ProcessingParser gtASTNodeNames at: node class) asRopedText
					foreground: Color lightGray ]
			ifFalse: [ node value asRopedText ].

	aMondrian nodes
		shape: [ :n | 
			BlTextElement new
				text: label;
				padding: (BlInsets all: 3) ];
		with: {node}.

	(ProcessingParser gtGetASTChildren: node)
		do: [ :childNode | 
			| child |
			child := self
					addSubTree: childNode
					for: ast
					to: aMondrian.
			aMondrian edges connect: {child} from: [ :x | node ] ].
	^ node
]

{ #category : 'creating' }
ProcessingTreeMondrianCreator class >> mondrianFor: ast [
	| view |
	view := GtMondrian new.
	view nodes
		shape: [ :n | 
			BlTextElement new
				text: ('Root' translated asRopedText foreground: Color lightGray);
				padding: (BlInsets all: 5) ];
		with: {ast}.

	(ast acceptVisitor: ProcessingTokenExtractor new)
		do: [ :childNode | 
			| child |
			child := self
					addSubTree: childNode
					for: ast
					to: view.
			view edges connect: {child} from: [ :x | ast ] ].

	view layout horizontalTree nodeDistance: 7.
	^ view
]
