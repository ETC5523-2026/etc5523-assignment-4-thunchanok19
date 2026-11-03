library(shiny)
library(ggplot2)

rentals <- vicrental::rentals

ui <- bslib::page_navbar(
  title = "Victorian rents by suburb",
  theme = bslib::bs_theme(
    bootswatch = "minty",
    heading_font = bslib::font_google("Inter"),
    "headings-font-weight" = 500
  ),

bslib::nav_panel(
  "About",
  bslib::card(
    h3("Who is this for?"),
    p("People renting, or planning to rent, in Victoria who want to understand
       how rents differ across suburbs and over time, and what they can afford."),
    h3("Question this app answers"),
    p("How have rents changed across suburbs over time, which suburbs are the
       most or least expensive, and where can I afford to live?"),
    h3("How to use it"),
    tags$ul(
      tags$li(tags$b("Compare suburbs:"), " choose up to 3 suburbs, a property
               type and a number of bedrooms to compare median rent over time.
               Hover over the lines for values."),
      tags$li(tags$b("Top 10 rankings:"), " choose a year, quarter, property
               type and number of bedrooms, then show up to 10 of the most or
               least expensive suburbs."),
      tags$li(tags$b("Affordability:"), " set a weekly budget, property type,
               number of bedrooms and how many recent quarters to average over.
               Click a column header to sort.")
    ),
    h3("What the fields mean"),
    tags$ul(
      tags$li(tags$b("Median rent:"), " the middle weekly rent of new rental
               agreements in that suburb and quarter."),
      tags$li(tags$b("New lettings:"), " the number of new rental agreements
               signed in that quarter."),
      tags$li(tags$b("Suburb:"), " a suburb or a group of suburbs, such as
               Carlton-Parkville."),
      tags$li(tags$b("Region:"), " the area group the suburb belongs to.")
    ),
    p(class = "text-muted",
      paste0("Data: DFFH Rental Report, ", min(rentals$year), " to ",
             max(rentals$year), ". Rents are for new lettings only, not
             existing tenants."))
  )
),
  bslib::nav_panel(
    "Compare suburbs",
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
    selectizeInput("suburbs", "Suburbs (choose up to 3)",
                   choices = sort(unique(rentals$suburb)),
                   selected = c("Fitzroy", "Carlton North"),
                   multiple = TRUE,
                   options = list(maxItems = 3)),
    selectInput("type", "Property type",
                choices = sort(unique(rentals$property_type)),
                selected = "Flat"),
    selectInput("beds", "Bedrooms",
                choices = sort(unique(rentals$no_of_bedroom)),
                selected = 2)
  ),
  plotly::plotlyOutput("rent_plot", height = "500px"), 
  bslib::card(
      bslib::card_header("How to read this"),
      p("Each line shows the median weekly rent of new lettings by quarter. 
      A line that is shorter than the others means that suburb has no reported data for the missing quarter. 
      Hover over a line to see the median rent and number of new lettings for each quarter and year.")
        )
)
),
bslib::nav_panel(
  "Top 10 rankings",
  bslib::layout_sidebar(
    sidebar = bslib::sidebar(
      selectInput("rank_year", "Select a year",
                  choices = sort(unique(rentals$year), decreasing = TRUE)),
      selectInput("rank_quarter", "Select a quarter",
                  choices = levels(rentals$quarter), selected = "Q1"),
      selectInput("rank_type", "Select a property type",
                  choices = sort(unique(rentals$property_type)),
                  selected = "Flat"),
      selectInput("rank_beds", "Select number of bedrooms",
                  choices = sort(unique(rentals$no_of_bedroom)),
                  selected = 1),
      sliderInput("rank_n", "Number of suburbs", min = 3, max = 10,
                  value = 10, step = 1),
      radioButtons("rank_dir", "Ranking from",
                   choices = c("Most expensive" = "high",
                               "Least expensive" = "low"))
    ),
    plotly::plotlyOutput("rank_plot", height = "500px"),
    bslib::card(
  bslib::card_header("How to read this"),
  p("Bars show the median weekly rent in the chosen quarter. The top bar is
     the most expensive suburb when ranking from most expensive, or the
     least expensive when ranking from least expensive. Colour shows the
     region, so you can see whether expensive or cheap suburbs cluster in
     one area. Hover over a bar to see the number of new lettings: a rent
     based on few lettings is less reliable.")
)
)
),
bslib::nav_panel(
    "Affordability",
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        sliderInput("budget", "Weekly rent budget", min = 100, max = 1000,
                    value = 400, step = 10, pre = "$"),
        selectInput("aff_type", "Property type",
                    choices = sort(unique(rentals$property_type)),
                    selected = "Flat"),
        selectInput("aff_beds", "Bedrooms",
                    choices = sort(unique(rentals$no_of_bedroom)),
                    selected = 2),
        selectInput("aff_q", "Period to use",
                    choices = c("Latest quarter" = 1,
                                "Last 2 quarters" = 2,
                                "Last 4 quarters" = 4),
                    selected = 4)
      ),
      textOutput("afford_msg"),
      reactable::reactableOutput("afford_table"),
      bslib::card(
  bslib::card_header("How to read this"),
  p("The table lists suburbs whose average rent is at or below your weekly
         budget. Rent is the average of the quarterly median rents over the
         chosen period, so it is an approximation rather than an exact median.
         Lettings show the average number of new rental agreements per
         quarter, and suburbs with few quarters of data are less reliable.")
)
)
)
)

server <- function(input, output, session) {
  summary_data <- reactive({
    req(input$suburbs, input$type, input$beds)
    vicrental::summarise_rent(
      suburb = input$suburbs,
      property_type = input$type,
      bedrooms = as.integer(input$beds)
    )
  })

output$rent_plot <- plotly::renderPlotly({
  validate(need(nrow(summary_data()) > 0,
                "No data for this combination. Try another suburb, type or bedroom count."))

d <- summary_data()
d$label <- paste0(
  d$year, " ", d$quarter,
  " | Median rent: $", round(d$median_rent),
  " | New lettings: ", d$new_lettings
)

plotly::plot_ly(
  d,
  x = ~period, y = ~median_rent, color = ~suburb,
  type = "scatter", mode = "lines",
  text = ~label, hoverinfo = "text"
) |>
  plotly::layout(
    hovermode = "x unified",
    title = paste("Median rent:", paste(input$suburbs, collapse = " vs ")),
    xaxis = list(title = "", hoverformat = "%Y"),
    yaxis = list(title = "Median weekly rent ($)", tickprefix = "$"),
    legend = list(orientation = "h", y = -0.15)
  )
}) 

rank_data <- reactive({
    req(input$rank_year, input$rank_quarter, input$rank_type, input$rank_beds)
    vicrental::top10_rent(            
      year = as.integer(input$rank_year),
      quarter = input$rank_quarter,
      property_type = input$rank_type,
      bedrooms = as.integer(input$rank_beds),
      n = input$rank_n,
      highest = input$rank_dir == "high"
    )
  })

 output$rank_plot <- plotly::renderPlotly({
  d <- rank_data()
  validate(need(nrow(d) > 0,
                "No data for this combination. Try another quarter or bedroom count.")) 
  
d$suburb <- factor(d$suburb, levels = rev(d$suburb))

  plotly::plot_ly(
    d,
    x = ~median_rent,
    y = ~suburb,
    color = ~region,
    colors = "Set2",
    type = "bar", orientation = "h",
    hovertext = ~paste0("<br>Median rent: $", round(median_rent),
                        "<br>New lettings: ", new_lettings),
    hoverinfo = "text"
  ) |>
    plotly::layout(
  title = list(
    text = paste0("Top ", nrow(d), " ",
                  if (input$rank_dir == "high") "highest" else "lowest",
                  "-rent suburbs, ", input$rank_quarter, " ", input$rank_year),
    font = list(size = 16),
    x = 0.02, xanchor = "left"
  ), margin = list(t = 70),
      xaxis = list(title = "Median weekly rent ($)", tickprefix = "$"),
      yaxis = list(title = ""),
      showlegend = TRUE,
      legend = list(title = list(text = "Region"))
    )
})
  afford_data <- reactive({
    req(input$budget, input$aff_type, input$aff_beds, input$aff_q)
    vicrental::affordable_suburbs(
      budget = input$budget,
      property_type = input$aff_type,
      bedrooms = as.integer(input$aff_beds),
      quarters = as.integer(input$aff_q),
      n = Inf
    )
  })

  output$afford_msg <- renderText({
    paste(nrow(afford_data()), " suburbs have an average rent at or below $",
          input$budget, "a week.")
  })

  output$afford_table <- reactable::renderReactable({
    d <- afford_data()
    validate(need(nrow(d) > 0,
                  "No suburbs match this budget, property type and bedroom count. Try a higher budget or a different number of bedrooms."))

    tbl <- data.frame(
      Suburb = d$suburb,
      Region = d$region,
      Rent = round(d$avg_rent),
      Lettings = round(d$avg_lettings),
      Quarters = d$n_quarters
    )

reactable::reactable(
  tbl,
  searchable = TRUE,
  striped = TRUE,
  highlight = TRUE,
  compact = TRUE,
  borderless = TRUE,
  defaultPageSize = 10,
  showPageSizeOptions = TRUE,
  pageSizeOptions = c(10, 25, 50),
  paginationType = "simple",
  defaultSorted = list(Rent = "asc"),
  theme = reactable::reactableTheme(
    color = "#5a5a5a",
    stripedColor = "#f3faf8",
    highlightColor = "#e1f4ee",
    headerStyle = list(
      backgroundColor = "#78c2ad",
      color = "white",
      fontWeight = 600,
      "&:hover" = list(backgroundColor = "#56cc9d")
    ),
    searchInputStyle = list(
      borderColor = "#78c2ad",
      "&:focus" = list(borderColor = "#56cc9d", boxShadow = "0 0 0 2px #cfeee5")
    ),
    pageButtonHoverStyle = list(backgroundColor = "#e1f4ee"),
    pageButtonActiveStyle = list(backgroundColor = "#78c2ad", color = "white")
  ),
      columns = list(
        Suburb = reactable::colDef(minWidth = 200),
        Region = reactable::colDef(name = "Region", minWidth = 150),
        Rent = reactable::colDef(
          name = "Average rent",
          format = reactable::colFormat(prefix = "$", separators = TRUE)
        ),
        Lettings = reactable::colDef(
          name = "Avg new lettings",
          format = reactable::colFormat(separators = TRUE)
        ),
        Quarters = reactable::colDef(name = "Quarters of data")
      )
    )
  })
}

shinyApp(ui, server)
  