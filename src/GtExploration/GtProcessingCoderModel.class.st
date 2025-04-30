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
	^ GtProcessingCoderViewModel new coder: self
]

{ #category : #'private - execution' }
GtProcessingCoderModel >> bindAndExecute: sourceString inContext: aGtSourceCoderEvaluationContext [
	^ (ProcessingSource new fromString: sourceString) render
]

{ #category : #'api - ast' }
GtProcessingCoderModel >> computeAst: theSourceString [
	^ ProcessingParser
		parseWithErrors: theSourceString
		startingAt: ProcessingParser startingStateForfile_input
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doIt: aEvaluationContext [
	self doItAndPublish: [
		(ProcessingSource fromViewModel: aEvaluationContext requesterObject coderViewModel) render
	] with: aEvaluationContext.
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doItAndGo: aEvaluationContext [
	self doItAndPublish: [
		| program |
		program := (ProcessingSource fromViewModel: aEvaluationContext requesterObject coderViewModel) program.
		"TODO: update stepper when the source changes? (this becomes expensive quickly!)"
		Stepper for: (ProcessingRunner new runStepwise: program compilation) view: #gtAbstractionsFor:
	] with: aEvaluationContext.
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doItAndGoSerialized: aEvaluationContext [
	self doItAndPublish: [
		ProcessingSource fromViewModel: aEvaluationContext requesterObject coderViewModel
	] with: aEvaluationContext.
]

{ #category : #'private - execution' }
GtProcessingCoderModel >> doItAndPublish: aBlock with: aEvaluationContext [
	| result |
	result := aBlock on: Error do: [ :error |
		Transcript nextPut: error asString , '
'.
		"TODO: error handling."
	].
	
	aEvaluationContext evaluatedSourceString: ''.
	result := GtSourceCoderEvaluationResultWithValue new value: result; evaluationContext: aEvaluationContext.
	
	self notifyEvaluatedWithResult: result.
	self notifyObjectSpawnFromEvaluationResult: result requesterObject: aEvaluationContext requesterObject.
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
		addMainAction: 'Run' translated
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
	addOns
		addMainAction: 'Abstractions' translated
		icon: BrGlamorousVectorIcons playAsynchronous
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGoSerialized
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoSerializedActionId.
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
