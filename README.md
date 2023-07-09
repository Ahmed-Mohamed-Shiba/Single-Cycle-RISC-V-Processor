# Single_Cycle_RISC_V_Microprocessor

In this project, the famous **32-bit RISCV Processor** has been implemented.  It's a single-cycle microarchitecture RISC-V processor based on Harvard Architecture, which means that it has two separate memories for instruction and data. The single-cycle processor executes an entire instruction in one cycle. In other words, instruction fetch, instruction decode, execute, write back, and program counter update occurs within a single clock cycle. 


## Block Diagram

![Diagram](https://user-images.githubusercontent.com/104662487/222999637-26137c52-6733-47f1-a66f-718b297255e3.JPG)

## Main Modules 
- ALU
> An Arithmetic/Logical Unit (ALU) combines a variety of
mathematical and logical operations into a single unit. For example, a
typical ALU might perform addition, subtraction, magnitude
comparison, AND, and OR operations. The ALU forms the heart of
most computer systems. The 3-bit ALUControl signal specifies the
operation. The ALU generates a 32-bit ALUResult, a Zero flag that
indicates whether ALUResult == 0, and a sign flag that indicates ALU
result sign (ALUResult [31]). Thefollowing table lists the specified
functions that our ALU can perform.
- Program Counter
> To fetch the instructions from the instruction memory, we need a
pointer to keep track of the address of the current instruction for this
task we use the program counter. The program counter is simply a 32-
bit register that has the address of the current instruction at its output
and the address of the next instruction at its input. Firstly, you need to
implement this register and then the logic that calculates the address of
the next instruction. The program counter has four inputs a 32-bit word
which is the next address, the clock signal, asynchronous reset, and a
load signal (always high except for the HLT instruction). And have one
32-bit output PC.
- Instruction Memory
> The instruction memory has a single read port. It takes a 32-bit instruction address input, A, and reads the 32-bit data
(i.e., instruction) from that address onto the read data output, RD. The PC is simply connected to the address input of the instruction
memory. The instruction memory reads out, or fetches, the 32-bit instruction,
labeled Instr. Our instruction memory is a Read Only Memory (ROM) that holds the
program that your CPU will execute. The ROM Memory has width = 32 bits and depth = 64 entries.
- Data Memory
> It has a single read/write port. If its write enable, WE, is asserted, then it writes data WD into address A on the rising edge of the clock. It reads are asynchronous while writes are synchronous to the rising edge of the “clk” signal. The Word width of the data memory is 32-bits to match the datapath width. The data memory contains 64 entries. RD is read with no respect to the clock edge. A is the memory address from which the data are read through the output port RD.
- Sign Extend
> Sign extension simply copies the sign bit (most
significant bit) of a short input (16 bits) into all the
upper bits of the longer output (32 bits).
- Control Unit
> The control unit computes the control signals based on the
opcode and funct3, funct7 fields ofthe instruction, Instr14:12 and
Instr30 respectively. Most of the control information comes from
the opcode, but R-type instructions and I-type instructions also
use the funct3 and funct7 fields to determine the ALU operation.
Thus, we will simplify our design by factoring the control unit
into two blocks of combinational logic, as shown in the figure
below.

![CU](https://user-images.githubusercontent.com/104662487/223000559-24ba8947-3336-4d77-9d7f-d835b274af87.JPG)

- Register File
> The Register File contains the 32-bit registers. The register file has two read output ports (RD1 and RD2) and a single input write port (WD3), RD1 and RD2 are read with no respect to the clock edge. The register file is read asynchronously and written synchronously at the rising edge of the clock. The register file supports simultaneous read and writes. The register file has width = 32 bits and depth = 32 entries supports simultaneous read and writes. The register file has active low asynchronous reset signal. A1 is the register address from which the data are read through the output port RD1. Whereas A2 is corresponding to the register address of output port RD2.

## Testing The Top Module

To validate the success of the written RTL, the processor was tested to generate and store the first ten numbers of the Fibonacci sequence by writing a test bench that loads the instruction memory with the machine code corresponding to the following C code.

```C
#include <iostream>
using namespace std;
int main()
{
  int x = 0; int y = 1; int sel = 1;
  for (int i = 0; i < 10; i++)
  {
    if (sel == 1)
    {
      x = x + y; sel = 2;
      cout << x << endl;
    }
    else
    {
       y = x + y; sel = 1;
      cout << y << endl;
    }
  }
}

```

## Loading the Machine code into the instruction Memory

The machine code was loaded into the instruction memory using the command ``` $readmemh ```. the command was used to load the test program "[FibSeries](https://github.com/Moaz-Helmy/Single_Cycle_RISC_V_Processor/blob/master/Test%20Program/program.txt)" into the instruction memory as follows.
```Verilog
/*loading test program into the instruction memory*/
    initial
	$readmemh ("program.txt", instr, 0);
```
