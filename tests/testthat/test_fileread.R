context("Check fars_read func")

setwd(system.file("extdata", package = "Fars"))

test_that("fars_read() works correctly", {
  expect_is(fars_read("accident_2015.csv.bz2"), "tbl_df")
  expect_error(fars_read("accident_2016.csv.bz2"))
})
