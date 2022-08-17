library(testthat)
library(openxlsx)

# Set each file directory
output_lists = list.files("outputs", full.names = T)
testdata_lists = gsub("outputs/|.xlsx", "", output_lists)
testdata_file = "Unit Test_TrialRun.xlsx"

# Test: Each aggregation is collect.
testthat::test_that("Each aggregation is collect.", {
  for (l in 1:6) {
    testthat::expect_identical(
      read.xlsx(output_lists[l], sheet = 1),
      read.xlsx(testdata_file, sheet = testdata_lists[l])
    )
  }
})