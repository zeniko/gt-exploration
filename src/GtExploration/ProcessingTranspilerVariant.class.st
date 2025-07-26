Class {
	#name : #ProcessingTranspilerVariant,
	#superclass : #Object,
	#traits : 'TPyRootNodeVisitor',
	#classTraits : 'TPyRootNodeVisitor classTrait',
	#instVars : [
		'indentation',
		'style'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'accessing - method dictionary' }
ProcessingTranspilerVariant class >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aCategory [
	"When a new methods is added, I add it to the localMethodDict and also propagate the changes to my users"

	self localMethodDict at: selector put: compiledMethod.

	super
		addAndClassifySelector: selector
		withMethod: compiledMethod
		inProtocol: aCategory.

	TraitChange addSelector: selector on: self
]

{ #category : #'accessing - method dictionary' }
ProcessingTranspilerVariant class >> addSelector: selector withMethod: compiledMethod [
	"When a new selector is installed in a class I insert the selector in the local methodDict and propagate the changes to my users"

	self localMethodDict at: selector put: compiledMethod.
	super addSelector: selector withMethod: compiledMethod.
	TraitChange addSelector: selector on: self
]

{ #category : #'accessing - method dictionary' }
ProcessingTranspilerVariant class >> addSelector: selector withRecompiledMethod: compiledMethod [
	"When a new selector is installed in a class I insert the selector in the local methodDict and propagate the changes to my users"

	compiledMethod isFromTrait
		ifTrue: [ ^ super addSelector: selector withRecompiledMethod: compiledMethod ].

	self localMethodDict at: selector put: compiledMethod.
	super addSelector: selector withRecompiledMethod: compiledMethod.
	TraitChange addSelector: selector on: self
]

{ #category : #querying }
ProcessingTranspilerVariant class >> allTraits [
	^ self traitComposition allTraits
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> doRebuildMethodDictionary [
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
ProcessingTranspilerVariant class >> findOriginClassOf: aMethod [
	"I return the myself or the trait that has the original implementation of a method.
	If the method is an alias, the returned class includes the original aliased method"

	(aMethod hasProperty: #traitSource)
		ifTrue: [ ^ aMethod traitSource innerClass ].

	(self includesLocalSelector: aMethod selector) ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ])
		innerClass
]

{ #category : #testing }
ProcessingTranspilerVariant class >> findOriginMethodOf: aMethod [
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
ProcessingTranspilerVariant class >> hasTraitComposition [
	^ self traitComposition isEmpty not
]

{ #category : #testing }
ProcessingTranspilerVariant class >> includesLocalSelector: aSymbol [
	^ self isLocalSelector: aSymbol
]

{ #category : #testing }
ProcessingTranspilerVariant class >> includesTrait: aTrait [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition includesTrait: aTrait
]

{ #category : #testing }
ProcessingTranspilerVariant class >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : #testing }
ProcessingTranspilerVariant class >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : #testing }
ProcessingTranspilerVariant class >> isLocalMethodsProtocol: aProtocol [
	"Checks if the protocol has local selectors"

	aProtocol methodSelectors ifEmpty: [ ^ true ].
	^ aProtocol methodSelectors anySatisfy: [ :each | self isLocalSelector: each ]
]

{ #category : #testing }
ProcessingTranspilerVariant class >> isLocalSelector: aSelector [
	^ self localMethodDict includesKey: aSelector
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> localMethodDict [
	"The local methodDict is in the metaclass. In this way I do not have to recompile the methods during the bootstrap when we don't have a compiler."

	^ self class baseLocalMethods
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> localMethodDict: aMethodDictionary [
	^ self class baseLocalMethods: aMethodDictionary
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses"

	^ self localMethodDict values
]

{ #category : #'accessing - method dictionary' }
ProcessingTranspilerVariant class >> localSelectors [
	^ self localMethodDict keys
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> postfix [
	^ ProcessingTranspilerVariant new style: 'postfix'
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> prefix [
	^ ProcessingTranspilerVariant new style: 'prefix'
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> rebuildMethodDictionary [
	"Useful to be rewritten in Traits"

	^ self doRebuildMethodDictionary
]

{ #category : #categories }
ProcessingTranspilerVariant class >> recategorizeSelector: selector from: oldCategory to: newCategory [
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
ProcessingTranspilerVariant class >> recompile: selector from: oldClass [
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
ProcessingTranspilerVariant class >> removeFromComposition: aTrait [
	self
		setTraitComposition: (self traitComposition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : #removing }
ProcessingTranspilerVariant class >> removeFromSystem: logged [
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
ProcessingTranspilerVariant class >> removeSelector: aSelector [
	"When a selector is removed it should be notified to my users.
	Check the class TraitChange for more details"

	super removeSelector: aSelector.
	self localMethodDict removeKey: aSelector ifAbsent: [  ].

	TraitChange removeSelector: aSelector on: self
]

{ #category : #initialization }
ProcessingTranspilerVariant class >> smalltalk [
	^ ProcessingTranspiler new
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> traitComposition [
	"My trait composition is in my class. So I do not need to recompile the methods when installing them during bootstrap"

	^ self class baseComposition
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> traitComposition: aComposition [
	aComposition asTraitComposition allTraits
		do: [ :aMaybeTrait | 
			aMaybeTrait isTrait
				ifFalse: [ self error: 'All the members of the trait composition should be traits' ] ].

	self class baseComposition: aComposition
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> traitUsers [
	"I am a traited class, I have no users, this is for compatibility with traits"

	^ #()
]

{ #category : #accessing }
ProcessingTranspilerVariant class >> traits [
	^ self traitComposition traits
]

{ #category : #visiting }
ProcessingTranspilerVariant >> accept: anObject [
	(anObject isKindOf: SmaCCParseNode) ifTrue: [ ^ self acceptNode: anObject ].
	(anObject isKindOf: Collection) ifTrue: [ ^ self acceptNodes: anObject ].
	^ anObject
]

{ #category : #visiting }
ProcessingTranspilerVariant >> acceptNode: aSmaCCParseNode [
	aSmaCCParseNode isNil ifTrue: [ ^ nil ].
	^ aSmaCCParseNode acceptVisitor: self
]

{ #category : #visiting }
ProcessingTranspilerVariant >> acceptNodes: aCollection [
	^ aCollection collect: [ :each | self acceptNode: each ]
]

{ #category : #visiting }
ProcessingTranspilerVariant >> acceptStatements: expr [
	| output |
	output := ''.
	indentation := indentation + 1.
	output := ''
			join: (expr statements
					collect: [ :stmt | 
						self indent , (stmt acceptVisitor: self)
							, '
' ]).
	indentation := indentation - 1.
	^ output
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emit: op args: args [
	^ style = 'postfix'
		ifTrue: [ ('' join: (args collect: [ :arg | arg , ' ' ])) , op ]
		ifFalse: [ '(' , op , ('' join: (args collect: [ :arg | ' ' , arg ])) , ')' ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitBlockCond: args [
	^ style = 'postfix' ifTrue: [ '{ ' , args , ' }' ] ifFalse: [ args ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitBlockDo: args [
	^ style = 'postfix'
		ifTrue: [ '{
' , args , self indent , '}' ]
		ifFalse: [ '(do
' , args , self indent , ')' ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitCall: name size: size [
	| defaultSizes |
	defaultSizes := {'append' -> 2.
			'background' -> 3.
			'circle' -> 3.
			'color' -> 3.
			'concat' -> 2.
			'cos' -> 1.
			'delay' -> 1.
			'ellipse' -> 4.
			'fill' -> 3.
			'frameRate' -> 1.
			'image' -> 5.
			'int' -> 1.
			'line' -> 4.
			'loadImage' -> 1.
			'millis' -> 0.
			'noStroke' -> 0.
			'print' -> 1.
			'println' -> 1.
			'radians' -> 1.
			'random' -> 1.
			'rect' -> 4.
			'reverse' -> 1.
			'reversed' -> 1.
			'rotate' -> 1.
			'scale' -> 1.
			'shorten' -> 1.
			'sin' -> 1.
			'size' -> 2.
			'sort' -> 1.
			'sorted' -> 1.
			'sq' -> 1.
			'sqrt' -> 1.
			'square' -> 3.
			'str' -> 1.
			'stroke' -> 3.
			'strokeWeight' -> 1.
			'tan' -> 1.
			'text' -> 3.
			'textSize' -> 1.
			'translate' -> 2.
			'triangle' -> 6.
			'assert' -> 1.
			'global' -> 1.
			'list' -> 0.
			'range' -> 2} asDictionary.
	style = 'postfix'
		ifTrue: [ size = (defaultSizes at: name ifAbsent: size)
				ifFalse: [ ^ name , '_' , size asString ] ].
	^ name
]

{ #category : #emitting }
ProcessingTranspilerVariant >> emitSymbol: name [
	^ style = 'postfix' ifTrue: [ '$' , name ] ifFalse: [ name ]
]

{ #category : #emitting }
ProcessingTranspilerVariant >> indent [
	^ String new: indentation - 1 withAll: Character tab
]

{ #category : #'error handling' }
ProcessingTranspilerVariant >> notImplemented: expr [
	ProcessingNotImplementedException
		signal: 'Unsupported expression type: ' , ((expr class name removePrefix: 'Py') removeSuffix: 'Node')
		withTag: expr
]

{ #category : #accessing }
ProcessingTranspilerVariant >> style [
	^ style
]

{ #category : #accessing }
ProcessingTranspilerVariant >> style: anObject [
	style := anObject
]

{ #category : #emitting }
ProcessingTranspilerVariant >> transpile: anAst [
	indentation := 0.
	^ (ProcessingAstCleaner clean: anAst) acceptVisitor: self
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitArgument: anArgument [
	^ self visitRoot: anArgument
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitAsName: anAsName [
	^ self visitName: anAsName
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssertStatement: stmt [
	^ self
		emit: (self emitCall: 'assert' size: stmt values size)
		args: (self acceptNodes: stmt values)
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssignmentExpression: expr [
	^ self
		emit: '='
		args: {self emitSymbol: expr variable nameToken value.
				expr value acceptVisitor: self}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitAssignmentStatement: stmt [
	stmt tos size > 1 ifTrue: [ self notImplemented: stmt ].
	(stmt lhs isKindOf: PySubscriptExpressionNode)
		ifTrue: [ ^ self
				emit: 'put_at'
				args: {stmt lhs receiver acceptVisitor: self.
						stmt lhs subscripts first acceptVisitor: self.
						stmt tos first acceptVisitor: self} ].
	(stmt lhs isKindOf: PyVariableExpressionNode)
		ifFalse: [ self notImplemented: stmt ].
	^ self
		emit: stmt assigns first value
		args: {self emitSymbol: stmt lhs nameToken value.
				stmt tos first acceptVisitor: self}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitAwaitExpression: anAwaitExpression [
	^ self visitExpression: anAwaitExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitBacktickExpression: aBacktickExpression [
	^ self visitExpression: aBacktickExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitBinaryExpression: expr [
	^ self
		emit: expr operator value
		args: {expr left acceptVisitor: self.
				expr right acceptVisitor: self}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitBreakStatement: aBreakStatement [
	^ self visitStatement: aBreakStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitClassDefinition: aClassDefinition [
	^ self visitStatement: aClassDefinition
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitComparisonExpression: expr [
	^ self visitBinaryExpression: expr
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehension: aComprehension [
	^ self visitRoot: aComprehension
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehensionDictionaryItem: aComprehensionDictionaryItem [
	^ self visitRoot: aComprehensionDictionaryItem
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehensionFor: aComprehensionFor [
	^ self visitRoot: aComprehensionFor
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitComprehensionIf: aComprehensionIf [
	^ self visitRoot: aComprehensionIf
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitContinueStatement: aContinueStatement [
	^ self visitStatement: aContinueStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDecoratorExpression: aDecoratorExpression [
	^ self visitFunctionCallExpression: aDecoratorExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDelStatement: aDelStatement [
	^ self visitStatement: aDelStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDictionaryExpression: aDictionaryExpression [
	^ self visitExpression: aDictionaryExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitDictionaryItem: aDictionaryItem [
	^ self visitRoot: aDictionaryItem
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitElif: anElif [
	^ self visitRoot: anElif
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitEllipsis: expr [
	^ '...'
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitElse: anElse [
	^ self visitRoot: anElse
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitEval: anEval [
	^ self visitRoot: anEval
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitExceptClause: anExceptClause [
	^ self visitRoot: anExceptClause
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitExecStatement: anExecStatement [
	^ self visitStatement: anExecStatement
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitExpression: expr [
	self notImplemented: expr
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitExpressionStatement: stmt [
	^ ' ' join: (stmt children collect: [ :part | part acceptVisitor: self ])
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitFieldAccessExpression: aFieldAccessExpression [
	^ self visitExpression: aFieldAccessExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFile: file [
	^ self acceptStatements: file
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitFinally: aFinally [
	^ self visitRoot: aFinally
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitForStatement: expr [
	expr exprs size = 1 ifFalse: [ self notImplemented: expr ].
	(expr exprs first isKindOf: PyVariableExpressionNode)
		ifFalse: [ self notImplemented: expr ].
	expr else ifNotNil: [ self notImplemented: expr ].
	^ self
		emit: 'for_in'
		args: {self emitSymbol: expr exprs first nameToken value.
				expr inExpression acceptVisitor: self.
				self emitBlockDo: (self acceptStatements: expr)}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFunctionCallExpression: fnCall [
	^ self
		emit: (self emitCall: fnCall receiver nameToken value size: fnCall arguments size)
		args: (self acceptNodes: fnCall arguments)
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitFunctionDefinition: def [
	^ self
		emit: 'deffun'
		args: {self emitSymbol: def fname value.
				'('
					, (' ' join: (def parameters collect: [ :param | param acceptVisitor: self ]))
					, ')'.
				self emitBlockDo: (self acceptStatements: def)}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitGlobalStatement: global [
	^ self
		emit: (self emitCall: 'global' size: global nameTokens size)
		args: (global nameTokens collect: [ :token | self emitSymbol: token value ])
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitIfExpression: expr [
	^ self
		emit: 'ifelse'
		args: {expr condition acceptVisitor: self.
				expr if acceptVisitor: self.
				expr else acceptVisitor: self}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitIfStatement: expr [
	| output |
	self assert: expr elsifs isEmpty.	"cf. ProcessingAstCleaner>>visitIfStatement:"
	output := expr else
			ifNotNil: [ self emitBlockDo: (self acceptStatements: expr else) ]
			ifNil: [ style = 'postfix' ifTrue: [ self emitBlockCond: 'pass' ] ifFalse: [ '' ] ].
	output := self
			emit: 'ifelse'
			args: {self emitBlockCond: (expr condition acceptVisitor: self).
					self emitBlockDo: (self acceptStatements: expr).
					output}.
	^ output
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitImportStatement: anImportStatement [
	^ self visitStatement: anImportStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitInit: anInit [
	^ self visitRoot: anInit
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitKeywordParameter: aKeywordParameter [
	^ self visitParameter: aKeywordParameter
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitLambdaExpression: aLambdaExpression [
	^ self visitExpression: aLambdaExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitListExpression: list [
	^ self
		emit: (self emitCall: 'list' size: list expressions size)
		args: (self acceptNodes: list expressions)
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitListFor: aListFor [
	^ self visitRoot: aListFor
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitListIf: aListIf [
	^ self visitRoot: aListIf
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitListParameter: aListParameter [
	^ self visitParameter: aListParameter
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitMetaclass: aMetaclass [
	^ self visitRoot: aMetaclass
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitName: aName [
	^ self visitRoot: aName
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitNumber: num [
	^ num numberToken value
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitParameter: param [
	^ self emitSymbol: param name nameToken value
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitParameterList: aParameterList [
	^ self visitRoot: aParameterList
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitPassStatement: pass [
	^ self emit: 'pass' args: #()
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitPrintStatement: aPrintStatement [
	^ self visitStatement: aPrintStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitRaiseStatement: aRaiseStatement [
	^ self visitStatement: aRaiseStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitRelativeName: aRelativeName [
	^ self visitRoot: aRelativeName
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitReturnStatement: expr [
	expr expressions size = 0 ifTrue: [ ^ self emit: 'return' args: #('None') ].
	expr expressions size > 1 ifTrue: [ self notImplemented: expr ].
	^ self emit: 'return' args: {expr expressions first acceptVisitor: self}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitReturnTypeAnnotation: aReturnTypeAnnotation [
	^ self visitRoot: aReturnTypeAnnotation
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitRoot: aRoot [
	^ self visitSmaCCParseNode: aRoot
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitSetExpression: aSetExpression [
	^ self visitExpression: aSetExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitSlice: aSlice [
	^ self visitRoot: aSlice
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitSpreadExpression: aSpreadExpression [
	^ self visitExpression: aSpreadExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitStatement: stmt [
	self notImplemented: stmt
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitString: expr [
	^ '"'
		, ('' join: (expr parts collect: [ :part | part value allButFirst allButLast ]))
		, '"'
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitSubscriptExpression: subscript [
	(subscript subscripts first isKindOf: PySliceNode)
		ifTrue: [ ^ self
				emit: 'slice'
				args: {subscript receiver acceptVisitor: self.
						subscript subscripts first from
							ifNotNil: [ subscript subscripts first from acceptVisitor: self ]
							ifNil: [ 'None' ].
						subscript subscripts first to
							ifNotNil: [ subscript subscripts first to acceptVisitor: self ]
							ifNil: [ 'None' ]} ].
	^ self
		emit: 'item'
		args: (self
				acceptNodes: {subscript receiver.
						subscript subscripts first})
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitTryStatement: aTryStatement [
	^ self visitStatement: aTryStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitTupleExpression: aTupleExpression [
	^ self visitExpression: aTupleExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitTypedVariableExpression: aTypedVariableExpression [
	^ self visitVariableExpression: aTypedVariableExpression
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitUnaryExpression: expr [
	| op |
	op := expr operator value.
	style = 'postfix' & (op size = 1) ifTrue: [ op := 'unary' , op ].
	^ self emit: op args: {expr expression acceptVisitor: self}
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitVariableExpression: var [
	^ var nameToken value
]

{ #category : #visiting }
ProcessingTranspilerVariant >> visitWhileStatement: expr [
	expr else ifNotNil: [ self notImplemented: expr ].
	^ self
		emit: 'while'
		args: {self emitBlockCond: (expr condition acceptVisitor: self).
				self emitBlockDo: (self acceptStatements: expr)}
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitWithItem: aWithItem [
	^ self visitRoot: aWithItem
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitWithStatement: aWithStatement [
	^ self visitStatement: aWithStatement
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitYieldExpression: aYieldExpression [
	^ self visitExpression: aYieldExpression
]

{ #category : #generated }
ProcessingTranspilerVariant >> visitYieldStatement: aYieldStatement [
	^ self visitStatement: aYieldStatement
]
