Class {
	#name : #GtExplorationHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'GtExploration-Sections'
}

{ #category : #initialization }
GtExplorationHomeSection >> cardPriorities [
	^ #(
		projectCard
		projectCard2
	)
]

{ #category : #card }
GtExplorationHomeSection >> projectCard [
	<gtSectionCard>
	^ GtHomeCard page
		title: 'Implementation and Tests';
		description: 'Technical details (not for students)';
		priority: 10;
		databaseName: 'zeniko:gt-exploration';
		pageName: 'Individual Project';
		assertInvariant;
		yourself
]

{ #category : #'as yet unclassified' }
GtExplorationHomeSection >> projectCard2 [
	<gtSectionCard>
	^ ProcessingAbstractionsHomeSection new projectCard
		priority: 20;
		yourself

]

{ #category : #initialization }
GtExplorationHomeSection >> sectionTitle [
	^ 'Processing Abstractions (zeniko)'
]
