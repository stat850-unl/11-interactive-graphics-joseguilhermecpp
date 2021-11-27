#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Loading packages
library(ggplot2)
library(ggthemes)
library(dplyr)
library(rsconnect)
library(shinyWidgets)

# Get the Data

cocktails <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')

# UI

ui = fluidPage(
    titlePanel("Barman App"),
    setBackgroundColor("ghostwhite"),
    
    sidebarPanel(
        # Menu for drink type
        selectInput(inputId = "drink_type", "Drink", choices = sort(unique(cocktails$drink)))
    ),
    # Plotting the quantity of each ingredient
    mainPanel(
        tabsetPanel(
            tabPanel("Recipe", plotOutput("ingredient"),
            img(src = "barman.png", height = 250, width = 400, style="display: block; margin-left: auto; margin-right: auto;")
        )
    )
    
)
)

# Server

server = function(input, output) {
    # Filtering by drink
    cocktails_subset <- reactive({
        cocktails %>%
            filter(drink == input$drink_type)
    })
    
    # Plotting the ingredients using barchart
    output$ingredient <- renderPlot({
        
        ggplot(data = cocktails_subset(), aes(x = ingredient, y= ingredient_number, fill = ingredient)) + 
            geom_col(alpha=0.3, width= 0.7)+ scale_color_brewer(palette="Dark2") + theme_base()+
            labs(x = "Ingredient ", title = "Drink's Ingredients")
    })
}


shinyApp(ui = ui, server = server)

