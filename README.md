# HierarchicalVisualizations

[![CI/Pharo9](https://github.com/ObjectProfile/HierarchicalVisualizations/actions/workflows/runTests.yml/badge.svg)](https://github.com/ObjectProfile/HierarchicalVisualizations/actions/workflows/runTests.yml)[![CI/Moose9](https://github.com/ObjectProfile/HierarchicalVisualizations/actions/workflows/runOnMoose.yml/badge.svg)](https://github.com/ObjectProfile/HierarchicalVisualizations/actions/workflows/runOnMoose.yml)

This project provide a small API to build hierarchical visualization using the [Pharo](http://pharo.org) programming language. HierarchicalVisualizations uses [Roassal](https://github.com/ObjectProfile/Roassal3).

### Install

Execute the following code snippet in a Playground:

```Smalltalk
[ Metacello new
    baseline: 'HierarchicalVisualizations';
    repository: 'github://ObjectProfile/HierarchicalVisualizations:main';
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ]
```

### Example
Consider the following code snippet:
```Smalltalk
node1 := HNode new name: 'Node1'.
node2 := HNode new name: 'Node2'.
subnode1 := HNode new name: 'Sub1'.
subnode2 := HNode new name: 'Sub2'.
subnode3 := HNode new name: 'Sub3'.
subnode4 := HNode new name: 'Sub4'.

node1 addAll: {subnode1. subnode2}.
node2 addAll: {subnode3. subnode4}.
	
rootNode := HNode new name: 'Root'.
rootNode addAll: { node1. node2 }.
subnode3 dependenciesToNodes: { subnode1. subnode2 }.

rootNode open.

```

The code above defines four nodes in total, structured as a hierarchy. Executing the code should shows:
<img width="800" alt="portfolio_view" src="https://raw.githubusercontent.com/ObjectProfile/HierarchicalVisualizations/main/scripts/simpleExample.png">

Node can be collapsed or expanded:

<img width="500" alt="portfolio_view" src="https://raw.githubusercontent.com/ObjectProfile/HierarchicalVisualizations/main/scripts/simpleExample02.png">

New menu items can be defined by creating a subclass of `HAbstractMenuItem`. The package [`Hierarchical-Roassal3-Menu`](https://github.com/ObjectProfile/HierarchicalVisualizations/tree/main/src/Hierarchical-Roassal3-Menu) contains many examples on how to define a new menu item.

# Extensions

## Heat Map

An example of a Heat map extension for a Famix `model`. "Intensity" of `fanout` is indicated in red:

```Smalltalk
HHeatMap new
	elements: model allModelClasses ;
	colorMin: (Color fromHexString: #FFF0F0) ;  "VERY PALE red, default is white"
	colorMax: Color red ;   "this is the default anyway"
	property: [ :clazz | clazz fanOut ] ;
	open.
```

## Distribution Map

An example of a DistributionMap for a Famix `model`. There are four categories according to the number of methods in the class (less than 5, 6 to 10, 11 to 25, more than 25). Categories are colored according to a red/gray map (`RSColorPalette diverging rdgy4`) :

```Smalltalk
HDistributionMap new
	elements: model allModelPackages ;
	childrenBlock: [ :pckg | pckg allClasses ] ;
	propertyBlock: [ :clazz | 
		{ 0 -> (0 to: 5) .
		 1 -> (6 to: 10) .
		 2 -> (11 to: 25) .
		 3 -> (26 to: 999999) }
		 detect: [ :cat | cat value includes: (clazz numberOfMethods) ] ] ;
	colorMap: RSColorPalette diverging rdgy4 ;
	open.
```
