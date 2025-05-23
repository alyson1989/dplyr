#' Arrange rows by a selection of variables
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' Scoped verbs (`_if`, `_at`, `_all`) have been superseded by the use of
#' [pick()] or [across()] in an existing verb. See `vignette("colwise")` for
#' details.
#'
#' These [scoped] variants of [arrange()] sort a data frame by a
#' selection of variables. Like [arrange()], you can modify the
#' variables before ordering with the `.funs` argument.
#'
#' @inheritParams scoped
#' @inheritParams arrange
#'
#' @section Grouping variables:
#'
#' The grouping variables that are part of the selection participate
#' in the sorting of the data frame.
#'
#' @export
#' @keywords internal
#' @examples
#' df <- as_tibble(mtcars)
#' arrange_all(df)
#' # ->
#' arrange(df, pick(everything()))
#'
#' arrange_all(df, desc)
#' # ->
#' arrange(df, across(everything(), desc))
arrange_all <- function(
  .tbl,
  .funs = list(),
  ...,
  .by_group = FALSE,
  .locale = NULL
) {
  lifecycle::signal_stage("superseded", "arrange_all()")
  funs <- manip_all(
    .tbl,
    .funs,
    enquo(.funs),
    caller_env(),
    .include_group_vars = TRUE,
    ...,
    .caller = "arrange_all"
  )
  if (!length(funs)) {
    funs <- syms(tbl_vars(.tbl))
  }
  arrange(.tbl, !!!funs, .by_group = .by_group, .locale = .locale)
}
#' @rdname arrange_all
#' @export
arrange_at <- function(
  .tbl,
  .vars,
  .funs = list(),
  ...,
  .by_group = FALSE,
  .locale = NULL
) {
  lifecycle::signal_stage("superseded", "arrange_at()")
  funs <- manip_at(
    .tbl,
    .vars,
    .funs,
    enquo(.funs),
    caller_env(),
    .include_group_vars = TRUE,
    ...,
    .caller = "arrange_at"
  )
  if (!length(funs)) {
    funs <- tbl_at_syms(.tbl, .vars, .include_group_vars = TRUE)
  }
  arrange(.tbl, !!!funs, .by_group = .by_group, .locale = .locale)
}
#' @rdname arrange_all
#' @export
arrange_if <- function(
  .tbl,
  .predicate,
  .funs = list(),
  ...,
  .by_group = FALSE,
  .locale = NULL
) {
  lifecycle::signal_stage("superseded", "arrange_if()")
  funs <- manip_if(
    .tbl,
    .predicate,
    .funs,
    enquo(.funs),
    caller_env(),
    .include_group_vars = TRUE,
    ...,
    .caller = "arrange_if"
  )
  if (!length(funs)) {
    funs <- tbl_if_syms(.tbl, .predicate, .include_group_vars = TRUE)
  }
  arrange(.tbl, !!!funs, .by_group = .by_group, .locale = .locale)
}
