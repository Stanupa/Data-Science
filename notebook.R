#Install needed libraries.
install.packages("tm")
install.packages("ngram")
install.packages("plyr")
install.packages("wordcloud")

#Load needed libraries.
library(tm)
library(SentimentAnalysis)
library(ngram)
library(plyr)
library(wordcloud)
library(qdapDictionaries)

#Read in first 10000 rows of the Yelp Reviews Data.
setwd("C:/Users/Matthew Brown/Desktop/School Work/CSE 160/Yelp Dataset")
data <- read.csv("review.csv", header = TRUE, nrows = 10000, stringsAsFactors = FALSE)
words <- read.table("stopwords.txt", sep="\n")
data$text <- tolower(data$text)

#Ask the user to input their business ID so that we can look at reviews specific to that business.
businessID <- readline(prompt="Please enter your Yelp business ID.")
businessID

#Subset data frame with only reviews for the specific business. 
reviews <- data[data$business_id == businessID,]

#For each review in the business-specific data frame, calculate its sentiment and record it.

ngramsDF <- data.frame(ngrams = character(), sentiment = character(), stringsAsFactors = FALSE)

  for (i in 1:nrow(reviews)) {
    reviews[i,"text"] <- removeWords(reviews[i,"text"], words[,1])
    reviews[i,"text"] <- gsub("\\s+"," ",reviews[i,"text"])
    reviews[i,"text"] <- gsub(",","",reviews[i,"text"])
    reviews[i,"text"] <- gsub("!+","",reviews[i,"text"])
    reviews[i,"text"] <- gsub("[.]","",reviews[i,"text"])
    ngrams <- ngram_asweka(reviews[i,"text"],min=4,max=4)
    sentiments <- convertToDirection(analyzeSentiment(ngrams)$SentimentQDAP)
    ngramsDF <- rbind(ngramsDF, data.frame(ngrams,sentiments, stringsAsFactors = FALSE))
  }

#Removes neutral sentiment ngrams.
ngramsDF <- subset(ngramsDF, sentiments != "neutral")

#Replaces column of ngrams with a column containing a list of the 4 words
ngramsDF$wordList <- strsplit(ngramsDF$ngrams," ")
ngramsDF$ngrams <- NULL

#Creates empty vectors for wordlists
posWordList <- character()
negWordList <- character()

#Adds the appropriate words to each of the lists
posWordList <- c(posWordList, subset(ngramsDF, sentiments == "positive")$wordList, recursive = TRUE)
negWordList <- c(negWordList, subset(ngramsDF, sentiments == "negative")$wordList, recursive = TRUE)

#Remove more useless words from the list of words.
posWordsToRemove <- readLines("wordRemove.txt")
negWordsToRemove <- readLines("wordRemove.txt")

posWordList <- posWordList[!posWordList %in% posWordsToRemove]
negWordList <- negWordList[!negWordList %in% negWordsToRemove]

#Count Positive words
posWordFreq <- count(posWordList)
negWordFreq <- count(negWordList)

#Formatting to match word cloud generation.
colnames(posWordFreq)[1] <- "word"
colnames(negWordFreq)[1] <- "word"

#Clean out non-words in positive cloud.
is.word <- function(x) x %in% GradyAugmented
for(i in 1:nrow(posWordFreq))
{
  if(is.word(posWordFreq$word[i])==FALSE)
  {
    posWordFreq$freq[i]<-0
  }
}

#Clean out non-words in negative cloud.
for(i in 1:nrow(negWordFreq))
{
  if(is.word(negWordFreq$word[i])==FALSE)
  {
    negWordFreq$freq[i]<-0
  }
}

#Positive Cloud With Title
layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, "What People Like About Your Business")
wordcloud(words = posWordFreq$word, freq = posWordFreq$freq, min.freq = 15,
          max.words=40, random.order=TRUE, rot.per=0.35,
          colors="green3")

#Negative Cloud With Title
layout(matrix(c(1, 2), nrow=2), heights=c(1, 4))
par(mar=rep(0, 4))
plot.new()
text(x=0.5, y=0.5, "Things Your Customers Don't Like")
wordcloud(words = negWordFreq$word, freq = negWordFreq$freq, min.freq = 6,
          max.words=50, random.order=TRUE, rot.per=0.35, 
          colors="firebrick")


