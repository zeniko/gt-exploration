Class {
	#name : #ProcessingParserFixer,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #visiting }
ProcessingParserFixer >> needsLeftAssociativityFix: expr [
	"Checks whether a binary expression has been parsed with right associativity where left associativity would be correct (only relevant, when multiple operators have the same precedence).
	
	Cf. https://www.geeksforgeeks.org/python/precedence-and-associativity-of-operators-in-python/"

	| leftAssocPrecedences selfp rightp |
	(expr right isKindOf: PyBinaryExpressionNode) ifFalse: [ ^ false ].

	leftAssocPrecedences := {'*' -> 6.
			'@' -> 6.
			'/' -> 6.
			'//' -> 6.
			'%' -> 6.
			'+' -> 7.
			'-' -> 7.
			'>>' -> 8.
			'<<' -> 8} asDictionary.

	selfp := leftAssocPrecedences at: expr operator value ifAbsent: -1.
	rightp := leftAssocPrecedences at: expr right operator value ifAbsent: -2.
	^ selfp = rightp
]

{ #category : #visiting }
ProcessingParserFixer >> visitBinaryExpression: expr [
	"PythonParser associates binary operations to the right instead of to the left (cf. https://github.com/feenkcom/gtoolkit/issues/4629)."

	[ self needsLeftAssociativityFix: expr ]
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
