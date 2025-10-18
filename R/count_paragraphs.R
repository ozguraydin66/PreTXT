#'Number of paragraphs in the text
#'
#' @description This script finds the number of paragraphs in the text file 
#' located at the given path..
#' @param text.path The path of the .txt file.
#' @param title logical value indicating whether it is a header (TRUE,FALSE)
#' @return Returns the input text as number.
#' @examples count_paragraphs(text.path='texts/text1.txt', title=TRUE)
#' @export
count_paragraphs <- function(text.path, title=TRUE){
  if(title==TRUE) {i=1}
  if(title==FALSE){i=0}
  text=readr::read_lines(text.path,skip=i,skip_empty_rows=F)
  if (length(text) > 1) text <- paste(text, collapse = "\n")
  text <- gsub("\r\n", "\n", text)
  text <- gsub("\r", "\n", text)
  parts <- unlist(strsplit(text, "\\n[ \\t\\f]*\\n+"))
  parts <- trimws(parts)
  parts <- parts[nzchar(parts)]
  parLen=length(parts)
  return(parLen)
}
