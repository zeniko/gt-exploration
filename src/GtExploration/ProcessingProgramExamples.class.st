Class {
	#name : 'ProcessingProgramExamples',
	#superclass : 'Object',
	#category : 'GtExploration-Examples',
	#package : 'GtExploration',
	#tag : 'Examples'
}

{ #category : 'example' }
ProcessingProgramExamples >> allPrograms [
	<gtExample>
	^ ProcessingSourceExamples new sourceNames
		collect: [ :name | 
			| program |
			program := (ProcessingSourceExamples new perform: #source , name) program.
			self assert: program source isNotNil.
			self assert: program ast isNotNil.
			self assert: program compilation isNotNil.
			program ]
]

{ #category : 'example' }
ProcessingProgramExamples >> allProgramsLepiter [
	"All programs linked from Lepiter pages (for reference, due to https://github.com/feenkcom/gtoolkit/issues/4671)"

	<gtExample>
	self programAlpinerWanderweg.
	self programExample02.
	self programExample03.
	self programPrint.
	self programMouseEvents.
	self programRecursion.
	ProcessingTranspilerExamples new transpileExample02.
	ProcessingTranspilerExamples new transpileRecursion
]

{ #category : 'example' }
ProcessingProgramExamples >> allViews [
	<gtExample>
	| program views |
	program := self programPresentationDemo.
	views := program class methodDict keys
			select: [ :key | (key beginsWith: 'gt') & (key endsWith: 'For:') ].
	self assert: views size equals: 28.
	views
		do: [ :key | 
			| view element |
			view := program perform: key with: GtPhlowView empty.
			self assert: view isNotNil.
			element := view asElement.
			self assert: element containerName = 'phlow--exception' equals: false ].
	self
		assert: (' ' join: views sorted)
		equals: 'gtAbstractionsFor: gtBytecodeFor: gtBytecodePlusIRFor: gtBytecodePlusSourceFor: gtHexDumpFor: gtIntermediaryRepresentationFor: gtIntermediaryRepresentationPlusSourceFor: gtOutputFor: gtOutputPlusSourceFor: gtOutputShapesFor: gtSlicesFor: gtSourceBytesFor: gtSourceBytesPlusCharsFor: gtSourceBytesPlusSourceFor: gtSourceCharsFor: gtSourceCharsPlusSourceFor: gtSourceCodeFor: gtStepsFor: gtTokensFor: gtTokensPlusSourceFor: gtTokensPlusTreeFor: gtTranspilationFor: gtTranspilationPlusSourceFor: gtTranspilationPostfixFor: gtTranspilationPrefixFor: gtTreeFor: gtTreeMondrianFor: gtTreePlusSourceFor:'.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programAlpinerWanderweg [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceAlpinerWanderweg program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programExample02 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample02 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programExample03 [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceExample03 program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programMouseEvents [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceMouseEvents program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programPresentationDemo [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourcePresentationDemo program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programPrint [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourcePrint program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]

{ #category : 'example' }
ProcessingProgramExamples >> programRecursion [
	<gtExample>
	| program |
	program := ProcessingSourceExamples new sourceRecursion program.
	self assert: program source isNotNil.
	self assert: program compilation isNotNil.
	self assert: program ast isNotNil.
	^ program
]
