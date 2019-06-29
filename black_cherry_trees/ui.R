library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Black Cherry Trees Dataset"),
  h5("This data set provides measurements of the diameter, 
    height and volume of timber in 31 felled black cherry trees. 
    Note that the diameter (in inches) is erroneously labelled Girth 
    in the data. It is measured at 4 ft 6 in above the ground (R datasets)."),
  
  
  sidebarPanel(
    radioButtons("p", "Select scatter plot of Y by X:",
                 list("Volume vs. Height"='a', "Diameter vs. Height"='b')),
    radioButtons("dist", "Select a column to display the histogram:",
              list("Diameter in inches"='a', "Height in feet"='b', "Volume in cubic feet"='c')    ),
    #sliderInput("Height_CI", h6("Confidence Level for CI on Mean Tree Height"), 
    #            min = 80, max = 99, value = 50),
    textOutput("HCI")
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Data Visualization",
      #plots a graph of each column in the trees data
      plotOutput("treeplot"),
      plotOutput("treedist")
      ),
      tabPanel("Data Table",
      #displays a summary of the tree dataset
      dataTableOutput("trees_stats")
      ),
      tabPanel("Volume Bootstrap", numericInput("reps", "Bootstrap Replicates R", 1000),
               sliderInput("bootstrap_ci", "Confidence level for bootstrap interval", min = 80, max = 99, value = 95),
               actionButton("runBoot", "Run Bootstrap for Volume Estimate")
                ,plotOutput("results"), textOutput("resultsText"),
               textOutput("bootCI"))
      
    )
  )
  
))
