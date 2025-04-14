Class {
	#name : #ProcessingProgram,
	#superclass : #Object,
	#instVars : [
		'source',
		'compilation',
		'ast'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #'as yet unclassified' }
ProcessingProgram >> ast [
	^ ast
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> canvas [
	| runner promise |
	runner := ProcessingRunner new.
	promise := runner run: self.
	"TODO: make this customizeable"
	runner limitTo: 2 seconds.
	(promise wait isKindOf: AsyncFutureCancelled) ifTrue: [
		Error new signal: 'Endless loop detected.'
	].
	^ runner canvas
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> compilation [
	^ compilation
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtBytecodeFor: aView [
	<gtView>
	^ compilation gtBytecodeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtOutputFor: aView [
	<gtView>
	^ compilation gtOutputFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtSourceCodeFor: aView [
	<gtView>
	^ compilation gtSourceCodeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtTreeFor: aView [
	<gtView>
	^ ast gtTreeFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> gtViewIntermediaryRepresentationFor: aView [
	<gtView>
	^ compilation gtViewIntermediaryRepresentationFor: aView
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> source [
	^ source
]

{ #category : #'as yet unclassified' }
ProcessingProgram >> source: aSource [
	source := aSource.
	ast := ProcessingParser parse: source asString.
	compilation := ProcessingTranspiler new compile: ast.
]
