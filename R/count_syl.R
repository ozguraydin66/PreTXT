#'Number of syllables in the word
#'
#' @description This script finds the number of syllable in any word 
#' @param word A vector includes words.
#' @return Returns the input word as number.
#' @examples count_syl(c('masa','arkadaş','ağaç'))
#' @export
count_syl <- function(words) {
  vowels_pattern <- "[aeıioöuüAEIİOÖUÜ]"
  vapply(words, function(w) {
    if (is.na(w) || nchar(w) == 0) return(0L)
    pos <- gregexpr(vowels_pattern, w, perl = TRUE)[[1]]
    if (identical(pos, -1L)) 0L else length(pos)
  }, integer(1))
}

#' Find syllables in any word
#'
#' @description This script finds the syllables in any word 
#' @param word A vector includes words.
#' @return Returns the input word as syllabified word.
#' @examples syllabify_naive(c('masa','arkadaş','ağaç'))
#' @export
syllabify_naive <- function(word) {
  if (is.na(word) || nchar(word) == 0) return(character(0))
  pattern <- "(?i)([^aeıioöuü]*[aeıioöuü]+[^aeıioöuü]*)"
  m <- gregexpr(pattern, word, perl = TRUE)[[1]]
  if (identical(m, -1L)) return(character(0))
  regmatches(word, gregexpr(pattern, word, perl = TRUE))[[1]]
}