#' Select distinct rows by a selection of variables
#'
#' @description
#' `r lifecycle::badge("superseded")`
#'
#' Scoped verbs (`_if`, `_at`, `_all`) have been superseded by the use of
#' [pick()] or [across()] in an existing verb. See `vignette("colwise")` for
#' details.
#'
#' These [scoped] variants of [distinct()] extract distinct rows by a
#' selection of variables. Like `distinct()`, you can modify the
#' variables before ordering with the `.funs` argument.
#'
#' @param .keep_all If `TRUE`, keep all variables in `.data`.
#'   If a combination of `...` is not distinct, this keeps the
#'   first row of values.
#' @inheritParams scoped
#' @export
#'
#' @section Grouping variables:
#'
#' The grouping variables that are part of the selection are taken
#' into account to determine distinct rows.
#'
#' @keywords internal
#' @examples
#' df <- tibble(x = rep(2:5, each = 2) / 2, y = rep(2:3, each = 4) / 2)
#'
#' distinct_all(df)
#' # ->
#' distinct(df, pick(everything()))
#'
#' distinct_at(df, vars(x,y))
#' # ->
#' distinct(df, pick(x, y))
#'
#' distinct_if(df, is.numeric)
#' # ->
#' distinct(df, pick(where(is.numeric)))
#'
#' # You can supply a function that will be applied before extracting the distinct values
#' # The variables of the sorted tibble keep their original values.
#' distinct_all(df, round)
#' # ->
#' distinct(df, across(everything(), round))
distinct_all <- function(.tbl, .funs = list(), ..., .keep_all = FALSE) {
  lifecycle::signal_stage("superseded", "distinct_all()")
  funs <- manip_all(
    .tbl,
    .funs,
    enquo(.funs),
    caller_env(),
    .include_group_vars = TRUE,
    ...,
    .caller = "distinct_all"
  )
  if (!length(funs)) {
    funs <- syms(tbl_vars(.tbl))
  }
  distinct(.tbl, !!!funs, .keep_all = .keep_all)
}
#' @rdname distinct_all
#' @export
distinct_at <- function(.tbl, .vars, .funs = list(), ..., .keep_all = FALSE) {
  lifecycle::signal_stage("superseded", "distinct_at()")
  funs <- manip_at(
    .tbl,
    .vars,
    .funs,
    enquo(.funs),
    caller_env(),
    .include_group_vars = TRUE,
    ...,
    .caller = "distinct_at"
  )
  if (!length(funs)) {
    funs <- tbl_at_syms(.tbl, .vars, .include_group_vars = TRUE)
  }
  distinct(.tbl, !!!funs, .keep_all = .keep_all)
}
#' @rdname distinct_all
#' @export
distinct_if <- function(
  .tbl,
  .predicate,
  .funs = list(),
  ...,
  .keep_all = FALSE
) {
  lifecycle::signal_stage("superseded", "distinct_if()")
  funs <- manip_if(
    .tbl,
    .predicate,
    .funs,
    enquo(.funs),
    caller_env(),
    .include_group_vars = TRUE,
    ...,
    .caller = "distinct_if"
  )
  if (!length(funs)) {
    funs <- tbl_if_syms(.tbl, .predicate, .include_group_vars = TRUE)
  }
  distinct(.tbl, !!!funs, .keep_all = .keep_all)
}
