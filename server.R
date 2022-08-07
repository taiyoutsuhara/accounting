server = function(input, output, session) {
  observeEvent(input$file, {
    # Incomes #
    # Load input file
    input_file_of_incomes = reactive({
      df_of_incomes = read.xlsx(input$file$datapath,
                                sheet = "収入")
      return(df_of_incomes)
    })
    input_file_of_legends = reactive({
      df_of_legends = read.xlsx(input$file$datapath,
                                sheet = "項目シート")
      return(df_of_legends)
    })
    
    # Figure total incomes
    total_incomes = reactive({
      input_for_ti = input_file_of_incomes()
      result_of_ti = fun_total_incomes(input_for_ti)
      return(result_of_ti)
    })
    
    # Conduct respective incomes
    respective_incomes = reactive({
      input_for_ri = input_file_of_incomes()
      input_for_lg = input_file_of_legends()
      result_of_ri = fun_respective_incomes(input_for_ri, input_for_lg)
      return(result_of_ri)
    })
    
    
    # Costs #
    # Load input file
    input_file_of_costs = reactive({
      # Set consts
      const_len_months = 12
      const_seq_months = c(1:12)
      
      # Set a list
      list_of_monthly_costs = vector("list", length = const_len_months)
      for (l in const_seq_months) {
        list_of_monthly_costs[[l]] = read.xlsx(input$file$datapath,
                                               sheet = as.character(l))
      }
      return(list_of_monthly_costs)
    })
    
    # Figure total costs
    total_costs = reactive({
      input_for_tc = input_file_of_costs()
      result_of_tc = fun_total_costs(input_for_tc)
      return(result_of_tc)
    })
    
    # Calculate divided costs
    divided_costs = reactive({
      input_for_dc = input_file_of_costs()
      result_of_dc = fun_divided_costs(input_for_dc)
      return(result_of_dc)
    })
    
    # Conduct respective costs
    fixed_costs = reactive({
      input_for_rc = input_file_of_costs()
      input_for_lg = input_file_of_legends()
      result_of_fc = fun_respective_costs(input_for_rc, input_for_lg, "fc")
      return(result_of_fc)
    })
    variable_costs = reactive({
      input_for_rc = input_file_of_costs()
      input_for_lg = input_file_of_legends()
      result_of_vc = fun_respective_costs(input_for_rc, input_for_lg, "vc")
      return(result_of_vc)
    })
    
    
    # Equip data tables #
    output$dt_total_incomes = renderDataTable(total_incomes())
    output$dt_respective_incomes = renderDataTable(respective_incomes())
    output$dt_total_costs = renderDataTable(total_costs())
    output$dt_divided_costs = renderDataTable(divided_costs())
    output$dt_fixed_costs = renderDataTable(fixed_costs())
    output$dt_variable_costs = renderDataTable(variable_costs())
    
    
    # Draw figures #
    const_seq_months = c(1:12)
    # Total graph
    total_income_and_costs = rbind(total_incomes(),
                                   total_costs(),
                                   divided_costs())
    const_seq_ssm_total = seq(0,
                              length(unique(total_income_and_costs$`区分`))
    )
    output$fig_total =
      renderPlot(
        ggplot(
          total_income_and_costs,
          aes(x = `月`, y = `金額（円）`, colour = `区分`, shape = `区分`)
        ) +
          geom_line() +
          scale_x_continuous(breaks = const_seq_months) +
          geom_point() +
          scale_shape_manual(values = const_seq_ssm_total) +
          guides(colour = guide_legend(title = "")) +
          labs(title = "収入と費用", x = "月", y = "金額（円）")
      )
    
    # Graphs with legends
    # Respective incomes
    const_seq_ssm_ri = seq(0,
                           length(unique(respective_incomes()$`項目`))
    )
    output$fig_respective_incomes =
      renderPlot(
        ggplot(
          respective_incomes(),
          aes(x = `月`, y = `金額（円）`, colour = `項目`, shape = `項目`)
        ) +
          geom_line() +
          scale_x_continuous(breaks = const_seq_months) +
          geom_point() +
          scale_shape_manual(values = const_seq_ssm_ri) +
          guides(colour = guide_legend(title = "")) +
          labs(title = "項目別収入", x = "月", y = "金額（円）")
      )
    
    # Fixed costs
    const_seq_ssm_fc = seq(0,
                           length(unique(fixed_costs()$`費目`))
    )
    output$fig_fixed_costs =
      renderPlot(
        ggplot(
          fixed_costs(),
          aes(x = `月`, y = `金額（円）`, colour = `費目`, shape = `費目`)
        ) +
          geom_line() +
          scale_x_continuous(breaks = const_seq_months) +
          geom_point() +
          scale_shape_manual(values = const_seq_ssm_fc) +
          guides(colour = guide_legend(title = "")) +
          labs(title = "費目別固定費用", x = "月", y = "金額（円）")
      )
    
    # Variable costs
    const_seq_ssm_vc = seq(0,
                           length(unique(variable_costs()$`費目`))
    )
    output$fig_variable_costs =
      renderPlot(
        ggplot(
          variable_costs(),
          aes(x = `月`, y = `金額（円）`, colour = `費目`, shape = `費目`)
        ) +
          geom_line() +
          scale_x_continuous(breaks = const_seq_months) +
          geom_point() +
          scale_shape_manual(values = const_seq_ssm_vc) +
          guides(colour = guide_legend(title = "")) +
          labs(title = "費目別変動費用", x = "月", y = "金額（円）")
      )
  })
}