Class {
	#name : #GtSceneryObjectLabelStencil,
	#superclass : #GtSceneryTextLabelStencil,
	#instVars : [
		'object'
	],
	#category : #'GtExploration-GtExtensions'
}

{ #category : #menu }
GtSceneryObjectLabelStencil class >> itemCreationMenuSpecification [
	"<sceneryItemCreationSpecification>"
	"Only for automatic creation!"
	^ nil
]

{ #category : #'as yet unclassified' }
GtSceneryObjectLabelStencil class >> leJsonV4Name [
	"The name (symbol) for this type of stencil in the JSON representation."
	^ #sceneryObjectLabelStencil
]

{ #category : #'as yet unclassified' }
GtSceneryObjectLabelStencil >> defaultLabel [
	^ object asString
]

{ #category : #'api - instantiation' }
GtSceneryObjectLabelStencil >> elementClass [
	^ GtSceneryTextLabelElement
]

{ #category : #listeners }
GtSceneryObjectLabelStencil >> handleDoubleClickForItemElement: anItemElement inSceneryElement: aSceneryElement [
	"Show the object"
	anItemElement fireEvent: (GtSceneryObjectToSpawn new object: object "asPagePhlowTool")
]

{ #category : #accessing }
GtSceneryObjectLabelStencil >> hoverColor [
	^ Color paleBlue
]

{ #category : #accessing }
GtSceneryObjectLabelStencil >> label [
	^ label ifNotNil: [ label ] ifNil: [ self defaultLabel ]
]

{ #category : #accessing }
GtSceneryObjectLabelStencil >> object [
	^ object
]

{ #category : #accessing }
GtSceneryObjectLabelStencil >> object: anObject [
	object := anObject
]

{ #category : #copying }
GtSceneryObjectLabelStencil >> postCopy [
	super postCopy.
	"object := object copy."
]

{ #category : #storing }
GtSceneryObjectLabelStencil >> storeOnAttributes [
	"Attributes used in the #storeOn:method"

	^ super storeOnAttributes , {#databaseName}
]
