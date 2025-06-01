Class {
	#name : #ProcessingAstCleaner,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#category : #'GtExploration-Processing'
}

{ #category : #'accessing - method dictionary' }
ProcessingAstCleaner class >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aCategory [
	"When a new methods is added, I add it to the localMethodDict and also propagate the changes to my users"

	self localMethodDict at: selector put: compiledMethod.

	super
		addAndClassifySelector: selector
		withMethod: compiledMethod
		inProtocol: aCategory.

	TraitChange addSelector: selector on: self
]

{ #category : #'accessing - method dictionary' }
ProcessingAstCleaner class >> addSelector: selector withMethod: compiledMethod [
	"When a new selector is installed in a class I insert the selector in the local methodDict and propagate the changes to my users"

	self localMethodDict at: selector put: compiledMethod.
	super addSelector: selector withMethod: compiledMethod.
	TraitChange addSelector: selector on: self
]

{ #category : #'accessing - method dictionary' }
ProcessingAstCleaner class >> addSelector: selector withRecompiledMethod: compiledMethod [
	"When a new selector is installed in a class I insert the selector in the local methodDict and propagate the changes to my users"

	compiledMethod isFromTrait
		ifTrue: [ ^ super addSelector: selector withRecompiledMethod: compiledMethod ].

	self localMethodDict at: selector put: compiledMethod.
	super addSelector: selector withRecompiledMethod: compiledMethod.
	TraitChange addSelector: selector on: self
]

{ #category : #querying }
ProcessingAstCleaner class >> allTraits [
	^ self traitComposition allTraits
]

{ #category : #cleaning }
ProcessingAstCleaner class >> clean: anAst [
	^ anAst acceptVisitor: ProcessingAstCleaner new
]

{ #category : #initialization }
ProcessingAstCleaner class >> doRebuildMethodDictionary [
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
ProcessingAstCleaner class >> findOriginClassOf: aMethod [
	"I return the myself or the trait that has the original implementation of a method.
	If the method is an alias, the returned class includes the original aliased method"

	(aMethod hasProperty: #traitSource)
		ifTrue: [ ^ aMethod traitSource innerClass ].

	(self includesLocalSelector: aMethod selector) ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ])
		innerClass
]

{ #category : #testing }
ProcessingAstCleaner class >> findOriginMethodOf: aMethod [
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
ProcessingAstCleaner class >> hasTraitComposition [
	^ self traitComposition isEmpty not
]

{ #category : #testing }
ProcessingAstCleaner class >> includesLocalSelector: aSymbol [
	^ self isLocalSelector: aSymbol
]

{ #category : #testing }
ProcessingAstCleaner class >> includesTrait: aTrait [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition includesTrait: aTrait
]

{ #category : #testing }
ProcessingAstCleaner class >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : #testing }
ProcessingAstCleaner class >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : #testing }
ProcessingAstCleaner class >> isLocalMethodsProtocol: aProtocol [
	"Checks if the protocol has local selectors"

	aProtocol methodSelectors ifEmpty: [ ^ true ].
	^ aProtocol methodSelectors anySatisfy: [ :each | self isLocalSelector: each ]
]

{ #category : #testing }
ProcessingAstCleaner class >> isLocalSelector: aSelector [
	^ self localMethodDict includesKey: aSelector
]

{ #category : #accessing }
ProcessingAstCleaner class >> localMethodDict [
	"The local methodDict is in the metaclass. In this way I do not have to recompile the methods during the bootstrap when we don't have a compiler."

	^ self class baseLocalMethods
]

{ #category : #accessing }
ProcessingAstCleaner class >> localMethodDict: aMethodDictionary [
	^ self class baseLocalMethods: aMethodDictionary
]

{ #category : #accessing }
ProcessingAstCleaner class >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses"

	^ self localMethodDict values
]

{ #category : #'accessing - method dictionary' }
ProcessingAstCleaner class >> localSelectors [
	^ self localMethodDict keys
]

{ #category : #initialization }
ProcessingAstCleaner class >> rebuildMethodDictionary [
	"Useful to be rewritten in Traits"

	^ self doRebuildMethodDictionary
]

{ #category : #categories }
ProcessingAstCleaner class >> recategorizeSelector: selector from: oldCategory to: newCategory [
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
ProcessingAstCleaner class >> recompile: selector from: oldClass [
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
ProcessingAstCleaner class >> removeFromComposition: aTrait [
	self
		setTraitComposition: (self traitComposition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : #removing }
ProcessingAstCleaner class >> removeFromSystem: logged [
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
ProcessingAstCleaner class >> removeSelector: aSelector [
	"When a selector is removed it should be notified to my users.
	Check the class TraitChange for more details"

	super removeSelector: aSelector.
	self localMethodDict removeKey: aSelector ifAbsent: [  ].

	TraitChange removeSelector: aSelector on: self
]

{ #category : #accessing }
ProcessingAstCleaner class >> traitComposition [
	"My trait composition is in my class. So I do not need to recompile the methods when installing them during bootstrap"

	^ self class baseComposition
]

{ #category : #accessing }
ProcessingAstCleaner class >> traitComposition: aComposition [
	aComposition asTraitComposition allTraits
		do: [ :aMaybeTrait | 
			aMaybeTrait isTrait
				ifFalse: [ self error: 'All the members of the trait composition should be traits' ] ].

	self class baseComposition: aComposition
]

{ #category : #accessing }
ProcessingAstCleaner class >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : #accessing }
ProcessingAstCleaner class >> traitUsers [
	"I am a traited class, I have no users, this is for compatibility with traits"

	^ #()
]

{ #category : #accessing }
ProcessingAstCleaner class >> traits [
	^ self traitComposition traits
]

{ #category : #visiting }
ProcessingAstCleaner >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : #visiting }
ProcessingAstCleaner >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : #visiting }
ProcessingAstCleaner >> acceptNodes: aCollection [
	aCollection do: [ :each | self acceptNode: each ].
	^ aCollection
]

{ #category : #visiting }
ProcessingAstCleaner >> notImplemented: expr [
	ProcessingNotImplementedException
		signal: ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
		withTag: expr
]

{ #category : #cleaning }
ProcessingAstCleaner >> replace: anExpr with: anotherExpr [
	| parent |
	parent := anExpr parent.
	parent nodeVariables
		select: [ :name | (parent perform: name) = anExpr ]
		thenDo: [ :name | parent perform: name , ':' with: anotherExpr ].
	parent compositeNodeVariables
		select: [ :name | (parent perform: name) includes: anExpr ]
		thenDo: [ :name | 
			(parent perform: name)
				at: ((parent perform: name) indexOf: anExpr)
				put: anotherExpr ].
	^ anotherExpr
]

{ #category : #generated }
ProcessingAstCleaner >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : #generated }
ProcessingAstCleaner >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : #generated }
ProcessingAstCleaner >> visitAssertStatement: anAssertStatement [
	^ self visitStatement: anAssertStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitAssignmentExpression: anAssignmentExpression [
	^ self visitExpression: anAssignmentExpression
]

{ #category : #visiting }
ProcessingAstCleaner >> visitAssignmentStatement: stmt [
	"Rewrite a += b and friends to a = a + b for Smalltalk"

	stmt assigns size > 1 ifTrue: [ self notImplemented: stmt ].
	stmt assigns first value size = 2 & (stmt assigns first value last = $=)
		ifTrue: [ | op |
			op := stmt assigns first value first asString.
			stmt tos
				at: 1
				put: (PyBinaryExpressionNode new
						operator: (SmaCCToken
								value: op
								start: stmt assigns first startPosition
								ids: #());
						left: stmt lhs clone;
						right: stmt tos first;
						parent: stmt).
			stmt assigns
				at: 1
				put: (SmaCCToken
						value: '='
						start: stmt assigns first stopPosition
						ids: #()) ].
	^ self visitStatement: stmt
]

{ #category : #generated }
ProcessingAstCleaner >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : #visiting }
ProcessingAstCleaner >> visitBinaryExpression: expr [
	"GtUnoptimizedConditionalAdvice suggests (a and (b and c)) instead of ((a and b) and c)"

	expr left acceptVisitor: self.
	expr right acceptVisitor: self.
	[ (#('and' 'or') includes: expr operator value)
		and: [ (expr left isKindOf: PyBinaryExpressionNode)
				and: [ expr left operator value = expr operator value ] ] ]
		whileTrue: [ | a b c |
			a := expr left left.
			b := expr left right.
			c := expr right.
			expr right: expr left.
			expr left: a.
			expr right left: b.
			expr right right: c.
			a parent: expr.
			b parent: expr right.
			c parent: expr right ].
	^ expr
]

{ #category : #generated }
ProcessingAstCleaner >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : #generated }
ProcessingAstCleaner >> visitComparisonExpression: aComparisonExpression [
	^ self visitBinaryExpression: aComparisonExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : #generated }
ProcessingAstCleaner >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : #generated }
ProcessingAstCleaner >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : #generated }
ProcessingAstCleaner >> visitElif: anElif [
	^ self visitRoot: anElif
]

{ #category : #generated }
ProcessingAstCleaner >> visitEllipsis: anEllipsis [
	^ self visitExpression: anEllipsis
]

{ #category : #generated }
ProcessingAstCleaner >> visitElse: anElse [
	^ self visitRoot: anElse
]

{ #category : #generated }
ProcessingAstCleaner >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : #generated }
ProcessingAstCleaner >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : #generated }
ProcessingAstCleaner >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitExpression: anExpression [
	^ self visitRoot: anExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitExpressionStatement: anExpressionStatement [
	^ self visitStatement: anExpressionStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitFieldAccessExpression: aFieldAccessExpression [
	^ self visitExpression: aFieldAccessExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitFile: aFile [
	^ self visitRoot: aFile
]

{ #category : #generated }
ProcessingAstCleaner >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : #generated }
ProcessingAstCleaner >> visitForStatement: aForStatement [
	^ self visitStatement: aForStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitFunctionCallExpression: aFunctionCallExpression [
	^ self visitExpression: aFunctionCallExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitFunctionDefinition: aFunctionDefinition [
	^ self visitStatement: aFunctionDefinition
]

{ #category : #generated }
ProcessingAstCleaner >> visitGlobalStatement: aGlobalStatement [
	^ self visitStatement: aGlobalStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitIfExpression: anIfExpression [
	^ self visitExpression: anIfExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitIfStatement: anIfStatement [
	^ self visitStatement: anIfStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : #generated }
ProcessingAstCleaner >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : #generated }
ProcessingAstCleaner >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitListExpression: aListExpression [
	^ self visitExpression: aListExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : #generated }
ProcessingAstCleaner >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : #generated }
ProcessingAstCleaner >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : #generated }
ProcessingAstCleaner >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : #generated }
ProcessingAstCleaner >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : #generated }
ProcessingAstCleaner >> visitNumber: aNumber [
	^ self visitExpression: aNumber
]

{ #category : #generated }
ProcessingAstCleaner >> visitParameter: aParameter [
	^ self visitRoot: aParameter
]

{ #category : #generated }
ProcessingAstCleaner >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : #generated }
ProcessingAstCleaner >> visitPassStatement: aPassStatement [
	^ self visitStatement: aPassStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : #visiting }
ProcessingAstCleaner >> visitReturnStatement: stmt [
	"Smalltalk doesn't expect statements after a return, so we omit them."

	| index |
	index := stmt parent statements indexOf: stmt.
	[ stmt parent statements size > index ]
		whileTrue: [ stmt parent statements removeAt: index + 1 ].
	^ self visitStatement: stmt
]

{ #category : #generated }
ProcessingAstCleaner >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : #generated }
ProcessingAstCleaner >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ProcessingAstCleaner >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : #visiting }
ProcessingAstCleaner >> visitSmaCCError: aSmaCCError [
	^ self visitSmaCCParseNode: aSmaCCError
]

{ #category : #visiting }
ProcessingAstCleaner >> visitSmaCCParseNode: aSmaCCParseNode [
	self acceptNodes: aSmaCCParseNode sortedChildren.
	^ aSmaCCParseNode
]

{ #category : #generated }
ProcessingAstCleaner >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitStatement: aStatement [
	^ self visitRoot: aStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitString: aString [
	^ self visitExpression: aString
]

{ #category : #generated }
ProcessingAstCleaner >> visitSubscriptExpression: aSubscriptExpression [
	^ self visitExpression: aSubscriptExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : #visiting }
ProcessingAstCleaner >> visitTupleExpression: expr [
	"PythonParser produces PyTupleExpressionNodes for parenthesized expressions. These nodes aren't necessary for the AST"

	expr expressions size = 1 ifFalse: [ self notImplemented: expr ].
	expr expressions first acceptVisitor: self.
	^ self replace: expr with: expr expressions first
]

{ #category : #generated }
ProcessingAstCleaner >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitUnaryExpression: anUnaryExpression [
	^ self visitExpression: anUnaryExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitVariableExpression: aVariableExpression [
	^ self visitExpression: aVariableExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitWhileStatement: aWhileStatement [
	^ self visitStatement: aWhileStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : #generated }
ProcessingAstCleaner >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : #generated }
ProcessingAstCleaner >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : #generated }
ProcessingAstCleaner >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
