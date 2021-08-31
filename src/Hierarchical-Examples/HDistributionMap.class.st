Class {
	#name : #HDistributionMap,
	#superclass : #HPaletteNodeBuilder,
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
	| outerNodes |
	outerNodes := self buildNodes: elements.
	self colorNodes: outerNodes.

	rootNode := HNode new.
	rootNode addAll: (self orderOuterNodes: outerNodes)
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
HDistributionMap >> buildNodes: aCollection [
	allProperties := Set new.
	^aCollection collect: [ :elt |
			HNode new
				name: elt name ;
				rawModel: elt ;
				addAll: (self orderInnerNodes: (self innerNodesFor: elt)) ;
				yourself]
]

{ #category : #accessing }
HDistributionMap >> childrenBlock: aBlock [
	childrenBlock := aBlock
]

{ #category : #accessing }
HDistributionMap >> colorMap [

	^ self colorPalette
]

{ #category : #accessing }
HDistributionMap >> colorMap: anObject [

	self colorPalette: anObject
]

{ #category : #building }
HDistributionMap >> colorNodes: outerNodes [

	self colorPalette domain: allProperties asOrderedCollection.
	outerNodes do: [ :outerNode | 
		outerNode children do: [ :innerNode | 
			self updateNodeColor: innerNode ] ]
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
