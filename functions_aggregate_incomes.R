# Total incomes
fun_total_incomes = function(df_for_agg){
  # Aggregation
  total_incomes =
    aggregate(x = df_for_agg$`金額（円）`,
              by = list(df_for_agg$`月`,
                        rep("総収入", nrow(df_for_agg))
              ),
              sum)
  
  # Rename colnames
  const_colnames_3c_total = c("月", "区分", "金額（円）")
  colnames(total_incomes) = const_colnames_3c_total
  
  # Return the result
  return(total_incomes)
}

# Respective incomes
fun_respective_incomes = function(df_for_agg, df_for_leg){
  # Aggregation
  detailed_incomes =
    aggregate(x = df_for_agg$`金額（円）`,
              by = list(df_for_agg$`月`,
                        df_for_agg$`項目`),
              sum)
  
  # Rename colnames
  const_colnames_3c_incomes = c("月", "項目", "金額（円）")
  colnames(detailed_incomes) = const_colnames_3c_incomes
  
  # Compose complete table
  const_len_months = 12
  const_seq_months = c(1:12)
  const_leg_respective_incomes = na.omit(df_for_leg$`収入`)
  const_len_respective_incomes = length(const_leg_respective_incomes)
  const_nrows_ri_in_comp_table = const_len_respective_incomes * const_len_months
  
  complete_df_of_respective_incomes =
    data.frame(
      "月" = rep(const_seq_months, const_len_respective_incomes),
      "項目" = sort(rep(const_leg_respective_incomes, const_len_months)),
      "金額（円）" = rep(0, const_nrows_ri_in_comp_table)
    )
  colnames(complete_df_of_respective_incomes) = const_colnames_3c_incomes
  
  # Fill detailed incomes
  detailed_incomes_joined = rbind(complete_df_of_respective_incomes,
                                  detailed_incomes)
  respective_incomes = aggregate(x = detailed_incomes_joined$`金額（円）`,
                                 by = list(detailed_incomes_joined$`月`,
                                           detailed_incomes_joined$`項目`),
                                 sum)
  colnames(respective_incomes) = const_colnames_3c_incomes
  
  # Return the result
  return(respective_incomes)
}