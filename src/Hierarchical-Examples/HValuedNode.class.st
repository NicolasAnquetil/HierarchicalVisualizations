Class {
	#name : #HValuedNode,
	#superclass : #HNode,
	#instVars : [
		'value'
	],
	#category : #'Hierarchical-Examples'
}

{ #category : #accessing }
HValuedNode >> value [
	^ value
]

{ #category : #accessing }
HValuedNode >> value: anObject [

	value := anObject
]
