"
This is the singleton object used for Python's `...` (which is mainly used for explicitly omitting source code without producing syntax errors).

```
ProcessingSource fromString: 'print(...)'
```

"
Class {
	#name : #ProcessingEllipsis,
	#superclass : #Object,
	#category : #'GtExploration-Processing'
}

{ #category : #views }
ProcessingEllipsis class >> asString [
	^ 'Ellipsis'
]
