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
	| runner result |
	runner := self run.
	result := runner wait.
	(result isKindOf: AsyncFutureCancelled) ifTrue: [
		ProcessingRunawayProgramException new signal: 'Endless loop detected.'
	].
	(result isKindOf: Error) ifTrue: [
		result signal.
	].
	^ runner canvas
]

{ #category : #accessing }
ProcessingProgram >> compilation [
	^ compilation
]

{ #category : #views }
ProcessingProgram >> gtASTTokensFor: aView [
	<gtView>
	^ aView columnedList
		title: 'AST Tokens';
		priority: 4;
		items: [ PythonASTBuilder new extractTokens: ast ];
		column: 'Line' translated
			text: [ :each |
				(source asString copyFrom: 1 to: each startPosition) lineCount asRopedText foreground: Color gray
			] width: 45;
		column: 'Indentation' translated
			text: [ :each |
				| line indent ch |
				line := (source asString copyFrom: 1 to: each startPosition) lines last readStream.
				indent := 0.
				[ line atEnd not and: [ (ch := line next) isSeparator ] ] whileTrue: [
					indent := indent + (ch = Character tab ifTrue: [ 8 - (indent \\ 8) ] ifFalse: [ 1 ])
				].
				indent asRopedText foreground: Color gray
			] width: 45;
		column: 'Token'
			text: [ :each | each value ];
		updateWhen: ProcessingSourceChanged in: source announcer
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
	^ self gtGetLiveView: aView for: [ :view | compilation gtIntermediaryRepresentationFor: view ]
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
			aList selectedItemDo: [ :anItem |
				| item |
				item := anItem.
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
ProcessingProgram >> gtSourceBytesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Source Bytes' translated;
		priority: 3;
		items: [ source asString ];
		column: 'Index' translated
			text: [ :each :index | 
				index asRopedText foreground: Color gray ]
			width: 45;
		column: 'Character' translated
			text: [ :each | (each gtDisplayString removePrefix: 'Character ') removePrefix: '$' ];
		column: 'ASCII'
			text: [ :each | each asciiValue ];
		column: 'HEX'
			text: [ :each | (each asciiValue radix: 16) padLeftTo: 2 with: $0 ];
		updateWhen: ProcessingSourceChanged in: source announcer
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
			
			(compilation gtIntermediaryRepresentationFor: GtPhlowView empty)
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
ProcessingProgram >> gtSourceSourceBytesFor: aView [
	<gtView>
	^ aView explicit
		title: 'Source Bytes' translated;
		priority: 3;
		stencil: [
		| container list editor |
		container := BlElement new
			constraintsDo: [:c | 
				c vertical matchParent. 
				c horizontal matchParent. ];
			margin: (BlInsets top: 10 bottom: 10);
			layout: (BlLinearLayout horizontal cellSpacing: 10).
		editor := BrEditorElement new
				constraintsDo: [ :c | 
					c vertical matchParent. 
					c horizontal matchParent.
					c linear weight: 2. ];
				editor: (BrTextEditorModel new
				text: (source asString asRopedText glamorousCodeFont);
				when: BrTextEditorCursorMovedEvent do: [:e | 
					list selectOne: (e newIndex + 1 max: 1).
					list children first scrollToPosition: (e newIndex + 1 clampBetween: 1 and: source asString size - 1) ];
				when: BrTextEditorCursorAddedEvent do: [:e | 
					list selectOne: (e cursor position + 1 max: 1).
					list children first scrollToPosition: (e cursor position + 1 clampBetween: 1 and: source asString size - 1) ]).
		container addChild: editor.
		
		list := BrColumnedList new
			rowStencil: (BrGlamorousColumnedListSelectableRowElementStencilBuilder new);
			constraintsDo: [:c | 
				c vertical matchParent. 
				c horizontal matchParent ];
			
			items: source asString asOrderedCollection;
			when: BrSelectionChanged do: [ :event | 
				event selectedInterval ifNotNil: [ 
					editor editor text clearAttributes: [ :each | each isKindOf: BlTextHighlightAttribute ].
					(editor editor text from: event selectedInterval first to: event selectedInterval last)
						attribute: (BlTextHighlightAttribute new paint: BrGlamorousColors textHighlightColor "result: (editor editor text at: event selectedInterval first)")] ].
		list column
			title: 'Index';
			width: 35;
			stencil: [ :char :index | BrColumnCellLabelStencil new text: (index asString asRopedText glamorousRegularFont; foreground: Color gray; fontSize: 12)].
		list column
			title: 'Char';
			width: 45;
			stencil: [ :char | BrColumnCellLabelStencil new text: (((char gtDisplayString removePrefix: 'Character ') removePrefix: '$') asRopedText glamorousRegularFont; fontSize: 12)].
		list column
			title: 'ASCII';
			width: 45;
			stencil: [ :char | BrColumnCellLabelStencil new text: ((char asciiValue asString) asRopedText glamorousRegularFont; fontSize: 12)].
		list column
			title: 'HEX';
			width: 45;
			stencil: [ :char | BrColumnCellLabelStencil new text: ((((char asciiValue radix: 16) padLeftTo: 2 with: $0) asString) asRopedText glamorousRegularFont; fontSize: 12)].
		container addChild: list.
		
		container 
		];
	updateWhen: ProcessingSourceChanged in: source announcer
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
			"silently swallow errors on updates, as these happen intermittently during incomplete/slow typing"
		].
	] for: self.
]
