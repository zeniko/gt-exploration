Class {
	#name : #Stepper,
	#superclass : #Object,
	#instVars : [
		'list',
		'view',
		'index',
		'announcer'
	],
	#category : #'GtExploration-GtExtensions'
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
	list size = 0 ifTrue: [ ^ aView empty ].
	
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
	list ifEmpty: [ ^ aView empty ].
	
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
			
			GtPhlowView empty columnedList
				items: [ list ];
				column: 'Index' translated
					text: [ :each :eachIndex |
						eachIndex asRopedText foreground: Color gray 
					] width: 45;
				column: 'Item' translated
					"TODO: use each gtDisplayText instead?"
					text: [ :each | each asString ];
				asElementDo: [ :e | child := e ].
			child
				background: Color white;
				margin: (BlInsets all: 5).
			element addChild: child.
			"TODO: less hacky way to get to the list (view)?"
			listElement := child children last.
			
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

{ #category : #accessing }
Stepper >> index [
	^ index
]

{ #category : #accessing }
Stepper >> stepTo: anIndex [
	index := anIndex clampBetween: 1 and: list size.
	announcer announce: StepperUpdate new.
]
