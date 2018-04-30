context("Check available file")

test_that(".csv data files are available",{
  files <- list.files(system.file("extdata",package = "Fars"))
  ExpectedNames <- c("accident_2013.csv.bz2",
                      "accident_2014.csv.bz2",
                      "accident_2015.csv.bz2")
  testthat::expect_equal(files,ExpectedNames)
})
