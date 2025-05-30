Class {
	#name : #ProcessingCanvasPresenter,
	#superclass : #Object,
	#instVars : [
		'containerElement',
		'canvasElement',
		'canvasBuffer',
		'canvasOutput',
		'model',
		'transcriptElement'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #initialization }
ProcessingCanvasPresenter class >> newFor: aModel [
	^ ProcessingCanvasPresenter new
		model: aModel 
]

{ #category : #accessing }
ProcessingCanvasPresenter >> canvasElement [
	^ canvasElement
]

{ #category : #outputting }
ProcessingCanvasPresenter >> clearWithBackground: aColor [
	"background() is used as a hint to buffer animations"
	canvasBuffer ifNotNil: [
		canvasOutput := canvasBuffer.
	].
	canvasOutput background: aColor.
	canvasOutput children do: #removeFromParent.
]

{ #category : #accessing }
ProcessingCanvasPresenter >> containerElement [
	^ containerElement
]

{ #category : #outputting }
ProcessingCanvasPresenter >> display: aShape [
	| element |
	element := aShape asElementTransformed.
	canvasOutput addChild: element.
	"Allow adding an explanation marker."
	containerElement dispatchEvent: (ProcessingExplainShape
		newFor: element createdBy: aShape context).
]

{ #category : #outputting }
ProcessingCanvasPresenter >> displayTranscript: aTranscript for: aSource [
	transcriptElement ifNil: [
		transcriptElement := containerElement addTextCanvas: aTranscript.
	].
	"Allow adding an explanation marker."
	containerElement dispatchEvent: (ProcessingExplainShape
		newFor: transcriptElement createdBy: aSource).
]

{ #category : #initialization }
ProcessingCanvasPresenter >> initialize [
	containerElement := ProcessingCanvasElement new
		presenter: self;
		yourself.
	canvasElement := (containerElement addVisualCanvas: 100 @ 100 colored: Color veryLightGray)
		when: BlMouseMoveEvent do: [ :event | model onMouseMove: event. ];
		when: BlMouseDownEvent do: [ :event | model onMouseDown: event. ];
		when: BlMouseUpEvent do: [ :event | model onMouseUp: event. ];
		yourself.
	transcriptElement := nil.
	
	"Animations are buffered starting with the second frame."
	canvasBuffer := nil.
	canvasOutput := canvasElement.
]

{ #category : #accessing }
ProcessingCanvasPresenter >> model [
	^ model
]

{ #category : #accessing }
ProcessingCanvasPresenter >> model: aModel [
	model := aModel.
]

{ #category : #outputting }
ProcessingCanvasPresenter >> outputSize: aSize [
	canvasElement size: aSize.
]

{ #category : #outputting }
ProcessingCanvasPresenter >> updateOutput [
	canvasBuffer ifNil: [
		canvasBuffer := (containerElement addVisualCanvas: model canvasSize colored: model background)
			when: BlMouseMoveEvent do: [ :event | model onMouseMove: event. ];
			when: BlMouseDownEvent do: [ :event | model onMouseDown: event. ];
			when: BlMouseUpEvent do: [ :event | model onMouseUp: event. ];
			yourself.
		canvasBuffer parent zIndex: -1.
	].
	
	canvasOutput = canvasElement ifFalse: [
		| swap |
		swap := canvasBuffer.
		canvasBuffer := canvasElement.
		canvasElement := swap.
		canvasElement parent zIndex: 1.
		canvasBuffer parent zIndex: -1.
	].
]
