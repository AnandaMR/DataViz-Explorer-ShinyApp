library(shiny)

# Available datasets
data_choices <- c("mtcars", "iris", "ToothGrowth")

# Dataset descriptions
dataset_descriptions <- list(
  mtcars = "The 'mtcars' dataset contains data on various car attributes like miles per gallon, number of cylinders, horsepower, etc.",
  iris = "The 'iris' dataset contains measurements of the sepal and petal length and width for three species of iris flowers.",
  ToothGrowth = "The 'ToothGrowth' dataset contains data on the effect of vitamin C on the growth of teeth in guinea pigs."
)

ui <- fluidPage(
  # Custom pastel colors and consistent font style
  tags$head(
    tags$style(HTML("
      body {
        background-color: #F0F8FF;
        font-family: 'Verdana', sans-serif;
        color: #333333;
      }
      .container-fluid {
        background-color: #FFF8F0;
      }
      .navbar {
        background-color: #A3C8F0;
      }
      .sidebar-panel {
        background-color: #B3D9F0;
      }
      h1, h4 {
        color: #4C9CCF;
      }
      .btn {
        background-color: #A3C8F0;
        border-color: #A3C8F0;
      }
      .btn:hover {
        background-color: #4C9CCF;
        border-color: #4C9CCF;
      }
      .modal-content {
        background-color: #F9F9F9;
      }
      .modal-header {
        background-color: #A3C8F0;
        color: #fff;
      }
      .modal-footer {
        background-color: #F0F8FF;
      }
    "))
  ),
  
  # Title panel for the app
  titlePanel("Data Explorer"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      # Dropdown menu for dataset selection
      selectInput("dataset", "Choose a dataset:", choices = data_choices),
      
      # Button to move to the next step
      actionButton("go_data", "Next", class = "btn"),
      
      # Help text to guide the user
      p("Select a dataset from the dropdown to explore different variables. Click 'Next' to view the details of the chosen dataset."),
      br(),
      # Dynamic description for the dataset selected
      uiOutput("dataset_description")
    ),
    
    # Main panel to show outputs based on user input
    mainPanel(
      # Placeholder for dynamic content in step 2 (dataset details)
      uiOutput("step2")
    )
  )
)

# Return the UI object for use in the app
ui
