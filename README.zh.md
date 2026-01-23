# authordown

[![R-CMD-check](https://github.com/zh1peng/authordown/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/zh1peng/authordown/actions/workflows/R-CMD-check.yaml)

<img src="man/figures/logo.png" align="right" height="150" alt="authordown logo" />

**English README:** [README.md](README.md)

在线应用：[打开应用](https://zh1peng-authordown.share.connect.posit.cloud/)

authordown 是一个用于管理作者信息并生成论文前置信息（尤其是大型作者列表题名页）的 R 包。

## 功能

- 题名页生成（机构编号、通讯作者标记）
- 作者信息校验与标准化
- 致谢、利益冲突与作者贡献部分
- 标准模板，统一作者数据录入
- Shiny 应用用于快速预览与导出

## 安装

CRAN（发布后）：

```r
install.packages("authordown")
```

GitHub：

```r
# install.packages("devtools")
devtools::install_github("zh1peng/authordown")
```

## 端到端流程（离线可用）

### 1) 从内置模板开始

```r
library(authordown)

# 使用包内置 CSV 模板
template_path <- system.file("extdata", "authordown_template.csv", package = "authordown")
authors <- authordown_read_local(template_path)
```

也可以写出一个新的模板到工作目录：

```r
authordown_template("authors.csv")
```

### 2) 生成题名页（显示学位）

```r
title_page <- generate_title_page(
  data = authors,
  title = "Example Paper",
  style = "default",
  show_degree = TRUE
)
cat(title_page)
```

### 3) 生成其他部分

```r
ack <- generate_acknowledgement(authors, style = "paragraph")
coi <- generate_conflict(authors, style = "paragraph")
contrib <- generate_contribution(authors, style = "bullets")

cat(ack)
cat("\n\n")
cat(coi)
cat("\n\n")
cat(contrib)
```

### 4) XLSX 输入

```r
xlsx_path <- system.file("extdata", "authordown_template.xlsx", package = "authordown")
authors_xlsx <- authordown_read_local(xlsx_path)
```

## 在线表格推荐流程

如果你在在线表格中维护作者信息，建议导出到本地后再读取：

1) 导出为 CSV 或 XLSX（也可 TSV）
2) 使用 `authordown_read_local()` 读取本地文件

支持格式：CSV、TSV、XLSX。

## 机构信息（Affiliations）

使用 `Affiliation1`, `Affiliation2`, ... `AffiliationN` 列填写同一作者的多个机构。
没有硬上限，需要多少列就添加多少列。题名页会按首次出现的顺序编号。

## Shiny 应用

在线应用：[打开应用](https://zh1peng-authordown.share.connect.posit.cloud/)

```r
library(shiny)
shiny::runApp(system.file("shiny-app", package = "authordown"))
```

流程：下载模板 → 填写模板 → 上传 → 预览解析结果 → 生成输出并复制/导出。

## 渲染 HTML 以便复制粘贴

如果需要渲染后的 HTML 便于粘贴到投稿系统，可使用：

```r
\dontrun{
html_path <- render_section_html(
  section_title = "Conflict of Interest",
  content_function = generate_conflict,
  data = authors,
  style = "paragraph"
)
}
```

## 常见问题

- “Missing required column” 表示文件缺少必填列（如 `FirstName`、`LastName`）。
- “Corresponding authors must have an Email” 表示存在 `Corresponding = TRUE` 但 `Email` 为空。
- “ORCID values must use the 0000-0000-0000-0000 format” 表示 ORCID 格式错误。

## 许可

AGPL-3
