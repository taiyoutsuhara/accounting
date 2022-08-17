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
                      "毎日2-3分程度の収支記録を続けることにより、収入と支出に対する意識の醸成を目指します。",
                      tags$br(),
                      "データシート1つでクロス集計表と時系列グラフを出力します。",
                      tags$h2("便利な機能"),
                      "<クロス集計表> フィルタやソートにより、着目したい情報にたどり着きやすくなります。",
                      tags$br(),
                      "<時系列グラフ> グラフをダブルクリックすると、プロットデータ情報を取得できます。",
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
                          tabPanel("毎月の収入",
                                   dataTableOutput('dt_total_incomes'),
                                   downloadButton('dl_total_incomes', 'Download')
                          ),
                          tabPanel("毎月の項目別収入",
                                   dataTableOutput('dt_respective_incomes'),
                                   downloadButton('dl_respective_incomes', 'Download')
                          ),
                          tabPanel("毎月の費用",
                                   dataTableOutput('dt_total_costs'),
                                   downloadButton('dl_total_costs', 'Download')
                          ),
                          tabPanel("毎月の固定/変動費用",
                                   dataTableOutput('dt_divided_costs'),
                                   downloadButton('dl_divided_costs', 'Download')
                          ),
                          tabPanel("毎月の費目別固定費用",
                                   dataTableOutput('dt_fixed_costs'),
                                   downloadButton('dl_fixed_costs', 'Download')
                          ),
                          tabPanel("毎月の費目別変動費用",
                                   dataTableOutput('dt_variable_costs'),
                                   downloadButton('dl_variable_costs', 'Download')
                          )
                        )
                      )
             ),
             tabPanel("時系列グラフ",
                      mainPanel(
                        tabsetPanel(
                          type = "tabs",
                          tabPanel("毎月の収入と費用",
                                   plotOutput('fig_total',
                                              dblclick = dblclickOpts(
                                                id = 'fig_total_dblclick'
                                              )
                                   ),
                                   verbatimTextOutput("fig_total_dblclick_info")
                          ),
                          tabPanel("毎月の項目別収入",
                                   plotOutput('fig_respective_incomes',
                                              dblclick = dblclickOpts(
                                                id = 'fig_ri_dblclick'
                                              )
                                   ),
                                   verbatimTextOutput("fig_ri_dblclick_info")
                          ),
                          tabPanel("毎月の費目別固定費用",
                                   plotOutput('fig_fixed_costs',
                                              dblclick = dblclickOpts(
                                                id = 'fig_fc_dblclick'
                                              )
                                   ),
                                   verbatimTextOutput("fig_fc_dblclick_info")
                          ),
                          tabPanel("毎月の費目別変動費用",
                                   plotOutput('fig_variable_costs',
                                              dblclick = dblclickOpts(
                                                id = 'fig_vc_dblclick'
                                              )
                                   ),
                                   verbatimTextOutput("fig_vc_dblclick_info")
                          )
                        )
                      )
             )
  )
)