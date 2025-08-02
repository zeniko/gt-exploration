Class {
	#name : #ProcessingCanvasPresenter,
	#superclass : #Object,
	#instVars : [
		'containerElement',
		'canvasElement',
		'canvasBuffer',
		'canvasOutput',
		'model',
		'transcriptElement',
		'threadSafe'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvasPresenter class >> newFor: aModel [
	^ ProcessingCanvasPresenter new model: aModel
]

{ #category : #accessing }
ProcessingCanvasPresenter >> canvasElement [
	^ canvasElement
]

{ #category : #outputting }
ProcessingCanvasPresenter >> clearWithBackground: aColor [
	"background() is used as a hint to buffer animations"

	canvasBuffer ifNotNil: [ canvasOutput := canvasBuffer ].
	self
		uiActionDo: [ canvasOutput background: aColor.
			canvasOutput children do: #removeFromParent ]
]

{ #category : #accessing }
ProcessingCanvasPresenter >> containerElement [
	^ containerElement
]

{ #category : #outputting }
ProcessingCanvasPresenter >> display: aShape [
	| element |
	element := aShape asElementTransformed.
	self
		uiActionDo: [ canvasOutput addChild: element.
			containerElement
				dispatchEvent: (ProcessingExplainShape newFor: element createdBy: aShape context)	"Allow adding an explanation marker." ]
]

{ #category : #outputting }
ProcessingCanvasPresenter >> displayTranscript: aTranscript for: aSource [
	self
		uiActionDo: [ transcriptElement
				ifNil: [ transcriptElement := containerElement addTextCanvas: aTranscript ].
			containerElement
				dispatchEvent: (ProcessingExplainShape newFor: transcriptElement createdBy: aSource)	"Allow adding an explanation marker." ]
]

{ #category : #initialization }
ProcessingCanvasPresenter >> initialize [
	containerElement := ProcessingCanvasElement new
			presenter: self;
			yourself.
	canvasElement := (containerElement
			addVisualCanvas: 100 @ 100
			colored: Color veryLightGray)
			when: BlMouseMoveEvent do: [ :event | model onMouseMove: event ];
			when: BlMouseDownEvent do: [ :event | model onMouseDown: event ];
			when: BlMouseUpEvent do: [ :event | model onMouseUp: event ];
			yourself.
	transcriptElement := nil.
	canvasBuffer := nil.	"Animations are buffered starting with the second frame."
	canvasOutput := canvasElement.
	threadSafe := false
]

{ #category : #accessing }
ProcessingCanvasPresenter >> model [
	^ model
]

{ #category : #accessing }
ProcessingCanvasPresenter >> model: aModel [
	model := aModel
]

{ #category : #outputting }
ProcessingCanvasPresenter >> outputSize: aSize [
	self uiActionDo: [ canvasElement size: aSize ]
]

{ #category : #accessing }
ProcessingCanvasPresenter >> threadSafe [
	^ threadSafe
]

{ #category : #accessing }
ProcessingCanvasPresenter >> threadSafe: anObject [
	threadSafe := anObject
]

{ #category : #processing }
ProcessingCanvasPresenter >> uiActionDo: aBlock [
	^ threadSafe
		ifTrue: [ containerElement inUIProcessDo: aBlock ]
		ifFalse: [ aBlock value ]
]

{ #category : #outputting }
ProcessingCanvasPresenter >> updateOutput [
	self
		uiActionDo: [ canvasBuffer
				ifNil: [ canvasBuffer := (containerElement
							addVisualCanvas: model canvasSize
							colored: model background)
							when: BlMouseMoveEvent do: [ :event | model onMouseMove: event ];
							when: BlMouseDownEvent do: [ :event | model onMouseDown: event ];
							when: BlMouseUpEvent do: [ :event | model onMouseUp: event ];
							yourself.
					canvasBuffer parent zIndex: -1 ].

			canvasOutput = canvasElement
				ifFalse: [ | swap |
					swap := canvasBuffer.
					canvasBuffer := canvasElement.
					canvasElement := swap.
					canvasElement parent zIndex: 1.
					canvasBuffer parent zIndex: -1 ] ]
]
