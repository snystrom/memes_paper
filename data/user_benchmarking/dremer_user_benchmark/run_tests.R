suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(dremeR))
if (!dremeR:::meme_is_installed()) stop("dremeR cannot detect the MEME Suite")
if (!require(benchmarkme)) install.packages("benchmarkme")

dir <- "results/"
dir.create(dir, showWarnings = FALSE)

message("Collecting System Information")

# https://www.kaggle.com/tobikaggle/check-ram-and-cpu-in-r
system_specs <- benchmarkme::get_cpu() %>% 
  as.data.frame %>% 
  dplyr::mutate(ram = benchmarkme::get_ram())

message("Preparing for Benchmarks")

write.csv(system_specs, paste0(dir, "results_system_specs.csv"), row.names = F)

load(file = "test_sequences.rda")
db <- "fly_factor_survey.meme"

dreme_res <- runDreme(test_sequences, "shuffle")

message("Benchmarking runDreme (This may take a while...)")
dreme_time <- microbenchmark::microbenchmark(runDreme(test_sequences, "shuffle"), times = 5)

message("Benchmarking runAme")
ame_time <- microbenchmark::microbenchmark(runAme(test_sequences, "shuffle", database = db), times = 10)

message("Benchmarking runTomTom")
tomtom_time <- microbenchmark::microbenchmark(runTomTom(dreme_res$motif, database = db), times = 10)

message("Compiling Results")

tool_runtime <- list("dreme" = dreme_time,
                     "ame" = ame_time,
                     "tomtom" = tomtom_time
                     ) %>% 
  dplyr::bind_rows(.id = "tool")


tool_runtime %>% 
  write.csv(file = paste0(dir, "results_runtime_info.csv"), row.names = FALSE)

message("Completed Successfully")