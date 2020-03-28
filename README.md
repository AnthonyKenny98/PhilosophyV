# Philosophy V :book:
>A RISC-V Processor implemented in Verilog 

*Philosophy IV*, written in 1903 by [Mr. Owen Wister of the Class of 1882](https://en.wikipedia.org/wiki/Owen_Wister), recounts the antics of two Harvard students and their last minute attempts to study (or avoid studying) for an exam for which they are hopelessly unprepared. Similarly, this repository holds my last minute attempt to build a RISC-V processor for my [Senior Thesis](https://github.com/AnthonyKenny98/Thesis), a task for which I am unsure of my preparedness.
As such, I name my processor Philosphy V; both in reference to the RISC-V ISA for which it is designed, and to the fact that my current situation seems much like a sequel to Mr. Wister's novel.

**Philosophy V** implements the RV32I Base ISA (defined in the [RISC-V Instruction Set Manual](isa/riscv-spec-20191213.pdf).

![Core Diagram](https://github.com/AnthonyKenny98/PhilosophyV/blob/master/doc/PhilosophyV_Core-Core.png)

## Table of Contents
+ [Repository Structure](#structure)
+ [Testing Methodology](#testing)
+ [Built With](#builtwith)
+ [License](#license)

## <a name=structure></a>Repository Structure
  ```
  PhilosophyV/
      |
      |_assembler/                // Contains files neccesary for converting RISCV asm
      |                           // files to binary, to be loaded into core instruction
      |                           // memory
      |
      |_isa/                      // Contains documentation regarding the RISCV ISA
      |
      |_philosophy_v_001/         // The Vivado project directory. The project references
      |                           //    the external module files in src/
      |
      |_scripts/                  // Contains scripts for creating certain files
      |
      |_src/
      |   |_philv_core/           // Contains src code for the Philosphy V Core
      |   |_test/
      |   |    |_assembly_tests/  // Full processor testing by running .asm files
      |   |    |_module_tb/       // Module test benches
  ```
  
## <a name=testing></a>Testing Methodology
Tests are run on a module by module basis under the [simulation function](https://www.xilinx.com/products/design-tools/vivado/simulator.html) in Vivado. Test benches (```module_tb.v```) that test a certain module as a Unit Under Test (UUT) import test stimulus and expected results from a test vector file (```module.tv```). A python script for creating large test vectors has also been provided. See [TestingMethodology.md](doc/TestingMethodology.md) for a step by step example of testing an 8 bit adder.


## <a name=builtwith></a>Built With
This project is built using Xilinx's [Vivado Design Suite](https://www.xilinx.com/products/design-tools/vivado.html).

## <a name=license></a>License
This project is licensed under the MIT License.  See the [LICENSE](LICENSE) file for more information.
