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

{ #category : #'views - tools' }
ProcessingProgram >> addHighlightOnError: anElement [
	self announcer
		when: ProcessingSourceChangedError
		do: [ :event | anElement background: BrGlamorousColors paleFailureBackgroundColor ]
]

{ #category : #accessing }
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
	(result isKindOf: AsyncFutureCancelled)
		ifTrue: [ ProcessingRunawayProgramException new signal: 'Endless loop detected.' ].
	(result isKindOf: Error)
		ifTrue: [ ProcessingRunTimeException new
				tag: result;
				signal ].
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
		stencil: [ | element events editor astTree bytecode canvas |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].

			events := Announcer new.
			editor := self sharedContentsViewElement: events.
			element addChild: editor.
			astTree := self sharedTreeViewElement: events.
			element addChild: astTree.
			bytecode := self sharedBytecodeViewElement: events ignore: astTree.	"Oneway hook bytecode list to AST tree"
			element addChild: bytecode.
			canvas := self gtGetViewElement: #gtOutputFor:.
			element addChild: canvas.
			self addHighlightOnError: element.

			false ifTrue: [ self gtExplain: canvas in: editor ].	"Disabled for performance reasons"

			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtBytecodeFor: aView [
	<gtView>
	^ self
		gtGetLiveView: aView
		for: [ :view | compilation gtBytecodeFor: view ]
		title: 'Bytecode' translated
		priority: 35
]

{ #category : #views }
ProcessingProgram >> gtBytecodePlusIRFor: aView [
	"Match bytecode and intermediary representation at the level of bytecode instructions (instead of using sharedBytecodeViewElement: and sharedIRViewElement: which match at the level of Processing tokens)"

	<gtView>
	^ aView explicit
		priority: 37;
		title: 'Bytecode' translated , '+IR';
		stencil: [ | element bytecode irList skipOne |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].

			irList := self gtGetViewElement: #gtIntermediaryRepresentationFor:.
			element addChild: irList.
			bytecode := self gtGetViewElement: #gtBytecodeFor:.
			element addChild: bytecode.
			self addHighlightOnError: element.

			irList := irList children last.
			bytecode := bytecode children last.

			skipOne := false.	"Prevent auto-selecting feedback changes."
			bytecode
				when: BrSelectionChanged
				do: [ :event | 
					skipOne
						ifFalse: [ skipOne := true.
							bytecode
								selectedItemDo: [ :item | 
									(item isKindOf: SymbolicBytecode)
										ifTrue: [ self
												gtSelectListItem: irList
												with: [ :irItem | 
													(irItem isKindOf: IRInstruction)
														and: [ irItem sourceNode isNotNil
																and: [ irItem sourceNode methodNode sourceCode = item method sourceCode
																		& (item sourceInterval includesAll: irItem sourceNode sourceInterval) ] ] ] ] ].
							skipOne := false ] ].
			irList
				when: BrSelectionChanged
				do: [ :event | 
					skipOne
						ifFalse: [ skipOne := true.
							irList
								selectedItemDo: [ :irItem | 
									((irItem isKindOf: IRInstruction) and: [ irItem sourceNode isNotNil ])
										ifTrue: [ self
												gtSelectListItem: bytecode
												with: [ :item | 
													(item isKindOf: SymbolicBytecode)
														and: [ item method sourceCode = irItem sourceNode methodNode sourceCode
																& (irItem sourceNode sourceInterval includesAll: item sourceInterval) ] ] ] ].
							skipOne := false ] ].

			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtBytecodePlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 36;
		title: 'Bytecode' translated , '++';
		stencil: [ | events element |
			events := Announcer new.
			element := self
					gtCombineWithSource: (self sharedBytecodeViewElement: events ignore: nil)
					on: events.
			self addHighlightOnError: element.
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #'views - tools' }
ProcessingProgram >> gtCombineWithSource: anElement on: anAnnouncer [
	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild: (self sharedContentsViewElement: anAnnouncer);
		addChild: anElement;
		yourself
]

{ #category : #views }
ProcessingProgram >> gtContentsFor: aView [
	<gtView>
	^ aView explicit
		priority: 2;
		title: 'Source' translated;
		stencil: [ | editor |
			editor := ast gtSourceEditorWithHighlight: Color white.
			editor
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				beMode: BrTextEditorReadonlyWithNavigationMode new;
				background: Color white.
			editor ];
		updateWhen: ProcessingSourceChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtDefaultInspectorTool [
	^ GtPhlowCompositeTool new
		addTool: (GtPhlowExplicitTool new
				withIconAptitude;
				icon: BrGlamorousVectorIcons playAsynchronous;
				stencil: [ BlContainerWithHeaderElement new
						headerText: (self asString , ': ' , 'Abstractions' translated) asRopedText;
						addChild: (GtInspector forObject: self viewSelector: #gtAbstractionsFor:) ]);
		addTool: (GtPhlowExplicitTool new
				withIconAptitude;
				icon: BrGlamorousVectorIcons play;
				stencil: [ BlContainerWithHeaderElement new
						headerText: (self asString , ': ' , 'Output' translated) asRopedText;
						addChild: (GtInspector forObject: self viewSelector: #gtOutputFor:) ]);
		addTool: super gtDefaultInspectorTool
]

{ #category : #'views - tools' }
ProcessingProgram >> gtEditorHightlight: anEditor from: from to: to [
	anEditor editor text
		clearAttributes: [ :each | each isKindOf: BlTextHighlightAttribute ].
	(anEditor editor text from: from to: to)
		attribute: (BlTextHighlightAttribute new paint: BrGlamorousColors textHighlightColor).

	anEditor
		scrollToPosition: (anEditor text asString lineNumberCorrespondingToIndex: from)
]

{ #category : #'views - tools' }
ProcessingProgram >> gtExplain: aCanvas in: anEditor [
	| seen |
	aCanvas
		firstCommonParent: anEditor
		ifFound: [ :el | el explainer isExplanationHolder: true ]
		ifNone: [ ^ nil ].

	seen := Set new.
	aCanvas
		when: ProcessingExplainShape
		do: [ :event | 
			| slice |
			slice := compilation
					gtSliceFor: event sourceNode methodNode
					within: event sourceNode sourceInterval.
			ProcessingCanvasElement explainShape: event source as: slice.

			(seen includes: slice)
				ifFalse: [  "TODO: this block is called from a ProcessingRunner worker - pass the editor manipulation back to the UI thread"(anEditor
						text
						from: slice astNode receiver startPosition
						to: slice astNode receiver stopPosition) glamorousExplanationFor: slice.
					seen add: slice ] ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtGetLiveView: aView for: aBlock title: aTitle priority: aPriority [
	^ aView explicit
		title: aTitle;
		priority: aPriority;
		stencil: [ | element |
			element := (aBlock cull: GtPhlowView empty) asElement.
			element
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ].
			self addHighlightOnError: element.
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #'views - tools' }
ProcessingProgram >> gtGetViewElement: aViewName [
	^ (self perform: aViewName with: GtPhlowView empty) asElement
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		margin: (BlInsets all: 5);
		background: Color white;
		yourself
]

{ #category : #views }
ProcessingProgram >> gtIntermediaryRepresentationFor: aView [
	<gtView>
	^ self
		gtGetLiveView: aView
		for: [ :view | compilation gtIntermediaryRepresentationFor: view ]
		title: 'IR'
		priority: 30
]

{ #category : #views }
ProcessingProgram >> gtIntermediaryRepresentationPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 31;
		title: 'IR++';
		stencil: [ | events element |
			events := Announcer new.
			element := self
					gtCombineWithSource: (self sharedIRViewElement: events)
					on: events.
			self addHighlightOnError: element.
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #'views - tools' }
ProcessingProgram >> gtOnEditorChange: anEditor do: aBlock [
	anEditor editor
		when: BrTextEditorCursorMovedEvent
			do: [ :event | 
				| position |
				anEditor cursors do: [ :each | position := each position ].
				position notNil ifTrue: [ aBlock cull: position ] ];
		when: BrTextEditorCursorAddedEvent
			do: [ :event | 
				| position |
				anEditor cursors do: [ :each | position := each position ].
				position notNil ifTrue: [ aBlock cull: position ] ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtOnListSelect: aList do: aBlock [
	aList
		when: BrSelectionChanged
		do: [ :anEvent | 
			aList
				selectedItemDo: [ :anItem | 
					| item |
					item := anItem.
					(item isKindOf: SymbolicBytecode)
						ifTrue: [ item := compilation gtSliceFor: item method within: item sourceInterval ].
					(item isKindOf: IRInstruction)
						ifTrue: [ item sourceNode
								ifNotNil: [ item := compilation
											gtSliceFor: item sourceNode methodNode
											within: item sourceNode sourceInterval ] ].
					(item isKindOf: ProcessingTranspilationSlice)
						ifTrue: [ item := item astNode ].
					((item isKindOf: SmaCCParseNode) or: [ item isKindOf: SmaCCToken ])
						ifTrue: [ aBlock cull: item ] ] ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtOnTreeSelect: aTree do: aBlock [
	aTree
		when: BrSelectionChanged
		do: [ :anEvent | 
			aTree
				selectedNodeDo: [ :aNode | 
					| item |
					item := aNode value.
					(item isKindOf: SymbolicBytecode)
						ifTrue: [ item := compilation gtSliceFor: item method within: item sourceInterval ].
					(item isKindOf: ProcessingTranspilationSlice)
						ifTrue: [ item := item astNode ].
					((item isKindOf: SmaCCParseNode) or: [ item isKindOf: SmaCCToken ])
						ifTrue: [ aBlock cull: item ] ] ]
]

{ #category : #views }
ProcessingProgram >> gtOutputFor: aView [
	<gtView>
	^ (self
		gtGetLiveView: aView
		for: [ :view | compilation gtOutputFor: view ]
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
			element := self gtCombineWithSource: (self gtGetViewElement: #gtOutputFor:) on: Announcer new.
			self addHighlightOnError: element.
			self gtExplain: element children second in: element children first.
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtOutputShapesFor: aView [
	<gtView>
	compilation gtIsAnimation ifTrue: [ ^ GtPhlowView empty ].
	^ (self
		gtGetLiveView: aView
		for: [ :view | self canvas gtShapesFor: view ]
		title: 'Shapes' translated
		priority: 42)
		asElementDo: [ :e | e margin: (BlInsets all: 0) ];
		yourself
]

{ #category : #'views - tools' }
ProcessingProgram >> gtSelectBytecode: aList at: position [
	| slices |
	slices := compilation gtSlicesAround: position.
	slices ifEmpty: [ ^ nil ].
	self
		gtSelectListItem: aList
		with: [ :item | 
			(item isKindOf: SymbolicBytecode)
				and: [ item method name = slices last method name
						& (slices last interval includesAll: item sourceInterval) ] ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtSelectIRNode: aList at: position [
	| slices |
	slices := compilation gtSlicesAround: position.
	slices ifEmpty: [ ^ nil ].
	self
		gtSelectListItem: aList
		with: [ :item | 
			(item isKindOf: IRInstruction)
				and: [ item sourceNode isNotNil
						and: [ item sourceNode methodNode sourceCode = slices last method sourceCode
								& (slices last interval includesAll: item sourceNode sourceInterval) ] ] ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtSelectListItem: aList with: aBlock [
	| indices |
	indices := (1 to: aList items size)
			select: [ :index | aBlock cull: (aList items at: index) ].
	indices
		ifNotEmpty: [ aList selectOne: indices last.
			aList scrollToSelection ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtSelectToken: aList at: aPosition [
	1
		to: aList items size
		do: [ :index | 
			| item |
			item := aList items at: index.
			((item isKindOf: SmaCCToken)
				and: [ item sourceInterval includes: aPosition + 1 ])
				ifTrue: [ aList selectOne: index.
					aList scrollToSelection ] ]
]

{ #category : #'views - tools' }
ProcessingProgram >> gtSelectTreeNode: aTree at: aPosition [
	| treeNode nextNode |
	nextNode := aTree viewModel itemAt: 1.
	2
		to: aTree viewModel itemCount
		do: [ :index | 
			| node |
			node := aTree viewModel itemAt: index.
			(aPosition between: node value startPosition and: node value stopPosition)
				ifTrue: [ nextNode := node ] ].
	[ nextNode expand.
	treeNode := nextNode.
	nextNode := treeNode childrenNodes
			detect: [ :each | aPosition between: each value startPosition and: each value stopPosition ]
			ifNone: [ nil ].
	nextNode notNil ] whileTrue.
	aTree selectOne: treeNode indexInTree.
	aTree children first scrollToPosition: treeNode indexInTree
]

{ #category : #views }
ProcessingProgram >> gtSlicesFor: aView [
	<gtView>
	^ self
		gtGetLiveView: aView
		for: [ :view | compilation gtSlicesFor: view ]
		title: 'Slices' translated
		priority: 22
]

{ #category : #views }
ProcessingProgram >> gtSourceBytesFor: aView [
	"Bytes are displayed UTF-8 encoded"

	<gtView>
	^ aView columnedList
		title: 'Source Bytes' translated;
		priority: 8;
		items: [ ZnUTF8Encoder new encodeString: source asString ];
		column: 'Index' translated
			text: [ :each :index | index asRopedText foreground: Color gray ]
			width: 45;
		column: 'ASCII' text: [ :each | each asString ];
		column: 'HEX' text: [ :each | (each radix: 16) padLeftTo: 2 with: $0 ];
		column: 'Binary' text: [ :each | (each radix: 2) padLeftTo: 8 with: $0 ];
		updateWhen: ProcessingSourceChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtSourceBytesPlusCharsFor: aView [
	<gtView>
	^ aView explicit
		title: 'Source Chars+Bytes';
		priority: 7;
		stencil: [ | events |
			events := Announcer new.
			BlElement new
				layout: (BlGridLayout new columnCount: 2);
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				addChild: (self sharedSourceCharsViewElement: events);
				addChild: (self sharedSourceBytesViewElement: events);
				yourself ];
		updateWhen: ProcessingSourceChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtSourceBytesPlusSourceFor: aView [
	"Bytes are displayed UTF-8 encoded"

	<gtView>
	^ aView explicit
		title: 'Source Bytes++';
		priority: 9;
		stencil: [ | events |
			events := Announcer new.
			self
				gtCombineWithSource: (self sharedSourceBytesViewElement: events)
				on: events ];
		updateWhen: ProcessingSourceChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtSourceCharsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Source Chars' translated;
		priority: 5;
		items: [ source asString ];
		column: 'Index' translated
			text: [ :each :index | index asRopedText foreground: Color gray ]
			width: 45;
		column: 'Character' translated
			text: [ :each | (each gtDisplayString removePrefix: 'Character ') removePrefix: '$' ];
		column: 'ASCII' text: [ :each | each asciiValue ];
		column: 'HEX'
			text: [ :each | (each asciiValue radix: 16) padLeftTo: 2 with: $0 ];
		updateWhen: ProcessingSourceChanged in: source announcer
]

{ #category : #views }
ProcessingProgram >> gtSourceCharsPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		title: 'Source Chars++';
		priority: 6;
		stencil: [ | events |
			events := Announcer new.
			self
				gtCombineWithSource: (self sharedSourceCharsViewElement: events)
				on: events ];
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
				(source asString copyFrom: 1 to: each startPosition) lineCount asRopedText
					foreground: Color gray ]
			width: 45;
		column: 'Indentation' translated
			text: [ :each | 
				| line indent ch |
				line := (source asString copyFrom: 1 to: each startPosition) lines last
						readStream.
				indent := 0.
				[ line atEnd not and: [ (ch := line next) isSeparator ] ]
					whileTrue: [ indent := indent
								+ (ch = Character tab ifTrue: [ 8 - (indent \\ 8) ] ifFalse: [ 1 ]) ].
				indent asRopedText foreground: Color gray ]
			width: 45;
		column: 'Token' text: [ :each | each value ];
		updateWhen: ProcessingASTChanged in: self announcer;
		asElementDo: [ :e | self addHighlightOnError: e ];
		yourself
]

{ #category : #views }
ProcessingProgram >> gtTokensPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 11;
		title: 'AST Tokens++';
		stencil: [ | events element |
			events := Announcer new.
			element := BlElement new.
			element
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				addChild: (self sharedContentsViewElement: events);
				addChild: (self sharedTokensViewElement: events).
			self addHighlightOnError: element.
			element ];
		updateWhen: ProcessingASTChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTokensPlusTreeFor: aView [
	<gtView>
	^ aView explicit
		priority: 17;
		title: 'AST+Tokens';
		stencil: [ | events element |
			events := Announcer new.
			element := BlElement new.
			element
				layout: BlLinearLayout horizontal;
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				addChild: (self sharedTokensViewElement: events);
				addChild: (self sharedTreeViewElement: events).
			self addHighlightOnError: element.
			element ];
		updateWhen: ProcessingASTChanged in: self announcer
]

{ #category : #views }
ProcessingProgram >> gtTranspilationFor: aView [
	<gtView>
	^ self
		gtGetLiveView: aView
		for: [ :view | compilation gtSourceCodeFor: view ]
		title: 'Smalltalk'
		priority: 20
]

{ #category : #views }
ProcessingProgram >> gtTranspilationPlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 21;
		title: 'Smalltalk++';
		stencil: [ | element |
			element := self
					gtCombineWithSource: (self gtGetViewElement: #gtTranspilationFor:)
					on: Announcer new.
			self addHighlightOnError: element.
			element ];
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
		column: 'Node' translated
			text: [ :each | 
				| node next |
				node := each.
				[ (node isKindOf: PyRootNode)
					and: [ (next := node acceptVisitor: ProcessingTokenExtractor new) size = 1 ] ]
					whileTrue: [ node := next first ].
				(node isKindOf: PyRootNode)
					ifTrue: [ (ProcessingParser gtASTNodeNames at: node class) asRopedText
							foreground: Color lightGray ]
					ifFalse: [ node value ] ];
		column: 'Type' translated
			text: [ :each | 
				| node prev next |
				node := each.
				prev := each.
				[ (node isKindOf: PyRootNode)
					and: [ (next := node acceptVisitor: ProcessingTokenExtractor new) size = 1 ] ]
					whileTrue: [ prev := node.
						node := next first ].
				(prev isKindOf: PyRootNode)
					ifTrue: [ prev = node
							ifTrue: [ '' asRopedText ]
							ifFalse: [ (ProcessingParser gtASTNodeNames at: prev class) translated asRopedText ] ]
					ifFalse: [ 'Token' asRopedText
							foreground: BrGlamorousColors disabledButtonTextColor ] ];
		expandAll;
		updateWhen: ProcessingASTChanged in: self announcer;
		asElementDo: [ :e | self addHighlightOnError: e ];
		yourself
]

{ #category : #views }
ProcessingProgram >> gtTreeMondrianFor: aView [
	<gtView>
	^ ((ProcessingTreeMondrianCreator mondrianFor: self ast) gtLiveFor: aView)
		priority: 18;
		title: 'AST Tree';
		updateWhen: ProcessingASTChanged in: self announcer;
		asElementDo: [ :e | self addHighlightOnError: e ];
		yourself
]

{ #category : #views }
ProcessingProgram >> gtTreeOldFor: aView [
	<gtView>
	^ aView explicit
		priority: 19;
		title: 'AST (old)';
		stencil: [ | tree |
			tree := (ast topParent gtTreeFor: GtPhlowView empty)
					expandAll;
					asElement.
			tree
				constraintsDo: [ :e | 
					e vertical matchParent.
					e horizontal matchParent ];
				yourself ];
		updateWhen: ProcessingASTChanged in: self announcer;
		asElementDo: [ :e | self addHighlightOnError: e ];
		yourself
]

{ #category : #views }
ProcessingProgram >> gtTreePlusSourceFor: aView [
	<gtView>
	^ aView explicit
		priority: 16;
		title: 'AST++';
		stencil: [ | events element |
			events := Announcer new.
			element := self
					gtCombineWithSource: (self sharedTreeViewElement: events)
					on: events.
			self addHighlightOnError: element.
			element ];
		updateWhen: ProcessingProgramChanged in: self announcer
]

{ #category : #runtime }
ProcessingProgram >> run [
	"Animations are limited to 30 seconds for now."

	^ self
		runFor: (compilation gtIsAnimation ifTrue: [ 30 ] ifFalse: [ 2 ]) seconds
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
	steps := runner
			limitTo: duration;
			runStepwise: compilation clone.
	runner isDone
		ifFalse: [ steps
				add: (ProcessingRunStep
						create: thisContext
						canvas: runner canvas
						slice: (ProcessingRunawayProgramException new
								messageText: 'Endless loop detected!')) ].
	^ steps
]

{ #category : #views }
ProcessingProgram >> sharedBytecodeViewElement: anAnnouncer ignore: anIgnorable [
	| bytecode |
	bytecode := self gtGetViewElement: #gtBytecodeFor:.
	self
		gtOnListSelect: bytecode children last
		do: [ :astNode | 
			anAnnouncer
				announce: (ProcessingViewSelectionChanged new
						interval: astNode sourceInterval;
						source: bytecode) ].

	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = bytecode
				ifFalse: [ event source = anIgnorable
						ifFalse: [ self gtSelectBytecode: bytecode children last at: event interval first ] ] ].
	^ bytecode
]

{ #category : #views }
ProcessingProgram >> sharedContentsViewElement: anAnnouncer [
	| editor |
	editor := self gtGetViewElement: #gtContentsFor:.
	self
		gtOnEditorChange: editor
		do: [ :position | 
			| clamped |
			clamped := position + 1 clampBetween: 1 and: source asString size.	"Default the empty selection to the right of the cursor."
			anAnnouncer
				announce: (ProcessingViewSelectionChanged new
						interval: (clamped to: clamped);
						source: editor) ].
	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = editor
				ifFalse: [ self
						gtEditorHightlight: editor
						from: event interval first
						to: event interval last ] ].
	^ editor
]

{ #category : #views }
ProcessingProgram >> sharedIRViewElement: anAnnouncer [
	| irList |
	irList := compilation gtGetViewElement: #gtIntermediaryRepresentationFor:.
	self
		gtOnListSelect: irList children last
		do: [ :astNode | 
			anAnnouncer
				announce: (ProcessingViewSelectionChanged new
						interval: astNode sourceInterval;
						source: irList) ].

	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = irList
				ifFalse: [ self gtSelectIRNode: irList children last at: event interval first ] ].
	^ irList
]

{ #category : #views }
ProcessingProgram >> sharedSourceBytesViewElement: anAnnouncer [
	| bytesList encoder indices |
	bytesList := self gtGetViewElement: #gtSourceBytesFor:.
	encoder := ZnUTF8Encoder new.
	indices := OrderedCollection new.
	source asString
		doWithIndex: [ :c :index | 1 to: (encoder encodeString: c asString) size do: [ :ix | indices add: index ] ].
	bytesList children last
		when: BrSelectionChanged
		do: [ :event | 
			event selectedInterval
				ifNotNil: [ anAnnouncer
						announce: (ProcessingViewSelectionChanged new
								interval: ((indices at: event selectedInterval first)
										to: (indices at: event selectedInterval last));
								source: bytesList) ] ].
	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = bytesList
				ifFalse: [ bytesList children last selectOne: (indices indexOf: event interval first).
					bytesList children last scrollToSelection ] ].
	^ bytesList
]

{ #category : #views }
ProcessingProgram >> sharedSourceCharsViewElement: anAnnouncer [
	| charsList |
	charsList := self gtGetViewElement: #gtSourceCharsFor:.
	charsList children last
		when: BrSelectionChanged
		do: [ :event | 
			event selectedInterval
				ifNotNil: [ anAnnouncer
						announce: (ProcessingViewSelectionChanged new
								interval: event selectedInterval;
								source: charsList) ] ].
	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = charsList
				ifFalse: [ charsList children last selectOne: event interval first.
					charsList children last scrollToSelection ] ].
	^ charsList
]

{ #category : #views }
ProcessingProgram >> sharedTokensViewElement: anAnnouncer [
	| tokens |
	tokens := self gtGetViewElement: #gtTokensFor:.
	self
		gtOnListSelect: tokens children last
		do: [ :astNode | 
			anAnnouncer
				announce: (ProcessingViewSelectionChanged new
						interval: astNode sourceInterval;
						source: tokens) ].
	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = tokens
				ifFalse: [ self gtSelectToken: tokens children last at: event interval first ] ].
	^ tokens
]

{ #category : #views }
ProcessingProgram >> sharedTreeViewElement: anAnnouncer [
	| astTree |
	astTree := self gtGetViewElement: #gtTreeFor:.
	self
		gtOnTreeSelect: astTree children last
		do: [ :astNode | 
			anAnnouncer
				announce: (ProcessingViewSelectionChanged new
						interval: astNode sourceInterval;
						source: astTree) ].
	anAnnouncer
		when: ProcessingViewSelectionChanged
		do: [ :event | 
			event source = astTree
				ifFalse: [ self gtSelectTreeNode: astTree children last at: event interval first ] ].
	^ astTree
]

{ #category : #accessing }
ProcessingProgram >> source [
	^ source
]

{ #category : #initialization }
ProcessingProgram >> source: aSource [
	source
		ifNotNil: [ ProcessingCompileTimeException new
				signal: 'Reassigning ProcessingProgram>>#source isn''t supported!' ].

	source := aSource.
	ast := ProcessingParser parse: source asString.
	compilation := ProcessingTranspiler new
			compile: (ProcessingParser parse: source asString).	"The transpiler cleans up the AST first, so use a copy instead."

	source announcer
		when: ProcessingASTChanged
		do: [ :event | 
			[ compilation := ProcessingTranspiler new
					compile: (ProcessingParser parse: source asString).	"The transpiler cleans up the AST first, so use a copy instead."
			ast := event ast.
			self announcer announce: (ProcessingProgramChanged new program: self) ]
				on: Error
				do: [ :error | 
					self announcer
						announce: (ProcessingSourceChangedError new
								source: source;
								sourceError: error) ] ]
		for: self.
	source announcer
		when: ProcessingSourceChangedError
		do: [ :event | self announcer announce: event ]
]
