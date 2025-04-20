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
	snip := (aSnippet page children select: [ :child | child children size > 0 ]) first.
	snip text asString = header asString ifFalse: [
		snip := snip addSnippetBeforeSelf text: header.
		snip addSnippetAfterSelf indent.
	].
	^ snip
]
