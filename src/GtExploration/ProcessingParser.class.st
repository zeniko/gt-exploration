Class {
	#name : #ProcessingParser,
	#superclass : #PythonParser,
	#category : #'GtExploration-Processing'
}

{ #category : #tool }
ProcessingParser class >> gtASTNodeNames [
	^ {PyAssertStatementNode -> 'Assert'.
		PyAssignmentExpressionNode -> 'Assignment'.
		PyAssignmentStatementNode -> 'Assignment'.
		PyBinaryExpressionNode -> 'Binary Op'.
		PyComparisonExpressionNode -> 'Binary Comparison'.
		PyElifNode -> 'Else if'.
		PyElseNode -> 'Else'.
		PyExpressionStatementNode -> 'Expression'.
		PyFileNode -> 'Root'.
		PyForStatementNode -> 'For Loop'.
		PyFunctionCallExpressionNode -> 'Function Call'.
		PyFunctionDefinitionNode -> 'Function Definition'.
		PyGlobalStatementNode -> 'Global Variables'.
		PyIfExpressionNode -> 'If Conditional'.
		PyIfStatementNode -> 'If Conditional'.
		PyNumberNode -> 'Number'.
		PyParameterNode -> 'Parameter'.
		PyPassStatementNode -> 'Pass'.
		PyReturnStatementNode -> 'Return'.
		PyStringNode -> 'String'.
		PyTupleExpressionNode -> 'Tuple'.
		PyUnaryExpressionNode -> 'Unary Op'.
		PyVariableExpressionNode -> 'Variable'.
		PyWhileStatementNode -> 'While Loop'} asDictionary
]

{ #category : #tool }
ProcessingParser class >> gtGetASTChildren: aNode [
	| extractor nodes |
	(aNode isKindOf: PyRootNode) ifFalse: [ ^ #() ].

	extractor := ProcessingTokenExtractor new.
	nodes := aNode acceptVisitor: extractor.
	[ nodes size = 1 and: [ nodes first isKindOf: PyRootNode ] ]
		whileTrue: [ nodes := nodes first acceptVisitor: extractor ].

	(nodes size = 1) not ifTrue: [ ^ nodes ].
	(nodes first isKindOf: PyRootNode) ifTrue: [ ^ nodes ].
	^ #()
]
