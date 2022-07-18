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
  })
}