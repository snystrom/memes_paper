library(drake)
library(magrittr)
library(GenomicRanges)
library(memes)
source("R/get_raw_data.R")
source("R/plan.R")

drake_config(my_plan, verbose = 1L)