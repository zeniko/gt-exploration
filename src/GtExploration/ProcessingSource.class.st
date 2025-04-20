Class {
	#name : #ProcessingSource,
	#superclass : #Object,
	#instVars : [
		'source'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingSource >> asString [
	^ source contents
]

{ #category : #initialization }
ProcessingSource >> fromFile: locator [
	source := locator.
]

{ #category : #initialization }
ProcessingSource >> fromString: code [
	"TODO: this file does not seem to be modifyable (in #gtContentsFor)"
	source := (FileSystem memory workingDirectory / 'sample.pyde') writeStreamDo: [ :stream | stream nextPutAll: code ]; yourself.
]

{ #category : #views }
ProcessingSource >> gtBytecodeFor: aView [
	<gtView>
	^ self program gtBytecodeFor: aView
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

	eventLoop := source watcher startLoop.

	^ aView explicit
		title: 'Contents';
		priority: 1;
		updateWhen: GtFileWatcherModificationAnnouncement in: eventLoop announcer;
		stencil: [ source gtEditorView ]
]

{ #category : #views }
ProcessingSource >> gtOutputFor: aView [
	<gtView>
	^ self program gtOutputFor: aView
]

{ #category : #views }
ProcessingSource >> gtSourceCodeFor: aView [
	<gtView>
	^ self program gtSourceCodeFor: aView
]

{ #category : #views }
ProcessingSource >> gtTreeFor: aView [
	<gtView>
	^ self program gtTreeFor: aView
]

{ #category : #views }
ProcessingSource >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ self program gtViewIntermediaryRepresentationFor: aView
]

{ #category : #initialization }
ProcessingSource >> program [
	^ ProcessingProgram new source: self asString
]

{ #category : #runtime }
ProcessingSource >> render [
	^ self program canvas asElement
]
