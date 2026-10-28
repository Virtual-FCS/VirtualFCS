# VirtualFCS Library

VirtualFCS is an open Modelica library for dynamic modelling of hydrogen and hybrid energy systems. It brings together electrochemical, electrical, fluid, thermal, control, and vehicle models, with examples ranging from PEM fuel cell vehicles to ammonia cracking.

[![Release v3.0.1](https://img.shields.io/badge/Release-v3.0.1-blue)](https://github.com/Virtual-FCS/VirtualFCS/releases/tag/v3.0.1)
[![Documentation](https://img.shields.io/badge/Docs-online-brightgreen)](https://virtual-fcs.github.io/VirtualFCS/)
[![DOI 10.5281/zenodo.6104900](https://zenodo.org/badge/DOI/10.5281/zenodo.6104900.svg)](https://doi.org/10.5281/zenodo.6104900)
[![OpenModelica v1.24 win64](https://img.shields.io/badge/OpenModelica-v1.24%20win64-0f7c8a)](https://openmodelica.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

The library may also work with other versions of OpenModelica and on platforms other than Win64, but these configurations are not routinely tested during development.

<details>
<summary><b>Citing different library versions</b></summary>

Note that library versions older than v2.0.0 requires OpenModelica v1.14.

|  Released  | Version       | DOI |
|------------|---------------|-----|
| 2026-10-28 | v3.0.1        | [![DOI 10.5281/zenodo.23741265](https://zenodo.org/badge/DOI/10.5281/zenodo.23741265.svg)](https://doi.org/10.5281/zenodo.23741265) |
| 2026-10-23 | v3.0.0        | [![DOI 10.5281/zenodo.23604798](https://zenodo.org/badge/DOI/10.5281/zenodo.23604798.svg)](https://doi.org/10.5281/zenodo.23604798) |
| 2023-01-19 | v2.0.0        | [![DOI 10.5281/zenodo.7552220](https://zenodo.org/badge/DOI/10.5281/zenodo.7552220.svg)](https://doi.org/10.5281/zenodo.7552220) |
| 2022-02-16 | v2022.1.0-beta| [![DOI 10.5281/zenodo.6104901](https://zenodo.org/badge/DOI/10.5281/zenodo.6104901.svg)](https://doi.org/10.5281/zenodo.6104901) |
| 2021-12-15 | v0.2.1-beta   | [![DOI 10.5281/zenodo.7566040](https://zenodo.org/badge/DOI/10.5281/zenodo.7566040.svg)](https://doi.org/10.5281/zenodo.7566040) |
| 2021-09-22 | v0.2.0-beta   | [![DOI 10.5281/zenodo.7566037](https://zenodo.org/badge/DOI/10.5281/zenodo.7566037.svg)](https://doi.org/10.5281/zenodo.7566037) |
| 2021-07-01 | v0.1.0-beta   |     |

</details>

## Library Description

The objective of the complete hybrid system model is to reproduce and simulate the dynamic behaviour of all the components according to the desired architecture. Depending on the possibilities, degradation mechanisms of the components will be considered in order to predict the performance losses of the entire system.

![picture](img/hydrogen-high-res.jpg)

Here is the library exemplified with transport application. However, the library is well suited for other applications, such as stationary systems, electrolysers, and ammonia cracking. Under a fuel cell-battery hybrid electric vehicle, and a general layout of its propulsion system can be seen. Example of this application can be found in the library.

![picture](img/VirtualFCS_Model_Scope.png)

### The library contains:

- **Electrochemical systems:** PEM fuel cells and stacks, fuel-cell systems, batteries, and PEM electrolysers.
- **Balance of plant:** hydrogen, air, and cooling subsystems, compressors, humidifiers, heat exchangers, and related controls.
- **System integration:** battery-electric and fuel cell range-extender powertrains.
- **Other applications:** ammonia-cracking system case study, vehicle drive cycles, hardware-, software-, and user-in-the-loop examples.

## System Requirements and Installation
The VirtualFCS library is designed to work with OpenModelica and supports versions from 1.20 to 1.27, and Modelica Standard Library 4.1.0. To install OpenModelica, please visit their website:

[Information about OpenModelica](https://www.openmodelica.org/)<br/>
[Download OpenModelica v1.27 for Windows](https://build.openmodelica.org/omc/builds/windows/releases/1.27/1/)<br/>
[OpenModelica on GitHub](https://github.com/OpenModelica)<br/>

To use the VirtualFCS library, follow these steps:
1. Clone this repository to your computer
2. Open the OpenModelica Connection Editor
3. Open the file VirtualFCS\package.mo
4. The VirtualFCS library will load in the library browser on the left of the Connection Editor

Development and conventions
------------------------

### Workflow
The VirtualFCS library is currently in development by members of BeBoP, SURFER, MiNaMi projects. Development should always take place on a side branch. Never pull to main. Contributions submitted as [Pull Requests](https://github.com/Virtual-FCS/VirtualFCS/pulls) are welcome. Recommended git comment method for contributors can be found here: [How to Write a Git Commit Message](https://cbea.ms/git-commit/). 

Issues can be reported using the [Issues](https://github.com/Virtual-FCS/VirtualFCS/issues) button. 

### Naming conventions
Naming conventions are laid out below:

Classes. Classes should be nouns in UpperCamelCase (e.g. FuelCellStack).<br/>
Instance. Instance names should be nouns in lowerCamelCase. An underscore at the end of the name may be used to characterize an upper or lower index (e.g. automotiveStack, pin_a).<br/>
Method. Methods should be verbs in lowerCamelCase (e.g. updateFuelCellStack).<br/>
Variables. Local variables, instance variables, and class variables are also written either as single letters or in lowerCamelCase (e.g. U, cellVoltage).<br/>
Constants. Constants should be written in uppercase characters separated by underscores (e.g. T_REF).<br/>

License
-------
Virtual-FCS is shared under a MIT license. For more information, please see the [LICENSE file](LICENSE).

Attributions and credits
------------------------

### Contributors (in alphabetical order)
Amelie Pinard, 		SINTEF Industry, Trondheim, Norway<br/>
Benjamin Synnevåg, 		SINTEF Industry, Trondheim, Norway<br/>
Karim Bendioub, SINTEF Industry, Trondheim, Norway<br/>
Dr. Daniel Pérez Clos,	SINTEF Industry, Trondheim, Norway<br/>
Dr. Federico Zenith, 	SINTEF Digital, Trondheim, Norway<br/>
Dr. Loic Vichard, 	UBFC, Belfort, France<br/>
Dr. Mike Gerhardt, 	SINTEF Industry, Trondheim, Norway<br/>
Dr. Nadia Steiner, 	UBFC, Belfort, France<br/>
Dr. Roberto Scipioni, 	SINTEF Industry Trondheim, Norway<br/>
Dr. Simon Clark, 	SINTEF Industry, Trondheim, Norway<br/>
Dr. Yash Raka, 		SINTEF Industry, Trondheim, Norway<br/>

### Projects
- [Virtual-FCS](http://www.virtual-fcs.eu/); Grant Agreement No 875087.
- [BeBoP](https://bebop-hydrogen.eu/); Grant Agreement No 101192365.
- [MiNaMi](https://minami-project.eu/); Grant Agreement No 101250260. 
- [SURFER](https://h2surfer.eu/); Grant Agreement No 101250344. 
- [HYDROGENi](https://hydrogeni.no/); 333118.
- [LowEmission](https://lowemission.no/); 296207.
- [MarTrans](https://martrans.no/); 350371.

### Acknowledgements
  This code repository is part of a project that has received funding from the Clean Hydrogen (formerly Fuel Cells and Hydrogen 2) Joint Undertaking under Grant Agreements No 875087, 101192365, 101250260, and 101250344. This Joint Undertaking receives support from the European Union’s Horizon 2020 Research and Innovation programme, Hydrogen Europe and Hydrogen Europe Research.

This work has been supported by the HYDROGENi Research Centre and the LowEmissionResearch Centre , performed under the Norwegian research program FMETEKN and PETROSENTER. The authors acknowledge the industry partners in HYDROGENi and LowEmissionfor their contributions and the Research Council of Norway. 