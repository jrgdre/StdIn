# StdIn

Goal of the project is to have a unified Pascal interface for reading program
input from StdIn, independent of:

- OS
- If it is interactive keyboard input or a redirected file input

Especially under MS-Windows the is a difference between those. But usually we 
are only interested in the input data and not in where they come from.

## Build

Should be easy to compile from any Pascal environment.
Developed using FPC and Visual Studio Code with the OmniPascal extension.

Debugger under MS-Windows is msys64\\mingw64\\bin\\gdb.exe
