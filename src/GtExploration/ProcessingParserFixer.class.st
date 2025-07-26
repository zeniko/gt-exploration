Class {
	#name : #ProcessingParserFixer,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #visiting }
ProcessingParserFixer >> needsLeftAssociationFix: expr [
	"Checks whether a binary expression has been parsed with right association where left association would be correct."

	| leftAssocPrecedences selfp rightp |
	(expr right isKindOf: PyBinaryExpressionNode) ifFalse: [ ^ false ].

	leftAssocPrecedences := {'+' -> 3.
			'-' -> 3.
			'*' -> 4.
			'/' -> 4.
			'%' -> 4} asDictionary.	"TODO: complete"

	selfp := leftAssocPrecedences at: expr operator value ifAbsent: -1.
	rightp := leftAssocPrecedences at: expr right operator value ifAbsent: -2.
	^ selfp = rightp
]

{ #category : #visiting }
ProcessingParserFixer >> visitBinaryExpression: expr [
	"PythonParser associates binary operations to the right instead of (partly) to the left."

	[ self needsLeftAssociationFix: expr ]
		whileTrue: [ | a b c op1 op2 |
			a := expr left.
			op1 := expr operator.
			b := expr right left.
			op2 := expr right operator.
			c := expr right right.

			expr left: expr right.
			expr left left: a.
			expr left operator: op1.
			expr left right: b.
			expr operator: op2.
			expr right: c.

			a parent: expr left.
			b parent: expr left.
			c parent: expr ].

	^ self visitExpression: expr
]
