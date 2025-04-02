Class {
	#name : #ProcessingSource,
	#superclass : #Object,
	#instVars : [
		'source'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingSource >> asString [
	^ source contents
]

{ #category : #accessing }
ProcessingSource >> fromFile: locator [
	source := locator.
]

{ #category : #'as yet unclassified' }
ProcessingSource >> fromString: code [
	"TODO: this file does not seem to be modifyable (in #gtContentsFor)"
	source := (FileSystem memory workingDirectory / 'sample.pyde') writeStreamDo: [ :stream | stream nextPutAll: code ]; yourself.
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtBytecodeFor: aView [
	<gtView>
	^ self program gtBytecodeFor: aView
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
ProcessingSource >> gtOutputFor: aView [
	<gtView>
	^ self program gtOutputFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtSourceCodeFor: aView [
	<gtView>
	^ self program gtSourceCodeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtTreeFor: aView [
	<gtView>
	^ self program gtTreeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ self program gtViewIntermediaryRepresentationFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingSource >> program [
	^ ProcessingProgram new source: self asString
]

{ #category : #'as yet unclassified' }
ProcessingSource >> render [
	^ self program canvas render
]
