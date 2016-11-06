---
title: "readme"
author: "Colin Odden"
date: "November 6, 2016"
output: html_document
---

# Manifest
This project comprises five files:

1. readme.md - this file
2. codebook.md
3. run_analysis.R
4. data_merged.txt
5. data_collapsed.txt

## run_analysis.R
Operating on the source data:

1. Applies variable labels for all variables;
2. Merges, via appending, the fully-labeled 'test' and 'train' data sets and saves the result as an interim file;
3. Subsets to only include means and standard deviations of each measure,
4. Summarizes the data in #3 by taking the mean of each mean/standard deviation, for each Subject X Activity (thus, means are not column means but rather means across SubjXAct)
5. Saves this data as "data_collapsed.txt"

## data_merged.txt
Produced by run_analysis.R

This is a merging of the 'test' and 'train' data.
'test' and 'train' are merged via appending rows (long vs wide)
The merged data have activity labels applied.
Values unaltered from the UCI source.

## data_collapsed.txt
Produced by run_analysis.R
Contains the mean, for each subjectXactivity pair, of each indicator in data_merged.
Thus, this is a summarization of all indicators in data_merged.
