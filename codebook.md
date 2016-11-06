---
title: "readme"
author: "Colin Odden"
date: "November 6, 2016"
output: html_document
---

# Manifest
Project contents are as follows
## run_analysis.R
Operates on the source data:
* applies variable labels for all variables,
* merges, via appending, the fully-labeled 'test' and 'train' data sets,
* subsets to only include means and standard deviations of each measure,
* saves this data as "data_big.txt",
* summarizes the data comprising "data_big.txt" by taking mean of each mean/standard deviation,
      for each Subject X Activity (thus, means are not column means but rather means across SubjXAct)
* saves this data as "data_tidy.txt"

## data_big.txt
Produced by run_analysis.R
This is a merging of the 'test' and 'train' data.
'test' and 'train' are merged via appending rows (long vs wide)
The merged data have activity labels applied.
Origial data can be recoered - values are 100% unaltered.

## data_tidy.txt
Produced by run_analysis.R
Contains the mean, for each subjectXactivity pair, of each indicator in data_big.
Thus, this is a summarization of all indicators in data_big.
