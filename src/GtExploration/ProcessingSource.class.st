"
This is the **main class** for handling Processing programs.

- It produces a {{gtClass:ProcessingProgram}}, which
  - parses the program with {{gtClass:ProcessingParser}}
  - compiles it with {{gtClass:ProcessingTranspiler}} into a subclass of {{gtClass:ProcessingCodeBase}}
  - runs programs through {{gtClass:ProcessingRunner}}, yielding output into a {{gtClass:ProcessingCanvas}}
- It provides the main views of ""Processing Abstractions""
  - some of which are provided by {{gtClass:ProcessingCodeBase}}
  - many of which are provided by {{gtClass:ProcessingProgram}}
- It allows direct embedding of the various views into Lepiter pages:
```(ProcessingSource fromPage: thisSnippet page) render```
```(ProcessingSource fromPage: thisSnippet page) renderLiveView: #gtAbstractionsFor:```

```
ProcessingSource fromString: 'print(""Hello, world!"")'
```
"
Class {
	#name : 'ProcessingSource',
	#superclass : 'Object',
	#instVars : [
		'source',
		'announcer'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'initialization' }
ProcessingSource class >> fromFile: locator [
	| source |
	source := ProcessingSource new source: locator.
	locator watcher startLoop announcer
		when: GtFileWatcherModificationAnnouncement
		do: [ :event | source announceSourceChange ]
		for: source.
	^ source
]

{ #category : 'initialization' }
ProcessingSource class >> fromPage: aPage [
	^ self fromPage: aPage at: 1
]

{ #category : 'initialization' }
ProcessingSource class >> fromPage: aPage at: anIndex [
	^ self
		fromSnippet: ((aPage children select: [ :snip | snip isKindOf: LePythonSnippet ]) at: anIndex)
]

{ #category : 'initialization' }
ProcessingSource class >> fromSnippet: aSnippet [
	^ self fromViewModel: aSnippet asSnippetViewModel coderViewModel
]

{ #category : 'initialization' }
ProcessingSource class >> fromString: code [
	^ self
		fromFile: ((FileSystem memory workingDirectory
				/ ('prog' , ((SharedRandom globalGenerator nextInteger: 89999) + 10000) asString
						, '.pyde'))
				writeStreamDo: [ :stream | stream nextPutAll: code ];
				yourself)
]

{ #category : 'initialization' }
ProcessingSource class >> fromViewModel: aViewModel [
	| source |
	source := self fromString: aViewModel coderModel currentSourceString.
	aViewModel announcer
		when: GtTextualCoderViewModelTextChanged
		do: [ :event | source onSourceChangedTo: event text asString ]
		for: source.
	^ source
]

{ #category : 'announcements' }
ProcessingSource >> announceSourceChange [
	| ast |
	[ ast := ProcessingParser parse: self asString.
	self announcer
		announce: (ProcessingASTChanged new
				source: self;
				ast: ast) ]
		on: SmaCCParserError
		do: [ :error | 
			self announcer
				announce: (ProcessingSourceChangedError new
						source: self;
						sourceError: error) ]
]

{ #category : 'announcements' }
ProcessingSource >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'views' }
ProcessingSource >> asString [
	^ source contents
]

{ #category : 'views' }
ProcessingSource >> gtAbstractionsFor: aView [
	<gtView>
	^ (self program gtAbstractionsFor: aView)
		priority: 1;
		title: 'Abstractions' translated
]

{ #category : 'views' }
ProcessingSource >> gtBytecodeFor: aView [
	<gtView>
	^ (self program gtBytecodeFor: aView)
		title: 'Bytecode' translated;
		priority: 10
]

{ #category : 'views' }
ProcessingSource >> gtIntermediaryRepresentationFor: aView [
	<gtView>
	^ (self program gtIntermediaryRepresentationFor: aView)
		title: 'IR';
		priority: 7
]

{ #category : 'views' }
ProcessingSource >> gtOutputFor: aView [
	<gtView>
	^ (self program gtOutputFor: aView)
		title: 'Output' translated;
		priority: 20
]

{ #category : 'views' }
ProcessingSource >> gtSourceCodeFor: aView [
	<gtView>
	^ (self program gtSourceCodeFor: aView)
		title: 'Source' translated;
		priority: 2
]

{ #category : 'views' }
ProcessingSource >> gtTranspilationFor: aView [
	<gtView>
	^ (self program gtTranspilationFor: aView)
		title: 'Transpiled' translated;
		priority: 6
]

{ #category : 'views' }
ProcessingSource >> gtTreeFor: aView [
	<gtView>
	^ (self program gtTreeFor: aView)
		title: 'AST';
		priority: 5
]

{ #category : 'announcements' }
ProcessingSource >> onSourceChangedTo: aCode [
	source writeStreamDo: [ :stream | stream nextPutAll: aCode ].
	self announceSourceChange
]

{ #category : 'initialization' }
ProcessingSource >> program [
	^ ProcessingProgram new source: self
]

{ #category : 'runtime' }
ProcessingSource >> render [
	^ self program canvas asElement
]

{ #category : 'runtime' }
ProcessingSource >> renderLive [
	^ self renderLiveView: #gtOutputFor:
]

{ #category : 'runtime' }
ProcessingSource >> renderLiveView: aViewSelector [
	(self class methodDict includesKey: aViewSelector)
		ifFalse: [ ^ LiveViewWrapper createFor: self program view: aViewSelector ].
	^ LiveViewWrapper createFor: self view: aViewSelector
]

{ #category : 'initialization' }
ProcessingSource >> source: aSource [
	source := aSource
]
