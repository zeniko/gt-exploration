Class {
	#name : #ProcessingProgram,
	#superclass : #Object,
	#instVars : [
		'source',
		'compilation',
		'ast',
		'announcer'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #announcements }
ProcessingProgram >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

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
ProcessingProgram >> gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Abstractions' translated;
		stencil: [ | element child editor astTree |
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
			
			(self gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			astTree := child children last.
			self ast topParent gtHookEditor: editor toTree: astTree.
			
			(self gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			self gtHookEditor: editor toBytecode: child children last.
			"Oneway hook bytecode to the AST tree"
			self gtOnListSelect: child children last do: [ :astNode |
				astNode gtSelectItemIn: astTree at: astNode startPosition
			].
			
			(self gtOutputFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			"TODO: Hook into editor"
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtBytecodeFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtBytecodeFor: view ]
		title: 'Bytecode' translated
		priority: 15
]

{ #category : #views }
ProcessingProgram >> gtContentsFor: aView [
	<gtView>
	^ aView explicit
		priority: 2;
		title: 'Source' translated;
		stencil: [ | editor |
			editor := ast
				gtSourceEditorWithHighlight: Color white.
			editor
				constraintsDo: [ :e |
					e vertical matchParent.
					e horizontal matchParent ];
				beReadOnlyWithSelection;
				background: Color white.
			editor ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtGetLiveView: aView for: aBlock title: aTitle priority: aPriority [
	^ aView explicit
		title: aTitle;
		priority: aPriority;
		stencil: [
			| element |
			(aBlock cull: GtPhlowView empty)
				asElementDo: [ :e | element := e ].
			element
				constraintsDo: [ :e |
					e vertical matchParent.
					e horizontal matchParent ];
				yourself
		];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtHookEditor: anEditor toBytecode: aList [
	| highlightAttribute |
	highlightAttribute := (BlTextDecorationAttribute new underline)
		beNotOverwritableByStyler;
		color: BrGlamorousColors textHighlightColor;
		thickness: 3.
	
	self gtOnListSelect: aList do: [ :astNode |
		anEditor editor text clearAttributes: [ :attr | attr == highlightAttribute ].
		anEditor editor text
			attributes: { highlightAttribute }
			from: astNode startPosition
			to: astNode stopPosition.
		astNode gtScrollToPosition: astNode startPosition inEditor: anEditor
	].
	
	self gtOnEditorChange: anEditor do: [ :position | compilation gtSelectBytecode: aList at: position ]
]

{ #category : #views }
ProcessingProgram >> gtHookEditor: anEditor toIR: aList [
	| highlightAttribute |
	highlightAttribute := (BlTextDecorationAttribute new underline)
		beNotOverwritableByStyler;
		color: BrGlamorousColors textHighlightColor;
		thickness: 3.
	
	self gtOnListSelect: aList do: [ :astNode |
		anEditor editor text clearAttributes: [ :attr | attr == highlightAttribute ].
		anEditor editor text
			attributes: { highlightAttribute }
			from: astNode startPosition
			to: astNode stopPosition.
		astNode gtScrollToPosition: astNode startPosition inEditor: anEditor
	].
	
	self gtOnEditorChange: anEditor do: [ :position | compilation gtSelectIRNode: aList at: position ]
]

{ #category : #views }
ProcessingProgram >> gtIntermediaryRepresentationFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtViewIntermediaryRepresentationFor: view ]
		title: 'IR'
		priority: 10
]

{ #category : #views }
ProcessingProgram >> gtOnEditorChange: anEditor do: aBlock [
	anEditor editor
		when: BrTextEditorCursorMovedEvent
		do: [ :event |
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil ifTrue: [ aBlock cull: position ]
		]
]

{ #category : #views }
ProcessingProgram >> gtOnListSelect: aList do: aBlock [
	aList
		when: BrSelectionChanged
		do: [ :anEvent |
			aList selectedItemDo: [ :aItem |
				| item |
				item := aItem.
				(item isKindOf: SymbolicBytecode) ifTrue: [
					item := compilation gtSliceForItem: item.
				].
				(item isKindOf: IRInstruction) ifTrue: [
					item := compilation gtSliceForIRItem: item.
				].
				(item isKindOf: ProcessingTranspilationSlice) ifTrue: [
					item := item astNode.
				].
				((item isKindOf: SmaCCParseNode) or: [ item isKindOf: SmaCCToken ]) ifTrue: [
					aBlock cull: item.
				].
			]
		].
	
]

{ #category : #views }
ProcessingProgram >> gtOnTreeSelect: aTree do: aBlock [
	aTree
		when: BrSelectionChanged
		do: [ :anEvent |
			aTree selectedNodeDo: [ :aNode |
				| item |
				item := aNode value last.
				(item isKindOf: SymbolicBytecode) ifTrue: [
					item := compilation gtSliceForItem: item.
				].
				(item isKindOf: ProcessingTranspilationSlice) ifTrue: [
					item := item astNode.
				].
				((item isKindOf: SmaCCParseNode) or: [ item isKindOf: SmaCCToken ]) ifTrue: [
					aBlock cull: item.
				].
			]
		].
	
]

{ #category : #views }
ProcessingProgram >> gtOutputFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtOutputFor: view ]
		title: 'Output' translated
		priority: 20
]

{ #category : #views }
ProcessingProgram >> gtSlicesFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtSlicesFor: view ]
		title: 'Slices' translated
		priority: 7
]

{ #category : #views }
ProcessingProgram >> gtSourceAstFor: aView [
	<gtView>
	"adapted from {{gtMethod:SmaCCParseNode>>#gtExploreFor:}}"
	ast topParent completeSource isNil
		ifTrue: [ ^ aView empty ].
	^ aView explicit
		priority: 6;
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
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtSourceBytecodeFor: aView [
	<gtView>
	^ aView explicit
		priority: 16;
		title: 'Bytecode' translated , '++';
		stencil: [ | element child editor |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
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
			
			(compilation gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			self gtHookEditor: editor toBytecode: child children last.
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtSourceCodeFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtSourceCodeFor: view ]
		title: 'Smalltalk'
		priority: 8
]

{ #category : #views }
ProcessingProgram >> gtSourceIntermediaryRepresentationFor: aView [
	<gtView>
	^ aView explicit
		priority: 11;
		title: 'IR++';
		stencil: [ | element child editor |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
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
			
			(compilation gtViewIntermediaryRepresentationFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			self gtHookEditor: editor toIR: child children last.
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTreeFor: aView [
	<gtView>
	^ aView explicit
		priority: 5;
		title: 'AST';
		stencil: [ | tree |
			(ast topParent gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | tree := e ].
			tree
				constraintsDo: [ :e |
					e vertical matchParent.
					e horizontal matchParent ].
			"expand the entire tree (for now); TODO: refined view"
			tree children last expandAll.
			tree ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #runtime }
ProcessingProgram >> run [
	^ self runFor: 2 seconds
]

{ #category : #runtime }
ProcessingProgram >> runFor: duration [
	^ ProcessingRunner new
		limitTo: duration;
		run: compilation clone;
		yourself
]

{ #category : #runtime }
ProcessingProgram >> runSteps [
	^ self runStepsFor: 2 seconds
]

{ #category : #runtime }
ProcessingProgram >> runStepsFor: duration [
	| runner steps |
	runner := ProcessingRunner new.
	steps := runner limitTo: duration; runStepwise: compilation clone.
	runner isDone ifFalse: [
		ProcessingRunawayProgramException new signal: 'Endless loop detected.'
	].
	^ steps
]

{ #category : #accessing }
ProcessingProgram >> source [
	^ source
]

{ #category : #initialization }
ProcessingProgram >> source: aSource [
	source ifNotNil: [ ProcessingCompileTimeException new signal: 'Reassigning ProcessingProgram>>#source isn''t supported!' ].
	
	source := aSource.
	ast := ProcessingParser parse: source asString.
	compilation := ProcessingTranspiler new compile: ast.
	
	source announcer when: ProcessingSourceChanged do: [ :event |
		[
			compilation := ProcessingTranspiler new compile: event ast.
			ast := event ast.
			self announcer announce: (ProcessingProgramChanged new program: self).
		] on: Error do: [ :error |
			"TODO: error handling?"
			Transcript nextPut: error asString , '
'.
		].
	] for: self.
]
