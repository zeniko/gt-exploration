"
This class wraps a view inside a {{gtClass:GtInspector}} so that it can be updated when it's needed in a {{gtClass:BlElement}} context (such as a Lepiter notebook).
"
Class {
	#name : #LiveViewWrapper,
	#superclass : #Object,
	#instVars : [
		'view',
		'object'
	],
	#category : #'GtExploration-GtExtensions'
}

{ #category : #initialization }
LiveViewWrapper class >> createFor: anObject view: aView [
	^ LiveViewWrapper new object: anObject view: aView
]

{ #category : #views }
LiveViewWrapper >> asElement [
	^ (GtInspector forObject: object viewSelector: view) asElement
]

{ #category : #views }
LiveViewWrapper >> gtViewFor: aView [
	<gtView>
	^ (object perform: view with: aView)
		actionButtonIcon: BrGlamorousVectorIcons playinspect
		tooltip: 'Inspect wrapped object' translated
		action: [ :button | button fireEvent: (GtPhlowObjectToSpawn new object: object) ]
]

{ #category : #accessing }
LiveViewWrapper >> object [
	^ object
]

{ #category : #accessing }
LiveViewWrapper >> object: anObject view: aView [
	object := anObject.
	view := aView
]

{ #category : #accessing }
LiveViewWrapper >> view [
	^ view
]
