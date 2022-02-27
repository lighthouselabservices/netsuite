# Data Conversion for Oraclte Netsuite
# server side
# (c) Lighthouse Lab Services 2021

require(shiny)
shinyServer(function(input, output, session) {

  # reactive values
  rvals <- reactiveValues()

  # ---- upload file ----

  observeEvent(input$file_upload, ignoreNULL = T, {
    inFile <- req(input$file_upload)


    # get temp file location
    fl_loc <- inFile$datapath
    file_name <- inFile$name

    # load file
    dt_in <- fread(fl_loc, check.names = T)

    rvals$dt_in <- dt_in
    rvals$file_name <- file_name
  })

  # ----- render input table ----

  output$dt_input <- renderDT({
    dt_in <- req(rvals$dt_in)

    # make datatable
    dat_view <- DT::datatable(dt_in,
      rownames = FALSE, style = "default", class = "display compact", selection = "single", filter = "top",
      options = list(dom = "ipft", deferRender = TRUE, width = "100%", pageLength = 20)
    )
  })

  output$dt_fields <- renderDT({
    dt_in_names <- req(names(rvals$dt_in))
    dt_names <- data.table(Fields = dt_in_names)

    # make datatable
    dat_view <- DT::datatable(dt_names,
      caption = "Input Table Field Names", rownames = FALSE, style = "default", class = "display compact", selection = "single", filter = "top",
      options = list(dom = "ipt", deferRender = TRUE, width = "400px", pageLength = 20)
    )
  })

  # ---- get config ----

  # yaml file for config
  config_yaml <- reactive({
    config_options[input$type]
  })

  # translation configuration object
  config <- reactive({
    req(GetConfig(schema_yaml = req(config_yaml())))
  })

  # view translation configuration if valid
  output$conf <- renderJsonedit({
    listviewer::jsonedit(req(config()), mode = "view")
  })

  # ---- render output table ----

  dt_out <- reactive({
    dt_in <- req(rvals$dt_in)
    conf <- req(config())

    # convert input fields by config
    
    dt_out <- ConvertFields(dt_in, conf$conf)
    
    # post processing for input type if available
    
    if(exists(input$type)){
    PostProcess <- get(input$type)
    dt_out = PostProcess(dt_out, conf$options)
    }
    
    # common post processing
    dt_out <- CommonPostProcessiing(dt_out)

    return(dt_out)
  })

  output$dt_output <- renderDT({
    dt_out <- req(dt_out())

    # make data table
    dat_view <- DT::datatable(dt_out,
      rownames = FALSE, style = "default", class = "display compact", selection = "single", filter = "top",
      options = list(dom = "ipft", deferRender = TRUE, width = "100%", pageLength = 20)
    ) %>% formatStyle(columns = names(dt_out), color = styleEqual("?", "tomato"))
  
    
  })

  # ------ download results -----

  output$download <- downloadHandler(
    filename = function() {
      file_name <- req(rvals$file_name)

      paste0("conversion-", file_name)
    },
    content = function(file) {
      dt <- req(dt_out())

      fwrite(dt, file)
    }
  )
}) # end of server