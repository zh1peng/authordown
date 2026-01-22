% Generated manually for authordown_read_google_sheet
\name{authordown_read_google_sheet}
\alias{authordown_read_google_sheet}
\title{Read author metadata from Google Sheets (placeholder)}
\usage{
authordown_read_google_sheet(url, validate = TRUE)
}
\arguments{
\item{url}{A Google Sheets share URL.}
\item{validate}{Logical. If TRUE, validate the data.}
}
\value{
A data frame.
}
\description{
This function currently does not fetch data from Google Sheets. Export the
sheet as CSV or XLSX and read it locally with
\code{\link{authordown_read_local}}.
}
\examples{
\dontrun{
authordown_read_google_sheet("https://docs.google.com/spreadsheets/d/...")
}
}
