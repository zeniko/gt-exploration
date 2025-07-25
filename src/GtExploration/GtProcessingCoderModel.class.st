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
			Stepper for: loader view: #gtOverviewFor: ]
		with: anEvaluationContext
]

{ #category : #'private - execution' }
GtProcessingCoderModel >> doItAndPublish: aBlock with: anEvaluationContext [
	| result |
	result := aBlock
			on: Error
			do: [ :error | ^ self handleError: error for: anEvaluationContext ].

	anEvaluationContext evaluatedSourceString: ''.
	result := GtSourceCoderEvaluationResultWithValue new
			value: result;
			evaluationContext: anEvaluationContext.

	self notifyEvaluatedWithResult: result.
	self
		notifyObjectSpawnFromEvaluationResult: result
		requesterObject: anEvaluationContext requesterObject
]

{ #category : #'error handling' }
GtProcessingCoderModel >> handleError: anError for: aContext [
	| location message |
	location := aContext requesterObject coderViewModel coderModel
			currentSourceString size + 1.	"default to the very end"
	message := anError messageText.	"TODO: nicer error messages"
	message ifEmpty: [ message := anError asString ].

	(anError isKindOf: SmaCCParserError)
		ifTrue: [ | parser stack expected found |
			parser := anError tag.
			location := parser errorToken startPosition.
			stack := self parserStack: parser.
			expected := self potentialStateActions: parser.
			found := self lookaheadToken: parser.
			(expected includes: '<rparen>')
				ifTrue: [ stack
						do: [ :symbol_token | 
							symbol_token first = '<lparen>'
								ifTrue: [ location := symbol_token second startPosition.
									message := 'Open parenthesis' ] ] ]
				ifFalse: [ message := 'Expected: ' , (' or ' join: expected) ].
			message = 'Expected: <INDENT>'
				ifTrue: [ message := 'Expected indentation (press Tab)' ].
			found = 'E O F'
				ifTrue: [ message := 'Incomplete code (open parenthesis or missing argument)' ].
			found = '<INDENT>'
				ifTrue: [ message := 'Unexpected indentation (press Shift+Tab)' ] ].

	(anError isKindOf: ProcessingNotImplementedException)
		| (anError isKindOf: ProcessingCompileTimeException)
		ifTrue: [ anError tag ifNotNil: [ location := anError tag startPosition ] ].

	^ self
		announce: (GtCoderParseError new
				errorMessage: message;
				location: location;
				exception: anError;
				requesterObject: aContext requesterObject)
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

{ #category : #'error handling' }
GtProcessingCoderModel >> lookaheadToken: aParser [
	| stream |
	aParser currentToken ifNil: [ ^ nil ].
	stream := WriteStream on: String new.
	aParser currentToken ids
		do: [ :each | stream nextPutAll: (aParser symbolNameFor: each) ]
		separatedBy: [ stream nextPut: $; ].
	^ stream contents
]

{ #category : #'instance creation' }
GtProcessingCoderModel >> newCompletionStrategy [
	^ GtCompletionStrategy new
]

{ #category : #'error handling' }
GtProcessingCoderModel >> parserStack: aParser [
	| states nodes |
	states := aParser stateStack.
	nodes := aParser nodeStack.
	^ ((1 to: states size - 1)
		collect: [ :i | 
			{aParser symbolForTransitionFrom: (states at: i) to: (states at: i + 1).
				nodes at: i} ]) reversed
]

{ #category : #accessing }
GtProcessingCoderModel >> pharoBindings [
	^ pharoBindings
]

{ #category : #accessing }
GtProcessingCoderModel >> pharoBindings: anObject [
	pharoBindings := anObject
]

{ #category : #'error handling' }
GtProcessingCoderModel >> potentialStateActions: aParser [
	"Adapted from SmaCCParserDebugSession>>#potentialStateActions"

	| items ids |
	ids := aParser currentToken ifNotNil: [ :token | token ids ] ifNil: [ #() ].
	items := OrderedCollection new.
	aParser
		actionsAndSymbolsForState: aParser stateStack last
		do: [ :action :symbol | items add: (aParser symbolNameFor: symbol) ].
	^ items sorted
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> primitiveDebug: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	self flag: #TODO
]

{ #category : #'private - actions' }
GtProcessingCoderModel >> primitiveEvaluate: aSourceString inContext: aGtSourceCoderEvaluationContext onFailDo: anEvaluationFailBlock [
	^ self bindAndExecute: aSourceString inContext: aGtSourceCoderEvaluationContext
]
