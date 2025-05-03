Class {
	#name : #ProcessingSource,
	#superclass : #Object,
	#instVars : [
		'source',
		'announcer'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingSource class >> fromFile: locator [
	| source |
	source := ProcessingSource new source: locator.
	locator watcher startLoop announcer when: GtFileWatcherModificationAnnouncement do: [ :event |
		source announceSourceChange.
	] for: source.
	^ source
]

{ #category : #initialization }
ProcessingSource class >> fromSnippet: aSnippet [
	^ self fromViewModel: aSnippet asSnippetViewModel coderViewModel
]

{ #category : #initialization }
ProcessingSource class >> fromString: code [
	^ self fromFile: ((FileSystem memory workingDirectory / ('prog' , ((SharedRandom globalGenerator nextInteger: 89999) + 10000) asString , '.pyde')) writeStreamDo: [ :stream | stream nextPutAll: code ]; yourself)
]

{ #category : #initialization }
ProcessingSource class >> fromViewModel: aViewModel [
	| source |
	source := self fromString: aViewModel coderModel currentSourceString.
	aViewModel announcer when: GtTextualCoderViewModelTextChanged do: [ :event |
		source onSourceChangedTo: event text asString.
	] for: source.
	^ source
]

{ #category : #announcements }
ProcessingSource >> announceSourceChange [
	| ast |
	[
		ast := ProcessingParser parse: self asString.
		self announcer announce: (ProcessingSourceChanged new source: self; ast: ast).
	]
		on: SmaCCParserError do: [ :error |
			"silently swallow errors on updates, as these happen intermittently during incomplete/slow typing"
		].
]

{ #category : #announcements }
ProcessingSource >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #accessing }
ProcessingSource >> asString [
	^ source contents
]

{ #category : #views }
ProcessingSource >> gtAbstractionsFor: aView [
	<gtView>
	^ (self program gtAbstractionsFor: aView)
		priority: 1;
		title: 'Abstractions' translated
]

{ #category : #views }
ProcessingSource >> gtBytecodeFor: aView [
	<gtView>
	^ (self program gtBytecodeFor: aView)
		title: 'Bytecode' translated;
		priority: 10
]

{ #category : #views }
ProcessingSource >> gtContentsFor: aView [
	"copy/paste from FileLocator > AbstractFileReference > #gtContentsFor:"
	<gtView>
	| eventLoop |
	source isFile ifFalse: [ ^ aView empty ].
	[ source readStreamDo: [ :s | s next: 1000 ] ]
		on: ZnInvalidUTF8
		do: [ ^ aView empty ].
	
	^ aView explicit
		title: 'Source' translated;
		priority: 2;
		stencil: [ source gtEditorView ];
		updateWhen: ProcessingSourceChanged in: self announcer
]

{ #category : #views }
ProcessingSource >> gtIntermediaryRepresentationFor: aView [
	<gtView>
	^ (self program gtIntermediaryRepresentationFor: aView)
		title: 'IR';
		priority: 7
]

{ #category : #views }
ProcessingSource >> gtOutputFor: aView [
	<gtView>
	^ (self program gtOutputFor: aView)
		title: 'Output' translated;
		priority: 20
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtSourceBytesFor: aView [
	<gtView>
	^ (self program gtSourceBytesFor: aView)
		title: 'Source Bytes' translated;
		priority: 3
]

{ #category : #views }
ProcessingSource >> gtSourceCodeFor: aView [
	<gtView>
	^ (self program gtSourceCodeFor: aView)
		title: 'Transpiled' translated;
		priority: 6
]

{ #category : #views }
ProcessingSource >> gtTreeFor: aView [
	<gtView>
	^ (self program gtTreeFor: aView)
		title: 'AST';
		priority: 5
]

{ #category : #announcements }
ProcessingSource >> onSourceChangedTo: aCode [
	source writeStreamDo: [ :stream | stream nextPutAll: aCode ].
	self announceSourceChange.
]

{ #category : #initialization }
ProcessingSource >> program [
	^ ProcessingProgram new source: self
]

{ #category : #runtime }
ProcessingSource >> render [
	^ self program canvas asElement
]

{ #category : #accessing }
ProcessingSource >> source: aSource [
	source := aSource.
]
