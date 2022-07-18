# Load library
library(shiny)
library(openxlsx)
library(tidyverse)

# Load functions for aggregation
source("functions_aggregate_incomes.R")
source("functions_aggregate_costs.R")

shinyUI(
  navbarPage("出納可視化システム",
             tabPanel("メインページ",
                      tags$h2("本システムの概要"),
                      "時系列グラフによって、お金の出入りを簡単に把握できます。",
                      "集計結果のフィルタやソートにより、着目したい内容に素早くたどり着けます。",
                      tags$h2("本システムの狙い"),
                      "お金の出入りに関する把握を無理なく習慣化します。",
                      sidebarLayout(
                        sidebarPanel(
                          fileInput("file",
                                    "データシート（XLSX形式）を選んでください。",
                                    accept = ".xlsx"
                          )
                        ),
                        mainPanel()
                      )
             ),
             tabPanel("集計結果",
                      mainPanel(
                        tabsetPanel(
                          type = "tabs",
                          tabPanel("毎月の収入", dataTableOutput('dt_total_incomes')),
                          tabPanel("毎月の項目別収入", dataTableOutput('dt_respective_incomes')),
                          tabPanel("毎月の費用", dataTableOutput('dt_total_costs')),
                          tabPanel("毎月の固定/変動費用", dataTableOutput('dt_divided_costs')),
                          tabPanel("毎月の費目別固定費用", dataTableOutput('dt_fixed_costs')),
                          tabPanel("毎月の費目別変動費用", dataTableOutput('dt_variable_costs'))
                        )
                      )
             )
  )
)