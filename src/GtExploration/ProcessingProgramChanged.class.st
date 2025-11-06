"
This event is sent by {{gtClass:ProcessingProgram}} whenever the program's source changed and resulted in a successful recompilation.
"
Class {
	#name : #ProcessingProgramChanged,
	#superclass : #ProcessingASTChanged,
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
