Class {
	#name : #HHeatMap,
	#superclass : #HPaletteNodeBuilder,
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

{ #category : #building }
HHeatMap >> build [
	| allNodes |
	rootNode := HNode new.
	allNodes := elements collect: [ :elt | self buildElementNode: elt].

	colorPalette := (NSScale linear
		range: {colorMin . colorMax} ;
		domain: {valueMin .valueMax} ;
		yourself ).

	allNodes do: [ :node | self updateNodeColor: node ].
	rootNode addAll: (allNodes sorted: [ :a :b | a value < b value ]).
	
]

{ #category : #building }
HHeatMap >> buildElementNode: anElement [
	| elementValue |
	elementValue := (property value: anElement).
	self updateValueRange: elementValue.

	^HValuedNode new
		name: anElement name ;
		rawModel: anElement ;
		value: elementValue ;
		yourself
	

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

{ #category : #accessing }
HHeatMap >> property [

	^ property
]

{ #category : #accessing }
HHeatMap >> property: anObject [

	property := anObject
]

{ #category : #building }
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
