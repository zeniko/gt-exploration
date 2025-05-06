Class {
	#name : #BaselineOfGtExploration,
	#superclass : #BaselineOf,
	#category : #BaselineOfGtExploration
}

{ #category : #loading }
BaselineOfGtExploration class >> loadLepiter [
	IceRepository registry
		detect: [ :aRepository |
			aRepository name = 'gt-exploration' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGtExploration >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'GtExploration'
		]
]
