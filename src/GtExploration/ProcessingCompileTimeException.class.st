"
This exception is thrown by {{gtClass:ProcessingTranspiler}} when it encounters syntactically valid but semantically invalid Processing code where semantical validity is relevant for the transpilation to Smalltalk (such as the number of arguments of a function or the declaration of a variable before usage).
"
Class {
	#name : 'ProcessingCompileTimeException',
	#superclass : 'ProcessingException',
	#category : 'GtExploration-Processing',
	#package : 'GtExploration',
	#tag : 'Processing'
}
