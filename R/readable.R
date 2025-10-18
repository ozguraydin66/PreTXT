#'Readability tests
#'
#' @description It processes the data frame returned by the make_wordlist() 
#' function and provides readability measurements for the text. The syllable 
#' column in the data frame returned by the make_wordlist() function must 
#' contain values. It also includes readability criteria proposed for Turkish.
#' @param df the data frame returned by the make_wordlist() function.
#' @param returnType Determines whether the data frame to be returned will 
#' be wide or long
#' @return Returns data frame .
#' @examples readable(df=df,returnType='long')
#' @export
readable <- function(df, returnType='long') {
  library(dplyr) 
  library(plyr) 
  WordLength <- ddply(df[[2]],.(LineNum),
                      summarise, 
                      syllable.s = sum(syllable),
                      syl.word_2 =sum(syllable==2),
                      syl.word_3 =sum(syllable==3),
                      syl.word_4 =sum(syllable==4),
                      syl.word_5 =sum(syllable==5),
                      syl.word_6 =sum(syllable>=6),
                      Multi.syllable=sum(syllable>=2))
  WordLength <- ddply(WordLength, .(), summarise, 
                      syllable.t    = sum(syllable.s),
                      syllable.m    = mean(syllable.s),
                      syllable.SD   = sd(syllable.s, na.rm=TRUE), 
                      syl.word_2.m  = mean(syl.word_2),
                      syl.word_2.SD = sd(syl.word_2, na.rm=TRUE),
                      syl.word_3.m  = mean(syl.word_3),
                      syl.word_3.SD = sd(syl.word_3, na.rm=TRUE),
                      syl.word_4.m  = mean(syl.word_4),
                      syl.word_4.SD = sd(syl.word_4, na.rm=TRUE),
                      syl.word_5.m  = mean(syl.word_5),
                      syl.word_5.SD = sd(syl.word_5, na.rm=TRUE),
                      syl.word_6.m  = mean(syl.word_6),
                      syl.word_6.SD = sd(syl.word_6, na.rm=TRUE),
                      syl.Mult.t    = sum(Multi.syllable),
                      syl.Mult.m    = mean(Multi.syllable),
                      syl.Mult.SD   = sd(Multi.syllable, na.rm=TRUE))
  WordLength$SentLength.m=mean(df[[1]]$WordCountinSent, na.rm = TRUE)
  WordLength$SentLength.t=sum(df[[1]]$WordCountinSent, na.rm = TRUE)
  WordLength$SentCount=mean(df[[1]]$SentCount, na.rm = TRUE)
  Calc.w <- WordLength %>%
    mutate(
      Atesman        = 198.825-(40.175*(syllable.t/SentLength.t))-(2.610*(SentLength.t/SentCount)),
      Cetinkaya      = 118.823-(25.987*(syllable.t/SentLength.t))-(0.971*(SentLength.t/SentCount)),
      Bezirci.Yilmaz = sqrt((SentLength.t/SentCount)*((syl.word_3.m*0.84)+
                                                        (syl.word_4.m *1.50)+
                                                        (syl.word_5.m *3.50)+
                                                        (syl.word_6.m *26.25))),
      FRES           = 206.835-1.015*(SentLength.t/SentCount)-84.6*(syllable.t/SentLength.t),
      FKGL           = (0.39*SentLength.m)+(11.8*syllable.m) - 15.59,
      PSK.Edu        = (0.0778*SentLength.m)+(0.455*syllable.t)-2.2029,
      PSK.Age        = (0.778*SentLength.m)+(0.455*syllable.t)+2.7971,
      SMOG           = 3+sqrt(syl.Mult.t),
      SMOG2          = 1.043*sqrt(30*(syl.Mult.t/SentCount))) %>%
    select(c(21:29)
    )
  Calc.l <- as.data.frame(t(Calc.w))
  Calc.l <- cbind(method = rownames(Calc.l), Calc.l)
  Calc.l$method <- rownames(Calc.l); rownames(Calc.l) <- NULL
  colnames(Calc.l)[2] <- "values"
  if(returnType=='long'){Calc=Calc.l}
  if(returnType=='wide'){Calc=Calc.w}   
  return(Calc)
}