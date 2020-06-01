library(shiny)

my_ui <- navbarPage(
  "website title",
  tabPanel(
    "tab name",
    titlePanel("page title"),
    sidebarLayout(
      sidebarPanel(
        "title of sidebar panel",
        checkboxGroupInput(inputId = "variable",
                           label = "Variables to show:",
                           choices = 
                             c("Cylinders" = "cyl",
                               "Transmission" = "am",
                               "Gears" = "gear"),
                           selected = "cyl")
      ),
      mainPanel(
        "title",
        tableOutput("data")
      )
    )
  )
)

my_server <- function(input, output) {
  output$data <- renderTable({
    mtcars[, c("mpg", input$variable), drop = FALSE]
  }, rownames = TRUE)
}

shinyApp(ui = my_ui, server = my_server)
