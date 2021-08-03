Class {
	#name : #HHeatMap,
	#superclass : #HSimpleVisualizationBuilder,
	#instVars : [
		'elements',
		'property',
		'valueMax',
		'valueMin',
		'colorMax',
		'colorMin'
	],
	#category : #'Hierarchical-Examples'
}

{ #category : #'instance creation' }
HHeatMap >> buildElementNode: anElement [
	| elementValue |
	elementValue := (property value: anElement).
	self updateValueRange: elementValue.

	^HHeatMapNode new
		name: anElement name ;
		rawModel: anElement ;
		value: elementValue ;
		yourself
	

]

{ #category : #'instance creation' }
HHeatMap >> buildNodes [
	| allNodes |
	rootNode := HNode new.
	rootNode name: 'Root'.
	allNodes := elements collect: [ :elt | self buildElementNode: elt].
	rootNode addAll: (allNodes sorted: [ :a :b | a level < b level ])
]

{ #category : #accessing }
HHeatMap >> colorMax [

	^ colorMax
]

{ #category : #accessing }
HHeatMap >> colorMax: anObject [

	colorMax := anObject
]

{ #category : #accessing }
HHeatMap >> colorMin [

	^ colorMin
]

{ #category : #accessing }
HHeatMap >> colorMin: anObject [

	colorMin := anObject
]

{ #category : #accessing }
HHeatMap >> elements [

	^ elements
]

{ #category : #accessing }
HHeatMap >> elements: anObject [

	elements := anObject
]

{ #category : #initialization }
HHeatMap >> initialize [ 
	super initialize.
	valueMax := nil.
	valueMin := nil.
	colorMin := Color white.
	colorMax := Color red.
	elements := #().
	property := [ :elt | 0 ]
]

{ #category : #'instance creation' }
HHeatMap >> open [
	self buildNodes.

	self colorPalette: (NSScale linear
		range: {colorMin . colorMax} ;
		domain: {valueMin .valueMax} ;
		yourself ).

	self rootNode: rootNode.

	super open
	
]

{ #category : #accessing }
HHeatMap >> property [

	^ property
]

{ #category : #accessing }
HHeatMap >> property: anObject [

	property := anObject
]

{ #category : #'instance creation' }
HHeatMap >> updateValueRange: aValue [

	valueMin
		ifNil: [ valueMin := aValue ]
		ifNotNil: [ valueMin := valueMin min: aValue ].
	valueMax
		ifNil: [ valueMax := aValue ]
		ifNotNil: [ valueMax := valueMax max: aValue ]
]

{ #category : #accessing }
HHeatMap >> valueMax [

	^ valueMax
]

{ #category : #accessing }
HHeatMap >> valueMin [

	^ valueMin
]
