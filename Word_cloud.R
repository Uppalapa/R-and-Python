## ============================================================================
## BASIC TEXT MINING
## ============================================================================
## bnary packages:

Needed <- c("tm", "SnowballCC", "RColorBrewer", "ggplot2", "wordcloud", "biclust", "cluster", "igraph", "fpc")
install.packages(Needed, dependencies=TRUE)

install.packages("Rcampdf", repos = "http://datacube.wu.ac.at/", type = "source")

cname <- file.path("C:\\Users\\sravy\\Desktop\\texts")   
cname   
dir(cname)

## Load the R package for text mining and then load your texts into R.
library(tm)   
docs <- Corpus(DirSource(cname))   
summary(docs)

##Preprocessing
docs <- tm_map(docs, removePunctuation)
for(j in seq(docs))   
{   
  docs[[j]] <- gsub("/", " ", docs[[j]])   
  docs[[j]] <- gsub("@", " ", docs[[j]])   
  docs[[j]] <- gsub("\\|", " ", docs[[j]])   
} 

#removing numbers
docs <- tm_map(docs, removeNumbers) 

#converting lowercase
docs <- tm_map(docs, tolower) 

#removing stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))

#removing particular words
docs <- tm_map(docs, removeWords, c("department", "email"))

#combining words that should stay together
for (j in seq(docs))
{
  docs[[j]] <- gsub("Peloponnesian War", "PW", docs[[j]])
  docs[[j]] <- gsub("World War I", "WWI", docs[[j]])
  docs[[j]] <- gsub("World War II", "WWII", docs[[j]])
}

library(SnowballC)   
docs <- tm_map(docs, stemDocument) 

## Stripping unnecesary whitespace from your documents:
docs <- tm_map(docs, stripWhitespace) 
docs <- tm_map(docs, PlainTextDocument)

##staging the data
dtm <- DocumentTermMatrix(docs)   
dtm  
##inspecting the document term matrix
inspect(dtm[1:2, 1:20]) 
dim(dtm)

#transpose of the matrix
tdm <- TermDocumentMatrix(docs)   
tdm 

## Organize terms by their frequency:
freq <- colSums(as.matrix(dtm))   
length(freq)  
ord <- order(freq)

##Export the matrix to Excel:   
m <- as.matrix(dtm)   
dim(m)   
write.csv(m, file="dtm.csv") 
mt <- as.matrix(tdm)   
dim(mt)   
write.csv(mt, file="tdm.csv")

#  Start by removing sparse terms:   
dtms <- removeSparseTerms(dtm, 0.1)

## Word Frequency
freq[head(ord)] 
freq[tail(ord)] 

## Check out the frequency of frequencies.
head(table(freq), 20)
tail(table(freq), 20) 

## For a less, fine-grained look at term freqency we can view a table of the terms we selected when we removed sparse terms, above. (Look just under the word "Focus".)
freq <- colSums(as.matrix(dtms))   
freq   

freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)   
head(freq, 14) 
## An alternate view of term frequency:
##  This will identify all terms that appear frequently (in this case, 50 or more times).
findFreqTerms(dtm, lowfreq=50)
## another way to do this:
wf <- data.frame(word=names(freq), freq=freq)   
head(wf)  

## Plot Word Frequencies

## Plot words that appear at least 250 times.
library(ggplot2)   
p <- ggplot(subset(wf, freq>250), aes(word, freq))    
p <- p + geom_bar(stat="identity")   
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))   
p 

#generating word cloud
library(wordcloud)   

##Plot words that occur at least 250 times.
set.seed(142)   
wordcloud(names(freq), freq, min.freq=250)  

## Note: The "set.seed() function just makes the configuration of the layout of the clouds consistent each time you plot them. You can omit that part if you are not concerned with preserving a particular layout.

## Plot the 100 most frequently used words.
set.seed(142)   
wordcloud(names(freq), freq, max.words=100) 

##Add some color and plot words occurring at least 250 times.
set.seed(142)   
wordcloud(names(freq), freq, min.freq=250, scale=c(5, .1), colors=brewer.pal(6, "Dark2"))   

##Plot the 100 most frequently occurring words.
set.seed(142)   
dark2 <- brewer.pal(6, "Dark2")   
wordcloud(names(freq), freq, max.words=100, rot.per=0.2, colors=dark2) 

