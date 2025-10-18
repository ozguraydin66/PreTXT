#'Text similarity tests
#'
#' @description Identifies similarities between two texts written in txt format.Provides Jaccard Similarity and Cousine Similarity values.
#' @param text.paths The paths to the .txt files.You should combine the variables one by one using c() to form vectors. eg., c(tex1.path,tex2.path)
#' @param pgraphs Number of paragraphs in the texts (excluding the title).You should combine the variables one by one using c() to form vectors. eg., c(3,2)
#' @param titles logical value indicating whether they are headers. You should combine the variables one by one using c() to form vectors. eg., c(TRUE,FALSE)
#' @return Returns the input texts as a data frame.
#' @examples txt_similarity(text.paths=c(text.path='texts/text1.txt', 
#' text.path='texts/text1.txt'), pgraph=c(2,3),titles=c(TRUE,FALSE))
#' @export
txtSimilarity <- function(text.paths,pgraphs,titles=c(FALSE,FALSE)) {
  library(dplyr)
  text.file <-list() 
  for(z in 1:2){
    if(titles[z]==TRUE){i=0}
    if(titles[z]==FALSE & pgraphs[z]==1){i=0}
    if(titles[z]==FALSE & pgraphs[z]>1){i=1}
    text.file[[z]]=readr::read_lines(text.paths[z],
                                     skip = i,
                                     skip_empty_rows = T,
                                     n_max = pgraphs[z]+1)
    text.file[[z]] <- paste(text.file[[z]], collapse = " ")
    text.file[[z]] <- tm::removePunctuation(text.file[[z]])
  }
  JScore = textTinyR::JACCARD_DICE(strsplit(text.file[[1]], "\\s+"),
                                   strsplit(text.file[[2]], "\\s+"), 
                                   method = 'jaccard', threads = 1)
  CScore = textTinyR::cosine_distance(text.file[[1]],
                                      text.file[[2]], split_separator= " ")
  results= data.frame(
    Tests = c('Jaccard similarity','Cousine similarity'), 
    Scores = c(JScore,CScore))
  return(results)
}
