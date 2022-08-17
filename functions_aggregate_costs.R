# Total costs
fun_total_costs = function(df_list_for_agg){
  # Set consts
  const_len_months = 12
  const_seq_months = c(1:12)
  
  # Aggregation
  # Merge data list
  merged_xlsx_file_cost = NULL
  for (l in const_seq_months) {
    merged_xlsx_file_cost = rbind(merged_xlsx_file_cost,
                                  df_list_for_agg[[l]])
  }
  
  # Total costs
  total_costs =
    aggregate(x = merged_xlsx_file_cost$`金額（円）`,
              by = list(merged_xlsx_file_cost$`月`,
                        rep("総費用", nrow(merged_xlsx_file_cost))),
              sum)
  
  # Rename colnames
  const_colnames_3c_total = c("月", "区分", "金額（円）")
  colnames(total_costs) = const_colnames_3c_total
  
  # Return the result
  return(total_costs)
}

# Divided costs
fun_divided_costs = function(df_list_for_agg){
  # Set consts
  const_len_months = 12
  const_seq_months = c(1:12)
  
  # Aggregation
  # Merge data list
  merged_xlsx_file_cost = NULL
  for (l in const_seq_months) {
    merged_xlsx_file_cost = rbind(merged_xlsx_file_cost,
                                  df_list_for_agg[[l]])
  }
  
  # Divided costs
  divided_costs =
    aggregate(x = merged_xlsx_file_cost$`金額（円）`,
              by = list(merged_xlsx_file_cost$`月`,
                        merged_xlsx_file_cost$`固定費用または変動費用`),
              sum)
  
  # Rename colnames
  const_colnames_3c_total = c("月", "区分", "金額（円）")
  colnames(divided_costs) = const_colnames_3c_total
  
  # Return the result
  return(divided_costs)
}

# Respective costs
fun_respective_costs = function(df_list_for_agg, df_for_leg, request){
  # Set consts
  const_len_months = 12
  const_seq_months = c(1:12)
  const_leg_fixed_costs = na.omit(df_for_leg$`固定費用`)
  const_leg_variable_costs = na.omit(df_for_leg$`変動費用`)
  const_len_fixed_costs = length(const_leg_fixed_costs)
  const_len_variable_costs = length(const_leg_variable_costs)
  const_nrows_fc_in_comp_table = const_len_fixed_costs * const_len_months
  const_nrows_vc_in_comp_table = const_len_variable_costs * const_len_months
  
  # Aggregation
  # Merge data list
  merged_xlsx_file_cost = NULL
  for (l in const_seq_months) {
    merged_xlsx_file_cost = rbind(merged_xlsx_file_cost,
                                  df_list_for_agg[[l]])
  }
  
  # Detailed costs
  detailed_costs =
    aggregate(x = merged_xlsx_file_cost$`金額（円）`,
              by = list(merged_xlsx_file_cost$`月`,
                        merged_xlsx_file_cost$`固定費用または変動費用`,
                        merged_xlsx_file_cost$`費目`),
              sum)
  
  # Rename colnames
  const_colnames_4c = c("月", "固定費用または変動費用", "費目", "金額（円）")
  colnames(detailed_costs) = const_colnames_4c
  
  # Compose complete table
  complete_df_of_fixed_costs =
    data.frame(
      "月" = rep(const_seq_months, const_len_fixed_costs),
      "固定費用または変動費用" = rep("固定費用", const_nrows_fc_in_comp_table),
      "項目" = sort(rep(const_leg_fixed_costs, const_len_months)),
      "金額（円）" = rep(0, const_nrows_fc_in_comp_table)
    )
  colnames(complete_df_of_fixed_costs) = const_colnames_4c
  complete_df_of_variable_costs =
    data.frame(
      "月" = rep(const_seq_months, const_len_variable_costs),
      "固定費用または変動費用" = rep("変動費用", const_nrows_vc_in_comp_table),
      "項目" = sort(rep(const_leg_variable_costs, const_len_months)),
      "金額（円）" = rep(0, const_nrows_vc_in_comp_table)
    )
  colnames(complete_df_of_variable_costs) = const_colnames_4c
  
  # Fill detailed costs
  detailed_costs_joined = rbind(complete_df_of_fixed_costs,
                                complete_df_of_variable_costs,
                                detailed_costs)
  detailed_costs_filled = aggregate(x = detailed_costs_joined$`金額（円）`,
                                    by = list(detailed_costs_joined$`月`,
                                              detailed_costs_joined$`固定費用または変動費用`,
                                              detailed_costs_joined$`費目`),
                                    sum)
  colnames(detailed_costs_filled) = const_colnames_4c
  
  # Fixed costs
  set_fc = (detailed_costs_filled$`固定費用または変動費用` == "固定費用")
  fixed_costs = detailed_costs_filled[set_fc, -2]
  
  # Variable costs
  set_vc = (detailed_costs_filled$`固定費用または変動費用` == "変動費用")
  variable_costs = detailed_costs_filled[set_vc, -2]
  
  # Return the result
  if (request == "fc") {
    return(fixed_costs)
  } else if (request == "vc") {
    return(variable_costs)
  } else {
    return(NULL)
  }
}