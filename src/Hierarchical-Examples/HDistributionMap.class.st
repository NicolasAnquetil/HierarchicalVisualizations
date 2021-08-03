Class {
	#name : #HDistributionMap,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'elements',
		'property',
		'colorMap',
		'allProperties',
		'children'
	],
	#category : #'Hierarchical-Examples'
}

{ #category : #rendering }
HDistributionMap >> buildInnerNode: anElement [
	| elementValue |
	elementValue := (property value: anElement).
	allProperties add: elementValue.

	^HHeatMapNode new
		name: anElement name ;
		rawModel: anElement ;
		value: elementValue ;
		yourself
	

]

{ #category : #rendering }
HDistributionMap >> buildNodes [
	| outerNodes |
	rootNode := HNode new.
	rootNode name: 'Root'.
	outerNodes := Dictionary new: elements size.
	elements do: [ :elt |
		outerNodes at: elt put: (self outerNodeChildren: elt)].
	allProperties := allProperties asOrderedCollection.
	rootNode addAll: (self orderOuterNodes: (self buildOuterNodes: outerNodes)) 
]

{ #category : #rendering }
HDistributionMap >> buildOuterNode: anElement withChildren: childrenNodes [
	^HNode new
		name: anElement name ;
		rawModel: anElement ;
		children: (self orderInnerNodes: childrenNodes) ;
		yourself
	

]

{ #category : #rendering }
HDistributionMap >> buildOuterNodes: nodeDictionary [
	^nodeDictionary associations
		collect: [ :nodeAssociation |
			HNode new
				name: nodeAssociation key name ;
				rawModel: nodeAssociation key ;
				addAll: (self orderInnerNodes: nodeAssociation value) ;
				yourself
		]
]

{ #category : #accessing }
HDistributionMap >> children: aBlock [
	children := aBlock
]

{ #category : #accessing }
HDistributionMap >> colorMap [

	^ colorMap
]

{ #category : #accessing }
HDistributionMap >> colorMap: anObject [

	colorMap := anObject
]

{ #category : #accessing }
HDistributionMap >> elements [

	^ elements
]

{ #category : #accessing }
HDistributionMap >> elements: anObject [

	elements := anObject
]

{ #category : #'instance creation' }
HDistributionMap >> initialize [
	super initialize.
	allProperties := Set new.
]

{ #category : #private }
HDistributionMap >> numberOfchildrenWithProperty: aProp forNode: aNode [
	^aNode children count: [ :childNode | childNode level = aProp ]
]

{ #category : #rendering }
HDistributionMap >> open [
	self buildNodes.
	self rootNode: rootNode.
	self colorPalette: (colorMap domain: allProperties).

	super open
	
]

{ #category : #private }
HDistributionMap >> orderInnerNodes: innerNodes [
	^innerNodes sorted: [ :a :b | a level < b level ]
	
]

{ #category : #private }
HDistributionMap >> orderOuterNodes: aCollectionOfNodes [
	| engine partVectors |
	aCollectionOfNodes ifEmpty: [^#()].

	partVectors :=  aCollectionOfNodes asOrderedCollection collect: [:node |
		MalSimilarityItem with: node
			andAll: (allProperties collect: [:aProp | self numberOfchildrenWithProperty: aProp forNode: node]) ].
	engine := MalClusterEngine with: partVectors.
	engine hierarchicalClusteringUsing: #averageLinkage.
	^engine dendrogram orderLeafs collect: #item.
	
]

{ #category : #rendering }
HDistributionMap >> outerNodeChildren: anElement [
	^(children value: anElement)
		asOrderedCollection
			collect: [ :child | self buildInnerNode: child]	

]

{ #category : #accessing }
HDistributionMap >> property [

	^ property
]

{ #category : #accessing }
HDistributionMap >> property: anObject [

	property := anObject
]
