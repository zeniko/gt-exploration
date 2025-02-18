Class {
	#name : #ProcessingSource,
	#superclass : #Object,
	#instVars : [
		'source'
	],
	#category : #GtExploration
}

{ #category : #'as yet unclassified' }
ProcessingSource >> asString [
	^ source contents
]

{ #category : #accessing }
ProcessingSource >> fromFile: locator [
	source := locator
]

{ #category : #'as yet unclassified' }
ProcessingSource >> fromString: code [
	"TODO: this file does not seem to be modifyable (in #gtContentsFor)"
	source := (FileSystem memory workingDirectory / 'sample.pyde') writeStreamDo: [ :stream | stream nextPutAll: code ]; yourself
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
		priority: 10;
		updateWhen: GtFileWatcherModificationAnnouncement in: eventLoop announcer;
		stencil: [ source gtEditorView ]
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtOutputFor: aView [
	"copy/paste from BlElement > #gtLiveFor:"
	<gtView>
	^ aView explicit
		title: 'Output (Live)';
		priority: 20;
		stencil: [
			| ast canvas |
			"TODO: handle syntax errors"
			ast := ProcessingParser parse: self asString.
			canvas := ProcessingCanvas new.
			(ProcessingInterpreter new) interpret: ast onto: canvas.
			GtInspectorElementLiveViewContainer new
				element: canvas render;
				clipChildren: false
		]
]
