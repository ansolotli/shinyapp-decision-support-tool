library(shiny)
library(shinydashboard)




# Header
header <- dashboardHeader(title = "BONUS BLUEWEBS decision support tool", titleWidth = 450)

# Manually links menuItems to the corresponding tabItems that would otherwise be unlinked
convertMenuItem <- function(mi,tabName) {
  mi$children[[1]]$attribs['data-toggle']="tab"
  mi$children[[1]]$attribs['data-value'] = tabName
  mi
}


# Sidebar
sidebar <- dashboardSidebar(
  sidebarMenu(
    
    convertMenuItem(
      menuItem("About", tabName = "about"), tabName = "about"),
    convertMenuItem(
      menuItem("Predicted time series", tabName = "predicted",
               
               # Create the dropdowns of scenario options
               selectInput(inputId = 'F',
                           label = "Fishery Policy Scenario", 
                           choices = c("Sustainable" = "Sus", "Pelagics-Focused" = "Pel", "Open Access" = "OA"), 
                           selected = "Sus"
               ),
               
               selectInput(inputId = 'Nutr_scen', 
                           label = "Nutrient Loading Policy",
                           choices = c("Baltic Sea Action Plan" = "BSAP", "Average 1995-2002" = "Ref"),
                           selected = "BSAP"
               ),
               
               selectInput(inputId = 'Climate', 
                           label = "Climate Change Scenario - Representative Concentration Pathways",
                           choices = c("RCP4.5", "RCP8.5"), 
                           selected = "RCP4.5"
               ),
               
               # Create the two colums of checkbox groups (biomass and catch)
               fluidRow(
                 column(width = 5,
                        checkboxGroupInput(inputId = "bioVars", 
                                           label = "Biomass Variables",
                                           choiceNames = list("Cod SSB", "Herring SSB", "Sprat SSB", "Zooplankton SSB", "Phytoplankton SSB"),
                                           choiceValues = list("plotCod", "plotHer", "plotSpr", "plotZoo", "plotPhy"),
                                           selected = "plotCod")
                 ),
                 
                 column(width = 6, offset = 1,
                        checkboxGroupInput(inputId = "catchVars", 
                                           label = "Catch Size Variables",
                                           choiceNames = list("Cod Catch", "Herring Catch", "Sprat Catch"),
                                           choiceValues = list("plotCodCatch","plotHerCatch","plotSprCatch"), 
                                           selected = "plotCodCatch")
                 )
               )
      ), tabName = "predicted"),
    
    
    convertMenuItem(
      menuItem("Novelty", tabName = "novelty",
               # Create the dropdowns of scenario options
               selectInput(inputId = 'Nutr_scen_nov', 
                           label = "Nutrient Loading Policy",
                           choices = c("Baltic Sea Action Plan" = "BSAP", "Average 1995-2002" = "Ref"),
                           selected = "BSAP"
               ),
               
               selectInput(inputId = 'Climate_nov', 
                           label = "Climate Change Scenario - Representative Concentration Pathways",
                           choices = c("RCP4.5", "RCP8.5"), 
                           selected = "RCP4.5"
               ),
               
               # Create the column of checkbox groups (codRV, temp_MarchMay050, temp_Aug060, notHypoxic)
               fluidRow(
                 column(width = 12,
                        checkboxGroupInput(inputId = "novelVars", 
                                           label = "Novelty variables",
                                           choiceNames = list("Cod reproductive volume", "Water temperature 0-50m March-May", 
                                                              "Water temperature 0-60m August", "Inverse hypoxic area"),
                                           choiceValues = list("plotRv", "plotTemp1", "plotTemp2", "plotHyp"),
                                           selected = "plotRv")
                 )
               )
      ), tabName = "novelty"),
    
    convertMenuItem(
      menuItem("Optimize", tabName = "optimize"), tabName = "optimize")
  )
)

# Body
body <- dashboardBody(
  tabItems(
    tabItem("about",
            titlePanel("About the decision support tool"),
            htmlOutput("aboutText"), width = 10,
            box(width = 12,
                imageOutput("DSS", height = "auto")
            )),
    
    tabItem("predicted",
            titlePanel("Explore the predicted biomasses and catches in different management scenarios"),
            fluidRow(
              splitLayout(cellWidths = c("50%", "50%"), uiOutput("bio_plot_list"), uiOutput("catch_plot_list"))
            )
    ),
    tabItem("novelty",
            titlePanel("Explore the uncertainty of model forecasts under novel conditions"),
            htmlOutput("novel_info"), 
            uiOutput("novel_plot_list")
    ),
    tabItem("optimize",
            titlePanel("Explore the predictions for ecosystem services in different scenarios")
    )
  )
)

# Create the UI 
ui <- dashboardPage(header, sidebar, body, skin = "black") #skin determines the colour of the dashboard