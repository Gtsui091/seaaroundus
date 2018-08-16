context("catchdata")

test_that("catchdata works", {
  skip_on_cran()

  tt <- catchdata("eez", 76)

  expect_is(row.names(tt), "character")
  expect_is(names(tt), "character")
  expect_is(tt, "data.frame")
  expect_type(tt[,1], "integer")
  expect_type(tt[,2], "character")
  expect_type(tt[,10], "character")
})

test_that("fails well", {
  expect_error(catchdata(), "argument \"region\" is missing")
  expect_error(catchdata(id = 76), "argument \"region\" is missing")
  expect_error(catchdata(76), "check region is one of \"eez\", \"lme\", \"rfmo\", \"meow\"")

  skip_on_cran()

  expect_error(catchdata("Asdfadf", id = 76), "check region is one of \"eez\", \"lme\", \"rfmo\", \"meow\"")
})