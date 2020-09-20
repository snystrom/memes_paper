# Downloads data from GEO if not in data directory

rna_link <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE97956&format=file&file=GSE97956%5FgeneFPKMs%5FL3%5F24hr%5F44hr%2Exlsx"
chip_link <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE141738&format=file&file=GSE141738%5Funion%5Fchip%5Fpeaks%5Fannotated%2Ecsv%2Egz"

targets <- list("data/rna_fpkm.xlsx" = rna_link,
                "data/e93_chip_peaks.csv.gz" = chip_link
               )

download_geo <- function(url, destfile){
  curl::curl_download(url, destfile)
  return(destfile)
}

download_missing_data <- function(link, path){
  if (!file.exists(path)) {
    download_geo(link, path)
  } 
}

purrr::iwalk(targets, download_missing_data)


## Copy flyFactorSurvey .meme format file
flyFactorDB <- "data/flyFactorSurveyCleaned.meme" 
if (!file.exists(flyFactorDB)) {
  pkg_flyFactor <- system.file("extdata/flyFactorSurvey_cleaned.meme", package = "memes")
  file.copy(from = ffs, to = flyFactorDB)
}
