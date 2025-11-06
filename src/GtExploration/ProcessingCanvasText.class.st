"
This class represents text rendered onto a {{gtClass:ProcessingCanvas}} (e.g. through {{gtMethod:ProcessingCanvas>>text:x:y:}}).
"
Class {
	#name : #ProcessingCanvasText,
	#superclass : #ProcessingCanvasShape,
	#instVars : [
		'text',
		'textSize'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingCanvasText >> asElement [
	^ BlTextElement new
		text: (text asRopedText
				fontSize: textSize;
				foreground: fillColor)
]

{ #category : #accessing }
ProcessingCanvasText >> text [
	^ text
]

{ #category : #accessing }
ProcessingCanvasText >> text: aText [
	text := aText
]

{ #category : #accessing }
ProcessingCanvasText >> textSize [
	^ textSize
]

{ #category : #accessing }
ProcessingCanvasText >> textSize: aTextSize [
	textSize := aTextSize
]
