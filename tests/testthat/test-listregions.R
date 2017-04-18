context("listregions")

test_that("listregions works", {
  skip_on_cran()

  tt <- listregions("eez")

  expect_is(row.names(tt), "character")
  expect_true(sum(as.numeric(row.names(tt))) != sum(seq_len(NROW(tt))))
  expect_named(tt, 'title')
  expect_is(tt$title, "character")
})

test_that("listregions fails well", {
  expect_error(listregions(), "argument \"region\" is missing")
})
