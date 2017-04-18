context("eezsvshighseas")

test_that("eezsvshighseas works", {
  skip_on_cran()

  tt <- eezsvshighseas()

  expect_is(row.names(tt), "character")
  expect_true(sum(as.numeric(row.names(tt))) != sum(seq_len(NROW(tt))))
  expect_named(tt, c("EEZ percent catch", "High Seas percent catch"))
  expect_type(tt$`EEZ percent catch`, "double")
  expect_type(tt$`High Seas percent catch`, "double")
})
