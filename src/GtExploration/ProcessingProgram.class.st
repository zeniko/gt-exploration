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
		ProcessingRunTimeException new tag: result; signal.
	].
	^ runner canvas
]

{ #category : #accessing }
ProcessingProgram >> compilation [
	^ compilation
]

{ #category : #runtime }
ProcessingProgram >> debug [
	^ ProcessingRunner new debug: compilation clone
]

{ #category : #views }
ProcessingProgram >> gtAbstractionsFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Abstractions' translated;
		stencil: [ | element child editor astTree list canvas |
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
			
			(self gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			list := child children last.
			
			(self gtOutputFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			canvas := child.
			
			"Hook AST tree and source view:"
			"self ast topParent gtHookEditor: editor toTree: astTree."
			self gtOnTreeSelect: astTree do: [ :astNode |
				self gtEditorHightlight: editor from: astNode startPosition to: astNode stopPosition.
			].
			self gtOnEditorChange: editor do: [ :position |
				self gtSelectTreeNode: astTree at: position.
			].
			
			"Hook bytecode list and source view:"
			self gtOnListSelect: list do: [ :astNode |
				self gtEditorHightlight: editor from: astNode startPosition to: astNode stopPosition.
			].
			self gtOnEditorChange: editor do: [ :position |
				self gtSelectBytecode: list at: position.
			].
			"Oneway hook bytecode list to AST tree"
			self gtOnListSelect: list do: [ :astNode |
				self gtSelectTreeNode: astTree at: astNode startPosition
				"astNode gtSelectItemIn: astTree at: astNode startPosition"
			].
			
			"Hook canvas into editor"
			"self gtExplain: canvas in: editor."
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtBytecodeFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtBytecodeFor: view ]
		title: 'Bytecode' translated
		priority: 35
]

{ #category : #views }
ProcessingProgram >> gtBytecodePlusIRFor: aView [
	<gtView>
	^ aView explicit
		priority: 37;
		title: 'Bytecode' translated , '+IR';
		stencil: [ | element child list irList skipOne |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtIntermediaryRepresentationFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			irList := child children last.
			
			(self gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			list := child children last.
			
			"Prevent auto-selecting feedback changes."
			skipOne := false.
			list when: BrSelectionChanged do: [ :event |
				skipOne ifFalse: [
					skipOne := true.
					list selectedItemDo: [ :item |
						(item isKindOf: SymbolicBytecode) ifTrue: [
							self gtSelectListItem: irList with: [ :irItem |
								(irItem isKindOf: IRInstruction) and: [ irItem sourceNode isNotNil and: [
									(irItem sourceNode methodNode sourceCode = item method sourceCode) &
									(item sourceInterval includesAll: irItem sourceNode sourceInterval)
								] ]
							].
						].
					].
					skipOne := false.
				].
			].
			irList when: BrSelectionChanged do: [ :event |
				skipOne ifFalse: [
					skipOne := true.
					irList selectedItemDo: [ :irItem |
						((irItem isKindOf: IRInstruction) and: [ irItem sourceNode isNotNil ]) ifTrue: [
							self gtSelectListItem: list with: [ :item |
								(item isKindOf: SymbolicBytecode) and: [
									(item method sourceCode = irItem sourceNode methodNode sourceCode) &
									(irItem sourceNode sourceInterval includesAll: item sourceInterval)
								]
							].
						].
					].
					skipOne := false.
				].
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtBytecodePlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 36;
		title: 'Bytecode' translated , '++';
		stencil: [ | element editor list |
			element := self gtCombineWithSource: (compilation gtBytecodeFor: GtPhlowView empty).
			
			editor := element children first.
			list := element children last children last.
			
			self gtOnListSelect: list do: [ :astNode |
				self gtEditorHightlight: editor from: astNode startPosition to: astNode stopPosition.
			].
			self gtOnEditorChange: editor do: [ :position |
				self gtSelectBytecode: list at: position.
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtCombineWithSource: aView [
	| element child |
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
	
	aView
		asElementDo: [ :e | child := e ].
	child
		constraintsDo: [ :c |
			c vertical matchParent.
			c horizontal matchParent ];
		margin: (BlInsets all: 5).
	element addChild: child.
	
	^ element
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
				beMode: BrTextEditorReadonlyWithNavigationMode new;
				background: Color white.
			editor ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowExplicitTool new
			withIconAptitude;
			icon: BrGlamorousVectorIcons playAsynchronous;
			stencil: [
				BlContainerWithHeaderElement new
					headerText: (self asString, ': ' , 'Abstractions' translated) asRopedText;
					addChild: (GtInspector forObject: self viewSelector: #gtAbstractionsFor:)
			]);
		addTool: (GtPhlowExplicitTool new
			withIconAptitude;
			icon: BrGlamorousVectorIcons play;
			stencil: [
				BlContainerWithHeaderElement new
					headerText: (self asString , ': ' , 'Output' translated) asRopedText;
					addChild: (GtInspector forObject: self viewSelector: #gtOutputFor:)
			]);
		addTool: super gtDefaultInspectorTool
]

{ #category : #views }
ProcessingProgram >> gtEditorHightlight: anEditor from: from to: to [
	anEditor editor text clearAttributes: [ :each | each isKindOf: BlTextHighlightAttribute ].
	(anEditor editor text from: from to: to)
		attribute: (BlTextHighlightAttribute new paint: BrGlamorousColors textHighlightColor).
	
	anEditor scrollToPosition: (anEditor text asString lineNumberCorrespondingToIndex: from).
]

{ #category : #views }
ProcessingProgram >> gtExplain: aCanvas in: anEditor [
	| seen |
	aCanvas firstCommonParent: anEditor ifFound: [ :el |
		el explainer isExplanationHolder: true.
	] ifNone: [ ^ nil ].
	
	seen := Set new.
	aCanvas when: ProcessingExplainShape do: [ :event |
		| slice |
		slice := compilation gtSliceFor: event sourceNode methodNode within: event sourceNode sourceInterval.
		ProcessingCanvas explainShape: event source as: slice.
		
		(seen includes: slice) ifFalse: [
			"TODO: this block is called from a ProcessingRunner worker - pass the editor manipulation back to the UI thread"
			(anEditor text from: slice astNode receiver startPosition to: slice astNode receiver stopPosition) glamorousExplanationFor: slice.
			seen add: slice.
		].
	].
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
ProcessingProgram >> gtIntermediaryRepresentationFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtIntermediaryRepresentationFor: view ]
		title: 'IR'
		priority: 30
]

{ #category : #views }
ProcessingProgram >> gtIntermediaryRepresentationPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 31;
		title: 'IR++';
		stencil: [ | element editor list |
			element := self gtCombineWithSource: (compilation gtIntermediaryRepresentationFor: GtPhlowView empty).
			
			editor := element children first.
			list := element children last children last.
			
			self gtOnListSelect: list do: [ :astNode |
				self gtEditorHightlight: editor from: astNode startPosition to: astNode stopPosition.
			].
			self gtOnEditorChange: editor do: [ :position |
				self gtSelectIRNode: list at: position.
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtOnEditorChange: anEditor do: aBlock [
	anEditor editor
		when: BrTextEditorCursorMovedEvent do: [ :event |
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil ifTrue: [ aBlock cull: position ]
		];
		when: BrTextEditorCursorAddedEvent do: [ :event |
			| position |
			anEditor cursors do: [ :each | position := each position ].
			position notNil ifTrue: [ aBlock cull: position ]
		].
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
					item := compilation gtSliceFor: item method within: item sourceInterval.
				].
				(item isKindOf: IRInstruction) ifTrue: [
					item sourceNode ifNotNil: [
						item := compilation gtSliceFor: item sourceNode methodNode within: item sourceNode sourceInterval.
					].
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
				item := aNode value.
				(item isKindOf: SymbolicBytecode) ifTrue: [
					item := compilation gtSliceFor: item method within: item sourceInterval.
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
	^ (self gtGetLiveView: aView for: [ :view | compilation gtOutputFor: view ]
		title: 'Output' translated
		priority: 40)
		asElementDo: [ :e | e margin: (BlInsets all: 0) ];
		yourself
]

{ #category : #views }
ProcessingProgram >> gtOutputPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 41;
		title: 'Output++';
		stencil: [ | element |
			element := self gtCombineWithSource: (self gtOutputFor: GtPhlowView empty).
			self gtExplain: element children second in: element children first.
			element
		];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtOutputShapesFor: aView [
	<gtView>
	compilation gtIsAnimation ifTrue: [ ^ GtPhlowView empty ].
	^ (self gtGetLiveView: aView for: [ :view | self canvas gtShapesFor: view ]
		title: 'Shapes' translated
		priority: 42)
		asElementDo: [ :e | e margin: (BlInsets all: 0) ];
		yourself
]

{ #category : #views }
ProcessingProgram >> gtSelectBytecode: aList at: position [
	| slices |
	slices := compilation gtSlicesAround: position.
	slices ifEmpty: [ ^ nil ].
	self gtSelectListItem: aList with: [ :item |
		(item isKindOf: SymbolicBytecode) and: [
			(item method name = slices last method name) &
			(slices last interval includesAll: item sourceInterval)
		]
	].
]

{ #category : #views }
ProcessingProgram >> gtSelectIRNode: aList at: position [
	| slices |
	slices := compilation gtSlicesAround: position.
	slices ifEmpty: [ ^ nil ].
	self gtSelectListItem: aList with: [ :item |
		(item isKindOf: IRInstruction) and: [ item sourceNode isNotNil and: [
			(item sourceNode methodNode sourceCode = slices last method sourceCode) &
			(slices last interval includesAll: item sourceNode sourceInterval)
		] ]
	].
]

{ #category : #views }
ProcessingProgram >> gtSelectListItem: aList with: aBlock [
	| indices |
	indices := (1 to: aList items size) select: [ :index |
		aBlock cull: (aList items at: index)
	].
	indices ifNotEmpty: [
		aList selectOne: indices last.
		aList scrollToSelection.
	].
]

{ #category : #views }
ProcessingProgram >> gtSelectToken: aList at: aPosition [
	1 to: aList items size do: [ :index |
		| item |
		item := aList items at: index.
		((item isKindOf: SmaCCToken) and: [
			item sourceInterval includes: aPosition + 1
		]) ifTrue: [
			aList selectOne: index.
			aList scrollToSelection.
		]
	].
]

{ #category : #views }
ProcessingProgram >> gtSelectTreeNode: aTree at: aPosition [
	| treeNode nextNode |
	nextNode := aTree viewModel itemAt: 1.
	2 to: aTree viewModel itemCount do: [ :index |
		| node |
		node := aTree viewModel itemAt: index.
		(aPosition between: node value startPosition and: node value stopPosition) ifTrue: [
			nextNode := node.
		]
	].
	[
		nextNode expand.
		treeNode := nextNode.
		nextNode := treeNode childrenNodes detect: [ :each |
			aPosition between: each value startPosition and: each value stopPosition
		] ifNone: [ nil ].
		nextNode notNil
	] whileTrue.
	aTree selectOne: treeNode indexInTree.
	aTree children first scrollToPosition: treeNode indexInTree
]

{ #category : #views }
ProcessingProgram >> gtSlicesFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtSlicesFor: view ]
		title: 'Slices' translated
		priority: 22
]

{ #category : #views }
ProcessingProgram >> gtSourceBytesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Source Bytes' translated;
		priority: 5;
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
ProcessingProgram >> gtSourceBytesPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		title: 'Source Bytes++';
		priority: 6;
		stencil: [ | element editor list |
			element := self gtCombineWithSource: (self gtSourceBytesFor: GtPhlowView empty).
			
			editor := element children first.
			list := element children last children last.
			
			list when: BrSelectionChanged do: [ :event |
				event selectedInterval ifNotNil: [
					self gtEditorHightlight: editor from: event selectedInterval first to: event selectedInterval last.
				].
			].
			self gtOnEditorChange: editor do: [ :position |
				| clamped |
				clamped := position + 1 clampBetween: 1 and: source asString size.
				list selectOne: clamped.
				list scrollToSelection.
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTokensFor: aView [
	<gtView>
	^ aView columnedList
		title: 'AST Tokens';
		priority: 10;
		items: [ ProcessingTokenExtractor new extractTokens: ast ];
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
ProcessingProgram >> gtTokensPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 11;
		title: 'AST Tokens++';
		stencil: [ | element child editor list |
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
			
			(self gtTokensFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			list := child children last.
			
			self gtOnListSelect: list do: [ :astNode |
				self gtEditorHightlight: editor from: astNode startPosition to: astNode stopPosition.
			].
			self gtOnEditorChange: editor do: [ :position |
				self gtSelectToken: list at: position.
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTokensPlusTreeFor: aView [
	<gtView>
	^ aView explicit
		priority: 17;
		title: 'AST+Tokens';
		stencil: [ | element child list tree skipOne |
			element := BlElement new.
			element layout: BlLinearLayout horizontal.
			element
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			(self gtTokensFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			list := child children last.
			
			(self gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			tree := child children last.
			
			"Prevent auto-selecting feedback changes."
			skipOne := false.
			self gtOnListSelect: list do: [ :astNode |
				skipOne ifFalse: [
					skipOne := true.
					self gtSelectTreeNode: tree at: astNode startPosition.
					skipOne := false.
				].
			].
			self gtOnTreeSelect: tree do: [ :astNode |
				skipOne ifFalse: [
					skipOne := true.
					self gtSelectToken: list at: astNode startPosition.
					skipOne := false.
				].
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTranspilationFor: aView [
	<gtView>
	^ self gtGetLiveView: aView for: [ :view | compilation gtSourceCodeFor: view ]
		title: 'Smalltalk'
		priority: 20
]

{ #category : #views }
ProcessingProgram >> gtTranspilationPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 21;
		title: 'Smalltalk++';
		stencil: [
			self gtCombineWithSource: (self gtTranspilationFor: GtPhlowView empty)
		];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTreeFor: aView [
	<gtView>
	^ aView columnedTree
		priority: 15;
		title: 'AST';
		items: [ ast acceptVisitor: ProcessingTokenExtractor new ];
		children: [ :each | ProcessingParser gtGetASTChildren: each ];
		column: 'Node' translated text: [ :each |
			| node next |
			node := each.
			[ (node isKindOf: PyRootNode) and: [ (next := (node acceptVisitor: ProcessingTokenExtractor new)) size = 1 ] ] whileTrue: [
				node := next first.
			].
			(node isKindOf: PyRootNode) ifTrue: [
				(ProcessingParser gtASTNodeNames at: node class) asRopedText foreground: Color lightGray
			] ifFalse: [
				node value
			]
		];
		column: 'Type' translated text: [ :each |
			| node prev next |
			node := each.
			prev := each.
			[ (node isKindOf: PyRootNode) and: [ (next := (node acceptVisitor: ProcessingTokenExtractor new)) size = 1 ] ] whileTrue: [
				prev := node.
				node := next first.
			].
			(prev isKindOf: PyRootNode) ifTrue: [
				prev = node ifTrue: [
					'' asRopedText
				] ifFalse: [
					(ProcessingParser gtASTNodeNames at: prev class) translated asRopedText
				]
			] ifFalse: [
				'Token' asRopedText foreground: BrGlamorousColors disabledButtonTextColor
			]
		];
	expandAll;
	updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTreeMondrianFor: aView [
	<gtView>
	^ ((ProcessingTreeMondrianCreator mondrianFor: self ast) gtLiveFor: aView)
		priority: 18;
		title: 'AST Tree';
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTreeOldFor: aView [
	<gtView>
	^ aView explicit
		priority: 19;
		title: 'AST (old)';
		stencil: [ | tree |
			(ast topParent gtTreeFor: GtPhlowView empty)
				expandAll;
				asElementDo: [ :e | tree := e ].
			tree
				constraintsDo: [ :e |
					e vertical matchParent.
					e horizontal matchParent ];
				yourself
		];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTreePlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 16;
		title: 'AST++';
		stencil: [ | element editor tree |
			element := self gtCombineWithSource: (self gtTreeFor: GtPhlowView empty).
			
			editor := element children first.
			tree := element children last children last.

			self gtOnTreeSelect: tree do: [ :astNode |
				self gtEditorHightlight: editor from: astNode startPosition to: astNode stopPosition.
			].
			self gtOnEditorChange: editor do: [ :position |
				self gtSelectTreeNode: tree at: position.
			].
			
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #runtime }
ProcessingProgram >> run [
	"Animations are limited to 30 seconds for now."
	^ self runFor: (compilation gtIsAnimation ifTrue: [ 30 ] ifFalse: [ 2 ]) seconds
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
	"The default is 2 seconds even for animations in order to prevent an excessive amount of steps"
	^ self runStepsFor: 2 seconds
]

{ #category : #runtime }
ProcessingProgram >> runStepsFor: duration [
	| runner steps |
	runner := ProcessingRunner new.
	steps := runner limitTo: duration; runStepwise: compilation clone.
	runner isDone ifFalse: [
		steps add: (ProcessingRunStep create: thisContext canvas: runner canvas slice: (ProcessingRunawayProgramException new messageText: 'Endless loop detected!')).
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
	"The transpiler cleans up the AST first, so use a copy instead."
	compilation := ProcessingTranspiler new compile: (ProcessingParser parse: source asString).
	
	source announcer when: ProcessingSourceChanged do: [ :event |
		[
			"The transpiler cleans up the AST first, so use a copy instead."
			compilation := ProcessingTranspiler new compile: (ProcessingParser parse: source asString).
			ast := event ast.
			self announcer announce: (ProcessingProgramChanged new program: self).
		] on: Error do: [ :error |
			"silently swallow errors on updates, as these happen intermittently during incomplete/slow typing"
		].
	] for: self.
]
