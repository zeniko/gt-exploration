"
Processing programs render their output through canvas elements. Embed such elements e.g. in Lepiter's Element snippet.

To create such an element, use {{gtClass:ProcessingCanvas}}:
```
ProcessingCanvas new
	size: 200 by: 200;
	rect: 100 by: 100 at: 50 @ 50;
	asElement
```
or rather one provided through {{gtClass:ProcessingSource}}:
```
(ProcessingSource fromString: 'size(200, 200); rect(50, 50, 100, 100)')
	program canvas asElement
```

This is the view in the model-view-presenter pattern implemented by {{gtClass:ProcessingCanvas}}, {{gtClass:ProcessingCanvasElement}} and {{gtClass:ProcessingCanvasPresenter}}.
"
Class {
	#name : 'ProcessingCanvasElement',
	#superclass : 'BlElement',
	#instVars : [
		'visualContainer',
		'presenter'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'initalization' }
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
			(aShape isMemberOf: BlElement) | (aShape isKindOf: BlSkiaImageElement)
				ifTrue: [ marker centerAnchor: (BlElementTopLeftAnchor element: aShape) ].
			aShape addChild: marker ]
]

{ #category : 'initialization' }
ProcessingCanvasElement >> addTextCanvas: aTranscript [
	| textCanvas |
	textCanvas := aTranscript asElement
			constraintsDo: [ :c | 
				c frame vertical weight: 0.3.
				c frame vertical alignBottom ].
	self addChild: textCanvas.
	visualContainer constraintsDo: [ :c | c frame vertical weight: 0.7 ].
	^ textCanvas
]

{ #category : 'initialization' }
ProcessingCanvasElement >> addVisualCanvas: aSize colored: aColor [
	| canvasElement |
	canvasElement := BlElement new
			size: aSize;
			background: aColor;
			yourself.
	visualContainer addChild: canvasElement asScalableElement.
	^ canvasElement
]

{ #category : 'initialization' }
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

{ #category : 'accessing' }
ProcessingCanvasElement >> presenter [
	^ presenter
]

{ #category : 'accessing' }
ProcessingCanvasElement >> presenter: aPresenter [
	presenter := aPresenter
]
