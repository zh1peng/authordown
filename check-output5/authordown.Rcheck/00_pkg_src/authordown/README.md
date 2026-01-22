
# 🐝 authordown

**authordown** is an easy-to-use R package designed to streamline the management of author metadata, affiliations, and contributions in academic manuscripts—particularly helpful for papers with extensive author lists.

## ✨ Features

- **Automatic title page generation**: Creates formatted title pages tailored to journal requirements.
- **Author metadata management**: Easily handle multiple authors, affiliations, and correspondence information.
- **Acknowledgments and Conflict-of-Interest**: Automatically generate sections from standardized information.
- **CRediT-compatible author contributions**: Clearly define each author's contributions based on structured input.
- **Interactive Shiny App**: A user-friendly web interface to simplify the process.

## 🚀 Installation

You can install the development version directly from GitHub:

```r
# install.packages("devtools")
devtools::install_github("zh1peng/authordown")
```

## 📖 Quick Start

Prepare your author data using the provided CSV template (`author_template.csv`):

```r
library(authordown)

# Load author data
authors <- read.csv("author_template.csv")

# Generate title page text
generate_titlepage(authors, journal_style = "APA")
```

## 🎯 Using the Shiny Interface

A convenient Shiny interface is included:

```r
library(shiny)

shiny::runApp(system.file("shiny-app", package = "authordown"))
```

Simply upload your CSV file, select journal style, and get your formatted content instantly.

## 📋 Example CSV Format

Here's a quick look at the CSV structure you need:

| Order | FirstName | LastName | Email | Affiliation1 | Affiliation2 | Corresponding |
|-------|-----------|----------|-------|--------------|--------------|---------------|
| 1     | Alice     | Smith    | alice@example.com | University X, Dept. Y | NA           | TRUE          |
| 2     | Bob       | Johnson  | bob@example.com   | University X, Dept. Y | Company Z    | FALSE         |

- `Order`: Author order in manuscript
- `Corresponding`: Mark TRUE for corresponding authors

## 🛠 Contributing

Bug reports, feature suggestions, and contributions are welcome:

1. Fork the repository
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to your branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📧 Contact

- Your Name -zhipeng30@foxmail.com
- Project Link: [https://github.com/zh1peng/authordown](https://github.com/zh1peng/authordown)
