Class {
	#name : #ProcessingCanvasShape,
	#superclass : #Object,
	#instVars : [
		'fillColor',
		'border',
		'transform',
		'position',
		'context'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasShape >> asElement [
	self subclassResponsibility
]

{ #category : #views }
ProcessingCanvasShape >> asElementTransformed [
	| element |
	element := self asElement.

	(transform
		value: (element transform
				topLeftOrigin;
				translateBy: position)) apply.
	^ element
]

{ #category : #accessing }
ProcessingCanvasShape >> border [
	^ border
]

{ #category : #accessing }
ProcessingCanvasShape >> border: aBorder [
	border := aBorder
]

{ #category : #accessing }
ProcessingCanvasShape >> context [
	^ context
]

{ #category : #accessing }
ProcessingCanvasShape >> context: aContext [
	context := aContext
]

{ #category : #accessing }
ProcessingCanvasShape >> fillColor [
	^ fillColor
]

{ #category : #accessing }
ProcessingCanvasShape >> fillColor: aColor [
	fillColor := aColor
]

{ #category : #views }
ProcessingCanvasShape >> gtLiveFor: aView [
	<gtView>
	^ aView explicit
		stencil: [ GtInspectorElementLiveViewContainer new
				element: self asElementTransformed;
				background: BlBackground transparent;
				clipChildren: false ];
		title: 'Live' translated;
		priority: 10
]

{ #category : #accessing }
ProcessingCanvasShape >> position [
	^ position
]

{ #category : #accessing }
ProcessingCanvasShape >> position: aPosition [
	position := aPosition
]

{ #category : #accessing }
ProcessingCanvasShape >> transform [
	^ transform
]

{ #category : #accessing }
ProcessingCanvasShape >> transform: aTransform [
	transform := aTransform
]
