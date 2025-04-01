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
	| canvas |
	canvas := ProcessingCanvas new.
	compilation drawOnto: canvas.
	^ canvas
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
