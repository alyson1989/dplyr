test_that("can pass verb-level error call", {
  dplyr_local_error_call(call("foo"))
  expect_snapshot(error = TRUE, {
    mutate(mtcars, 1 + "")
    transmute(mtcars, 1 + "")
    summarise(mtcars, 1 + "")
    summarise(group_by(mtcars, cyl), 1 + "")
    filter(mtcars, 1 + "")
    arrange(mtcars, 1 + "")
    select(mtcars, 1 + "")
    slice(mtcars, 1 + "")
  })
})

test_that("can pass verb-level error call (example case)", {
  my_verb <- function(data, var1, var2) {
    dplyr_local_error_call()
    pull(transmute(data, .result = {{ var1 }} * {{ var2 }}))
  }
  expect_snapshot(error = TRUE, {
    my_verb(mtcars, 1 + "", am)
    my_verb(mtcars, cyl, c(am, vs))
  })
})

test_that("`err_locs()` works as expected", {
  expect_snapshot(error = TRUE, err_locs(1.5))
  expect_snapshot(error = TRUE, err_locs(integer()))

  expect_snapshot({
    err_locs(1L)
    err_locs(1:5)
    err_locs(1:6)
    err_locs(1:7)
  })
})

test_that("errors during dots collection are not enriched (#6178)", {
  expect_snapshot(error = TRUE, {
    mutate(mtcars, !!foobarbaz())
    transmute(mtcars, !!foobarbaz())
    select(mtcars, !!foobarbaz())
    arrange(mtcars, !!foobarbaz())
    filter(mtcars, !!foobarbaz())
  })
})

test_that("warnings are collected for `last_dplyr_warnings()`", {
  skip_if_not_installed("base", "3.6.0")

  local_options(
    rlang_trace_format_srcrefs = FALSE
  )

  df <- tibble(id = 1:2)
  f <- function() {
    warning("msg")
    1
  }

  reset_dplyr_warnings()
  expect_snapshot({
    "Ungrouped"
    df %>%
      mutate(x = f()) %>%
      invisible()
    last_dplyr_warnings()
  })

  reset_dplyr_warnings()
  expect_snapshot({
    "Grouped"
    df %>%
      group_by(id) %>%
      mutate(x = f()) %>%
      invisible()
    last_dplyr_warnings()
  })

  reset_dplyr_warnings()
  expect_snapshot({
    "Rowwise"
    df %>%
      rowwise() %>%
      mutate(x = f()) %>%
      invisible()
    last_dplyr_warnings()
  })

  reset_dplyr_warnings()
  expect_snapshot({
    "Multiple type of warnings within multiple verbs"
    df %>%
      group_by(g = f():n()) %>%
      rowwise() %>%
      mutate(x = f()) %>%
      group_by(id) %>%
      mutate(x = f()) %>%
      invisible()
    last_dplyr_warnings()
  })

  reset_dplyr_warnings()
  expect_snapshot({
    "Truncated (1 more)"
    df %>%
      rowwise() %>%
      mutate(x = f())
    last_dplyr_warnings(n = 1)
  })

  reset_dplyr_warnings()
  expect_snapshot({
    "Truncated (several more)"
    df <- tibble(id = 1:5)
    df %>%
      rowwise() %>%
      mutate(x = f())
    last_dplyr_warnings(n = 1)
  })
})

test_that("complex backtraces with base and rlang warnings", {
  skip_if_not_installed("base", "3.6.0")
  local_options(
    rlang_trace_format_srcrefs = FALSE
  )
  reset_dplyr_warnings()

  df <- tibble(id = 1:3)

  f <- function(...) g(...)
  g <- function(...) h(...)
  h <- function(x, base = TRUE) {
    if (base) {
      warning("foo")
    } else {
      warn("foo")
    }
    x
  }

  foo <- function() bar()
  bar <- function() {
    df %>%
      group_by(x = f(1):n()) %>%
      mutate(x = f(1, base = FALSE))
  }

  expect_snapshot({
    foo()
    last_dplyr_warnings()
  })
})

test_that("`last_dplyr_warnings()` only records 5 backtraces", {
  reset_dplyr_warnings()

  f <- function() {
    warning("msg")
    1
  }
  df <- tibble(id = 1:10)

  expect_warning(
    df %>%
      group_by(id) %>%
      mutate(x = f())
  )

  warnings <- last_dplyr_warnings(Inf)

  traces <- map(warnings, `[[`, "trace")
  expect_equal(
    sum(map_lgl(traces, is_null)),
    5
  )
})

test_that("can collect warnings in main verbs", {
  reset_dplyr_warnings()

  f <- function() {
    warning("foo")
    TRUE
  }

  expect_snapshot({
    invisible(
      mtcars %>%
        rowwise() %>%
        filter(f()) %>%
        arrange(f()) %>%
        mutate(a = f()) %>%
        summarise(b = f())
    )

    warnings <- last_dplyr_warnings(Inf)
    warnings[[1]] # filter()
    warnings[[33]] # arrange()
    warnings[[65]] # mutate()
    warnings[[97]] # summarise()
  })
})
