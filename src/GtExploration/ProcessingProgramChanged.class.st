Class {
	#name : #ProcessingProgramChanged,
	#superclass : #ProcessingSourceChanged,
	#instVars : [
		'program'
	],
	#category : #'GtExploration-Processing'
}

{ #category : #accessing }
ProcessingProgramChanged >> program [
	^ program
]

{ #category : #accessing }
ProcessingProgramChanged >> program: aProgram [
	program := aProgram
]
