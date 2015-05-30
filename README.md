# Futuregov - Adult Social Care Open Data Project
# Data Cleaning Tool

This tool allows CSV files to be cleaned in preperation for public release as
open data.

It can be used standalone, with the `asc_cleaner` command line program, or as a
library in a larger application.

## Usage

    $ asc_cleaner <council> <dataset> <csvpath>

For example:

    $ asc_cleaner Devon HomeVacancies homevacancies-20150528.csv

Which will use the HomeVacancies configuration for Devon to clean the given CVS
and output it to standard out.
