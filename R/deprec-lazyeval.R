#' Deprecated SE versions of main verbs.
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' dplyr used to offer twin versions of each verb suffixed with an
#' underscore. These versions had standard evaluation (SE) semantics:
#' rather than taking arguments by code, like NSE verbs, they took
#' arguments by value. Their purpose was to make it possible to
#' program with dplyr. However, dplyr now uses tidy evaluation
#' semantics. NSE verbs still capture their arguments, but you can now
#' unquote parts of these arguments. This offers full programmability
#' with NSE verbs. Thus, the underscored versions are now superfluous.
#'
#' Unquoting triggers immediate evaluation of its operand and inlines
#' the result within the captured expression. This result can be a
#' value or an expression to be evaluated later with the rest of the
#' argument. See `vignette("programming")` for more information.
#'
#' @name se-deprecated
#' @param .data A data frame.
#' @param dots,.dots,... Pair/values of expressions coercible to lazy objects.
#' @param vars Various meanings depending on the verb.
#' @param args Various meanings depending on the verb.
#' @keywords internal
NULL

lazy_deprec <- function(
  fun,
  hint = TRUE,
  env = caller_env(),
  user_env = caller_env(2)
) {
  lifecycle::deprecate_warn(
    when = "0.7.0",
    what = paste0(fun, "_()"),
    with = paste0(fun, "()"),
    details = if (hint) "See vignette('programming') for more help",
    env = env,
    user_env = user_env,
    always = TRUE
  )
}

#' @rdname se-deprecated
#' @export
add_count_ <- function(x, vars, wt = NULL, sort = FALSE) {
  lazy_deprec("add_count")

  vars <- compat_lazy_dots(vars, caller_env())
  wt <- wt %||% quo(NULL)
  wt <- compat_lazy(wt, caller_env())
  add_count(x, !!!vars, wt = !!wt, sort = sort)
}

#' @rdname se-deprecated
#' @export
add_tally_ <- function(x, wt, sort = FALSE) {
  lazy_deprec("add_tally")

  wt <- compat_lazy(wt, caller_env())
  add_tally(x, !!wt, sort = sort)
}

#' @export
#' @rdname se-deprecated
arrange_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("arrange")
  UseMethod("arrange_")
}
#' @export
arrange_.data.frame <- function(.data, ..., .dots = list(), .by_group = FALSE) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  arrange(.data, !!!dots, .by_group = .by_group)
}
#' @export
arrange_.tbl_df <- function(.data, ..., .dots = list(), .by_group = FALSE) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  arrange(.data, !!!dots, .by_group = .by_group)
}

#' @export
#' @rdname se-deprecated
count_ <- function(
  x,
  vars,
  wt = NULL,
  sort = FALSE,
  .drop = group_by_drop_default(x)
) {
  lazy_deprec("count")

  vars <- compat_lazy_dots(vars, caller_env())
  wt <- wt %||% quo(NULL)
  wt <- compat_lazy(wt, caller_env())
  count(x, !!!vars, wt = !!wt, sort = sort, .drop = .drop)
}

#' @export
#' @rdname se-deprecated
#' @inheritParams distinct
distinct_ <- function(.data, ..., .dots, .keep_all = FALSE) {
  lazy_deprec("distinct")
  UseMethod("distinct_")
}
#' @export
distinct_.data.frame <- function(
  .data,
  ...,
  .dots = list(),
  .keep_all = FALSE
) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  distinct(.data, !!!dots, .keep_all = .keep_all)
}

#' @export
# Can't use NextMethod() in R 3.1, r-lib/rlang#486
distinct_.tbl_df <- distinct_.data.frame

#' @export
distinct_.grouped_df <- function(
  .data,
  ...,
  .dots = list(),
  .keep_all = FALSE
) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  distinct(.data, !!!dots, .keep_all = .keep_all)
}

#' @export
#' @rdname se-deprecated
do_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("do")
  UseMethod("do_")
}
#' @export
do_.NULL <- function(.data, ..., .dots = list()) {
  NULL
}
#' @export
do_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  do(.data, !!!dots)
}
#' @export
do_.grouped_df <- function(.data, ..., env = caller_env(), .dots = list()) {
  dots <- compat_lazy_dots(.dots, env, ...)
  do(.data, !!!dots)
}
#' @export
do_.rowwise_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  do(.data, !!!dots)
}

#' @export
#' @rdname se-deprecated
filter_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("filter")
  UseMethod("filter_")
}
#' @export
filter_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  filter(.data, !!!dots)
}
#' @export
filter_.tbl_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  filter(.data, !!!dots)
}

#' @export
#' @rdname se-deprecated
#' @inheritParams funs
#' @param env The environment in which functions should be evaluated.
funs_ <- function(dots, args = list(), env = base_env()) {
  lazy_deprec("funs")
  dots <- compat_lazy_dots(dots, caller_env())
  funs(!!!dots, .args = args)
}

#' @export
#' @rdname se-deprecated
#' @inheritParams group_by
group_by_ <- function(.data, ..., .dots = list(), add = FALSE) {
  lazy_deprec("group_by")
  UseMethod("group_by_")
}
#' @export
group_by_.data.frame <- function(
  .data,
  ...,
  .dots = list(),
  add = FALSE,
  .drop = group_by_drop_default(.data)
) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  group_by(.data, !!!dots, .add = add, .drop = .drop)
}
#' @export
group_by_.rowwise_df <- function(
  .data,
  ...,
  .dots = list(),
  add = FALSE,
  .drop = group_by_drop_default(.data)
) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  group_by(.data, !!!dots, .add = add, .drop = .drop)
}

#' @export
#' @rdname se-deprecated
group_indices_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("group_indices", hint = FALSE)
  UseMethod("group_indices_")
}
#' @export
group_indices.data.frame <- function(.data, ..., .drop = TRUE) {
  dots <- enquos(...)
  if (length(dots) == 0L) {
    return(rep(1L, nrow(.data)))
  }
  group_indices(group_by(.data, !!!dots, .drop = .drop))
}
#' @export
group_indices_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  group_indices(.data, !!!dots)
}
#' @export
group_indices_.grouped_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  group_indices(.data, !!!dots)
}
#' @export
group_indices_.rowwise_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  group_indices(.data, !!!dots)
}

#' @export
#' @rdname se-deprecated
mutate_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("mutate")
  UseMethod("mutate_")
}
#' @export
mutate_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  mutate(.data, !!!dots)
}
#' @export
mutate_.tbl_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ..., .named = TRUE)
  mutate(.data, !!!dots)
}

#' @rdname se-deprecated
#' @inheritParams tally
#' @export
tally_ <- function(x, wt, sort = FALSE) {
  lazy_deprec("tally")

  wt <- compat_lazy(wt, caller_env())
  tally(x, wt = !!wt, sort = sort)
}

#' @rdname se-deprecated
#' @export
transmute_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("transmute")
  UseMethod("transmute_")
}
#' @export
transmute_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  transmute(.data, !!!dots)
}

#' @rdname se-deprecated
#' @export
rename_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("rename", hint = FALSE)
  UseMethod("rename_")
}
#' @export
rename_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  rename(.data, !!!dots)
}
#' @export
rename_.grouped_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  rename(.data, !!!dots)
}

#' @export
#' @rdname se-deprecated
rename_vars_ <- function(vars, args) {
  lifecycle::deprecate_warn(
    "0.7.0",
    "rename_vars_()",
    "tidyselect::vars_rename()",
    always = TRUE
  )
  args <- compat_lazy_dots(args, caller_env())
  tidyselect::vars_rename(vars, !!!args)
}

#' @export
#' @rdname se-deprecated
select_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("select", hint = FALSE)
  UseMethod("select_")
}
#' @export
select_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  select(.data, !!!dots)
}
#' @export
select_.grouped_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  select(.data, !!!dots)
}

#' @rdname se-deprecated
#' @param include,exclude Character vector of column names to always
#'   include/exclude.
#' @export
select_vars_ <- function(vars, args, include = chr(), exclude = chr()) {
  lifecycle::deprecate_warn(
    "0.7.0",
    "select_vars_()",
    "tidyselect::vars_select()",
    always = TRUE
  )
  args <- compat_lazy_dots(args, caller_env())
  tidyselect::vars_select(vars, !!!args, .include = include, .exclude = exclude)
}

#' @export
#' @rdname se-deprecated
slice_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("slice", hint = FALSE)
  UseMethod("slice_")
}
#' @export
slice_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  slice(.data, !!!dots)
}
#' @export
slice_.tbl_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  slice(.data, !!!dots)
}

#' @export
#' @rdname se-deprecated
summarise_ <- function(.data, ..., .dots = list()) {
  lazy_deprec("summarise", hint = FALSE)
  UseMethod("summarise_")
}
#' @export
summarise_.data.frame <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ...)
  summarise(.data, !!!dots)
}
#' @export
summarise_.tbl_df <- function(.data, ..., .dots = list()) {
  dots <- compat_lazy_dots(.dots, caller_env(), ..., .named = TRUE)
  summarise(.data, !!!dots)
}
#' @rdname se-deprecated
#' @export
summarize_ <- summarise_

#' Summarise and mutate multiple columns.
#'
#' @description
#' `r lifecycle::badge("deprecated")`
#'
#' `mutate_each()` and `summarise_each()` are deprecated in favour of
#' the new [across()] function that works within `summarise()` and `mutate()`.
#'
#' @keywords internal
#' @export
summarise_each <- function(tbl, funs, ...) {
  summarise_each_impl(tbl, funs, enquos(...), "summarise_each")
}
#' @export
#' @rdname summarise_each
summarise_each_ <- function(tbl, funs, vars) {
  summarise_each_impl(tbl, funs, vars, "summarise_each_")
}
summarise_each_impl <- function(
  tbl,
  funs,
  vars,
  name,
  env = caller_env(),
  user_env = caller_env(2)
) {
  what <- paste0(name, "()")

  lifecycle::deprecate_warn(
    when = "0.7.0",
    what = what,
    with = "across()",
    always = TRUE,
    env = env,
    user_env = user_env
  )

  if (is_empty(vars)) {
    vars <- tbl_nongroup_vars(tbl)
  } else {
    vars <- compat_lazy_dots(vars, user_env)
    vars <- tidyselect::vars_select(tbl_nongroup_vars(tbl), !!!vars)
    if (length(vars) == 1 && names(vars) == as_string(vars)) {
      vars <- unname(vars)
    }
  }
  if (is_character(funs)) {
    funs <- funs_(funs)
  }
  funs <- manip_at(tbl, vars, funs, enquo(funs), user_env, .caller = name)
  summarise(tbl, !!!funs)
}

#' @export
#' @rdname summarise_each
mutate_each <- function(tbl, funs, ...) {
  if (is_character(funs)) {
    funs <- funs_(funs)
  }
  mutate_each_impl(tbl, funs, enquos(...), "mutate_each")
}
#' @export
#' @rdname summarise_each
mutate_each_ <- function(tbl, funs, vars) {
  mutate_each_impl(tbl, funs, vars, "mutate_each_")
}
mutate_each_impl <- function(
  tbl,
  funs,
  vars,
  name,
  env = caller_env(),
  user_env = caller_env(2)
) {
  what <- paste0(name, "()")

  lifecycle::deprecate_warn(
    when = "0.7.0",
    what = what,
    with = "across()",
    always = TRUE,
    env = env,
    user_env = user_env
  )

  if (is_empty(vars)) {
    vars <- tbl_nongroup_vars(tbl)
  } else {
    vars <- compat_lazy_dots(vars, user_env)
    vars <- tidyselect::vars_select(tbl_nongroup_vars(tbl), !!!vars)
    if (length(vars) == 1 && names(vars) == as_string(vars)) {
      vars <- unname(vars)
    }
  }
  funs <- manip_at(tbl, vars, funs, enquo(funs), user_env, .caller = name)
  mutate(tbl, !!!funs)
}

#' @rdname summarise_each
#' @export
summarize_each <- summarise_each
#' @rdname summarise_each
#' @export
summarize_each_ <- summarise_each_
