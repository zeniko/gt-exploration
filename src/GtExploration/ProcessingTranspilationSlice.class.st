Class {
	#name : #ProcessingTranspilationSlice,
	#superclass : #Object,
	#instVars : [
		'astNode',
		'method',
		'startPos',
		'size'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingTranspilationSlice class >> link: aNode from: from [
	^ self new link: aNode method: nil from: from to: from
]

{ #category : #initialization }
ProcessingTranspilationSlice class >> link: aNode method: aName from: from to: to [
	^ self new link: aNode method: aName from: from to: to
]

{ #category : #views }
ProcessingTranspilationSlice >> asString [
	^ self slice: method sourceCode
]

{ #category : #accessing }
ProcessingTranspilationSlice >> astNode [
	^ astNode
]

{ #category : #initalization }
ProcessingTranspilationSlice >> cloneFor: aMethod [
	^ self class link: astNode method: aMethod from: startPos to: startPos + size
]

{ #category : #accessing }
ProcessingTranspilationSlice >> endPos [
	^ startPos + size
]

{ #category : #views }
ProcessingTranspilationSlice >> gtComparisonFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Comparison' translated;
		stencil: [ | element child |
			element := BlElement new.
			element
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtSourceFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			
			(self gtTranspilationFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			element ]
]

{ #category : #views }
ProcessingTranspilationSlice >> gtSourceFor: aView [
	"Adapted from SmaCCParseNode>>#gtSourceFor:"
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'Source' translated;
		stencil: [ astNode gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor ]
]

{ #category : #views }
ProcessingTranspilationSlice >> gtTranspilationFor: aView [
	"Adapted from SymbolicBytecode>>#gtSourceFor:"
	<gtView>
	^ aView textEditor
		title: 'Transpilation' translated;
		aptitude: BrGlamorousCodeEditorAptitude;
		styler: (BrRBTextStyler new classOrMetaClass: self method methodClass);
		priority: 11;
		text: [ | text |
			text := self method sourceCode asRopedText.
			(text from: self startPos to: startPos + size)
				attributes:
					{(BlTextUnderlineAttribute new
						color: BrGlamorousColors textHighlightColor;
						thickness: 3;
						beNotOverwritableByStyler)}.
			text ]
]

{ #category : #initalization }
ProcessingTranspilationSlice >> link: aNode method: aName from: from to: to [
	astNode := aNode.
	method := aName.
	startPos := from.
	size := to - from.
]

{ #category : #accessing }
ProcessingTranspilationSlice >> method [
	^ method
]

{ #category : #changing }
ProcessingTranspilationSlice >> move: offset [
	startPos := startPos + offset.
]

{ #category : #'as yet unclassified' }
ProcessingTranspilationSlice >> name: name [
	method := name.
]

{ #category : #changing }
ProcessingTranspilationSlice >> setEnd: endPos [
	size := endPos - startPos
]

{ #category : #'as yet unclassified' }
ProcessingTranspilationSlice >> size [
	^ size
]

{ #category : #accessing }
ProcessingTranspilationSlice >> slice: source [
	^ source copyFrom: startPos to: startPos + size
]

{ #category : #accessing }
ProcessingTranspilationSlice >> startPos [
	^ startPos
]
