library(shiny)
library(tidyverse)
library(lubridate)
library(scales)
library(shinyscreenshot)
library("readxl")
library(plotly) 

clean_data <- read_excel("clean_data.xlsx")

clean_data$Date <- as.POSIXct(clean_data$Date)


ui <- fluidPage(
  titlePanel("US Superstore Technology Product Category Sales Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      width = 2,
      
      h4("Timeline Filter"),
      
      fluidRow(
        column(10, selectInput("start_year", "Start Year", choices = 2011:2014, selected = 2011)),
        column(10, selectInput("start_month", "Start Month", choices = month.abb, selected = "Jan"))
      ),
      
      br(),
      
      fluidRow(
        column(10, selectInput("end_year", "End Year", choices = 2011:2014, selected = 2014)),
        column(10, selectInput("end_month", "End Month", choices = month.abb, selected = "Dec"))
      ),
      
      br(),
      hr(),
      
      actionButton("go_screenshot", "Export", 
                   icon = icon("camera"), 
                   style = "color: white; background-color: #00A5FF; border-color: #00A5FF; width: 100%;")
    ),
    
    mainPanel(
      width = 10,
      
      fluidRow(
        column(4, h4("Total Sales Volume", style = "color: gray;"), h3(textOutput("kpi_sales"), style = "font-weight: bold;")),
        column(4, h4("Total Net Profit", style = "color: gray;"), h3(textOutput("kpi_profit"), style = "font-weight: bold;")),
        column(4, h4("Average Discount", style = "color: gray;"), h3(textOutput("kpi_discount"), style = "font-weight: bold;"))
      ),
      
      hr(),
      
      fluidRow(
        column(6, plotlyOutput("chart1_market", height = "450px")), 
        column(6, plotlyOutput("chart2_sentiment", height = "450px"))
      ),
      
      br(),
      
      fluidRow(
        column(6, plotlyOutput("chart3_freight", height = "450px")),
        column(6, plotlyOutput("chart4_heatmap", height = "450px"))
      ),
      
      br(),
      
      fluidRow(
        column(12, plotlyOutput("chart5_discount", height = "560px"))
      )
    )
  )
)


server <- function(input, output) {
  
  observeEvent(input$go_screenshot, {
    screenshot(
      filename = "Superstore_Volatility_Dashboard", 
      timer = 1 
    )
  })
  
  filtered_data <- reactive({
    start_date_str <- paste(input$start_year, match(input$start_month, month.abb), "01", sep = "-")
    start_date <- as.POSIXct(as.Date(start_date_str))
    
    end_date_str <- paste(input$end_year, match(input$end_month, month.abb), "01", sep = "-")
    end_date <- as.POSIXct(as.Date(end_date_str))
    
    clean_data %>%
      filter(Date >= start_date & Date <= end_date)
  })
  
  output$kpi_sales <- renderText({
    dollar(sum(filtered_data()$Total_Sales, na.rm = TRUE))
  })
  
  output$kpi_profit <- renderText({
    dollar(sum(filtered_data()$Total_Profit, na.rm = TRUE))
  })
  
  output$kpi_discount <- renderText({
    percent(mean(filtered_data()$Avg_Discount, na.rm = TRUE), accuracy = 0.1)
  })

  style_interactive <- function(p, is_dual_axis = FALSE) {
    plotly_obj <- ggplotly(p) %>% 
      layout(
        margin = list(t = 110, b = 60, l = 60, r = 60),
        legend = list(
          orientation = "h", 
          xanchor = "center", 
          x = 0.5, 
          y = 1.12 
        )
      ) %>%
      config(displayModeBar = FALSE)
    
    for (i in seq_along(plotly_obj$x$data)) {
      if (!is.null(plotly_obj$x$data[[i]]$name)) {
        clean_name <- gsub("\\(", "", strsplit(plotly_obj$x$data[[i]]$name, ",")[[1]][1])
        plotly_obj$x$data[[i]]$name <- clean_name
      }
    }
    
    if (is_dual_axis) {
      plotly_obj <- plotly_obj %>% 
        layout(
          yaxis2 = list(
            overlaying = "y", 
            side = "right", 
            showgrid = FALSE, 
            automargin = TRUE
          )
        )
    }
    return(plotly_obj)
  }
  
  # Chart 1
  output$chart1_market <- renderPlotly({
    df <- filtered_data()
    if(nrow(df) == 0) return(NULL) 
    
    coeff <- max(df$Total_Sales, na.rm = TRUE) / max(df$RSEAS, na.rm = TRUE)
    
    g <- ggplot(df, aes(x = Date)) +
      geom_area(aes(y = RSEAS * coeff, fill = "RSEAS"), alpha = 0.6) +
      geom_line(aes(y = Total_Sales, color = "Monthly Sales"), linewidth = 0.6) +
      geom_point(aes(y = Total_Sales, color = "Monthly Sales"), size = 1) +
      scale_fill_manual(name = NULL, values = c("RSEAS" = "gray80")) +
      scale_color_manual(name = NULL, values = c("Monthly Sales" = "#00A5FF")) +
      scale_y_continuous(
        name = "<b>US Superstore Technology Sales</b>", labels = label_dollar(), 
        sec.axis = sec_axis(~ . / coeff, name = "<b>US Retail Electronic Market (Million)</b>", labels = label_dollar())
      ) +
      labs(title = "Internal Volatility vs. Market Stability", x = "<b>Year</b>") +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 20)),
        axis.title.y.left = element_text(color = "gray30", margin = margin(r = 10)),
        axis.text.y.left = element_text(color = "gray30"),
        axis.title.y.right = element_text(color = "gray30", margin = margin(l = 10)),
        axis.text.y.right = element_text(color = "gray30"),
        axis.title.x = element_text(color = "gray30", margin = margin(t = 10)),
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank()
      )
    
    style_interactive(g, is_dual_axis = TRUE)
  })
  
  # Chart 2
  output$chart2_sentiment <- renderPlotly({
    df <- filtered_data()
    if(nrow(df) == 0) return(NULL)
    
    g <- ggplot(df, aes(x = UMCSENT, y = Total_Sales)) +
      geom_point(aes(color = "Monthly Sales"), size = 2, alpha = 0.7) +
      geom_smooth(aes(color = "Trend line"), method = "lm", linewidth = 0.8, linetype = "dashed", se = FALSE) +
      scale_color_manual(
        name = NULL, 
        values = c("Monthly Sales" = "#00A5FF", "Trend line" = "#ff6c90")
      ) +
      scale_y_continuous(labels = label_dollar()) +
      labs(
        title = "Sales vs. Consumer Confidence",
        x = "<b>US Consumer Sentiment Index (UMCSENT)</b>",
        y = "<b>US Superstore Technology Sales</b>"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 20)),
        axis.title.x = element_text(color = "gray30", margin = margin(t = 15)),
        axis.title.y = element_text(color = "gray30", margin = margin(r = 15)),
        axis.text = element_text(size = 11, color = "gray30"),
        panel.border = element_rect(color = "gray80", fill = NA, linewidth = 0.5)
      )
    
    style_interactive(g, is_dual_axis = FALSE)
  })
  
  # Chart 3
  output$chart3_freight <- renderPlotly({
    df <- filtered_data()
    if(nrow(df) == 0) return(NULL)
    
    coeff_freight <- max(df$Total_Sales, na.rm = TRUE) / max(df$TSIFRGHT - 100, na.rm = TRUE)
    
    g <- ggplot(df, aes(x = Date)) +
      geom_line(aes(y = (TSIFRGHT - 100) * coeff_freight, color = "US Freight Index"), linewidth = 0.6, linetype = "solid") +
      geom_line(aes(y = Total_Sales, color = "Monthly Sales"), linewidth = 0.6) +
      scale_color_manual(
        name = NULL, 
        values = c("Monthly Sales" = "#00A5FF", "US Freight Index" = "#ff6c90")
      ) +
      scale_y_continuous(
        name = "<b>US Superstore Technology Sales</b>", labels = label_dollar(),
        sec.axis = sec_axis(~ . / coeff_freight + 100, name = "<b>US Freight Transportation Index (Base = 100)</b>")
      ) +
      labs(
        title = "Sales vs. Supply Chain",
        x = "<b>Year</b>"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 20)),
        axis.title.y.left = element_text(color = "gray30", margin = margin(r = 10)),
        axis.text.y.left = element_text(color = "gray30"),
        axis.title.y.right = element_text(color = "gray30", margin = margin(l = 10)),
        axis.text.y.right = element_text(color = "gray30"),
        axis.title.x = element_text(color = "gray30", margin = margin(t = 15)),
        axis.text.x = element_text(color = "gray30"),
        panel.grid.minor = element_blank()
      )
    
    style_interactive(g, is_dual_axis = TRUE)
  })
  
  # Chart 4
  output$chart4_heatmap <- renderPlotly({
    df <- filtered_data()
    if(nrow(df) == 0) return(NULL)
    
    df_heatmap <- df %>%
      mutate(
        Year = factor(year(Date), levels = sort(unique(year(Date)), decreasing = TRUE)),
        Month = month(Date, label = TRUE, abbr = TRUE)
      )
    
    g <- ggplot(df_heatmap, aes(x = Month, y = Year, fill = Total_Sales)) +
      geom_tile(color = "white", linewidth = 1) +
      scale_fill_gradient(low = "#F0F4FF", high = "#00A5FF", name = "Sales", labels = label_dollar()) +
      labs(
        title = "Sales Distribution (2011 - 2014)", 
        x = "<b>Month</b>", 
        y = "<b>Year</b>"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 20)),
        axis.title.x = element_text(color = "gray30", margin = margin(t = 15)),
        axis.title.y = element_text(color = "gray30", margin = margin(r = 15)),
        axis.text = element_text(color = "gray30"),
        panel.grid = element_blank()
      )
    
    ggplotly(g) %>% 
      layout(margin = list(t = 70, b = 60)) %>%
      config(displayModeBar = FALSE) # <--- REMOVES THE TOOLBAR HERE TOO
  })
  
  # Chart 5
  output$chart5_discount <- renderPlotly({
    df <- filtered_data()
    if(nrow(df) == 0) return(NULL)
    
    coeff_discount <- max(df$Total_Profit, na.rm = TRUE) / max(df$Avg_Discount, na.rm = TRUE)
    
    df <- df %>% 
      mutate(Profit_Status = ifelse(Total_Profit > 0, "Positive Profit", "Net Loss"))
    
    g <- ggplot(df, aes(x = Date)) +
      geom_col(aes(y = Total_Profit, fill = Profit_Status), alpha = 0.85) +
      geom_line(aes(y = Avg_Discount * coeff_discount, color = "Average Discount Margin"), linewidth = 0.8) +
      geom_point(aes(y = Avg_Discount * coeff_discount, color = "Average Discount Margin"), size = 1.5) +
      geom_hline(yintercept = 0, color = "gray50", linewidth = 0.8) +
      scale_fill_manual(
        name = NULL, 
        values = c("Positive Profit" = "#00A5FF", "Net Loss" = "#ff6c90")
      ) +
      scale_color_manual(
        name = NULL, 
        values = c("Average Discount Margin" = "gray50")
      ) +
      scale_y_continuous(
        name = "<b>Net Profit</b>", labels = label_dollar(), 
        sec.axis = sec_axis(~ . / coeff_discount, name = "<b>Average Discount Margin</b>", labels = label_percent())
      ) +
      scale_x_datetime(date_breaks = "6 months", date_labels = "%b '%y") +
      labs(
        title = "Net Profit vs. Average Discount Margin",
        x = "<b>Timeline</b>"
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(face = "bold", size = 14, margin = margin(b = 20)),
        axis.title.y.left = element_text(color = "gray30", margin = margin(r = 10)),
        axis.text.y.left = element_text(color = "gray30"),
        axis.title.y.right = element_text(color = "gray30", margin = margin(l = 10)),
        axis.text.y.right = element_text(color = "gray30"),
        axis.title.x = element_text(color = "gray30", margin = margin(t = 15)),
        axis.text.x = element_text(color = "gray30"),
        panel.grid.minor = element_blank()
      )
    
    style_interactive(g, is_dual_axis = TRUE)
  })
}

shinyApp(ui = ui, server = server)