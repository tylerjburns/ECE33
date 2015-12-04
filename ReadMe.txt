
The installation directory contains two executables:
8085 assembler Asm85 (version 1.0f) and 
8085 simulator Sim85 (version 1.0e-L).

To run Asm85:

1. Create the assembly file with an extension asm (say, example1.asm)
2. Open a command window (Start -> Accessories -> Command Prompt).
3. Type 
   asm85 example1
   to assemble file example1.asm.
4. Assembler would report the number of errors in assembly.
5. A file example1.lst will show the line-by-line assembly of the program.
6. If there are no syntax errors, a file example1.hex will be created.
   Proceed to simulation with Sim85.
7. In case of syntax errors, the .lst file will identify the lines with errors.
   Edit the assembly file appropriately to fix errors and reassemble.
8. Running the assembler with command
   asm85 /help
   will show a help screen showing various options.

To run Sim85:

1. Choose the program sim85 from the start menu (or double click on a
   shortcut you may have created.)
2. Load the code example1.hex
3. Open views of code, register or memory as appropriate.
4. You can run the code by hitting the RUN button in the console,
   or step through the code one instruction at a time by using STEP button,
   or change the speed of execution by the JOG button.
5. The light in the console window shows the status of the simulator:
   red light means that the simulator is stopped.
   green light means that the simulator is running.
   yellow light means that the simulator is jogging.
   blue light means that the simulator is waiting for user input.
6. You can set breakpoints in the code by double clicking on the
   left of a code line in the code window. You may set as many 
   breakpoints as needed.  A breakpoint can be removed by double 
   clicking on it.  Program in run mode will stop when it reaches a 
   breakpoint.
7. The program will end automatically when it returns the control to 
   the CP/M operating system.  The console window shows you the
   number of instructions and clocks used by the program as well as
   the maximum stack used.

  
