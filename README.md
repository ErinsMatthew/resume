# resume

Generate resume from [source YAML file](matthew.yml).

## Overview

This script will convert a resume formatted as YAML into
various formats.

## Execution

To execute this script, run the following commands once the
dependencies are installed:

```sh
# list possible options and help
$ generate.sh -h

# generate a PDF version of resume.yml and output to current directory
$ generate.sh -d -i resume.yml -f pdf .
```

## Formatters

This script converts the YAML source file to other formats using
"formatters," which are basically scripts that do the actual work.

A formatter lives under the `formatters` directory.  To create a
new formatter, simply create a child directory under `formatters`
with the name of the formatter (e.g., `pdf`) and place a script
named `format.sh` in that child directory.

The `format.sh` script will be passed two arguments: (1) the path
of the input file (e.g., resume.yml) and (2) the path of the
output file (e.g., /tmp/resume.pdf).  How the formatter
converts the input to the output is up to it to determine.

## Dependencies

- `cat` - pre-installed with macOS and most Linux distributions
- `find` - pre-installed with macOS and most Linux distributions
- `realpath` - install via coreutils using [Homebrew](https://formulae.brew.sh/formula/coreutils), another package manager, or [manually](https://www.gnu.org/software/coreutils/).

Formatters may have their own dependencies.

## Platform Support

This script was tested on macOS Monterey (12.6) using GNU Bash 5.2.15,
but should work on any GNU/Linux system that supports the dependencies
above.
