install.packages(c("usethis", "devtools", "roxygen2"))

usethis::create_package("authordown")

usethis::use_git()


usethis::use_roxygen_md()


devtools::document()
#devtools::check()
# devtools::check(args="--no-tests --no-vignettes")
# devtools::check(args="--no-tests --no-vignettes --as-cran")
# styler::style_pkg()
devtools::build()
devtools::install()

usethis::use_github()
usethis::use_agpl3_license()

usethis::use_package("shiny")



library(authordown)

authordown_template("authors.csv")
authors <- authordown_read_local("authors.csv")

generate_title_page(authors, title = "My Paper")
generate_acknowledgement(authors)
generate_conflict(authors)
generate_contribution(authors)


generate_template() 

 authors <- data.frame(
   FirstName = c("Alice", "Bob"),
   LastName = c("Smith", "Johnson"),
   Conflict = c("No conflict", "Consultant at Company Z"))
 generate_conflict(authors)


library(authordown)
authors <- data.frame(
FirstName = c("Alice", "Bob"),
  LastName = c("Smith", "Johnson"),
   Contribution = c("Conceptualization; Data curation", "Supervision; Writing - review")
)
generate_contribution(authors)


# conflict of interest example
 authors <- data.frame(
   FirstName = c("Alice", "Bob"),
   LastName = c("Smith", "Johnson"),
   Conflict = c("No conflict", "Consultant at Company Z"))
 generate_conflict(authors)
html_path <- render_section_html("Conflict of Interest", generate_conflict, authors)
browseURL(html_path)



authors <- data.frame(
  Acknowledgement = c("This work received support from resource X", 
                      "Resource Y was instrumental", 
                      "Alice Smith received support from resource ZZ"),
  stringsAsFactors = FALSE
)

generate_acknowledgement(authors)
html_path <- render_section_html("Acknowledgements", generate_acknowledgement, authors)
browseURL(html_path)



authors <- data.frame(
  FirstName      = c("Alice", "Bob", "Charlie"),
  MiddleName     = c("M.", "", "Q."),
  LastName       = c("Smith", "Johnson", "Lee"),
  Degree         = c("PhD", "MD", "PhD"),
  Email          = c("alice@example.com", "bob@example.com", "charlie@example.org"),
  Rank           = c(1, 1, 2),
  Correspondence = c(TRUE, FALSE, TRUE),
  Affiliation1   = c("University of X, Dept. of Y", "University of X, Dept. of Y", "Institute of Z"),
  Affiliation2   = c(NA, "Company W", NA),
  stringsAsFactors = FALSE
)

cat(generate_title_page(authors, title = "A Great Paper"))
html_path <- render_section_html("Title Page", generate_title_page, authors, title="A great paper")
browseURL(html_path)

library(shiny)

shiny::runApp(system.file("shiny-app", package = "authordown"))