Class {
	#name : #GtExplorationHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#classInstVars : [
		'studentMode'
	],
	#category : #'GtExploration-GtExtensions'
}

{ #category : #accessing }
GtExplorationHomeSection class >> studentMode [
	^ studentMode ifNil: [ false ]
]

{ #category : #accessing }
GtExplorationHomeSection class >> studentMode: aBoolean [
	studentMode := aBoolean.
	self updateGtWorld.
]

{ #category : #initialization }
GtExplorationHomeSection >> cardPriorities [
	^ #(
		explorationCard
		processingAbstractionCard
	)
]

{ #category : #card }
GtExplorationHomeSection >> explorationCard [
	<gtSectionCard>
	"allow hiding this card in student distributions"
	self class studentMode ifTrue: [ ^ GtEmptyHomeCard new ].
	^ GtHomeCard lazy
		title: 'Implementation and Tests';
		description: 'Technical details (not for students)';
		databaseName: 'zeniko:gt-exploration';
		pageName: 'Individual Project';
		setPriority;
		loadLepiter: [
			Metacello new
				repository: 'github://zeniko/gt-exploration:main/src';
				baseline: 'GtExploration';
				load.
			#BaselineOfGtExploration asClass loadLepiter.
			self class updateGtWorld
		];
		assertInvariant;
		yourself
]

{ #category : #card }
GtExplorationHomeSection >> processingAbstractionCard [
	<gtSectionCard>
	^ GtHomeCard lazy
		title: 'Unterrichtseinheiten';
		description: 'Material für Schüler:innen';
		databaseName: 'zeniko:processing-abstractions';
		pageName: 'Einleitung';
		setPriority;
		loadLepiter: [
			Metacello new
				repository: 'github://zeniko/processing-abstractions:main/src';
				baseline: 'ProcessingAbstractions';
				load.
			#BaselineOfProcessingAbstractions asClass loadLepiter.
			self class updateGtWorld
		];
		assertInvariant;
		yourself
]

{ #category : #initialization }
GtExplorationHomeSection >> sectionTitle [
	^ 'Processing Abstractions (zeniko)'
]
