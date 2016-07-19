library(shiny)
library(shinydashboard)

dashboardPage(skin = "blue",
  dashboardHeader(title = "DSS Capstone Project - Predictive Text App", 
                  titleWidth = 450),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(width = 4,
        box(
          title = "About",
          p("This application was developed as the Capstone Project for the Data 
            Science Specialization developed by Coursera and John Hopkin's 
            University. It tries to predict -using the Stupid Backoff algorithm- 
            the next word the user will input, based on the phrase 
            or word previously imputed."), 
          br(),
          p(  
            "As an extra, the application includes a fake tweet generator. This
            also uses the previous user input but instead of predicting a word,
            it generates a ~140 characters sentence using the same algorithm."),
          width = NULL,
          collapsible = TRUE
          )     
      ),
      column(width = 4, 
        box(
          title = "Enter your text here",
          width = NULL, status = "primary",
          textInput("user_text", 
                    NULL, 
                    value = "")
        ),
        box(
          title = "Next word prediction",
          width = NULL, status = "success",
          verbatimTextOutput("guess_word"),
          color = "black"
          )
      ),
      column(width = 4,
        box(
          title = "Generate a fake tweet",
          width = NULL, status = "danger",
          verbatimTextOutput("fake_tweet"),
          actionButton("gen_tweet", "Generate!")
          )
      )
  )
))
