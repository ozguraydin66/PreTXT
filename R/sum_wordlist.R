#'Removing duplicates from the word list
#'
#' @description It processes the data frame returned by the make_wordlist() 
#' function and provides readability measurements for the text. The syllable 
#' column in the data frame returned by the make_wordlist() function must 
#' contain values. It also includes readability criteria proposed for Turkish.
#' @param df the data frame returned by the make_wordlist() function.
#' @return Returns data frame .
#' @examples sum_wordlist(df=df)
#' @export
sum_wordlist <- function(df) {
  library(dplyr)
  df= df[[2]] %>% 
    dplyr::select(-LineNum) %>%
    group_by(across(any_of(c('word','WordCount','SentCount','WordLength','OLD20',
                             'ON.hamming','ON.levenshtein',
                             'Bigram.Mean','syllable'))))%>%
    dplyr::summarise(across(c(n), sum)) %>%
    dplyr::arrange(desc(n)) %>%
    dplyr::rename(freq=n)%>%
    as.data.frame()
  return(df)
}