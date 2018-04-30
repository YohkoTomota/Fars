context("Check file name")

test_that("Check csv names",{
  fname<-make_filename(2013)
  testthat::expect_equal(fname, "accident_2013.csv.bz2")
})
