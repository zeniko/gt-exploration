"
This class provides a stepper interface, allowing to step through the same view of multiple objects.

```
source := ProcessingSource fromString: 's = ""Hello, world""; print(s)'.
Stepper for: [ source program runSteps ] view: #gtAbstractionsFor:
```

"
Class {
	#name : 'Stepper',
	#superclass : 'Object',
	#instVars : [
		'list',
		'view',
		'index',
		'announcer',
		'reloader',
		'background'
	],
	#category : 'GtExploration-GtExtensions',
	#package : 'GtExploration',
	#tag : 'GtExtensions'
}

{ #category : 'initialization' }
Stepper class >> for: aList view: aView [
	^ Stepper new for: aList view: aView
]

{ #category : 'views' }
Stepper >> addActionButtons: aView [
	reloader
		ifNotNil: [ aView
				actionButtonIcon: BrGlamorousVectorIcons refresh
				tooltip: 'Reload the steps from their source' translated
				action: [ :button | 
					list := reloader value.
					self stepTo: index ] ].
	^ aView
		actionButtonIcon: BrGlamorousVectorIcons left
			tooltip: 'Move one step backward' translated
			action: [ :button | self stepTo: index - 1 ];
		actionButtonIcon: BrGlamorousVectorIcons right
			tooltip: 'Move one step forward' translated
			action: [ :button | self stepTo: index + 1 ]
]

{ #category : 'views' }
Stepper >> asElement [
	^ (GtInspector forObject: self) asElement
]

{ #category : 'accessing' }
Stepper >> background: aBackground [
	background := aBackground
]

{ #category : 'initialization' }
Stepper >> for: aList view: aView [
	(aList isKindOf: FullBlockClosure)
		ifTrue: [ reloader := aList.
			list := reloader value ]
		ifFalse: [ reloader := nil.
			list := aList ].
	view := aView.
	index := 1.
	announcer := Announcer new
]

{ #category : 'views' }
Stepper >> gtContentFor: aView [
	<gtView>
	list ifNil: [ ^ aView empty ].
	list size = 0 ifTrue: [ ^ aView empty ].
	^ self
		addActionButtons: (aView explicit
				priority: 1;
				title: 'Step' translated;
				stencil: [ | element |
					((list at: index) perform: view with: GtPhlowView empty)
						asElementDo: [ :e | element := e asScalableElement ].
					background ifNotNil: [ element background: background ].
					element ];
				updateWhen: StepperUpdate in: announcer)
]

{ #category : 'views' }
Stepper >> gtListViewFor: aView [
	<gtView>
	list ifNil: [ ^ aView empty ].
	list ifEmpty: [ ^ aView empty ].
	^ self
		addActionButtons: (aView explicit
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
								element measuredBounds extent x > element measuredBounds extent y
									ifTrue: [ element layout: BlLinearLayout horizontal ]
									ifFalse: [ element layout: BlLinearLayout vertical ] ].

					GtPhlowView empty columnedList
						items: [ list ];
						column: 'Index' translated
							text: [ :each :eachIndex | eachIndex asRopedText foreground: Color gray ]
							width: 45;
						column: 'Item' translated
							text: [ :each | each asString	"TODO: use each gtDisplayText instead?" ];
						asElementDo: [ :e | child := e ].
					child
						constraintsDo: [ :c | 
							c vertical matchParent.
							c horizontal matchParent.
							c linear weight: 0.5 ];
						background: Color white;
						margin: (BlInsets all: 5).
					element addChild: child.
					listElement := child children last.	"TODO: less hacky way to get to the list (view)?"

					(self gtContentFor: GtPhlowView empty) asElementDo: [ :e | child := e ].
					element addChild: child.

					listElement
						selectOne: index;
						scrollToSelection;
						when: BrSelectionChanged
							do: [ :anEvent | 
								listElement selectedIndices
									ifNotEmpty: [ :theIndices | self stepTo: theIndices first ] ].

					announcer
						when: StepperUpdate
						do: [ listElement
								selectOne: index;
								scrollToSelection ]
						for: listElement.

					element ])
]

{ #category : 'accessing' }
Stepper >> index [
	^ index
]

{ #category : 'accessing' }
Stepper >> list [
	^ list
]

{ #category : 'accessing' }
Stepper >> stepTo: anIndex [
	index := anIndex clampBetween: 1 and: list size.
	announcer announce: StepperUpdate new
]
