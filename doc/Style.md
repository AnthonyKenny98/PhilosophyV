# Style

Documentation (partly for my own benefit) detailing style decisions for the verilog code that makes up this project. These conventions apply to everything within the ```PhilosophyV/src/``` directory.

## Table of Contents
+ [File Naming](#files)
+ [Modules](#Modules)
  + [Definitions](#definitions)
  + [Instances](#instances)
  + [Wires](#wires)
  + [Ports](#ports)
  
## <a name=#files></a> Files
  + Files should be named for the module that they contain.
  + Naming should be in the following style: **fileForModule.v**
  + Header files for a particular module should be named as **fileForModule.h**
  + Header defining constants shared by multiple modules should be named as **constantsForSomething_defines.h**

## <a name=#modules></a> Modules

### <a name=#definitions></a> Module Definitions

Modules should be named in the following style: **exampleModuleA**

Modules should be named for their broadest possible prupose. E.g. **register** (which may be instantiated as REGISTER_FOR_A and REGISTER_FOR_B) rather than **registerForA**.

### <a name=#instances></a> Module Instances

Modules should be instantiated in the following style: **EXAMPLE\_MODULE\_A**

### <a name=#wires></a> Wires

Wires within a module should be named in the following style: **\_wire\_in\_module\_**

### <a name=#ports></a> Ports

Module ports should be named in the following style:
  + **exampleModuleA.portA()**
  + **exampleModuleA.portB()**
  + **exampleModuleA.anotherExamplePort()**
