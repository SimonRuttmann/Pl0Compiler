# 🧩 Pl0Compiler – A simple educational compiler for the PL/0 language


This is a complete compiler for the **PL/0** programming language, implemented in **C/C++** using **Flex** (lexer) and **Bison** (parser).  

---

## 🎓 Project & Context

**Pl0Compiler** is a lightweight compiler and interpreter for **PL/0**, the minimalist teaching language introduced by Niklaus Wirth in *Compilerbau*.
It supports integer arithmetic, variables, procedures, `if`/`while`, input (`?`), and output (`!`) — ideal for learning the basics of parsing, code generation, and virtual machines.

This compiler was developed as a study project to explore the fundamentals of compiler construction, inspired by the educational PL/0 model originally designed for teaching recursive-descent parsing and compilation.

---

## ⚙️ Features

- **Recursive-descent parser** for PL/0 syntax
- **Symbol table** with support for global and local procedures/variables
- Compiles `.pl0` source files into **assembler (`.asm`)** output
- Supports the **complete PL/0 grammar**. EBNF:
    ```
    program    = block "." .
    
    block      = [ "CONST" ident "=" number { "," ident "=" number } ";" ]
    [ "VAR" ident { "," ident } ";" ]
    { "PROCEDURE" ident ";" block ";" } statement .
    
    statement  = [ ident ":=" expression | "CALL" ident | "?" ident | "!" expression |
    "BEGIN" statement { ";" statement } "END" |
    "IF" condition "THEN" statement |
    "WHILE" condition "DO" statement ] .
    
    condition  = "ODD" expression |
    expression ( "=" | "#" | "<" | "<=" | ">" | ">=" ) expression .
    
    expression = [ "+" | "-" ] term { ( "+" | "-" ) term } .
    
    term       = factor { ( "*" | "/" ) factor } .
    
    factor     = ident | number | "(" expression ")" .
    ```
---

## 🧠 How It Works

1. **Lexing** – Tokenizes the PL/0 input.
2. **Parsing** – Builds the abstract syntax tree (AST).
3. **Symbol Resolution** – Tracks constants, variables, and procedures.
4. **AST Generation** – Creates a abstract syntax tree.
5. **Execution** – A simple interpreter executes the instructions.

---

## 🛠️ Project Structure

```
Pl0Compiler/
├── pl-0.c                                 # Main source file
├── pl-0.l                                 # Flex lexer
├── pl-0.y                                 # Bison parser
├── pl0-symtab.cpp/.h                      # Symbol table for variables and procedures
├── IntermediateCode.cpp/.h                # Implementaion of an abstract syntax tree
├── DebugConsole.cpp/.h                    # Generator of assembler code
├── AssemblerCodeGenrator.cpp/.h           # Generator of assembler code
├── Makefile                               # Build instructions
├── examples/                              # Example programs
└── README.md                              # This file
```

---

## 🚀 Getting Started

### Requirements

- **C or C++ compiler** (e.g., `gcc`, `g++`)
- [`flex`](https://github.com/westes/flex) – lexical analyzer generator
- [`bison`](https://www.gnu.org/software/bison/) – parser generator
- A **Unix-like shell** environment (Linux, macOS, or WSL)

### 🔧 Build

Use the provided `Makefile` to compile the project:

```bash
make
```

This generates an executable named pl-0 in the current directory.

---

## ▶️ Usage

- Input: /path/to/source/myprogram.pl0
- Output: /path/to/source/myprogram.asm

```bash
./pl-0 path/to/myprogram.pl0
```


---

## 🎮 Example

Given `examples/primes.pl0`:

```pl0
const max = 100;
var n;
procedure primes;
begin
  n := 2;
  while n <= max do
  begin
    if odd(n) then ! n;
    n := n + 1
  end
end;
call primes.
```

Compile with:

```bash
./pl-0 examples/primes.pl0
```

This will create a `.asm` file to print prime candidates from 2 to 100 using the `!` operator.

---

## 📜 License

Licensed under the **Apache 2.0 License**.
See [LICENSE](LICENSE) for details — use, modify, and extend freely, with attribution.

---

Happy compiling! 🧠🛠️
