#' Data Frame içindeki Kelimeler için Dilsel Metrikleri Hesaplama
#'
#' @param df_input The main data frame containing the words..
#' @param word_col The name of the column containing the words (as a string, e.g., "word").
#' @param lang The language to be used for the dictionary (e.g., 'turkish').
#' @param bigram.type Calculation type ('mean' or 'summed').
#' @export

compute_orth <- function(df_input, word_col, lang='turkish', bigram.type='mean') {
  
  library(dplyr)
  library(vwr)
  library(strngrams)
  
  WordList <- df_input
  target_words <- WordList[[word_col]]
  WordList$WordLength <- nchar(as.character(target_words))
  
    message("The dictionary is loading and metrics are being calculated....")
    data(list = lang) 
    message("-> OLD20, Hamming and Levenshtein are being calculated....")
    WordList$OLD20 <- vwr::old20(target_words, lexicon[,1])
    WordList$ON.hamming <- vwr::coltheart.N(target_words, lexicon[,1], method="hamming")
    WordList$ON.levenshtein <- vwr::coltheart.N(target_words, lexicon[,1], method="levenshtein")
    
    message("-> Bigrams are being calculated...")
    z_bigram <- strngrams::get_ngram_frequencies(lexicon$V1, lexicon$V3, type = "bigram", position_specific = TRUE)
    WordList$Bigram.Mean <- strngrams::ngram_frequency(
      target_words, z_bigram, type = "bigram",
      position_specific = TRUE, frequency = "token",
      func = bigram.type, progressbar = TRUE
    )
    
    message("-> Trigrams are being calculated...")
    z_trigram <- strngrams::get_ngram_frequencies(lexicon$V1, lexicon$V3, type = "trigram", position_specific = TRUE)
    WordList$Trigram.Mean <- strngrams::ngram_frequency(
      target_words, z_trigram, type = "trigram",
      position_specific = TRUE, frequency = "token",
      func = bigram.type, progressbar = TRUE
    )

  if(lang == 'turkish'){
    message("-> Syllable counts are being calculated...")
    # count_syl fonksiyonunun yüklü olduğu varsayılmıştır
    WordList$syllable <- sapply(target_words, function(x) {
      tryCatch({ count_syl(as.character(x)) }, error = function(e) { NA })
    })
  }
  
  message("Process completed.")
  return(WordList)
}