"
This is a thin subclass of {{gtClass:PythonParser}} for parsing Processing programs in Python syntax.
"
Class {
	#name : 'ProcessingParser',
	#superclass : 'PythonParser',
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'tool' }
ProcessingParser class >> gtASTNodeNames [
	^ {PyAssertStatementNode -> 'Assert'.
		PyAssignmentExpressionNode -> 'Assignment'.
		PyAssignmentStatementNode -> 'Assignment'.
		PyBinaryExpressionNode -> 'Binary Op'.
		PyComparisonExpressionNode -> 'Binary Comparison'.
		PyEllipsisNode -> 'Ellipsis'.
		PyElifNode -> 'Else if'.
		PyElseNode -> 'Else'.
		PyExpressionStatementNode -> 'Expression'.
		PyFieldAccessExpressionNode -> 'Field Access'.
		PyFileNode -> 'Root'.
		PyForStatementNode -> 'For Loop'.
		PyFunctionCallExpressionNode -> 'Function Call'.
		PyFunctionDefinitionNode -> 'Function Definition'.
		PyGlobalStatementNode -> 'Global Variables'.
		PyIfExpressionNode -> 'If Conditional'.
		PyIfStatementNode -> 'If Conditional'.
		PyListExpressionNode -> 'List'.
		PyNumberNode -> 'Number'.
		PyParameterNode -> 'Parameter'.
		PyPassStatementNode -> 'Pass'.
		PyReturnStatementNode -> 'Return'.
		PySliceNode -> 'Slice'.
		PyStringNode -> 'String'.
		PySubscriptExpressionNode -> 'Subscript'.
		PyTupleExpressionNode -> 'Tuple'.
		PyUnaryExpressionNode -> 'Unary Op'.
		PyVariableExpressionNode -> 'Variable'.
		PyWhileStatementNode -> 'While Loop'} asDictionary
]

{ #category : 'tool' }
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
