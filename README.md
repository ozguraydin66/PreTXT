
![Logo](https://github.com/ozguraydin66/PreTXT/blob/main/documents/pretxt.png?raw=true)

    
# PreTXT

PreTXT is an open-source R project. This package allows you to perform various operations on text.

- Calculate the readability score of the text.
- Determine the similarity between two texts.
- Number of words in the text and list of words.
- Count and list the number of sentences in the text.
- Determine the length of the letters in the words.
- Determine the number of syllables in each word.
- Determine the OLD20 values of the words.
- Determine the bigram values of the words.
- Determine the ON values of the words.

Citation

To cite arfima in publications use:

Özer Esmehan, Acar Sema, Artuvanlı Hazal, Temeltürk Duygu & Aydın Özgür (2025). Okuma Becerisinin Klinik Değerlendirmesinde Kullanılacak Metinlerin Niceliksel Özellikleri: Bir Metin Analiz Aracı Önerisi, Pamukkale Üniversitesi Eğitim Fakültesi Dergisi.

Support

This tool was developed under TÜBİTAK 1001 project number 122K308.  

Author and copyright holders

Özgür Aydın (aut, cre), ozguraydin66@gmail.com 
Esmehan Özer (cph), R.Duygu Temeltürk (cph), Hazal Artuvanlı (cph), Sema Acar (cph)


## How to use
Instalation
```javascript
library(devtools)
install_github("ozguraydin66/PreTXT")
```
Word list functions

The count_paragraphs() function can be used to determine the number of paragraphs in the text located at the ‘text.path’ path
```javascript
library(PreTXT)
text.path <- file.path(rootdir, "texts/text_1.txt") 
pnum <- count_paragraphs(text.path, TRUE)
```
The make_wordlist() function (a) lists the number and list of words, (b) the number and list of sentences, (c) the letter lengths of words, (d) the syllable lengths of words, (e) the OLD20 values of words, (f) the bigram values of words, (g) and the ON values of words in the text file with the *.txt extension located at the ‘text.path’ path.
```javascript
wlist.type <- make_wordlist(text.path,
                          pgraph= pnum,
                          title =TRUE,
                          bigram.type='mean',
                          lang='turkish', 
                          orth=TRUE)

```
This function returns the text list class. wlist.type[[1]] lists the sentences and their properties.
wlist.type[[2]] lists the words and their properties. This list is in ‘type’ format, meaning that all the words are listed.

text.path: Path to the .txt file

title: Whether the text has a title. TRUE, FALSE

bigram.type: summed or mean

lang: For the language variable, you can use the following: basque, dutch, english, french, german, italian, polish, serbian_cyrillic, serbian_latin, spanish, turkish, vietnamese.

orth: TRUE for orthographic measurements (OLD20, ON, bigram).

The sum_wordlist() function lists the tokens returned by the make_wordlist() function as a type list. In other words, it displays the words from the text on a single line and provides frequency information.
```javascript
wlist.token=sum_wordlist(wlist .type)
```
The txtSimilarity() function uses the Jaccard and Cousine similarity methods to calculate the similarity between two texts.
```javascript
text.path.1 <- file.path(rootdir, "texts/text_1.txt")
text.path.2 <- file.path(rootdir, "texts/text_2.txt")

pnum.1=count_paragraphs(text.path.1, TRUE)
pnum.2=count_paragraphs(text.path.2, TRUE)

txtSimilarity(text.paths=c(text.path=text.path.1, text.path=text.path.2), 
              pgraph=c(pnum.1, pnum. 2), titles=c(TRUE, FALSE))
```
The 'readable()' function calculates the readability of the text using different formulas based on the type list returned by the 'make_wordlist()' function. For Turkish text, it uses the Ateşman (1997), Bezirci & Yılmaz (2010) and Çetinkaya (2010, 2018 )formulas. Readability cannot be calculated for languages other than Turkish at this time.
```javascript
readable(wlist.type, ‘long’)
readable(wlist.type, 'wide')

```
## References

Ateşman, E. (1997). Türkçede okunabilirliğin ölçülmesi. Ankara Üniversitesi Türkçe ve Yabancı Dil Uygulama ve Araştırma Merkezi Dil Dergisi, 58, 171-174. 

Bezirci, B. ve Yılmaz, A. E. (2010). Metinlerin okunabilirliğinin ölçülmesi üzerine bir yazilim kütüphanesi ve Türkçe için yeni bir okunabilirlik ölçütü. Dokuz Eylül Üniversitesi Mühendislik Fakültesi Fen ve Mühendislik Dergisi, 12(3), 49-62.

Çetinkaya, G. (2010). Türkçe metinlerin okunabilirlik düzeylerinin tanımlanması ve sınıflandırılması [Identifying and classifying the readability levels of the Turkish texts] (Tez Numarası: 265580) [Doktora tezi, Ankara Üniversitesi]. Yükseköğretim Kurulu Ulusal Tez Merkezi.

Çetinkaya, G. ve Uzun, L. (2018). Türkçe ders kitaplarındaki metinlerin okunabilirlik özellikleri. H. Ülper (Ed.), Türkçe ders kitabı çözümlemeleri (4, 141-153) içinde.  Pegem Akademi.

Özer Esmehan, Acar Sema, Artuvanlı Hazal, Temeltürk Duygu & Aydın Özgür (2025). Okuma Becerisinin Klinik Değerlendirmesinde Kullanılacak Metinlerin Niceliksel Özellikleri: Bir Metin Analiz Aracı Önerisi, Pamukkale Üniversitesi Eğitim Fakültesi Dergisi.


  