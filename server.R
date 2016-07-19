library(shiny)
library(shinydashboard)
library(quanteda)
library(data.table)
library(dplyr)

unigrams_fil <- readRDS("unigrams_fil_1c.rds")
bigrams_fil <- readRDS("bigrams_fil_1c.rds")
trigrams_fil <- readRDS("trigrams_fil_1c.rds")
quadgrams_fil <- readRDS("quadgrams_fil_1c.rds")
cincgrams_fil <- readRDS("cincgrams_fil_1c.rds")

process_text <- function(raw_text, pre = TRUE) {
  if (pre == TRUE) {
    proc_text <- paste(c("^", paste(raw_text, collapse = "_"), "_"), 
                       collapse = "")
  } else {
    proc_text <- tail(strsplit(raw_text, "_")[[1]], 1)
  }
  return(proc_text)
}

predict_text <- function(text_r) {
  
  if (is.na(text_r)){
    break 
  }
  
  raw_text <- strsplit(tolower(text_r), " ")[[1]]
  text_len <- min(length(raw_text), 4)
  prediction <- " "
  
  while (text_len > 1) {
    text_pred <- process_text(tail(raw_text, text_len))
    if (text_len == 4) {
      prediction <- process_text(
        cincgrams_fil$ngram[grep(text_pred, cincgrams_fil$ngram)][1], 
        pre = FALSE)
    } else if (text_len == 3) {
      prediction <- process_text(
        quadgrams_fil$ngram[grep(text_pred, quadgrams_fil$ngram)][1], 
        pre = FALSE)
    } else if (text_len == 2) {
      prediction <- process_text(
        trigrams_fil$ngram[grep(text_pred, trigrams_fil$ngram)][1], 
        pre = FALSE)
    }
    
    if (prediction == " " | is.na(prediction)) {
      raw_text <- tail(raw_text, text_len - 1)
      text_len <- length(raw_text)
    } else { break }
  }
  
  if (text_len == 1) {
    text_pred <- process_text(raw_text)
    prediction <- process_text(
      bigrams_fil$ngram[grep(text_pred, bigrams_fil$ngram)][1], 
      pre = FALSE)
    
    if (is.na(prediction)) {
      prediction <- unigrams_fil$ngram[1]
    }
  }
  return(prediction)
}

generate_tweet <- function(tweet) {
  tweet_len <- nchar(tweet)
  result <- tweet
  
  if (is.na(result)){
    break 
  }
  
  if (tweet_len >= 140) {
    result <- "Cannot generate a tweet longer than 140 characters."
  } else {
    
    while (tweet_len < 140) {
      result <- paste(result, predict_text(result))
      tweet_len <- nchar(result)
    }
  }
  
  return(result)
}

shinyServer(function(input, output) {
   
  output$guess_word <- renderText({predict_text(input$user_text)})
  output$fake_tweet <- eventReactive(input$gen_tweet, {
    generate_tweet(input$user_text)
  }) 

})
