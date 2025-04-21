Class {
	#name : #GtProcessingCoderModel,
	#superclass : #GtSourceCoder,
	#instVars : [
		'pharoBindings'
	],
	#category : #'GtExploration-Snippet'
}

{ #category : #converting }
GtProcessingCoderModel >> asCoderViewModel [
	^ GtPythonCoderViewModel new coder: self
]

{ #category : #'private - execution' }
GtProcessingCoderModel >> bindAndExecute: sourceString inContext: aGtSourceCoderEvaluationContext [
	^ ProcessingSource new fromString: sourceString
]

{ #category : #'api - ast' }
GtProcessingCoderModel >> computeAst: theSourceString [
	^ ProcessingParser
		parseWithErrors: theSourceString
		startingAt: ProcessingParser startingStateForfile_input
]

{ #category : #'api - ast' }
GtProcessingCoderModel >> implicitVariableReferencesTo: aString do: aBlock [
	self astSync withAllNodesOfType: PyVariableExpressionNode do: [ :node | 
		node nameToken source = aString ifTrue: [ aBlock value: node ] ]
]

{ #category : #initialize }
GtProcessingCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.
	
	addOns addStyler: (GtCoderAstSmaCCParserStyler new smaccStyler: ProcessingParser gtStyler).
	
	addOns
		addMainAction: 'Evaluate' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doIt
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItActionId.
	addOns
		addMainAction: 'Inspect' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGo
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoActionId.
]

{ #category : #initialize }
GtProcessingCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns
		addShortcut: GtSourceCoderDoItShortcut new;
		addShortcut: GtSourceCoderDoItAndInspectShortcut new
]

{ #category : #'instance creation' }
GtProcessingCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #accessing }
GtProcessingCoderModel >> pharoBindings [
	^ pharoBindings
]

{ #category : #accessing }
GtProcessingCoderModel >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	self flag: #TODO.
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self
		bindAndExecute: aSourceString
		inContext: aGtSourceCoderEvaluationContext
]
