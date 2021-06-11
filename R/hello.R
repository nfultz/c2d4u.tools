#' c2d4u Utilities
#'
#' c2d4u is a repository of precompiled R packages for Ubuntu. Using it through
#' the operating system commands typically installs packages to the host's site
#' library, which may require root. Instead, these functions can be run from and
#' packages installed to the user library.
#'
#' @name c2d4u.tools
#' @docType package
#' @aliases c2d4u
#' @seealso \url{https://launchpad.net/~c2d4u.team}
#' @section Future Work:
#' \itemize{
#' \item Resolve dependencies.
#' }
NULL


pkgname <- "c2d4u.tools"

#' @param sources.list The debian \code{sources.list} file with the URL of the PPA.
#' @param lists A directory to store apt listings.
#' @param cache A directory to cache apt operations.
#'
#' @return \code{config} - a set of CLI flags for apt.
#'
#' @rdname c2d4u.tools
config <- function(sources.list, lists, cache) {

  if(missing(sources.list)) sources.list =     file.path(system.file('sources', package = pkgname), 'sources.list')
  if(missing(lists))        lists        =     file.path(system.file(package = pkgname), 'lists')
  if(missing(cache))        cache        =     file.path(system.file(package = pkgname), 'cache')

  strsplit(sprintf(
    "-o Dir::Etc::SourceList=%s  -o Dir::Etc::SourceParts=/dev/null -o Dir::State::Lists=%s -o Dir::Cache=%s",
    sources.list,
    lists,
    cache
  ), "\\s+")[[1]]

}


#' @param ... options for \code{config}.
#' @return \code{update}, \code{show} and \code{find} - a conventional UNIX return code (0 for success), invisibly.
#' @rdname c2d4u.tools
update <- function(...) {
  system2("apt-get", c(config(...), "update"))


}

#' @param pkg a package name. Note: Ubuntu packages typically have a "r-cran-" prefix.
#' @rdname c2d4u.tools
find <- function(pkg, ...) {

  system2("apt-cache", c(config(...), "search", pkg))

}

#' @rdname c2d4u.tools
show <- function(pkg, ...) {

  system2("apt-cache", c(config(...), "show", pkg))

}


#' @return \code{install} - a logical for each file copied, invisibly (like \code{file.copy})
#' @examples
#'
#' \dontrun{
#'   # Only relevant to Ubuntu users
#'   c2d4u.tools::update()
#'   c2d4u.tools::find("randomizr")
#'   c2d4u.tools::show("r-cran-randomizr")
#'   c2d4u.tools::install("r-cran-randomizr")
#' }
#'
#'
#' @rdname c2d4u.tools
install <- function(pkg, ...) {
  olddir <- getwd()
  on.exit(setwd(olddir))

  stopifnot(dir.create(newdir <- tempfile(pkg)))
  setwd(newdir)

  message("attempting to download...")

  system2("apt-get", c(config(...), "download", pkg))

  deb <- dir(pattern="[.]deb$")[1]

  message("extracting...")

  system2("ar", c("x", deb, "data.tar.xz"))

  untar("data.tar.xz")

  setwd("usr/lib/R/site-library")

  file.copy(
    ".",
    file.path(system.file(package = pkgname), ".."),
    recursive = TRUE
  )

}

.onAttach <- function(libname, pkgname) {
    packageStartupMessage(
      'You probably do not want to attach this package; its functions
      conflict with base R'
    )
}

