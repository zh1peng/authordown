% Generated manually for authordown_template
\name{authordown_template}
\alias{authordown_template}
\title{Write an authordown input template}
\usage{
authordown_template(path = "authordown_template.csv", format = NULL)
}
\arguments{
\item{path}{Output file path. Extension determines format if \code{format}
is not supplied.}
\item{format}{Optional format override: \code{"csv"} or \code{"xlsx"}.}
}
\value{
Invisibly returns the output path.
}
\description{
Copies a standard author metadata template from the package into the requested
path.
}
\examples{
\dontrun{
authordown_template("authors.csv")
authordown_template("authors.xlsx")
}
}
