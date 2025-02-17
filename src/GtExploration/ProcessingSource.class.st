Class {
	#name : #ProcessingSource,
	#superclass : #Object,
	#instVars : [
		'source'
	],
	#category : #GtExploration
}

{ #category : #accessing }
ProcessingSource >> fromFile: locator [
	source:=locator
]

{ #category : #'as yet unclassified' }
ProcessingSource >> gtContentsFor: aView [
	<gtView>
	| eventLoop |
	source isFile ifFalse: [ ^ aView empty ].
	[ source readStreamDo: [ :s | s next: 1000 ] ]
		on: ZnInvalidUTF8
		do: [ ^ aView empty ].

	eventLoop := source watcher startLoop.

	^ aView explicit
		title: 'Contents' translated;
		priority: 50;
		updateWhen: GtFileWatcherModificationAnnouncement in: eventLoop announcer;
		stencil: [ source gtEditorView ]
]
