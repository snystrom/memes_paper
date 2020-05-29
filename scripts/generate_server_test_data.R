library(dremeR)
library(plyranges)
library(magrittr)

link <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE141738&format=file&file=GSE141738%5Funion%5Fchip%5Fpeaks%5Fannotated%2Ecsv%2Egz"
peak_file <- curl::curl_download(link, destfile = here::here("data", "peaks.csv.gz"))

peaks <- readr::read_csv(peak_file) %>%
  GRanges %>%
  anchor_start() %>%
  mutate(width = 1) %>%
  shift_right(mcols(.)$summit_position) %>%
  mutate(width = 100)

dm.genome <- BSgenome.Dmelanogaster.UCSC.dm3::BSgenome.Dmelanogaster.UCSC.dm3

seq_by_behavior <- peaks %>%
  split(mcols(.)$e93_sensitive_behavior) %>% 
  get_sequence(dm.genome)

dir <- here::here("data", "user_benchmarking", "dremer_user_benchmark")
dir.create(dir, showWarnings = F, recursive = T)

seq_by_behavior$Increasing %>% 
  write_fasta(paste(dir, "test_sequences.fa", sep = "/"))

test_sequences <- seq_by_behavior$Increasing
save(test_sequences, file = paste(dir, "test_sequences.rda", sep = "/"))
