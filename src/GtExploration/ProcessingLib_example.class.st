"
This is an example library that can be imported from Processing, allowing Processing to be extended by interfacing Smalltalk code.

```
import example
chars = example.chars(""test"")
print(example.join(chars, ""-""))
```

"
Class {
	#name : 'ProcessingLib_example',
	#superclass : 'Object',
	#category : 'GtExploration-Examples',
	#package : 'GtExploration',
	#tag : 'Examples'
}

{ #category : 'utilities' }
ProcessingLib_example class >> chars: string [
	^ ProcessingList newFrom: ((Array newFrom: string) collect: #asString)
]

{ #category : 'utilities' }
ProcessingLib_example class >> join: list varargs: args [
	self assert: args size equals: 1.
	^ list joinUsing: args first
]
