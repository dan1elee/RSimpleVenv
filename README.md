# Simple Local Package Environment for R

This creates a "virtualenv" for R that can be easily setup through the command 
line and that works with Rscript (which packrat doesn't (easily?)).

The need for this arose when I wanted to have packages that were needed for a 
project in a local R library folder, much like 
[virtualenv](https://virtualenv.pypa.io/en/latest/) does in Python. After a 
bit of debugging, I created two scripts that together create a dead-simple 
local R library folder.

The script understands CRAN, GitHub, and local packages.

## Usage

Basic usage:

```bash
$ mkdir -p ./rlibs
$ bash R_setup.sh Rpackages.txt ./rlibs
```

where ``Rpackages.txt`` is a file with one package per line, for example:

```text
sparsestep
SyncRNG
github:GjjvdBurg/RGensvm
local:/path/to/local/package
```

A common way to use this is to place the above two lines of bash in a 
Makefile, for instance:

```Makefile

RLIBS=./rlibs

all: setup
        Rscript ./my_R_script.sh

setup:
        mkdir -p $(RLIBS)
        bash R_setup.sh Rpackages.txt $(RLIBS)

```

This would run the R code with the local library directory.

## How it works

The ``R_setup.sh`` creates an ``.Rprofile`` and an ``.Renviron`` file that set 
the local library path to the desired library directory. Any R script that 
runs from this directory therefore loads the packages from this package 
library instead of anywhere else.

## Notes

License: MIT

Author: [Gertjan van den Burg](https://gertjan.dev)

Tested on Linux only, probably works on Mac. PRs welcome for Windows.
