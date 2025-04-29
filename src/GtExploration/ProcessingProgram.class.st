Class {
	#name : #ProcessingProgram,
	#superclass : #Object,
	#instVars : [
		'source',
		'compilation',
		'ast'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingProgram >> ast [
	^ ast
]

{ #category : #runtime }
ProcessingProgram >> canvas [
	| runner |
	runner := self run.
	(runner wait isKindOf: AsyncFutureCancelled) ifTrue: [
		ProcessingRunawayProgramException new signal: 'Endless loop detected.'
	].
	^ runner canvas
]

{ #category : #accessing }
ProcessingProgram >> compilation [
	^ compilation
]

{ #category : #views }
ProcessingProgram >> gtBytecodeFor: aView [
	<gtView>
	^ compilation _gtBytecodeFor: aView
]

{ #category : #views }
ProcessingProgram >> gtContentsFor: aView [
	<gtView>
	^ aView explicit
		priority: 5;
		title: 'Source';
		stencil: [ | editor |
			editor := ast
				gtSourceEditorWithHighlight: Color white.
			editor
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				beReadOnlyWithSelection;
				background: Color white.
			editor ]
]

{ #category : #views }
ProcessingProgram >> gtHookBytecode: anEditor toList: aList [
	"Adapted from SmaCCParseNode>>#gtHookEditor:toTree:"
	| highlightAttribute |
	highlightAttribute := (BlTextDecorationAttribute new underline)
		beNotOverwritableByStyler;
		color: BrGlamorousColors textHighlightColor;
		thickness: 3.
	
	aList
		when: BrSelectionChanged
		do:
			[ :anEvent | 
			aList
				selectedItemDo:
					[ :aItem |
					| item |
					item := aItem.
					(item isKindOf: SymbolicBytecode) ifTrue: [
						item := compilation _gtSliceForItem: item.
					].
					(item isKindOf: ProcessingTranspilationSlice)
						ifTrue:
							[ anEditor editor text clearAttributes: [ :attr | attr == highlightAttribute ].
							anEditor editor text
								attributes: {highlightAttribute}
								from: item astNode startPosition
								to: item astNode stopPosition.
							item astNode gtScrollToPosition: item astNode startPosition inEditor: anEditor ] ] ].
	
	anEditor editor
		when: BrTextEditorCursorMovedEvent
		do:
			[ :event | 
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil ifTrue: [ compilation _gtSelectBytecode: aList at: position ] ]
]

{ #category : #views }
ProcessingProgram >> gtOutputFor: aView [
	<gtView>
	^ compilation _gtOutputFor: aView
]

{ #category : #views }
ProcessingProgram >> gtSlicesFor: aView [
	<gtView>
	^ compilation _gtSlicesFor: aView
]

{ #category : #views }
ProcessingProgram >> gtSourceAstFor: aView [
	<gtView>
	"adapted from {{gtMethod:SmaCCParseNode>>#gtExploreFor:}}"
	ast topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'AST++';
		stencil: [ | element editor tree |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			(self gtContentsFor: GtPhlowView empty)
				asElementDo: [ :e | editor := e ].
			editor
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: editor.
			(self gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | tree := e ].
			tree
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: tree.
			ast topParent gtHookEditor: editor toTree: tree children last.
			element ]
]

{ #category : #views }
ProcessingProgram >> gtSourceBytecodeFor: aView [
	<gtView>
	^ aView explicit
		priority: 10;
		title: 'Bytecode++';
		stencil: [ | element child editor |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtContentsFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			editor := child.
			
			(self gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			self gtHookBytecode: editor toList: child.
			
			element ]
]

{ #category : #views }
ProcessingProgram >> gtSourceCodeFor: aView [
	<gtView>
	^ compilation _gtSourceCodeFor: aView
]

{ #category : #views }
ProcessingProgram >> gtTreeFor: aView [
	<gtView>
	| topParent |
	topParent := ast topParent.
	topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 5;
		title: 'AST';
		stencil: [ | tree |
			(topParent gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | tree := e ].
			tree
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ].
			"expand the entire tree (for now); TODO: refined view"
			tree children second expandAll.
			tree ]
]

{ #category : #views }
ProcessingProgram >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ compilation _gtViewIntermediaryRepresentationFor: aView
]

{ #category : #runtime }
ProcessingProgram >> run [
	^ self runFor: 2 seconds
]

{ #category : #runtime }
ProcessingProgram >> runFor: duration [
	^ ProcessingRunner new
		limitTo: duration;
		run: compilation;
		yourself
]

{ #category : #accessing }
ProcessingProgram >> source [
	^ source
]

{ #category : #initialization }
ProcessingProgram >> source: aSource [
	source := aSource.
	ast := ProcessingParser parse: source asString.
	compilation := ProcessingTranspiler new compile: ast.
]
