"
This is a subclass of {{gtClass:OrderedCollection}} modified to behave more closely as Python's lists:
- `sort` and `reverse` happen in place
- accessing items allows for negative indices (which access from the back)
- slicing is right opened instead of right closed (i.e. the end index is excluded instead of included)
- slicing may also happen in reverse with negative steps
- accessing may also happen 0-based

```
list := ProcessingList new.
list append: 1; append: 2; append: 4.
list reverse.
list at0: -3 ""this returns the third last item""
```

"
Class {
	#name : 'ProcessingList',
	#superclass : 'OrderedCollection',
	#instVars : [
		'recursionCheck'
	],
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}

{ #category : 'arithmetic' }
ProcessingList >> * arg [
	| res |
	res := ProcessingList new.
	1 to: arg do: [ :x | res addAll: self ].
	^ res
]

{ #category : 'arithmetic' }
ProcessingList >> + arg [
	^ self clone
		addAll: arg;
		yourself
]

{ #category : 'adding' }
ProcessingList >> append: value [
	self add: value.
	^ nil
]

{ #category : 'converting' }
ProcessingList >> asString [
	| str |
	recursionCheck ifNotNil: [ ^ '[...]' ].
	recursionCheck := self.
	str := '[' , (', ' join: (self collect: #asString)) , ']'.
	recursionCheck := nil.
	^ str
]

{ #category : 'accessing' }
ProcessingList >> at0: anInteger [
	"0-based accessor"

	^ self at: anInteger + 1
]

{ #category : 'accessing' }
ProcessingList >> at0: anInteger put: anObject [
	"0-based accessor"

	^ self at: anInteger + 1 put: anObject
]

{ #category : 'accessing' }
ProcessingList >> at: anInteger [
	^ super
		at: (anInteger <= 0 ifTrue: [ self size + anInteger ] ifFalse: [ anInteger ])
]

{ #category : 'accessing' }
ProcessingList >> at: anInteger put: anObject [
	^ super
		at: (anInteger <= 0 ifTrue: [ self size + anInteger ] ifFalse: [ anInteger ])
		put: anObject
]

{ #category : 'comparing' }
ProcessingList >> hash [
	"SequenceableCollection>>hash doesn't take into account recursion"

	| hash |
	recursionCheck ifNotNil: [ ^ self identityHash ].
	recursionCheck := self.
	hash := super hash hashMultiply + self class hash.
	recursionCheck := nil.
	^ hash
]

{ #category : 'removing' }
ProcessingList >> pop [
	^ self removeLast
]

{ #category : 'accessing' }
ProcessingList >> recursionCheck [
	^ recursionCheck
]

{ #category : 'accessing' }
ProcessingList >> recursionCheck: anObject [
	recursionCheck := anObject
]

{ #category : 'converting' }
ProcessingList >> reverse [
	self setContents: self asArray reversed.
	^ nil
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom0: startIndex [
	"0-based accessor"

	^ self sliceFrom: startIndex + 1
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom0: startIndex stepBy: step [
	"0-based accessor"

	^ self
		sliceFrom: startIndex + 1
		to: self size
		stepBy: step
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom0: startIndex to: endIndex [
	"0-based accessor (right openend, i.e. endIndex is excluded)"

	^ self sliceFrom: startIndex + 1 to: endIndex
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom0: startIndex to: endIndex stepBy: step [
	"0-based accessor (right openend, i.e. endIndex is excluded)"

	^ self
		sliceFrom: startIndex + 1
		to: endIndex
		stepBy: step
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom: startIndex [
	^ super
		sliceFrom: (startIndex <= 0 ifTrue: [ self size + startIndex ] ifFalse: [ startIndex ])
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom: startIndex stepBy: step [
	^ self
		sliceFrom: startIndex
		to: self size
		stepBy: step
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom: startIndex to: endIndex [
	^ super
		sliceFrom: (startIndex <= 0 ifTrue: [ self size + startIndex ] ifFalse: [ startIndex ])
		to: endIndex
]

{ #category : 'accessing' }
ProcessingList >> sliceFrom: startIndex to: endIndex stepBy: step [
	| slice |
	slice := self sliceFrom: startIndex to: endIndex.
	step > 0
		ifTrue: [ ^ ProcessingList
				newFrom: ((1 to: slice size by: step) collect: [ :i | slice at: i ]) ].
	step < 0
		ifTrue: [ ^ ProcessingList
				newFrom: ((1 to: slice size by: step negated) collect: [ :i | slice at: i negated + 1 ]) ]
]

{ #category : 'sorting' }
ProcessingList >> sort [
	self setContents: self asArray sorted.
	^ nil
]
