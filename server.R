library(shiny)

server <- function(input, output, session) {
  
  # Step 2: Show dataset description and visualization selection
  observeEvent(input$go_data, {
    dataset <- get(input$dataset)
    
    # Dataset descriptions
    dataset_descriptions <- list(
      "iris" = "The 'iris' dataset contains measurements of sepal and petal dimensions for different species of iris flowers.",
      "mtcars" = "The 'mtcars' dataset contains data on various car attributes like miles per gallon, number of cylinders, horsepower, etc.",
      "ToothGrowth" = "The 'ToothGrowth' dataset contains data on the effect of vitamin C on the growth of teeth in guinea pigs."
    )
    
    # Show modal dialog with dataset description and plot type selection
    showModal(modalDialog(
      title = "Dataset Description and Visualization Selection",
      tags$h4(dataset_descriptions[[input$dataset]]),
      selectInput("plot_type", "Choose a visualization type:", 
                  choices = c("Scatter Plot", "Boxplot", "Statistics")),
      actionButton("next_axes", "Next", class = "btn"),
      easyClose = TRUE,
      footer = NULL
    ))
  })
  
  # Step 3: Choose axes for the plot (in a new modal window)
  observeEvent(input$next_axes, {
    if (input$plot_type == "Statistics") {
      # If "Statistics" is selected, allow selecting a specific variable
      removeModal()  # Remove the description modal
      
      dataset <- get(input$dataset)
      cols <- names(dataset)
      
      # Open the modal for variable selection
      showModal(modalDialog(
        title = "Select Variable for Statistics",
        selectInput("var_select", "Choose a variable:", choices = cols),
        actionButton("show_stats", "Show Stats", class = "btn"),
        easyClose = TRUE,
        footer = NULL
      ))
    } else {
      # If not "Statistics", proceed to choosing the axes for the plot
      removeModal()  # Remove the previous modal window
      
      dataset <- get(input$dataset)
      cols <- names(dataset)
      
      # Open the modal for axis selection
      showModal(modalDialog(
        title = "Select Axes for the Plot",
        selectInput("xvar", "Choose the variable for the X-axis:", choices = cols),
        selectInput("yvar", "Choose the variable for the Y-axis:", choices = cols),
        actionButton("show_plot", "Show Plot", class = "btn"),
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
  
  # Show statistics of the selected variable
  observeEvent(input$show_stats, {
    dataset <- get(input$dataset)
    selected_var <- input$var_select
    
    # Show the statistics for the selected variable
    removeModal()  # Remove the previous modal window
    
    showModal(modalDialog(
      title = paste("Statistics for", selected_var),
      verbatimTextOutput("stats_output"),
      easyClose = TRUE,
      footer = tagList(
        actionButton("close_stats", "Close", class = "btn")
      )
    ))
    
    # Render the statistics for the selected variable
    output$stats_output <- renderPrint({
      summary(dataset[[selected_var]])  # Display summary statistics of the selected variable
    })
  })
  
  # Generate the plot
  observeEvent(input$show_plot, {
    dataset <- get(input$dataset)
    
    # Create plot depending on the selected visualization type
    if (input$plot_type == "Scatter Plot") {
      plot_obj <- function() {
        plot(dataset[[input$xvar]], dataset[[input$yvar]],
             xlab = input$xvar, ylab = input$yvar, 
             main = paste("Scatter Plot of", input$xvar, "vs", input$yvar),
             col = "#A3C8F0", pch = 16, cex = 1.2)
      }
    } else if (input$plot_type == "Boxplot") {
      # If the Y-axis is categorical, move it to the X-axis for horizontal boxplots
      if (is.factor(dataset[[input$yvar]]) || is.character(dataset[[input$yvar]])) {
        plot_obj <- function() {
          boxplot(dataset[[input$xvar]] ~ dataset[[input$yvar]],
                  horizontal = TRUE, 
                  xlab = input$xvar, ylab = input$yvar,
                  main = paste("Boxplot of", input$xvar, "by", input$yvar),
                  col = "#A3C8F0", border = "#4C9CCF", notch = TRUE)
        }
      } else {
        plot_obj <- function() {
          boxplot(dataset[[input$yvar]] ~ dataset[[input$xvar]],
                  xlab = input$xvar, ylab = input$yvar,
                  main = paste("Boxplot of", input$yvar, "by", input$xvar),
                  col = "#A3C8F0", border = "#4C9CCF", notch = TRUE)
        }
      }
    }
    
    # Show plot in a modal window
    showModal(modalDialog(
      title = "Plot",
      plotOutput("plot_output", height = "400px"),
      easyClose = TRUE,
      footer = tagList(
        actionButton("close_plot", "Close", class = "btn")
      )
    ))
    
    # Render the plot in the modal window
    output$plot_output <- renderPlot({
      plot_obj()  # Call the plot function
    })
  })
  
  # Close the plot modal window
  observeEvent(input$close_plot, {
    removeModal()  # Close the modal and return to the main UI
  })
  
  # Close the statistics modal window
  observeEvent(input$close_stats, {
    removeModal()  # Close the statistics modal window
  })
}

# Return the server logic
server
