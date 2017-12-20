
# Yelp Dataset Challenge.

The goal of this project was to create a word cloud tool for business owners on Yelp, that would enable them to see the most common positive and negative aspects of their business.  Business owners simply enter their Yelp business_id, the R script filters through all the reviews for that business, divides each review into its constituent 4-Grams, performs sentiment analysis on these 4-Grams, and then outputs two word clouds.  One word cloud corresponds to the most common words associated with a positive sentiment, and another word cloud corresponds to the most common words associated with a negative sentiment.  

While I admit that the sentiment analysis is not perfect, and neither are the final word clouds, I think that it is an interesting idea that could be refined and made into an actual tool for business owners. This version is simply a mock-up - it only uses reviews from the first 10,000 rows of the review.csv data. The entire file is over 3 GB, and performing R operations on this data would take far too long. 

## Final Product: (Green == Positive, Red == Negative)
![capture](https://user-images.githubusercontent.com/19980155/34216604-ca16098a-e576-11e7-8407-3cf4af3119ad.PNG)
