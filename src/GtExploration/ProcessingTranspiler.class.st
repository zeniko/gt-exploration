Class {
	#name : #ProcessingTranspiler,
	#superclass : #Object,
	#category : #GtExploration
}

{ #category : #accessing }
ProcessingTranspiler >> compile: ast [
	| program visitor source nl |
	"Turn the AST into a Smalltalk source string"
	nl := String with: (Character cr).
	visitor := ProcessingTranspilingVisitor new.
	source := 'drawOnto: canvas' , nl , (nl join: (ast acceptVisitor: visitor)).
	"TODO: temporary names?"
	ProcessingCodeBase
		subclass: #ProcessingCode01
		instanceVariableNames: ''
		classVariableNames: ''
		category: (self class category).
	program := Smalltalk at: #ProcessingCode01.
	program compile: source.
	^ program perform: #new
]
