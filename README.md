# VirtualFCS Library
VirtualFCS is a Modelica library for fuel cell system modelling developed through the EU H2020 research project Virtual-FCS.

[![2023: v2.0.0](https://img.shields.io/badge/Release-2023%3A%20v2.0.0-blue)![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7552220.svg)](https://doi.org/10.5281/zenodo.7552220)
[![OpenModelica v1.20 win64](https://img.shields.io/badge/OpenModelica-v1.20%20win64-blue)](https://openmodelica.org/)

Note that this library might also work with other platforms that win64, but that is not tested during development.

<details>
<summary><b>Citing other library versions</b></summary>

Note that library versions older than v2.0.0 requires OpenModelica v1.14.

|  Released  | Version       | DOI |
|------------|---------------|-----|
| 2023-01-19 | v2.0.0        | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7552220.svg)](https://doi.org/10.5281/zenodo.7552220) |
| 2022-02-16 | v2022.1.0-beta| [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.6104901.svg)](https://doi.org/10.5281/zenodo.6104901) |
| 2021-12-15 | v0.2.1-beta   | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7566040.svg)](https://doi.org/10.5281/zenodo.7566040) |
| 2021-09-22 | v0.2.0-beta   | [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7566037.svg)](https://doi.org/10.5281/zenodo.7566037) |
| 2021-07-01 | v0.1.0-beta   |     |

</details>

## Library Description

The objective of the complete hybrid system model is to reproduce and simulate the dynamic behavior of all the components according to the desired architecture. Depending on the possibilities, degradation mechanisms of the components will be considered in order to predict the performance losses of the entire system.

![picture](img/hydrogen-high-res.jpg)

The model is rather dedicated to transport applications. However, it should remain reliable for other applications. Consequently, the model must considerate dynamics phenomena linked to all applications. The perimeter of the model is limited to hybrid fuel cell system which refers to the fuel cell stack, the battery, and ancillaries. The Figure 2 highlights the system considered in the project. 

![picture](img/VirtualFCS_Model_Scope.png)


## System Requirements and Installation
The VirtualFCS library is designed to work with OpenModelica and supports version 1.20. To install OpenModelica, please visit their website:

[Information about OpenModelica](https://www.openmodelica.org/)<br/>
[Download OpenModelica v1.20 for Windows](https://build.openmodelica.org/omc/builds/windows/releases/1.20/0/)<br/>
[OpenModelica on GitHub](https://github.com/OpenModelica)<br/>

To use the VirtualFCS library, follow these steps:
1. Clone this repository to your computer
2. Open the OpenModelica Connection Editor
3. Open the file VirtualFCS\package.mo
4. The VirtualFCS library will load in the library browser on the left of the Connection Editor

Development and conventions
------------------------

### Workflow
The VirtualFCS library is currently in development by members of the Virtual-FCS project. The project started in 2020 and will continue through 2022. Minor releases are planned every 3 months of the project. Development should always take place on a side branch. Never pull to main. Contributions submitted as [Pull Requests](https://github.com/Virtual-FCS/VirtualFCS/pulls) are welcome. Recommended git comment method for contributors can be found here: [How to Write a Git Commit Message](https://cbea.ms/git-commit/). 

Issues can be reported using the [«Issues](https://github.com/Virtual-FCS/VirtualFCS/issues) button. 

### Naming conventions
Naming conventions are laid out below:

Classes. Classes should be nouns in UpperCamelCase (e.g. FuelCellStack).<br/>
Instance. Instance names should be nouns in lowerCamelCase. An underscore at the end of the name may be used to characterize an upper or lower index (e.g. automotiveStack, pin_a).<br/>
Method. Methods should be verbs in lowerCamelCase (e.g. updateFuelCellStack).<br/>
Variables. Local variables, instance variables, and class variables are also written either as single letters or in lowerCamelCase (e.g. U, cellVoltage).<br/>
Constants. Constants should be written in uppercase characters separated by underscores (e.g. T_REF).<br/>

License
-------
Virtual-FCS is shared under a MIT license. For more information, please see the file LICENSE.

Attributions and credits
------------------------

### Contributors (in alphabetical order)
Amelie Pinard, 		SINTEF Industry, Trondheim, Norway<br/>
Benjamin Synnevåg, 		SINTEF Industry, Trondheim, Norway<br/>
Dr. Loic Vichard, 	UBFC, Belfort, France<br/>
Dr. Mike Gerhardt, 	SINTEF Industry, Trondheim, Norway<br/>
Dr. Nadia Steiner, 	UBFC, Belfort, France<br/>
Dr. Roberto Scipioni, 	SINTEF Industry Trondheim, Norway<br/>
Dr. Simon Clark, 	SINTEF Industry, Trondheim, Norway<br/>
Dr. Yash Raka, 		SINTEF Industry, Trondheim, Norway<br/>

### Projects
- [Virtual-FCS](http://www.virtual-fcs.eu/); Grant Agreement No 875087.

### Acknowledgements
  This code repository is part of a project that has received funding from the Fuel Cells and Hydrogen 2 Joint Undertaking under Grant Agreement No 875087. This Joint Undertaking receives support from the European Union’s Horizon 2020 Research and Innovation programme, Hydrogen Europe and Hydrogen Europe Research.
