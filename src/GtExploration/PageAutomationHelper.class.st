Class {
	#name : #PageAutomationHelper,
	#superclass : #Object,
	#category : #'GtExploration-Experiments'
}

{ #category : #tool }
PageAutomationHelper class >> addWeekSection: aSnippet [
	| isoweek header snip |
	"Inverse to {{gtMethod:Week class>>#week:}}"
	isoweek := (Date today - Year current asYear firstThursday + 10 days) days / 7 roundDownTo: 1.
	
	header := BlRunRopedText string: '# Week ' , isoweek asString.
	snip := (aSnippet page children select: [ :child | child children isNotEmpty ]) first.
	snip text asString = header asString ifFalse: [
		snip := snip addSnippetBeforeSelf text: header.
		snip addSnippetAfterSelf indent.
	].
	^ snip
]

{ #category : #tool }
PageAutomationHelper class >> sistaV1BytecodeList [
	| bytecodes rx data list |
	
	bytecodes := OrderedCollection new.
	EncoderForSistaV1 methodDict valuesDo: [ :method |
		bytecodes addAll: method sourceCode lines.
	].
	EncoderForSistaV1 class methodDict valuesDo: [ :method |
		bytecodes addAll: method sourceCode lines.
	].
		
	rx := '(\d+)(-\d+)?\s+([01i ]{8,})([^"]+)' asRegex.
	data := (((bytecodes select: [ :l | (rx matchesIn: l) isNotEmpty ])
		flatCollect: [ :l | rx matchesIn: l ])
		collect: [ :m |
			| from to binary ext descr |
			rx matches: (m removeSuffix: '	').
			from := (rx subexpression: 2) asNumber.
			to := rx subexpression: 3.
			to := to ifNotNil: [ to asNumber negated ] ifNil: [ from ].
			binary := '' join: (rx subexpression: 4) substrings.
			
			ext := ' ' join: ('.{8}' asRegex matchesIn: ('' join: ('' join: (((rx subexpression: 5) splitOn: '	') allButLast)) substrings)).
			
			descr := ((rx subexpression: 5) splitOn: '	') last.
			{ from. to. binary. ext. descr. }
		]) sorted: [ :a :b | a first < b first or: [ a first = b first and: [ a second >= b second ] ] ].
	(2 to: data size) reversed do: [ :ix |
		| a b |
		a := data at: ix. b := data at: ix - 1.
		(a first = b first) & (a second = b second) ifTrue: [
			data removeAt: ix.
		].
	].
	
	list := BrColumnedList new.
	list items: data.
	list column
		title: 'From';
		weight: 1;
		stencil: [ :item | (BrColumnCellLabelStencil new text: item first) asElement width: 20 ].
	list column
		title: 'To';
		weight: 1;
		stencil: [ :item | BrColumnCellLabelStencil new text: item second ].
	list column
		title: 'Binary';
		weight: 2;
		stencil: [ :item | BrColumnCellLabelStencil new text: (item third asRopedText fontName: 'Source Code Pro') ].
	list column
		title: 'Ext';
		weight: 3;
		stencil: [ :item | BrColumnCellLabelStencil new text: (item fourth asRopedText fontName: 'Source Code Pro') ].
	list column
		title: 'Description';
		weight: 8;
		stencil: [ :item | BrColumnCellLabelStencil new text: item fifth ].
	list addAptitude: BrColumnedListHeaderAptitude.
	
	^ list
]

{ #category : #tool }
PageAutomationHelper class >> updateProcessingAPI [
	| dbs exploreDB unterrichtDB exploreAPI unterrichtAPI |
	
	dbs := LeDatabasesRegistry uniqueInstance defaultLogicalDatabase databases.
	exploreDB := (dbs select: [ :db | db databaseName = 'zeniko:gt-exploration' ]) first.
	unterrichtDB := (dbs select: [ :db | db databaseName = 'zeniko:processing-abstractions' ]) first.
	
	exploreAPI := exploreDB pageNamed: 'Processing API'.
	unterrichtAPI := unterrichtDB pageNamed: 'Processing API'.
	
	(unterrichtAPI children collect: [ :each | each ])
		do: [ :each | unterrichtAPI removeSnippet: each ].
	exploreAPI children do: [ :each | unterrichtAPI addSnippet: each clone ].
	
	^ unterrichtAPI
]
