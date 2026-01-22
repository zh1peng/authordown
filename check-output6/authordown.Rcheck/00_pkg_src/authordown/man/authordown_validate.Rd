% Generated manually for authordown_validate
\name{authordown_validate}
\alias{authordown_validate}
\title{Validate author metadata}
\usage{
authordown_validate(data, require_affiliations = FALSE)
}
\arguments{
\item{data}{A data frame of author metadata.}
\item{require_affiliations}{Logical. If TRUE, require at least one
affiliation column.}
}
\value{
The validated, standardized data frame.
}
\description{
Checks required columns and key formats such as order, email, ORCID, and
corresponding author rules.
}
\examples{
authors <- data.frame(FirstName = "Alice", LastName = "Smith")
authordown_validate(authors)
}
