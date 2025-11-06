"
This class imitates a {{gtClass:GtInspector}}'s object header for when a view is displayed alone but the header is still desired.
"
Class {
	#name : #BlContainerWithHeaderElement,
	#superclass : #BlElement,
	#instVars : [
		'header'
	],
	#category : #'GtExploration-GtExtensions'
}

{ #category : #accessing }
BlContainerWithHeaderElement >> headerText [
	^ header text
]

{ #category : #accessing }
BlContainerWithHeaderElement >> headerText: aText [
	header text: aText
]

{ #category : #initialization }
BlContainerWithHeaderElement >> initialize [
	| textWrapper |
	super initialize.
	header := BlAttributedTextElement new
			padding: (BlInsets all: 15);
			text: self asRopedText;
			constraintsDo: [ :c | 
				c vertical fitContent.
				c horizontal matchParent ].
	textWrapper := BlElement new
			addChild: header;
			constraintsDo: [ :c | 
				c vertical exact: 40.
				c horizontal matchParent ];
			background: BrGlamorousColors defaultHeaderBackgroundColor.
	self
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		layout: BlLinearLayout vertical;
		addChild: textWrapper
]
