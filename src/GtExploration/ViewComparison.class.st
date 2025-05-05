Class {
	#name : #ViewComparison,
	#superclass : #Object,
	#instVars : [
		'mapping'
	],
	#category : #'GtExploration-GtExtensions'
}

{ #category : #initialization }
ViewComparison class >> newFor: aMapping [
	^ ViewComparison new mapping: aMapping
]

{ #category : #views }
ViewComparison >> gtCompareFor: aView [
	<gtView>
	^ aView explicit
		priority: 1;
		title: 'Comparison' translated;
		stencil: [ | element children |
			children := OrderedCollection new.
			
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 2).
			element
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			mapping do: [ :assoc |
				| child |
				(assoc key perform: assoc value with: GtPhlowView empty)
					asElementDo: [ :e | child := e ].
				child
					background: Color white;
					margin: (BlInsets all: 5).
				element addChild: child.
				children add: child.
			].
			
			"TODO: synchronize list children, if there are any"
			
			element ]
]

{ #category : #initialization }
ViewComparison >> mapping: aMapping [
	mapping := aMapping
]
