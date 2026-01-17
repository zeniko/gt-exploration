"
This is an example library that can be imported from Processing, allowing Processing to be extended by interfacing Smalltalk code.

```
import example
chars = example.chars(""test"")
print(example.join(chars, ""-""))
```

The calling convention is determined by {{gtMethod:ProcessingTranspiler>>#visitFunctionCallExpression:}}:
- Methods with more than one argument are implemented by a `NAME:varargs:` message where all but the first argument are wrapped in an Array passed to varargs.
- Methods must return Processing-compatible types, such as {{gtClass:String}}, {{gtClass:Integer}}, {{gtClass:Boolean}} or {{gtClass:ProcessingList}}.

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
