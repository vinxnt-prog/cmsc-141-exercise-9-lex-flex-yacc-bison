# Environment Setup for Flex and Bison in WSL 2

This guide covers the complete setup for compiling Lex and Yacc (Flex and Bison) programs from source, managing versions with Git, and resolving common library errors.

## Direction 1: Git Repository Setup

### For an empty repository

If you are starting with a local directory and want to push it to a new, empty GitHub repository, run the following commands in your project directory:

```
git init
git add .
git commit -m "chore: initial commit of laboratory files"
git branch -M main
git remote add origin <your-repository-URL>
git push -u origin main

```

*What this does:* Initializes version control, stages your existing files, creates the first commit, renames the default branch to 'main', links your local folder to GitHub, and uploads your code.

### Cloning this repo

If the repository already exists online and you need to download it to a new machine or directory:

```
git clone <your-repository-URL>
cd <repository-folder-name>

```

*What this does:* Downloads the entire repository and its version history to your local machine and navigates into the project directory.

## Direction 2: Installing Prerequisites

Before building from source, you need standard C compilers, download tools, and the macro processor required by Bison.

```
sudo apt update
sudo apt install build-essential wget m4 -y

```

*What this does:* Updates your package list and installs `gcc`, `make`, `wget` (for downloading files), and `m4` (a prerequisite for Bison).

## Direction 3: Installing Flex (v2.6.4) from Source

```
wget https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz
tar -xvf flex-2.6.4.tar.gz
cd flex-2.6.4
./autogen.sh
./configure
make
sudo make install
cd ..
flex --version

```

*What this does:* Downloads the specific Flex release tarball, extracts it, navigates into the folder, configures the build environment for your system, compiles the source code, and installs the binaries and libraries to your system directories (like `/usr/local/lib`). The final command verifies the installation by displaying the installed version.

## Direction 4: Installing Bison (v3.8.2) from Source

```
wget https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz
tar -xvf bison-3.8.2.tar.gz
cd bison-3.8.2
./configure
make
sudo make install
cd ..
bison --version

```

*What this does:* Downloads the Bison source code from the GNU servers, extracts it, configures, builds, and installs it globally on your system. The final command verifies the installation by displaying the installed version.

## Direction 5: Compiling and Running the Calculator

Once the tools are installed, you can compile the base scanner and parser.

```
bison -d simple_calc.y
flex scanner.lex
gcc lex.yy.c simple_calc.tab.c -lfl -o calc

```

*What this does:*

1. `bison -d` generates the C parser (`simple_calc.tab.c`) and header file (`simple_calc.tab.h`).

2. `flex` generates the C lexer (`lex.yy.c`).

3. `gcc` compiles both C files together, linking the Flex library (`-lfl`), and outputs an executable named `calc`.

## Direction 6: Troubleshooting Shared Library Errors

**Error:**

```
./calc: error while loading shared libraries: libfl.so.2: cannot open shared object file: No such file or directory

```

**Cause:** Because Flex was installed from source, its library (`libfl.so.2`) was placed in `/usr/local/lib`. WSL's dynamic linker does not always check this directory by default, so it fails to find the library when running `./calc`.

**Fix:**
Run the following command to update the system's shared library cache:

```
sudo ldconfig

```

**Alternative Fix (if ldconfig fails):**
Export the library path directly to your current terminal session:

```
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

```

**Final Test:**
Run the calculator with your input file to verify everything works:

```
./calc < calc.in

```

*Expected Output:*
=6
=91
Exitting...