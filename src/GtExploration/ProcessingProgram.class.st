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

{ #category : #'as yet unclassified' }
ProcessingProgram >> ast [
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> canvas [
	| runner promise |
	runner := ProcessingRunner new.
	promise := runner run: self.
	"TODO: make this customizeable"
	runner limitTo: 2 seconds.
	(promise wait isKindOf: AsyncFutureCancelled) ifTrue: [
		ProcessingRunawayProgramException new signal: 'Endless loop detected.'
	].
	^ runner canvas
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> compilation [
	^ compilation
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtBytecodeFor: aView [
	<gtView>
	^ compilation gtBytecodeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtOutputFor: aView [
	<gtView>
	^ compilation gtOutputFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtSourceCodeFor: aView [
	<gtView>
	^ compilation gtSourceCodeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtTreeFor: aView [
	<gtView>
	"^ ast gtExploreFor: aView"
	"copied from {{gtMethod:SmaCCParseNode>>#gtExploreFor:}}"
	| topParent |
	topParent := ast topParent.
	topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 5;
		title: 'Explore';
		stencil: [ | element editor tree |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			editor := ast
				gtSourceEditorWithHighlight: BrGlamorousColors neutralBackgroundColor.
			editor
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				beReadOnlyWithSelection;
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			element addChild: editor.
			(topParent gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | tree := e ].
			tree
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				aptitude: BrShadowAptitude;
				background: Color white;
				margin: (BlInsets all: 10).
			"expand the entire tree (for now); TODO: refined view"
			tree children second expandAll.
			element addChild: tree.
			topParent gtHookEditor: editor toTree: tree children last.
			element ]
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ compilation gtViewIntermediaryRepresentationFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> source [
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> source: aSource [
	source := aSource.
	ast := ProcessingParser parse: source asString.
	compilation := ProcessingTranspiler new compile: ast.
]
