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
	^ self new
		link: aNode
		method: nil
		from: from
		to: from
]

{ #category : #initialization }
ProcessingTranspilationSlice class >> link: aNode method: aName from: from to: to [
	^ self new
		link: aNode
		method: aName
		from: from
		to: to
]

{ #category : #views }
ProcessingTranspilationSlice >> asString [
	^ astNode topParent completeSource asString
		sliceFrom: astNode startPosition
		to: astNode stopPosition	"^ self slice: method sourceCode"
]

{ #category : #accessing }
ProcessingTranspilationSlice >> astNode [
	^ astNode
]

{ #category : #accessing }
ProcessingTranspilationSlice >> astNodeInterval [
	^ astNode startPosition to: astNode stopPosition
]

{ #category : #initalization }
ProcessingTranspilationSlice >> cloneFor: aMethod [
	^ self class
		link: astNode
		method: aMethod
		from: startPos
		to: startPos + size
]

{ #category : #views }
ProcessingTranspilationSlice >> gtComparisonFor: aView [
	<gtView>
	^ ((ViewComparison
		newFor: {self -> #gtSourceCodeFor:.
				self -> #gtTranspilationFor:}) gtCompareFor: aView)
		priority: 1;
		title: 'Comparison' translated
]

{ #category : #views }
ProcessingTranspilationSlice >> gtSourceCodeFor: aView [
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'Source' translated;
		stencil: [ (astNode gtSourceEditorWithHighlight: BrGlamorousColors textHighlightColor)
				beMode: BrTextEditorReadonlyWithNavigationMode new;
				yourself ]
]

{ #category : #views }
ProcessingTranspilationSlice >> gtTranspilationFor: aView [
	<gtView>
	^ aView explicit
		title: 'Transpilation' translated;
		priority: 11;
		stencil: [ | element |
			(GtPhlowView empty textEditor
				aptitude: BrGlamorousCodeEditorAptitude;
				styler: (BrRBTextStyler new classOrMetaClass: self method methodClass);
				text: [ | text |
					text := self method sourceCode asRopedText.
					(text from: self startPos to: startPos + size)
						attribute: (BlTextHighlightAttribute paint: BrGlamorousColors textHighlightColor)
								beNotOverwritableByStyler.
					text ]) asElementDo: [ :e | element := e ].
			element children first
				beMode: BrTextEditorReadonlyWithNavigationMode new;
				padding: (BlInsets all: 5).
			element ]
]

{ #category : #accessing }
ProcessingTranspilationSlice >> interval [
	^ startPos to: startPos + size
]

{ #category : #initalization }
ProcessingTranspilationSlice >> link: aNode method: aName from: from to: to [
	astNode := aNode.
	method := aName.
	startPos := from.
	size := to - from
]

{ #category : #accessing }
ProcessingTranspilationSlice >> method [
	^ method
]

{ #category : #changing }
ProcessingTranspilationSlice >> move: offset [
	startPos := startPos + offset
]

{ #category : #accessing }
ProcessingTranspilationSlice >> name: name [
	method := name
]

{ #category : #changing }
ProcessingTranspilationSlice >> setEnd: endPos [
	size := endPos - startPos
]

{ #category : #accessing }
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
