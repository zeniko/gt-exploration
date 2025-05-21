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
