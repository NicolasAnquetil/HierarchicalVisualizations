Class {
	#name : #HDistributionMap,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'elements',
		'allProperties',
		'childrenBlock',
		'propertyBlock'
	],
	#category : #'Hierarchical-Examples'
}

{ #category : #building }
HDistributionMap >> build [
	self buildNodes.
	self buildLegend.
	super build
]

{ #category : #building }
HDistributionMap >> buildInnerNode: anElement [
	| elementValue |
	elementValue := (propertyBlock value: anElement).
	allProperties add: elementValue.

	^HValuedNode new
		name: anElement name ;
		rawModel: anElement ;
		value: elementValue ;
		yourself
	

]

{ #category : #building }
HDistributionMap >> buildLegend [
	| builder |
	builder := RSLegend new
		container: self canvas ;
		title: 'Properties' ;
		onDemand ;
		yourself.
	allProperties do: [ :prop |
		builder text: prop withBoxColor: (colorPalette scale: prop)
	].
	builder build.

]

{ #category : #building }
HDistributionMap >> buildNodes [
	| outerNodes |
	allProperties := Set new.
	outerNodes := elements collect: [ :elt | self buildOuterNode: elt ].
	self colorNodes: outerNodes.

	rootNode := HNode new.
	rootNode addAll: (self orderOuterNodes: outerNodes).
]

{ #category : #building }
HDistributionMap >> buildOuterNode: element [
	^HNode new
		name: element name ;
		rawModel: element ;
		addAll: (self orderInnerNodes: (self innerNodesFor: element)) ;
		yourself
]

{ #category : #accessing }
HDistributionMap >> childrenBlock: aBlock [
	childrenBlock := aBlock
]

{ #category : #accessing }
HDistributionMap >> colorMap: anObject [

	colorPalette := anObject
]

{ #category : #building }
HDistributionMap >> colorNodes: outerNodes [
	colorPalette domain: allProperties asOrderedCollection.

	outerNodes do: [ :outerNode | 
		outerNode children do: [ :innerNode |
			innerNode color: (colorPalette scale: innerNode level) ] ]
]

{ #category : #accessing }
HDistributionMap >> elements [

	^ elements
]

{ #category : #accessing }
HDistributionMap >> elements: anObject [

	elements := anObject
]

{ #category : #building }
HDistributionMap >> innerNodesFor: anElement [
	^(childrenBlock value: anElement)
		asOrderedCollection
			collect: [ :child | self buildInnerNode: child]	

]

{ #category : #private }
HDistributionMap >> numberOfchildrenWithProperty: aProp forNode: aNode [
	^aNode children count: [ :childNode | childNode value = aProp ]
]

{ #category : #private }
HDistributionMap >> orderInnerNodes: innerNodes [
	^innerNodes sorted: [ :a :b | a value < b value ]
	
]

{ #category : #private }
HDistributionMap >> orderOuterNodes: aCollectionOfNodes [
	| engine partVectors |
	aCollectionOfNodes ifEmpty: [^#()].

	allProperties := allProperties asOrderedCollection.
	partVectors :=  aCollectionOfNodes asOrderedCollection collect: [:node |
		MalSimilarityItem with: node
			andAll: (allProperties collect: [:aProp | self numberOfchildrenWithProperty: aProp forNode: node]) ].
	engine := MalClusterEngine with: partVectors.
	engine hierarchicalClusteringUsing: #averageLinkage.
	^engine dendrogram orderLeafs collect: #item.
	
]

{ #category : #accessing }
HDistributionMap >> propertyBlock [

	^ propertyBlock
]

{ #category : #accessing }
HDistributionMap >> propertyBlock: anObject [

	propertyBlock := anObject
]
