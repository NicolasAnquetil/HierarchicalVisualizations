Class {
	#name : #HPaletteNodeBuilder,
	#superclass : #HNodeBuilder,
	#instVars : [
		'colorPalette'
	],
	#category : #'Hierarchical-Examples'
}

{ #category : #accessing }
HPaletteNodeBuilder >> colorPalette [

	^ colorPalette
]

{ #category : #accessing }
HPaletteNodeBuilder >> colorPalette: anObject [

	colorPalette := anObject
]

{ #category : #'instance creation' }
HPaletteNodeBuilder >> open [
	self build.
	rootNode open
	
]

{ #category : #building }
HPaletteNodeBuilder >> updateNodeColor: node [
	node color: (self colorPalette scale: node value).
	node children do: [ :child| self updateNodeColor: child ].
	
]
