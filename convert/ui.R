# Data conversion for Oracle Netsuite
# (c) Lighthouse Lab services 2021

library(shiny)
library(bs4Dash)
library(shinyWidgets)
library(jsonlite)
library(stringr)
library(DT)
library(listviewer)

library(fresh)
library(shinybusy)

# modify theme

this_theme = create_theme(
  
  # dashboard settings
  
  bs4dash_vars(
    navbar_light_color = "#bec5cb",
    navbar_light_active_color = "#FFF",
    navbar_light_hover_color = "#FFF",
    
    # colors
    navy = "#002642",
    indigo = "#005fa3", # custom blue
    primary = '#00a9f4',
    success = '#28b78d',
    info = '#00a9f4',
    # change font
    
    font_family_sans_serif =  "'Roboto Condensed', 'Roboto', sans-serif"
  )
  

)

shinyUI(bs4DashPage( 
  
  freshTheme = this_theme,
  
  # ---- header ----
  
  header = bs4DashNavbar(
    title = dashboardBrand("Netsuite Convert", color = 'indigo', href = 'https://www.lighthouselabservices.com'),
    div(class="lead mr-3 ", "Convert Data for Netsuite"), 
    compact =F,
    # status = 'info',
    fixed = F
    
  ),
  
  # ---- footer ----
  
  footer = bs4DashFooter(left = str_glue('(c) Lighthouse Lab Services {format(Sys.Date(), "%Y")}'), right = conf$contact, fixed = TRUE),
  
  
  # ---- left bar ----
  sidebar = bs4DashSidebar(
    disable = T,
    elevation = 0,
    skin = "light",
    status = "secondary",
    expand_on_hover=T,
    width = 400
  ),
  
  # ---- BODY ----
  
  body = bs4DashBody(
    
    # shiny busy bar
    add_busy_bar(color = "#ffc107"),
    
    # ---- top row ----
    
    fluidRow( class='px-3 d-flex justify-content-start', style="font-family: 'Roboto Condensed', 'Roboto', sans-serif;",
              
              div(
                pickerInput(
                  inputId = "type",
                  label = "Conversion Type", 
                  choices = names(config_options),
                  options = list(
                    style = "btn-primary",
                    title = "Select Conversion Type"
                    )
                )
                
              ),
              
              
              div( class = 'ml-3', style="font-size:12pt; ",       
                   fileInput('file_upload', 'Upload Copper CRM File for Conversion (CSV ONLY)', width = 600,
                             accept = c(
                               'text/csv',
                               'text/comma-separated-values',
                               '.csv'
                             ))
              ),
              
              div(class = 'ml-3 d-flex justify-content-end align-items-center', downloadBttn ('download', style = 'simple', size = 'md', color = 'primary'))
              
              
    ),
    
    # ---- tab row ----
    
    fluidRow(
      
      # tabs 
      
      tabBox( 
        width = 12, 
        side ='right',
        id = "result_body",
        title = "Conversion",
        selected = "Input Table",
        status = "secondary",
        solidHeader = F,
        type = "tabs",
        collapsible = F,
        
        
        tabPanel(
          
          title = "Input Table",
          
          # input table
          div(class="p-3", style="font-size:10pt; font-family: 'Roboto Condensed', 'Roboto', sans-serif;",
              DT::dataTableOutput("dt_input")
          )
        ),
        
        tabPanel(
          
          title = "Input Table Fields",
          
          # input table Columns
          div(class="p-3", style="font-size:10pt; font-family: 'Roboto Condensed', 'Roboto', sans-serif;",
              DT::dataTableOutput("dt_fields")
          )
          
          
        ),
        
        tabPanel(
          title = "Conversion Config",
          div( jsoneditOutput('conf', width = "100%", height = "600px") )
          
        ),
        
        tabPanel(
          title = "Output Table",
          
          # output table
          div(class="p-3", style="font-size:10pt; font-family: 'Roboto Condensed', 'Roboto', sans-serif;",
              DT::dataTableOutput("dt_output")
          )
          
        )

      )
      
      
    )
    
    
  ) 
)
)