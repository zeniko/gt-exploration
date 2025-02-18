Extension { #name : #GtHome }

{ #category : #'*GtExploration' }
GtHome >> gtZenikoExplorationSection [
	<gtHomeSection>
	^ GtHomeStartPageSection new 
		title: 'Individual Project';
		description: 'zeniko''s GT explorations';
		databaseName: 'zeniko\gt-exploration\lepiter';
		startPageName: 'Individual Project';
		priority: 10
		
]
