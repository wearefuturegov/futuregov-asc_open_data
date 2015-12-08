# Futuregov - Adult Social Care Open Data Project
# Data Cleaning Tool

This tool allows CSV files to be cleaned in preperation for public release as
open data.

It can be used standalone, with the `asc_cleaner` command line program, or as a
library in a larger application.

## Usage

    $ asc_cleaner <council> <dataset> <csv_path>

For example:

    $ asc_cleaner Devon HomeVacancies homevacancies-20150528.csv

Which will use the HomeVacancies configuration for Devon to clean the given CVS
and output it to standard out.

## Available Dataset Processors

The **dataset** parameter can be one of the following. The supplied CSV file needs
to contain the correct headings (based on the originally-supplied files) for dataset
rules to be applied correctly.

### Devon

* DelayedTransfersOfCare – for "devon_dtoc_*.csv".
* HomeVacancies – for "devon_home_vacancies-*.csv".
* MarketTownCareHomeModel – for "devon_resnurs_model_*.csv".
* MICQCCompliance – for "devon_mi_cqc_compliance-*.csv"
