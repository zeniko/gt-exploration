Class {
	#name : #Stepper,
	#superclass : #Object,
	#instVars : [
		'list',
		'view',
		'index',
		'announcer'
	],
	#category : #'GtExploration-Tools'
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
		title: 'Step' translated;
		stencil: [
			| element |
			((list at: index) perform: view with: GtPhlowView empty) asElementDo: [ :e | element := e ].
			element asScalableElement
		];
		actionButtonIcon: BrGlamorousVectorIcons left
			tooltip: 'Move one step backward' translated
			action: [ :button | self stepTo: index - 1. ];
		actionButtonIcon: BrGlamorousVectorIcons right
			tooltip: 'Move one step forward' translated
			action: [ :button | self stepTo: index + 1. ];
		updateWhen: StepperUpdate in: announcer
]

{ #category : #views }
Stepper >> gtListViewFor: aView [
	<gtView>
	list ifNil: [ ^ aView empty ].
	^ aView explicit
		priority: 10;
		title: 'With List' translated;
		stencil: [ | element listElement child |
			element := BlElement new.
			element
				layout: BlLinearLayout vertical;
				constraintsDo: [ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
				when: BlElementExtentChangedEvent
				do: [ :anEvent |
					element measuredBounds extent x > element measuredBounds extent y ifTrue: [
						element layout: BlLinearLayout horizontal.
					] ifFalse: [
						element layout: BlLinearLayout vertical.
					].
				].
			
			GtPhlowView empty list
				items: [ list ];
				itemText: [ :each | (list indexOf: each) asString , ': ' , each asString ];
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
				scrollToSelection;
				when: BrSelectionChanged
				do:
					[ :anEvent |
						listElement selectedIndices ifNotEmpty:
							[ :theIndices | self stepTo: theIndices first. ]
					].
			announcer when: StepperUpdate do: [
				listElement selectOne: index; scrollToSelection.
			] for: listElement.
			
			element ];
		actionButtonIcon: BrGlamorousVectorIcons left
			tooltip: 'Move one step backward' translated
			action: [ :button | self stepTo: index - 1. ];
		actionButtonIcon: BrGlamorousVectorIcons right
			tooltip: 'Move one step forward' translated
			action: [ :button | self stepTo: index + 1. ]
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
