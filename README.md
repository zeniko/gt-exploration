GtExploration for Processing Abstractions
=========================================
A transpiler for the [Processing](https://processing.org/) programming language implemented for [Glamorous Toolkit](https://gtoolkit.com/) to be used for teaching programming and computer architecture using the [Processing Abstractions](https://github.com/zeniko/processing-abstractions) materials.

Developed as part of a [thesis](https://github.com/zeniko/gyminf-thesis) at [Software Engineering Group at UniBE](https://seg.inf.unibe.ch/).

## Installation

```st
Metacello new
	repository: 'github://zeniko/gt-exploration:thesis/src';
	baseline: 'GtExploration';
	load
```

## Load Lepiter

After installing with Metacello, you will be able to execute

```
#BaselineOfGtExploration asClass loadLepiter
```
