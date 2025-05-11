Class {
	#name : #GtSceneryColoredLineStencil,
	#superclass : #GtSceneryConnectionStencil,
	#instVars : [
		'borderColor'
	],
	#category : #'GtExploration-GtExtensions'
}

{ #category : #accessing }
GtSceneryColoredLineStencil >> borderColor [
	^ borderColor ifNotNil: [ borderColor ] ifNil: [ Color black ]
]

{ #category : #accessing }
GtSceneryColoredLineStencil >> borderColor: aBorderColor [
	borderColor := aBorderColor.
]

{ #category : #initialization }
GtSceneryColoredLineStencil >> create [
	^ BlLineElement new
		border: (BlBorder paint: self borderColor width: 1);
		zIndex: -100;
		toHead: BlArrowheadNone new
]
