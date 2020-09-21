
my_plan <- drake_plan(
  
  chip_path = file_in("data/e93_chip_peaks.csv.gz"),
  rna_path = file_in("data/rna_fpkm.xlsx"),
  
  full_rnaseq = readxl::read_excel(rna_path) %>%
    tidyr::pivot_longer(-matches("gene_symbol"), names_to = "time", values_to = "fpkm") %>%
    dplyr::filter(time != "44hr") %>%
    dplyr::mutate(time = dplyr::case_when(time == "L3" ~ "Early",
                                          time == "24hr" ~ "Late")) %>%
    dplyr::rename(symbol = gene_symbol) %>%
    dplyr::group_by(symbol) %>%
    dplyr::filter(max(fpkm) != 0),
  
  filtered_rnaseq = full_rnaseq %>% 
    dplyr::group_by(symbol) %>% 
    dplyr::filter(max(fpkm) > 5) %>% 
    dplyr::select(symbol) %>% 
    unique(),
  
  write_parsed_rna = readr::write_csv(filtered_rnaseq, path = file_out("data/wing_expressed_genes.csv")),
  
  chip_peaks = readr::read_csv(chip_path, col_types = c("chr" = "c",
                                                        "start" = "d",
                                                        "end" = "d",
                                                        "strand" = "c",
                                                        "id" = "c",
                                                        "summit_position" = "d",
                                                        "peak_binding_description" = "c",
                                                        "e93_dependent" = "c",
                                                        "e93_sensitive" = "c",
                                                        "e93_sensitive_behavior" = "c",
                                                        "wildtype_3lw_24apf_behavior" = "c")),
  chip_summits = chip_peaks %>% 
    dplyr::rename("e93_chromatin_response" = "e93_sensitive_behavior") %>% 
    dplyr::filter(!is.na(e93_chromatin_response)) %>% 
    GenomicRanges::GRanges() %>% 
    plyranges::anchor_start() %>% 
    plyranges::mutate(width = 1) %>% 
    plyranges::shift_right(.$summit_position) %>% 
    plyranges::select(id, e93_chromatin_response),
  
  chip_results = chip_summits %>% 
    plyranges::anchor_center() %>% 
    plyranges::mutate(width = 100)
  
  #genome = BSgenome.Dmelanogaster.UCSC.dm3::BSgenome.Dmelanogaster.UCSC.dm3,
  #
  #all_seq = chip_results %>% 
  #  memes::get_sequence(genome),
  #
  #all_dreme_res_full = memes::runDreme(all_seq, control = "shuffle", nmotifs = 3)
  
)
  

