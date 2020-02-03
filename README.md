# Philosophy V :book:
>A RISC-V Processor implemented in Verilog 

*Philosophy IV*, written in 1903 by [Mr. Owen Wister of the Class of 1882](https://en.wikipedia.org/wiki/Owen_Wister), recounts the antics of two Harvard students and their last minute attempts to study (or avoid studying) for an exam for which they are hopelessly unprepared. Similarly, this repository holds my last minute attempt to build a RISC-V processor for my Senior Thesis, a task for which I am unsure of my preparedness.
As such, I name my processor Philosphy V; both in reference to the RISC-V ISA for which it is designed, and to the fact that my current situation seems much like a sequel to Mr. Wister's novell.

## Table of Contents
+ [Repository Structure](#structure)
+ [Testing Methodology](#testing)
+ [Built With](#builtwith)
+ [License](#license)

## <a name=#structure></a>Repository Structure
  ```
  PhilosophyV/
      |
      |_isa/                    // Contains documentation regarding the RISCV ISA
      |
      |_philosophyv_001/        // The Vivado project directory. The project references
      |                         //    the external module files in src/
      |
      |_scripts/                // Contains scripts for creating certain files
      |
      |_src/
      |   |_modules             // Contains src code for verilog modules
      |   |_modules_tb          // Contains src code for verilod test benches
  ```
  
## <a name=#testing></a>Testing Methodology
Tests are run on a module by module basis under the simulation function in Vivado.

## <a name=#builtwith></a>Built With
This project is built using Xilinx's [Vivado Design Suite](https://www.xilinx.com/products/design-tools/vivado.html)

## <a name=#license></a>License
This project is licensed under the MIT License.  See the [LICENSE](LICENSE) file for more information.
