# HACK Assembler (OCaml)

This is an assembler for the HACK machine language, written in OCaml. It supports both A-instructions and C-instructions as per the HACK assembly specification.
Features

## 🛠 Features

- Translates `.asm` files into HACK 16-bit binary machine code
- Supports interactive input and file-based input
- Handles labels and predefined symbols
- Two-pass architecture for symbol resolution and code generation

---

## 🚀 How to Run
- dune exec assblr test/<filename>.asm
- Sample test files are provided in the test/ directory:
pong.asm
max.asm
rect.asm


### 🧪 Interactive Mode (Terminal Input)

You can write assembly instructions directly into the terminal.

```bash
dune exec assblr

Enter instructions line by line.

Use Ctrl+D to signal EOF and generate the machine code.

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

The machine code will be printed after pressing Ctrl+D.
