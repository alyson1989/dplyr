test_that("rename() handles deprecated `.data` pronoun", {
  withr::local_options(lifecycle_verbosity = "quiet")
  expect_identical(rename(tibble(x = 1), y = .data$x), tibble(y = 1))
})

test_that("arguments to rename() don't match vars_rename() arguments (#2861)", {
  df <- tibble(a = 1)
  expect_identical(rename(df, var = a), tibble(var = 1))
  expect_identical(
    rename(group_by(df, a), var = a),
    group_by(tibble(var = 1), var)
  )
  expect_identical(rename(df, strict = a), tibble(strict = 1))
  expect_identical(
    rename(group_by(df, a), strict = a),
    group_by(tibble(strict = 1), strict)
  )
})

test_that("rename() to UTF-8 column names", {
  skip_if_not(l10n_info()$"UTF-8")

  df <- tibble(a = 1) %>% rename("\u5e78" := a)
  expect_equal(colnames(df), "\u5e78")
})

test_that("can rename() with strings and character vectors", {
  vars <- c(foo = "cyl", bar = "am")

  expect_identical(rename(mtcars, !!!vars), rename(mtcars, foo = cyl, bar = am))
  expect_identical(rename(mtcars, !!vars), rename(mtcars, foo = cyl, bar = am))
})

test_that("rename preserves grouping", {
  gf <- group_by(tibble(g = 1:3, x = 3:1), g)

  i <- count_regroups(out <- rename(gf, h = g))
  expect_equal(i, 0)
  expect_equal(group_vars(out), "h")
})

test_that("can rename with duplicate columns", {
  df <- tibble(x = 1, x = 2, y = 1, .name_repair = "minimal")
  expect_named(df %>% rename(x2 = 2), c("x", "x2", "y"))
})

test_that("rename() ignores duplicates", {
  df <- tibble(x = 1)
  expect_named(rename(df, a = x, b = x), "b")
})

# rename_with -------------------------------------------------------------

test_that("can select columns", {
  df <- tibble(x = 1, y = 2)
  expect_named(df %>% rename_with(toupper, 1), c("X", "y"))

  df <- tibble(x = 1, y = 2)
  expect_named(df %>% rename_with(toupper, x), c("X", "y"))
})

test_that("passes ... along", {
  df <- tibble(x = 1, y = 2)
  expect_named(
    df %>% rename_with(gsub, 1, pattern = "x", replacement = "X"),
    c("X", "y")
  )
})

test_that("can't create duplicated names", {
  df <- tibble(x = 1, y = 2)
  expect_error(
    df %>% rename_with(~ rep_along(.x, "X")),
    class = "vctrs_error_names"
  )
})

test_that("`.fn` result type is checked (#6561)", {
  df <- tibble(x = 1)
  fn <- function(x) 1L

  expect_snapshot(error = TRUE, {
    rename_with(df, fn)
  })
})

test_that("`.fn` result size is checked (#6561)", {
  df <- tibble(x = 1, y = 2)
  fn <- function(x) c("a", "b", "c")

  expect_snapshot(error = TRUE, {
    rename_with(df, fn)
  })
})

test_that("can't rename in `.cols`", {
  df <- tibble(x = 1)

  expect_snapshot(error = TRUE, {
    rename_with(df, toupper, .cols = c(y = x))
  })
})
