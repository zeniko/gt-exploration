Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#category : #GtExploration
}

{ #category : #accessing }
ProcessingTranspiler >> compile: ast [ 
	| program visitor source |
	"Turn the AST into a Smalltalk source string"
	visitor := ProcessingTranspilingVisitor new.
	source := 'drawOnto: canvas ' , (' ' join: (ast acceptVisitor: visitor)).
	"TODO: temporary names?"
	Object
		subclass: #ProcessingCode01
		instanceVariableNames: ''
		classVariableNames: ''
		category: 'GtExploration'.
	program := (Smalltalk at: #ProcessingCode01).
	program compile: source.
	^ program perform: #new
]
