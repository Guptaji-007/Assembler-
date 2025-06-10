# Assembler-
This is an assembler for the HACK machine language, written in OCaml. It supports both A-instructions and C-instructions as per the HACK assembly specification.
Features
Parses HACK assembly language into 16-bit binary machine code

Supports both interactive input via terminal and batch processing of .asm files

Implements a full symbol table with support for labels and predefined symbols

Two-pass assembly: first for symbol resolution, second for code generation

Usage
1. Compile the assembler
sh
Copy
Edit
dune build
2. Run in interactive (terminal) mode
sh
Copy
Edit
dune exec assblr
You can then enter assembly instructions line by line directly in the terminal.

To end input and trigger machine code generation, use Ctrl+D (EOF).

The corresponding machine code will be displayed immediately.

Example:
asm
Copy
Edit
@2
D=A
@3
D=D+A
@0
M=D
3. Run using an input file
You can also provide an input file directly:

sh
Copy
Edit
dune exec assblr test/<filename>.asm
Sample test files are already included in the test/ directory:

pong.asm

max.asm

rect.asm

The assembler will read the .asm file and print the corresponding machine code to standard output.

Directory Structure
python
Copy
Edit
.
├── bin/
│   └── main.ml           # Entry point of the assembler
├── lib/
│   ├── parser.ml         # Parses assembly instructions
│   ├── codegen.ml        # Converts parsed instructions to binary
│   └── symbol_table.ml   # Handles label and variable resolution
├── test/
│   ├── pong.asm
│   ├── max.asm
│   └── rect.asm
├── dune
├── dune-project
└── README.md
