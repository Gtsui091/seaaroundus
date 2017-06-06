context("getcells")

test_that("getcells works", {
  skip_on_cran()

  tt <- getcells("POLYGON ((-48.177685950413291 15.842380165289299,
   -48.177685950413291 15.842380165289299,
   -54.964876033057919 28.964280991735578,
   -35.960743801652967 27.606842975206646,
   -48.177685950413291 15.842380165289299))")

  expect_type(tt, "integer")
  expect_type(tt[1], "integer")
  expect_gt(length(tt), 10)
})

test_that("getcells fails well", {
  expect_error(getcells(), "argument \"shape\" is missing")

  expect_error(
    getcells("POLYGON ((-48.177685950413291 15.842380165289299,
             -48.177685950413291 15.842380165289299,
             -54.964876033057919 28.964280991735578,
             -35.960743801652967 27.606842975206646,
             -48.177685950413291 15.8423801652892))"),
    "The WKT object is closed but does not have matching start/end points"
  )
})
