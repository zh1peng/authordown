% Generated manually for authordown_read_local
\name{authordown_read_local}
\alias{authordown_read_local}
\title{Read a local author metadata file}
\usage{
authordown_read_local(path, sheet = NULL, validate = TRUE)
}
\arguments{
\item{path}{Path to a local CSV, TSV, or XLSX file.}
\item{sheet}{Optional sheet name or index for XLSX files.}
\item{validate}{Logical. If TRUE, validate the data.}
}
\value{
A data frame with standardized columns.
}
\description{
Reads a CSV/TSV/XLSX file and returns a standardized data frame.
}
\examples{
\dontrun{
authors <- authordown_read_local("authors.csv")
}
}
