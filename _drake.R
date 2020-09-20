library(drake)
library(magrittr)
source("R/get_raw_data.R")
source("R/plan.R")

drake_config(my_plan, verbose = 1L)