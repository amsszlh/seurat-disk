#' @include TestObject.R
#' @importFrom methods setOldClass setMethod
#'
NULL

setOldClass(Classes = 'H5D')
setOldClass(Classes = 'H5Group')

#' Test HDF5 datasets and groups to see what kind of data they are
#'
#' @param x An HDF5 dataset or group
#'
#' @name TestH5
#' @rdname TestH5
#'
#' @seealso \code{\link{TestObject}}
#'
#' @keywords internal
#'
NULL

#' @rdname TestH5
#'
setMethod(
  f = 'IsDataFrame',
  signature = c('x' = 'H5D'),
  definition = function(x) {
    return(inherits(x = x, what = 'H5T_COMPOUND'))
  }
)

#' @rdname TestH5
#'
setMethod(
  f = 'IsDataFrame',
  signature = c('x' = 'H5Group'),
  definition = function(x) {
    check <- sapply(
      X = names(x = x),
      FUN = function(i) {
        if (inherits(x = x[[i]], what = 'H5Group')) {
          if (IsFactor(x = x[[i]])) {
            return(x[[i]][['values']]$dims)
          }
        } else {
          return(x[[i]]$dims)
        }
        return(NA_real_)
      },
      USE.NAMES = FALSE
    )
    return(!any(is.na(x = check)) && length(x = unique(x = check)) == 1)
  }
)

#' @rdname TestH5
#'
setMethod(
  f = 'IsFactor',
  signature = c('x' = 'H5Group'),
  definition = function(x) {
    slots <- c('levels', 'values')
    check <- vapply(
      X = slots,
      FUN = function(i) {
        return(x$exists(name = i) && inherits(x = x[[i]], what = 'H5D'))
      },
      FUN.VALUE = logical(length = 1L),
      USE.NAMES = FALSE
    )
    return(all(check))
  }
)

#' @rdname TestH5
#'
setMethod(
  f = 'IsList',
  signature = c('x' = 'H5Group'),
  definition = function(x) {
    return(!IsDataFrame(x = x) && !IsFactor(x = x) && !IsMatrix(x = x))
  }
)

#' @rdname TestH5
#'
setMethod(
  f = 'IsMatrix',
  signature = c('x' = 'H5D'),
  definition = function(x) {
    return(length(x = x$dims) == 2)
  }
)

#' @rdname TestH5
#'
setMethod(
  f = 'IsMatrix',
  signature = c('x' = 'H5Group'),
  definition = function(x) {
    slots <- c('indices', 'indptr', 'data')
    check <- vapply(
      X = slots,
      FUN = function(i) {
        return(x$exists(name = i) && inherits(x = x[[i]], what = 'H5D'))
      },
      FUN.VALUE = logical(length = 1L),
      USE.NAMES = FALSE
    )
    return(all(check))
  }
)