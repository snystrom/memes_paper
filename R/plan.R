
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
    GenomicRanges::GRanges() %>% 
    plyranges::anchor_start() %>% 
    plyranges::mutate(width = 1) %>% 
    plyranges::shift_right(.$summit_position) %>% 
    select(id, peak_binding_description, e93_sensitive_behavior)
)
  
