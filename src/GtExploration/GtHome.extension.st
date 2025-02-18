Extension { #name : #GtHome }

{ #category : #'*GtExploration' }
GtHome >> gtZenikoExplorationSection [
	<gtHomeSection>
	^ GtHomeStartPageSection new 
		title: 'GT Exploration';
		description: 'Zeniko''s GT experimentations';
		databaseName: 'zeniko\gt-exploration\lepiter';
		startPageName: 'Processing Source (class)';
		priority: 10
		
]
