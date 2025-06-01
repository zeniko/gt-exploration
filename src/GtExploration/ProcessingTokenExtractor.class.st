Class {
	#name : #ProcessingTokenExtractor,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #'accessing - method dictionary' }
ProcessingTokenExtractor class >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aCategory [
	"When a new methods is added, I add it to the localMethodDict and also propagate the changes to my users"

	self localMethodDict at: selector put: compiledMethod.

	super
		addAndClassifySelector: selector
		withMethod: compiledMethod
		inProtocol: aCategory.

	TraitChange addSelector: selector on: self
]

{ #category : #'accessing - method dictionary' }
ProcessingTokenExtractor class >> addSelector: selector withMethod: compiledMethod [
	"When a new selector is installed in a class I insert the selector in the local methodDict and propagate the changes to my users"

	self localMethodDict at: selector put: compiledMethod.
	super addSelector: selector withMethod: compiledMethod.
	TraitChange addSelector: selector on: self
]

{ #category : #'accessing - method dictionary' }
ProcessingTokenExtractor class >> addSelector: selector withRecompiledMethod: compiledMethod [
	"When a new selector is installed in a class I insert the selector in the local methodDict and propagate the changes to my users"

	compiledMethod isFromTrait
		ifTrue: [ ^ super addSelector: selector withRecompiledMethod: compiledMethod ].

	self localMethodDict at: selector put: compiledMethod.
	super addSelector: selector withRecompiledMethod: compiledMethod.
	TraitChange addSelector: selector on: self
]

{ #category : #querying }
ProcessingTokenExtractor class >> allTraits [
	^ self traitComposition allTraits
]

{ #category : #initialization }
ProcessingTokenExtractor class >> doRebuildMethodDictionary [
	| selectors removedSelectors removeFromOrganization modified |
	"During the creation of the class or after a change in the traitComposition, the whole method dictionary is calculated.
	If I return true, my users should be updated"
	"1. I recreate the local methodDict"
	modified := false.
	self methodDict
		valuesDo: [ :m | m traitSource ifNil: [ self localMethodDict at: m selector put: m ] ].	"2. I filter the selectors from the trait composition, rejecting the ones that are locally defined.
	And then I install the methods in myself. The trait composition only install the method if it is needed."
	selectors := self traitComposition selectors
			reject: [ :e | self localMethodDict includesKey: e ].
	selectors
		do: [ :e | 
			modified := modified
					| (self traitComposition
							installSelector: e
							into: self
							replacing: false) ].	"3. I handle the methods that I have and they are no more in the traitComposition."
	removedSelectors := self methodDict keys
			reject: [ :aSelector | 
				(selectors includes: aSelector)
					or: [ self localMethodDict includesKey: aSelector ] ].
	modified := modified | removedSelectors isNotEmpty.
	removedSelectors do: [ :aSelector | self methodDict removeKey: aSelector ].	"4. Finally, I remove these methods from my class organization"
	removeFromOrganization := self organization allMethodSelectors
			reject: [ :e | self methodDict includesKey: e ].
	removeFromOrganization
		do: [ :aSelector | self organization removeElement: aSelector ].

	^ modified
]

{ #category : #testing }
ProcessingTokenExtractor class >> findOriginClassOf: aMethod [
	"I return the myself or the trait that has the original implementation of a method.
	If the method is an alias, the returned class includes the original aliased method"

	(aMethod hasProperty: #traitSource)
		ifTrue: [ ^ aMethod traitSource innerClass ].

	(self includesLocalSelector: aMethod selector) ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ])
		innerClass
]

{ #category : #testing }
ProcessingTokenExtractor class >> findOriginMethodOf: aMethod [
	"I return the original method for a aMethod.
	If this is a local method, the original method is itself.
	If it cames from a trait composition I look for the method in the trait composition.
	First I try with the trait stored in the traitSource.
	If it is an aliased or conflicting method, the method is look up in the whole trait composition"

	(self includesLocalSelector: aMethod selector) ifTrue: [ ^ aMethod ].

	(aMethod hasProperty: #traitSource)
		ifTrue: [ | newSelector |
			newSelector := self traitComposition originSelectorOf: aMethod selector.
			^ aMethod traitSource compiledMethodAt: newSelector ifAbsent: [ aMethod ] ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ self ])
		compiledMethodAt: aMethod selector
		ifAbsent: [ ^ aMethod ]
]

{ #category : #testing }
ProcessingTokenExtractor class >> hasTraitComposition [
	^ self traitComposition isEmpty not
]

{ #category : #testing }
ProcessingTokenExtractor class >> includesLocalSelector: aSymbol [
	^ self isLocalSelector: aSymbol
]

{ #category : #testing }
ProcessingTokenExtractor class >> includesTrait: aTrait [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition includesTrait: aTrait
]

{ #category : #testing }
ProcessingTokenExtractor class >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : #testing }
ProcessingTokenExtractor class >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : #testing }
ProcessingTokenExtractor class >> isLocalMethodsProtocol: aProtocol [
	"Checks if the protocol has local selectors"

	aProtocol methodSelectors ifEmpty: [ ^ true ].
	^ aProtocol methodSelectors anySatisfy: [ :each | self isLocalSelector: each ]
]

{ #category : #testing }
ProcessingTokenExtractor class >> isLocalSelector: aSelector [
	^ self localMethodDict includesKey: aSelector
]

{ #category : #accessing }
ProcessingTokenExtractor class >> localMethodDict [
	"The local methodDict is in the metaclass. In this way I do not have to recompile the methods during the bootstrap when we don't have a compiler."

	^ self class baseLocalMethods
]

{ #category : #accessing }
ProcessingTokenExtractor class >> localMethodDict: aMethodDictionary [
	^ self class baseLocalMethods: aMethodDictionary
]

{ #category : #accessing }
ProcessingTokenExtractor class >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses"

	^ self localMethodDict values
]

{ #category : #'accessing - method dictionary' }
ProcessingTokenExtractor class >> localSelectors [
	^ self localMethodDict keys
]

{ #category : #initialization }
ProcessingTokenExtractor class >> rebuildMethodDictionary [
	"Useful to be rewritten in Traits"

	^ self doRebuildMethodDictionary
]

{ #category : #categories }
ProcessingTokenExtractor class >> recategorizeSelector: selector from: oldCategory to: newCategory [
	| original |
	"When a method is recategorized I have to classify the method, but also recategorize the aliases pointing to it"
	original := self organization categoryOfElement: selector ifAbsent: [ ^ self ].	"If it is nil is because it is a removal. It will removed when the method is removed."
	newCategory ifNil: [ ^ self ].

	original = oldCategory
		ifTrue: [ self organization
				classify: selector
				under: newCategory
				suppressIfDefault: true ].

	(self traitComposition reverseAlias: selector)
		do: [ :e | 
			self
				recategorizeSelector: e
				from: oldCategory
				to: newCategory.
			self
				notifyOfRecategorizedSelector: e
				from: oldCategory
				to: newCategory ].

	self organization removeEmptyCategories
]

{ #category : #recompilation }
ProcessingTokenExtractor class >> recompile: selector from: oldClass [
	"Compile the method associated with selector in the receiver's method dictionary."

	| method newMethod |
	method := oldClass compiledMethodAt: selector.
	newMethod := self compiler
			source: (oldClass sourceCodeAt: selector);
			class: self;
			failBlock: [ ^ self ];
			compiledMethodTrailer: method trailer;
			compile.	"Assume OK after proceed from SyntaxError"
	selector == newMethod selector ifFalse: [ self error: 'selector changed!' ].

	method properties
		at: #traitSource
		ifPresent: [ :aSource | newMethod propertyAt: #traitSource put: aSource ].

	self addSelector: selector withRecompiledMethod: newMethod
]

{ #category : #'trait-composition' }
ProcessingTokenExtractor class >> removeFromComposition: aTrait [
	self
		setTraitComposition: (self traitComposition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : #removing }
ProcessingTokenExtractor class >> removeFromSystem: logged [
	"When a traited class is removed the traits it is using should be updated"

	| mySubclasses |
	self traitComposition removeUser: self.
	self class traitComposition removeUser: self class.

	TraitedClass removeUser: self class.

	mySubclasses := self subclasses.

	super removeFromSystem: logged.	"As I am a traited class my subclasses does not have the basic traited class
	methods, so I add them."
	mySubclasses do: [ :each | each class initializeBasicMethods ]
]

{ #category : #removing }
ProcessingTokenExtractor class >> removeSelector: aSelector [
	"When a selector is removed it should be notified to my users.
	Check the class TraitChange for more details"

	super removeSelector: aSelector.
	self localMethodDict removeKey: aSelector ifAbsent: [  ].

	TraitChange removeSelector: aSelector on: self
]

{ #category : #accessing }
ProcessingTokenExtractor class >> traitComposition [
	"My trait composition is in my class. So I do not need to recompile the methods when installing them during bootstrap"

	^ self class baseComposition
]

{ #category : #accessing }
ProcessingTokenExtractor class >> traitComposition: aComposition [
	aComposition asTraitComposition allTraits
		do: [ :aMaybeTrait | 
			aMaybeTrait isTrait
				ifFalse: [ self error: 'All the members of the trait composition should be traits' ] ].

	self class baseComposition: aComposition
]

{ #category : #accessing }
ProcessingTokenExtractor class >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : #accessing }
ProcessingTokenExtractor class >> traitUsers [
	"I am a traited class, I have no users, this is for compatibility with traits"

	^ #()
]

{ #category : #accessing }
ProcessingTokenExtractor class >> traits [
	^ self traitComposition traits
]

{ #category : #visiting }
ProcessingTokenExtractor >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : #visiting }
ProcessingTokenExtractor >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : #visiting }
ProcessingTokenExtractor >> acceptNodes: aCollection [
	aCollection do: [ :each | self acceptNode: each ].
	^ aCollection
]

{ #category : #building }
ProcessingTokenExtractor >> add: values separatedBy: commas to: tokens [
	1
		to: values size - 1
		do: [ :index | 
			tokens add: (values at: index).
			tokens add: (commas at: index) ].
	tokens add: values last
]

{ #category : #building }
ProcessingTokenExtractor >> extractTokens: ast [
	^ ((ast acceptVisitor: self)
		collect: [ :item | 
			(item isKindOf: PyRootNode)
				ifTrue: [ self extractTokens: item ]
				ifFalse: [ item ] ]) deepFlatten
]

{ #category : #generated }
ProcessingTokenExtractor >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : #generated }
ProcessingTokenExtractor >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitAssertStatement: stmt [
	stmt values size = 1
		ifTrue: [ ^ {stmt assertToken.
				stmt values first} ].
	^ {stmt assertToken.
		stmt values first.
		stmt values second}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitAssignmentExpression: expr [
	^ {expr variable.
		expr assign.
		expr value}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitAssignmentStatement: stmt [
	^ {stmt lhs.
		stmt assigns first.
		stmt tos first}
]

{ #category : #generated }
ProcessingTokenExtractor >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitBinaryExpression: expr [
	^ {expr left.
		expr operator.
		expr right}
]

{ #category : #generated }
ProcessingTokenExtractor >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitComparisonExpression: expr [
	| tokens chain |
	tokens := OrderedCollection new.
	tokens add: expr left.
	tokens add: expr operator.
	chain := expr right.
	[ chain isKindOf: PyComparisonExpressionNode ]
		whileTrue: [ tokens add: chain left.
			tokens add: chain operator.
			chain := chain right ].
	tokens add: chain.
	^ tokens
]

{ #category : #generated }
ProcessingTokenExtractor >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : #generated }
ProcessingTokenExtractor >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : #generated }
ProcessingTokenExtractor >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : #generated }
ProcessingTokenExtractor >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : #generated }
ProcessingTokenExtractor >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitElif: elif [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: elif elifToken.
	tokens add: elif condition.
	tokens add: elif colonToken.
	tokens addAll: elif statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitEllipsis: expr [
	^ {expr ellipsis}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitElse: else [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: else elseToken.
	tokens add: else colonToken.
	tokens addAll: else statements.
	^ tokens
]

{ #category : #generated }
ProcessingTokenExtractor >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : #generated }
ProcessingTokenExtractor >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : #generated }
ProcessingTokenExtractor >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitExpression: expr [
	ProcessingNotImplementedException new
		tag: expr;
		signal: 'Unsupported expression type ' , expr asString
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitExpressionStatement: stmt [
	^ stmt children
]

{ #category : #generated }
ProcessingTokenExtractor >> visitFieldAccessExpression: aFieldAccessExpression [
	^ self visitExpression: aFieldAccessExpression
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitFile: file [
	^ self visitExpressionStatement: file
]

{ #category : #generated }
ProcessingTokenExtractor >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitForStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt forToken.
	self
		add: stmt exprs
		separatedBy: stmt commaTokens
		to: tokens.
	tokens add: stmt inToken.
	tokens add: stmt inExpression.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitFunctionCallExpression: fnCall [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: fnCall receiver.
	tokens add: fnCall lparenToken.
	fnCall arguments
		ifNotEmpty: [ self
				add: fnCall arguments
				separatedBy: fnCall commaTokens
				to: tokens ].
	tokens add: fnCall rparenToken.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitFunctionDefinition: def [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: def defToken.
	tokens add: def fname.
	tokens add: def lparenToken.
	def parameters
		ifNotEmpty: [ self
				add: def parameters
				separatedBy: def commaTokens
				to: tokens ].
	tokens add: def rparenToken.
	tokens add: def colonToken.
	tokens addAll: def statements.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitGlobalStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt globalToken.
	self
		add: stmt nameTokens
		separatedBy: stmt commaTokens
		to: tokens.
	^ tokens
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitIfExpression: expr [
	^ {expr if.
		expr ifToken.
		expr condition.
		expr elseToken.
		expr else}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitIfStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt ifToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	stmt elsifs ifNotNil: [ tokens addAll: stmt elsifs ].
	stmt else ifNotNil: [ tokens add: stmt else ].
	^ tokens
]

{ #category : #generated }
ProcessingTokenExtractor >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : #generated }
ProcessingTokenExtractor >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : #generated }
ProcessingTokenExtractor >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitListExpression: aListExpression [
	^ self visitExpression: aListExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : #generated }
ProcessingTokenExtractor >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : #generated }
ProcessingTokenExtractor >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : #generated }
ProcessingTokenExtractor >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : #generated }
ProcessingTokenExtractor >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitNumber: expr [
	^ {expr numberToken}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitParameter: param [
	^ {param name nameToken}
]

{ #category : #generated }
ProcessingTokenExtractor >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitPassStatement: stmt [
	^ {stmt passToken}
]

{ #category : #generated }
ProcessingTokenExtractor >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitReturnStatement: stmt [
	stmt expressions ifEmpty: [ ^ {stmt returnToken} ].
	^ {stmt returnToken.
		stmt expressions first}
]

{ #category : #generated }
ProcessingTokenExtractor >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : #generated }
ProcessingTokenExtractor >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ProcessingTokenExtractor >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitSmaCCError: aSmaCCError [
	^ self visitSmaCCParseNode: aSmaCCError
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitSmaCCParseNode: aSmaCCParseNode [
	self acceptNodes: aSmaCCParseNode sortedChildren.
	^ aSmaCCParseNode
]

{ #category : #generated }
ProcessingTokenExtractor >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitStatement: stmt [
	ProcessingNotImplementedException new
		tag: stmt;
		signal: 'Unsupported statement type ' , stmt asString
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitString: expr [
	^ expr parts
]

{ #category : #generated }
ProcessingTokenExtractor >> visitSubscriptExpression: aSubscriptExpression [
	^ self visitExpression: aSubscriptExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitTupleExpression: expr [
	^ {expr lparenToken.
		expr expressions first.
		expr rparenToken}
]

{ #category : #generated }
ProcessingTokenExtractor >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitUnaryExpression: expr [
	^ {expr operator.
		expr expression}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitVariableExpression: expr [
	^ {expr nameToken}
]

{ #category : #visiting }
ProcessingTokenExtractor >> visitWhileStatement: stmt [
	| tokens |
	tokens := OrderedCollection new.
	tokens add: stmt whileToken.
	tokens add: stmt condition.
	tokens add: stmt colonToken.
	tokens addAll: stmt statements.
	^ tokens
]

{ #category : #generated }
ProcessingTokenExtractor >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : #generated }
ProcessingTokenExtractor >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : #generated }
ProcessingTokenExtractor >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : #generated }
ProcessingTokenExtractor >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
