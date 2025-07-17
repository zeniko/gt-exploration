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
	^ (ProcessingSource fromString: sourceString) render
]

{ #category : #'api - ast' }
GtProcessingCoderModel >> computeAst: theSourceString [
	^ ProcessingParser
		parseWithErrors: theSourceString
		startingAt: ProcessingParser startingStateForfile_input
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doIt: anEvaluationContext [
	self
		doItAndPublish: [ (ProcessingSource
				fromViewModel: anEvaluationContext requesterObject coderViewModel)
				renderLive ]
		with: anEvaluationContext
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doItAndGo: anEvaluationContext [
	self
		doItAndPublish: [ (ProcessingSource
				fromViewModel: anEvaluationContext requesterObject coderViewModel) program ]
		with: anEvaluationContext
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doItAndGoAsynchronous: anEvaluationContext [
	self
		doItAndPublish: [ (ProcessingSource
				fromViewModel: anEvaluationContext requesterObject coderViewModel) program
				debug ]
		with: anEvaluationContext
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> doItAndGoSerialized: anEvaluationContext [
	self
		doItAndPublish: [ | program loader |
			program := (ProcessingSource
					fromViewModel: anEvaluationContext requesterObject coderViewModel) program.
			loader := [ | runsteps |
				runsteps := program runSteps.
				runsteps
					ifEmpty: [ ProcessingRunTimeException new
							signal: 'This program didn''t produce any run steps' ].
				runsteps ].	"The stepper isn't updated when the source changes, as that's too resource intensive for non-trivial programs"
			Stepper for: loader view: #gtAbstractionsFor: ]
		with: anEvaluationContext
]

{ #category : #'private - execution' }
GtProcessingCoderModel >> doItAndPublish: aBlock with: anEvaluationContext [
	| result |
	result := aBlock
			on: Error
			do: [ :error | 
				| location message |
				location := anEvaluationContext requesterObject coderViewModel coderModel
						currentSourceString size + 1.	"at the very end"
				message := error messageText.	"TODO: nicer error messages"
				message ifEmpty: [ message := error asString ].

				(error isKindOf: SmaCCParserError)
					ifTrue: [ location := error tag errorToken startPosition ].
				(error isKindOf: ProcessingCompileTimeException)
					ifTrue: [ location := error tag startPosition.
						message ifEmpty: [ message := 'Unsupported: ' , error tag asString ] ].
				^ self
					announce: (GtCoderParseError new
							errorMessage: message;
							location: location;
							exception: error;
							requesterObject: anEvaluationContext requesterObject) ].

	anEvaluationContext evaluatedSourceString: ''.
	result := GtSourceCoderEvaluationResultWithValue new
			value: result;
			evaluationContext: anEvaluationContext.

	self notifyEvaluatedWithResult: result.
	self
		notifyObjectSpawnFromEvaluationResult: result
		requesterObject: anEvaluationContext requesterObject
]

{ #category : #'api - ast' }
GtProcessingCoderModel >> implicitVariableReferencesTo: aString do: aBlock [
	self astSync
		withAllNodesOfType: PyVariableExpressionNode
		do: [ :node | node nameToken source = aString ifTrue: [ aBlock value: node ] ]
]

{ #category : #initialize }
GtProcessingCoderModel >> initializeAddOns: addOns [
	super initializeAddOns: addOns.

	addOns
		addStyler: (GtCoderAstSmaCCParserStyler new smaccStyler: ProcessingParser gtStyler).
	addOns
		addMainAction: 'Run (Ctrl+R)' translated
		icon: BrGlamorousVectorIcons play
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doIt
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItActionId.
	addOns
		addMainAction: 'Run Steps (Ctrl+G)' translated
		icon: BrGlamorousVectorIcons playinspect
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGoSerialized
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoSerializedActionId.
	addOns
		addMainAction: 'Details (Ctrl+D)' translated
		icon: BrGlamorousVectorIcons playAsynchronous
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGo
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDoItAndGoActionId.
	addOns
		addMainAction: 'Debug (Ctrl+Shift+D)' translated
		icon: BrGlamorousVectorIcons debug
		action: [ :aCoderUIModel :anElement | 
			GtCoderCodeExecutor doItAndGoAsynchronous
				coderViewModel: aCoderUIModel;
				element: anElement;
				execute ]
		id: GtSourceCoderDebugActionId
]

{ #category : #initialize }
GtProcessingCoderModel >> initializeShortcuts: addOns [
	super initializeShortcuts: addOns.

	addOns
		addShortcut: GtProcessingCoderRunShortcut new;
		addShortcut: GtProcessingCoderRunStepsShortcut new;
		addShortcut: GtProcessingCoderRunDetailsShortcut new;
		addShortcut: GtProcessingCoderDebugShortcut new
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
	self flag: #TODO
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self bindAndExecute: aSourceString inContext: aGtSourceCoderEvaluationContext
]
