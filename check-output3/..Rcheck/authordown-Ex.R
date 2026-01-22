pkgname <- "authordown"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
base::assign(".ExTimings", "authordown-Ex.timings", pos = 'CheckExEnv')
base::cat("name\tuser\tsystem\telapsed\n", file=base::get(".ExTimings", pos = 'CheckExEnv'))
base::assign(".format_ptime",
function(x) {
  if(!is.na(x[4L])) x[1L] <- x[1L] + x[4L]
  if(!is.na(x[5L])) x[2L] <- x[2L] + x[5L]
  options(OutDec = '.')
  format(x[1L:3L], digits = 7L)
},
pos = 'CheckExEnv')

### * </HEADER>
library('authordown')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("authordown")
### * authordown

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: authordown
### Title: Generate all sections (title page, acknowledgement, conflict,
###   contribution)
### Aliases: authordown

### ** Examples

## Not run: 
##D authors <- read.csv("authordown_template.csv")
##D cat(authordown(authors, title = "My Great Paper", style = "default"))
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("authordown", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("authordown_read_local")
### * authordown_read_local

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: authordown_read_local
### Title: Read a local author metadata file
### Aliases: authordown_read_local

### ** Examples

## Not run: 
##D authors <- authordown_read_local("authors.csv")
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("authordown_read_local", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("authordown_template")
### * authordown_template

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: authordown_template
### Title: Write an authordown input template
### Aliases: authordown_template

### ** Examples

## Not run: 
##D authordown_template("authors.csv")
##D authordown_template("authors.xlsx")
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("authordown_template", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("authordown_validate")
### * authordown_validate

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: authordown_validate
### Title: Validate author metadata
### Aliases: authordown_validate

### ** Examples

authors <- data.frame(FirstName = "Alice", LastName = "Smith")
authordown_validate(authors)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("authordown_validate", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("generate_acknowledgement")
### * generate_acknowledgement

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: generate_acknowledgement
### Title: Generate an Acknowledgement Section
### Aliases: generate_acknowledgement

### ** Examples

authors <- data.frame(
  FirstName = c("Alice", "Bob"),
  LastName = c("Smith", "Johnson"),
  Acknowledgement = c("Thanks for funding A", "Supported by XYZ"),
  stringsAsFactors = FALSE
)
generate_acknowledgement(authors, style = "paragraph")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("generate_acknowledgement", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("generate_conflict")
### * generate_conflict

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: generate_conflict
### Title: Generate a Conflict of Interest Statement
### Aliases: generate_conflict

### ** Examples

authors <- data.frame(
  FirstName = c("Alice", "Bob"),
  LastName = c("Smith", "Johnson"),
  Conflict = c("No conflict", "Consultant at Company Z"),
  stringsAsFactors = FALSE
)
generate_conflict(authors, style = "paragraph")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("generate_conflict", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("generate_contribution")
### * generate_contribution

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: generate_contribution
### Title: Generate Author Contributions
### Aliases: generate_contribution

### ** Examples

authors <- data.frame(
  FirstName = c("Alice", "Bob"),
  LastName = c("Smith", "Johnson"),
  Contribution = c("Conceptualization; Data curation", "Supervision; Writing - review"),
  stringsAsFactors = FALSE
)
generate_contribution(authors, style = "paragraph")



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("generate_contribution", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("generate_template")
### * generate_template

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: generate_template
### Title: Generate a sample CSV template for authordown
### Aliases: generate_template

### ** Examples

## Not run: 
##D generate_template() # writes authordown_template.csv
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("generate_template", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("generate_title_page")
### * generate_title_page

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: generate_title_page
### Title: Generate a Title Page
### Aliases: generate_title_page

### ** Examples

authors <- data.frame(
  FirstName = c("Alice", "Bob"),
  MiddleName = c("M.", ""),
  LastName = c("Smith", "Johnson"),
  Degree = c("PhD", "MD"),
  Email = c("alice@example.com", "bob@example.com"),
  Rank = c(1, 2),
  Correspondence = c(TRUE, FALSE),
  Affiliation1 = c("University of X, Dept. of Y", "University of X, Dept. of Y"),
  Affiliation2 = c(NA, "Company Z, Research Division"),
  stringsAsFactors = FALSE
)
generate_title_page(authors, style = "default", title = "Example Paper", show_degree = TRUE)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("generate_title_page", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
cleanEx()
nameEx("render_section_html")
### * render_section_html

flush(stderr()); flush(stdout())

base::assign(".ptime", proc.time(), pos = "CheckExEnv")
### Name: render_section_html
### Title: Render a Manuscript Section to HTML
### Aliases: render_section_html

### ** Examples

## Not run: 
##D   # To render the Conflict of Interest section:
##D   html_path <- render_section_html("Conflict of Interest", generate_conflict, authors)
##D   browseURL(html_path)
## End(Not run)



base::assign(".dptime", (proc.time() - get(".ptime", pos = "CheckExEnv")), pos = "CheckExEnv")
base::cat("render_section_html", base::get(".format_ptime", pos = 'CheckExEnv')(get(".dptime", pos = "CheckExEnv")), "\n", file=base::get(".ExTimings", pos = 'CheckExEnv'), append=TRUE, sep="\t")
### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
