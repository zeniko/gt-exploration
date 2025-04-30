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
		source announcer announce: (ProcessingSourceChanged new source: source).
	] for: source.
	^ source
]

{ #category : #initialization }
ProcessingSource class >> fromString: code [
	| source virtual |
	virtual := (FileSystem memory workingDirectory / 'sample.pyde') writeStreamDo: [ :stream | stream nextPutAll: code ]; yourself.
	source := ProcessingSource new source: virtual.
	virtual watcher startLoop announcer when: GtFileWatcherModificationAnnouncement do: [ :event |
		source announcer announce: (ProcessingSourceChanged new source: source).
	] for: source.
	^ source
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
	^ aView explicit
		priority: 1;
		title: 'Abstractions' translated;
		stencil: [ | element child editor program |
			program := self program.
			
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			(program gtContentsFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			editor := child.
			
			(program gtTreeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			program ast topParent gtHookEditor: editor toTree: child children last.
			
			(program gtBytecodeFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			program gtHookBytecode: editor toList: child.
			
			(program gtOutputFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			"TODO: Hook into editor"
			
			element ]
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
	"TODO: handle syntax errors"
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
ProcessingSource >> gtOutputFor: aView [
	<gtView>
	^ (self program gtOutputFor: aView)
		title: 'Output' translated;
		priority: 20
]

{ #category : #views }
ProcessingSource >> gtSourceCodeFor: aView [
	<gtView>
	^ (self program gtSourceCodeFor: aView)
		title: 'Transpiled' translated;
		priority: 5
]

{ #category : #views }
ProcessingSource >> gtTreeFor: aView [
	<gtView>
	^ (self program gtTreeFor: aView)
		title: 'AST';
		priority: 3
]

{ #category : #views }
ProcessingSource >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ (self program gtViewIntermediaryRepresentationFor: aView)
		title: 'IR';
		priority: 7
]

{ #category : #announcements }
ProcessingSource >> onSourceChangedTo: aCode [
	source writeStreamDo: [ :stream | stream nextPutAll: aCode ].
	self announcer announce: (ProcessingSourceChanged new source: self).
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
