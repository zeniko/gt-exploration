Class {
	#name : #ProcessingCanvasElement,
	#superclass : #BlElement,
	#instVars : [
		'visualContainer',
		'presenter'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initalization }
ProcessingCanvasElement class >> explainShape: aShape as: aTag [
	(aShape children
		select: [ :child | 
			(child isKindOf: BlEllipseElement)
				and: [ (child aptitude isKindOf: GtExplainerTargetAptitude)
						and: [ child aptitude explanationModel = aTag ] ] ]) size = 0
		ifTrue: [ | marker |
			marker := BlEllipseElement new
					centerAnchor: (BlElementCenterAnchor element: aShape);
					majorRadius: 4;
					minorRadius: 4;
					aptitude: (GtExplainerTargetAptitude new explanationModel: aTag).
			aShape addChild: marker ]
]

{ #category : #initialization }
ProcessingCanvasElement >> addTextCanvas: aTranscript [
	self
		addChild: (aTranscript asElement
				constraintsDo: [ :c | 
					c frame vertical weight: 0.3.
					c frame vertical alignBottom ]).
	visualContainer constraintsDo: [ :c | c frame vertical weight: 0.7 ]
]

{ #category : #initialization }
ProcessingCanvasElement >> addVisualCanvas: aSize colored: aColor [
	| canvasElement |
	canvasElement := BlElement new
			size: aSize;
			background: aColor;
			yourself.
	visualContainer addChild: canvasElement asScalableElement.
	^ canvasElement
]

{ #category : #initialization }
ProcessingCanvasElement >> initialize [
	super initialize.

	visualContainer := BlElement new
			constraintsDo: [ :c | 
				c vertical matchParent.
				c horizontal matchParent ];
			yourself.

	self
		background: Color white;
		layout: BlFrameLayout new;
		constraintsDo: [ :c | 
			c vertical matchParent.
			c horizontal matchParent ];
		addChild: visualContainer
]

{ #category : #accessing }
ProcessingCanvasElement >> presenter [
	^ presenter
]

{ #category : #accessing }
ProcessingCanvasElement >> presenter: aPresenter [
	presenter := aPresenter
]
