% Generated manually for authordown_read_tencent
\name{authordown_read_tencent}
\alias{authordown_read_tencent}
\title{Read author metadata from Tencent table (placeholder)}
\usage{
authordown_read_tencent(url, validate = TRUE)
}
\arguments{
\item{url}{A Tencent table share URL.}
\item{validate}{Logical. If TRUE, validate the data.}
}
\value{
A data frame.
}
\description{
This function currently does not fetch data from Tencent tables. Export the
table as CSV or XLSX and read it locally with
\code{\link{authordown_read_local}}.
}
\examples{
\dontrun{
authordown_read_tencent("https://docs.qq.com/sheet/...")
}
}
