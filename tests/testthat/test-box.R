test_that("Testing parameter input error messages", {
  expect_error(box.bygroup(iris, Species, Species), "The numeric.var parameter needs to be numeric")
  expect_warning(box.bygroup(iris, Sepal.Length, Sepal.Width), "The group.var you have entered is not a factor")
  expect_error(box.bygroup(iris, Sepal.Length, Species, mytitle = 55), "The mytitle parameter needs to be a character input")
  expect_error(box.bygroup(iris, Sepal.Length, Species, numeric.lab = 4i), "The numeric.lab parameter needs to be a character input")
  expect_error(box.bygroup(iris, Sepal.Length, Species, group.lab = TRUE), "The group.lab parameter needs to be a character input")
})

test_that("Testing missing value warning messages", {

  example.df1 <- data.frame(
    col1 = c(1,2,3,4,NA,NA),
    col2 = as.factor(c("A", "A", "A", "B", "B", "B")))

  example.df2 <- data.frame(
    col1 = c(1,2,3,4,5,6),
    col2 = as.factor(c("A", "A", "A", "B", NA, "B")))

  expect_warning(box.bygroup(example.df1, col1, col2), "The numerical variable has missing values.")
  expect_warning(box.bygroup(example.df2, col1, col2), "The grouping variable has missing values.")
})

test_that("Title and axes  are properly labelled",{
  test.plot2 <- box.bygroup(iris, Sepal.Length, Species, mytitle = "graph", numeric.lab = "sepal length", group.lab = "species")
  expect_identical(test.plot2$labels$title, "graph")
  expect_identical(test.plot2$labels$x, "species")
  expect_identical(test.plot2$labels$y, "sepal length")
})
