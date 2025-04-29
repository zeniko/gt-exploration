Class {
	#name : #Stepper,
	#superclass : #Object,
	#instVars : [
		'list',
		'view',
		'index',
		'announcer'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
Stepper class >> for: aList view: aView [
	^ Stepper new for: aList view: aView
]

{ #category : #initialization }
Stepper >> for: aList view: aView [
	list := aList.
	view := aView.
	index := 1.
	announcer := Announcer new.
]

{ #category : #views }
Stepper >> gtContentFor: aView [
	<gtView>
	list ifNil: [ ^ aView empty ].
	
	^ aView explicit
		priority: 1;
		title: 'Step';
		stencil: [ | element child editor program |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 1).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			((list at: index) perform: view with: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			element addChild: child.
			
			element ];
	
		actionButtonIcon: BrGlamorousVectorIcons left
			tooltip: 'Move one step backward'
			action: [ :button | self stepTo: index - 1. ];
		actionButtonIcon: BrGlamorousVectorIcons right
			tooltip: 'Move one step forward'
			action: [ :button | self stepTo: index + 1. ];
		updateWhen: StepperUpdate in: announcer
]

{ #category : #views }
Stepper >> gtListViewFor: aView [
	<gtView>
	list ifNil: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'With List';
		stencil: [ | element listElement child |
			element := BlElement new.
			element layout: (BlGridLayout new columnCount: 1).
			element
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ].
			
			GtPhlowView empty list
				items: [ list ];
				itemText: [ :each | each asString ];
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			listElement := child.
			
			(self gtContentFor: GtPhlowView empty)
				asElementDo: [ :e | child := e ].
			child
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				margin: (BlInsets all: 5).
			element addChild: child.
			
			listElement
				selectOne: index;
				"scrollToSelection;"
				when: BrSelectionChanged
				do:
					[ :anEvent |
						listElement selectedIndices ifNotEmpty:
							[ :theIndices | self stepTo: theIndices first. ]
					].
			
			element ];
		updateWhen: StepperUpdate in: announcer
]

{ #category : #'as yet unclassified' }
Stepper >> index [
	^ index
]

{ #category : #'as yet unclassified' }
Stepper >> stepTo: aIndex [
	index := aIndex clampBetween: 1 and: list size.
	announcer announce: StepperUpdate new.
]
