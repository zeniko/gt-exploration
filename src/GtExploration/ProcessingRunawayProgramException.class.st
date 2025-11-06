"
This exception is thrown when the endless loop detection heuristic deems a program to run endlessly (instead of solving the halting problem, the {{gtClass:ProcessingRunner}} is simply instructed to abort a static program after 2 seconds or an animation after 30 seconds).
"
Class {
	#name : #ProcessingRunawayProgramException,
	#superclass : #ProcessingRunTimeException,
	#category : #'GtExploration-Processing'
}
