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
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: ((mapping size nthRoot: 2) roundUpTo: 1)).
			element
				constraintsDo: [ :c |
					c vertical matchParent.
					c horizontal matchParent ].
			
			children := mapping collect: [ :assoc |
				| child |
				(assoc key perform: assoc value with: GtPhlowView empty)
					asElementDo: [ :e | child := e ].
				child
					background: Color white;
					margin: (BlInsets all: 5).
				element addChild: child.
				
				child children ifNotEmpty: [ child children last ] ifEmpty: [ child ]
			].
			
			(children size = 2 and: [
				(children first isKindOf: BrColumnedList) &
				(children second isKindOf: BrColumnedList)
			]) ifTrue: [
				self gtSynchronizeScrollstate: children first with: children second.
			].
			
			element ]
]

{ #category : #views }
ViewComparison >> gtSynchronizeScrollstate: aList with: anotherList [
	| skipScroll |
	"Skip auto-scrolling when an item in the second list is selected, which causes the first list to scroll to it."
	skipScroll := false.
	
	"Selection is synchronized both ways."
	aList when: BrSelectionChanged do: [ :event |
		aList selectedIndices ifNotEmpty: [
			anotherList selectOne: (aList selectedIndices last clampBetween: 1 and: anotherList maxSelectionIndex).
				anotherList scrollToSelection.
		].
	].
	anotherList when: BrSelectionChanged do: [ :event |
		anotherList selectedIndices ifNotEmpty: [
			aList selectOne: (anotherList selectedIndices last clampBetween: 1 and: aList maxSelectionIndex).
				skipScroll := true.
				aList scrollToSelection.
		].
	].
	"Scrolling only works one-way, as when positions don't match up exactly, there's a feedback loop which causes a very noticeable lag"
	aList children first addEventHandlerOn: BlElementScrolledEvent do: [ :event |
		| range |
		range := aList children first instVarNamed: #layoutPositionsRange.
		range ifNotNil: [ range ifNotEmpty: [
			skipScroll ifTrue: [ skipScroll := false. ] ifFalse: [
				"Try to ensure that the entire range is visible"
				anotherList scrollToIndex: range first offset: range last - range first - 1.
			].
		] ].
	].
]

{ #category : #initialization }
ViewComparison >> mapping: aMapping [
	mapping := aMapping
]
