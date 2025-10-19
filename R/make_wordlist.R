#' Converting text to a word list
#'
#' @description It provides the number of words and sentences in a text and 
#' the number of letters and syllables for each word, the OLD20 value 
#' according to the selected language, and the bigram value in a table..
#' @param text.path The path to the .txt file.
#' @param pgraph Number of paragraphs in the text (excluding the title)
#' @param title logical value indicating whether it is a header (TRUE, FALSE)
#' @param bigram.type Whether the bigram value of the word should be the mean 
#' or the sum value (mean, summed)
#' @param lang The language in which the text is written.Currently only 
#' available for some language's texts. 
#' Parameters: basque,dutch,english,french,german,italian,polish,serbian_cyrillic, 
#' serbian_latin, spanish,turkish,vietnamese
#' @return Returns the input text as a data frame.
#' @examples make_wordlist(text.path='texts/text1.txt',pgraph=2,title=TRUE, 
#'                         bigram.type='mean',lang='turkish')
#' @export
make_wordlist <- function(text.path,pgraph,title=FALSE,bigram.type='mean',lang='turkish'){
  library(dplyr)
  if(title==TRUE){i=0}
  if(title==FALSE & pgraph==1){i=0}
  if(title==FALSE & pgraph>1){i=1}
  text.file=readr::read_lines(text.path, skip=i,skip_empty_rows=T,n_max=pgraph+1)
  text.file = paste(text.file, collapse = " ")
  df <- text.file %>%
    textshape::split_sentence() %>%
    as.data.frame() %>% 
    purrr::pluck(1)
  SentCount = length(df)
  df=dplyr::tibble(line= 1:SentCount,text = df)
  df$WordCountinSent = stringi::stri_count_words(df$text)
  df$SentCount = SentCount
  df$text=stringr::str_replace_all(df$text, "[[:punct:]]", "")
  LineNum=df$line
  Word <-list()
  Sent = df
  for(z in LineNum){
    Word[[z]] = Sent[z,]  %>%
      tidytext::unnest_tokens(word, text) %>%
      dplyr::count(word, sort = TRUE)
    Word[[z]]=as.data.frame(Word[[z]])
    Word[[z]]$LineNum = z
  }
  WordList=dplyr::bind_rows(Word) 
  WordCount=nrow(WordList)
  WordList$WordCount=NA; WordList$WordCount=WordCount
  WordList$SentCount=NA; WordList$SentCount=SentCount
  WordList$WordLength=NA; WordList$WordLength=nchar(WordList$word)
  library(stringdist)
  data(list=lang)
  WordList$OLD20 <- vwr::old20(WordList$word, lexicon[,1])
  WordList$ON.hamming <- vwr::coltheart.N(WordList$word, lexicon[,1],method="hamming")
  WordList$ON.levenshtein <- vwr::coltheart.N(WordList$word, lexicon[,1],method="levenshtein")
  z =strngrams::get_ngram_frequencies(lexicon$V1, lexicon$V3, type = "bigram", position_specific = TRUE)
  newcol = ncol(WordList) +1
  WordList[,newcol] <- strngrams::ngram_frequency(WordList$word, z, type = "bigram",
                                                  position_specific = TRUE,
                                                  frequency = "token",
                                                  func = bigram.type,
                                                  progressbar = TRUE)
  colnames(WordList)[ncol(WordList)] <- "Bigram.Mean"
  WordList$syllable=NA
  if(lang=='turkish'){
    for(i in 1:length(WordList$word)){
      WordList$syllable[i]= tryCatch({
        count_syl(WordList$word[i])
      }, error = function(e) {
        cat("An error occurred:", conditionMessage(e), "\n")
        NA
      })
    }
  }
  return(list(df,WordList))
}
