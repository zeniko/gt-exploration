Class {
	#name : #GtExplorationHomeSection,
	#superclass : #GtHomeMultiCardSection,
	#category : #'GtExploration-Sections'
}

{ #category : #initialization }
GtExplorationHomeSection >> cardPriorities [
	<gtExample>
	^ #(
		projectCard
	)
]

{ #category : #initialization }
GtExplorationHomeSection >> defaultPriority [
	^ 10
]

{ #category : #card }
GtExplorationHomeSection >> projectCard [
	<gtSectionCard>
	<gtExample>
	^ GtHomeCard page
		title: 'Processing Project';
		description: 'zeniko''s GT explorations';
		setPriority;
		databaseName: 'zeniko:gt-exploration';
		pageName: 'Individual Project';
		assertInvariant;
		yourself
]

{ #category : #initialization }
GtExplorationHomeSection >> sectionTitle [
	^ 'Zeniko project'
]
