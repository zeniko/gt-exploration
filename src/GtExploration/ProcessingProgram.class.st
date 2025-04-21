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
	^ compilation gtBytecodeFor: aView
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
ProcessingProgram >> gtOutputFor: aView [
	<gtView>
	^ compilation gtOutputFor: aView
]

{ #category : #views }
ProcessingProgram >> gtSourceAstFor: aView [
	<gtView>
	"adapted from {{gtMethod:SmaCCParseNode>>#gtExploreFor:}}"
	ast topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 5;
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
ProcessingProgram >> gtSourceCodeFor: aView [
	<gtView>
	^ compilation gtSourceCodeFor: aView
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
	^ compilation gtViewIntermediaryRepresentationFor: aView
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
