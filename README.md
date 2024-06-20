# MDCS mosaic dataset config scripts

Example of a script that uses Esri MDCS for the creation and configuration of nested mosaic datasets with multidimensional raster datasets (Dec 2023).

If you are not sure what this is for, have a look at my [description here](https://bird70.github.io/ask-the-data/2023/12/19/Scripting-Mosaic-Datasets-The-Esri-multidimensional-data-model.html)

## Prerequisites

You'll have to have the [Esri's Mosaic Dataset Configuration Scripts](https://github.com/esri/mdcs-py) installed first.

## Output

The aim of this setup is to generate a File Geodatabase (Enterprise SDE GDB connections can be used too), with a 'master' or 'parent' Mosaic dataset that references all rasters that you have added.

It will also allow you to search for individual rasters, using attributes in the databases, which are created according to the name of raster files.

Interactively running the process would require hundreds of clicks in ArcGIS Pro, which would be very tedious and error-prone.
