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

	self colorPalette domain: allProperties asOrderedCollection.
	outerNodes do: [ :node | self updateNodeColor: node ].

	rootNode := HNode new.
	rootNode addAll: (self orderOuterNodes: outerNodes)
]

{ #category : #rendering }
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
HDistributionMap >> buildNodes: aCollection [
	| innerNodes |

	allProperties := Set new.
	innerNodes := Dictionary new: elements size.

	elements do: [ :elt |
		innerNodes at: elt put: (self innerNodeFor: elt)].

	^aCollection collect: [ :elt |
			HNode new
				name: elt name ;
				rawModel: elt ;
				addAll: (self orderInnerNodes: (innerNodes at: elt)) ;
				yourself]
]

{ #category : #rendering }
HDistributionMap >> buildOuterNode: anElement withChildren: childrenNodes [
	^HNode new
		name: anElement name ;
		rawModel: anElement ;
		children: (self orderInnerNodes: childrenNodes) ;
		yourself
	

]

{ #category : #accessing }
HDistributionMap >> childrenBlock: aBlock [
	childrenBlock := aBlock
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

{ #category : #rendering }
HDistributionMap >> innerNodeFor: anElement [
	^(childrenBlock value: anElement)
		asOrderedCollection
			collect: [ :child | self buildInnerNode: child]	

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

{ #category : #accessing }
HDistributionMap >> propertyBlock [

	^ propertyBlock
]

{ #category : #accessing }
HDistributionMap >> propertyBlock: anObject [

	propertyBlock := anObject
]
