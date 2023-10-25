sanitize_col_names <- function(col_names, some_df, option = 1) {
    if (is.null(col_names)) return(col_names)

    if (length(col_names) == 1) {
       if (col_names == "default") col_names <- colnames(some_df)
    }

    if (option == 1) {
       col_names <- col_names |>
           purrr::map_chr(stringr::str_replace_all, pattern = "\\r",
                    replacement = "")
    }

    if (option == 2) {
       col_names <- col_names |>
            purrr::map_chr(stringr::str_replace_all, pattern = "\\r",
                    replacement = "") |>
            purrr::map_chr(knitr:::escape_latex) |>
            kableExtra::linebreak()
    }

    return(col_names)
}

replace_na_new <- function(some_df) {
    some_df <- some_df |>
        purrr::map_df(as.character) |>
        purrr::map_df(tidyr::replace_na, "")

    return(some_df)
}

sanitize_line_breaks <- function(tbl_df, option) {
    if (option == 1) { # remove \\r
        tbl_df <- tbl_df |>
                    purrr::map_df(stringr::str_replace_all, pattern = "\\r",
                        replacement = "")

        return(tbl_df)
    }

    if (option == 2) { # remove \\r and replace \\n with <br>
        tbl_df <- tbl_df |>
                    purrr::map_df(stringr::str_replace_all, pattern = "\\r",
                        replacement = "") |>
                    purrr::map_df(stringr::str_replace_all, pattern = "\\n",
                        replacement = "<br>")

        return(tbl_df)
    }

    if (option == 3) { # kable latex options
        tbl_df <- tbl_df |>
                    purrr::map_df(stringr::str_replace_all, pattern = "\\r",
                        replacement = "") |>
                    # purrr::map_df(knitr:::escape_latex) |>
                    dplyr::mutate_all(kableExtra::linebreak)

        return(tbl_df)
    }
}

set_hux_md_func <- function(tbl, row_, col_) {
    tbl <- tbl |>
                huxtable::set_markdown(
                    row = huxtable::everywhere,
                    col = huxtable::everywhere,
                    value = TRUE
                ) |>
                huxtable::set_escape_contents(
                    row = huxtable::everywhere,
                    col = huxtable::everywhere,
                    value = FALSE
                )

    return(tbl)
}

create_table <- function(
    tbl_df, package = "pander", caption = NULL, col_names = "default",
    cell_align = NULL, pander_tbl_style = "grid", apply_theme = TRUE,
    set_hux_md = TRUE, is_beamer = FALSE
) {
    if (is.null(cell_align)) {
        if (package == "pander") cell_align <- "left"
        if (package == "kable") cell_align <- "l"
        if (package == "hux") cell_align <- "left"
    }

    tbl_df <- replace_na_new(tbl_df)

    if (package == "pander") {
        tbl_out <- create_table_pander(
            tbl_df, caption, col_names,
            cell_align, pander_tbl_style
        )
    } else if (package == "hux") {
        tbl_out <- create_table_hux(tbl_df, caption, col_names, cell_align,
                        set_hux_md, is_beamer, apply_theme)
    } else if (package == "kable") {
        tbl_out <- create_table_kable(
            tbl_df, caption, col_names, cell_align, apply_theme
        )
    }

    return(tbl_out)
}


create_table_kable <- function(tbl_df, caption, col_names, cell_align,
                                apply_theme) {
    if (knitr::is_html_output()) {
        tbl_out <- create_table_kable_html(
            tbl_df, caption, col_names, cell_align, apply_theme
        )
    } else {
        tbl_out <- create_table_kable_latex(
            tbl_df, caption, col_names, cell_align, apply_theme
        )
    }

    return(tbl_out)
}

create_table_kable_html <- function(
    tbl_df, caption, col_names, cell_align, apply_theme
) {
    tbl_df <- sanitize_line_breaks(tbl_df, option = 1)

    col_names <- sanitize_col_names(col_names = col_names,
        some_df = tbl_df)

    tbl_out <- tbl_df |>
        kableExtra::kbl(
            format.args = list(big.mark = ","), caption = caption,
            align = cell_align, escape = FALSE, booktabs = FALSE,
            longtable = FALSE, col.names = col_names
        )

    if (apply_theme) {
        tbl_out <- tbl_out |>
            kableExtra::kable_styling(
                bootstrap_options = c(
                    "striped", "hover", "condensed", "responsive"),
                full_width = FALSE)
    }

    return(tbl_out)
}

create_table_kable_latex <- function(tbl_df, caption, col_names, cell_align,
                                    apply_theme) {
    tbl_df <- sanitize_line_breaks(tbl_df, option = 3)

    col_names <- sanitize_col_names(col_names = col_names, some_df = tbl_df,
                    option = 2)

    tbl_out <- tbl_df |>
        kableExtra::kbl(
            format.args = list(big.mark = ","), caption = caption,
            align = cell_align, escape = FALSE, booktabs = TRUE,
            longtable = FALSE, col.names = col_names
        )

    if (apply_theme) {
        tbl_out <- tbl_out |>
            kableExtra::kable_styling(
                latex_options = c("striped", "HOLD_position", "scale_down"),
                full_width = FALSE
            )
    }

    return(tbl_out)
}

create_table_pander <- function(tbl_df, caption, col_names, cell_align,
                                pander_tbl_style) {
    tbl_df <- sanitize_line_breaks(tbl_df, option = 1)

    col_names <- sanitize_col_names(col_names = col_names, some_df = tbl_df)

    tbl_out <- tbl_df |>
        pander::pandoc.table.return(
            caption = caption, justify = cell_align,
            style = pander_tbl_style,
            keep.line.breaks = TRUE, col.names = col_names,
            split.tables = Inf, split.cells = Inf
        )

    return(tbl_out)
}

create_table_hux <- function(
    tbl_df, caption, col_names, cell_align, set_hux_md, is_beamer,
    apply_theme
    ) {
    if (is.null(caption)) caption <- NA

    tbl_df <- sanitize_line_breaks(tbl_df, option = 1)

    col_names <- sanitize_col_names(col_names = col_names, some_df = tbl_df)

    if (is.null(caption)) caption <- NA

    if (is.null(col_names)) {
        colnames(tbl_df) <- NULL
    }

    tbl_out <- tbl_df |>
        huxtable::hux(autoformat = TRUE) |>
        huxtable::set_caption(caption) |>
        huxtable::set_align(cell_align) |>
        huxtable::set_escape_contents(FALSE) |>
        huxtable::set_latex_float("H") |>
        huxtable::set_valign("middle")

    if (!is.null(col_names)) {
       tbl_out <- tbl_out |>
        huxtable::set_contents(row = 1, value = col_names)
    }

    if (set_hux_md) {
       tbl_out <- set_hux_md_func(tbl_out)
    }

    if (is_beamer || knitr::is_latex_output()) {
       tbl_out <- tbl_out |>
            huxtable::set_width(1)
    }

    if (apply_theme) {
        tbl_out <- tbl_out |>
            huxtable::theme_article() |>
            huxtable::set_width(1) |>
            huxtable::set_valign(value = "middle")
        if (is_beamer) {
            tbl_out <- tbl_out
        } else {
            tbl_out <- tbl_out
        }
    }

    return(tbl_out)
}

sanitize_df <- function(tbl_df, package = "kable", col_names = "default") {
    tbl_df <- replace_na_new(tbl_df)

    if (knitr::is_html_output()) {
        tbl_df <- sanitize_line_breaks(tbl_df, option = 1)
        col_names <- sanitize_col_names(
            col_names = col_names, some_df = tbl_df, option = 1)
    } else if (knitr::is_latex_output()) {
        tbl_df <- sanitize_line_breaks(tbl_df, option = 3)
        col_names <- sanitize_col_names(
            col_names = col_names, some_df = tbl_df, option = 2)
    } else {
        tbl_df <- sanitize_line_breaks(tbl_df, option = 1)
        col_names <- sanitize_col_names(
            col_names = col_names, some_df = tbl_df, option = 1)
    }

   colnames(tbl_df) <- col_names

   return(tbl_df)
}

print_tbl_out <- function(tbl_out, package) {

    if (knitr::is_html_output() && package == "hux") {
       tbl_out <- tbl_out |> huxtable::to_html()
    }

    if (knitr::is_latex_output() && package == "hux") {
       tbl_out <- tbl_out |> huxtable::to_latex()
    }

    if (knitr::is_html_output() || knitr::is_latex_output()) {
        tbl_out |> cat()
    } else {
        tbl_out
    }
}

clrz_ptrn_kbl <- function(tbl_, df_, cols_, ptrns_, colors_,
    default_color = "#000000") {
    for (col_ in cols_) {
        bg_color  <- rep(default_color, nrow(df_))
        for (idx_row in seq_along(df_[[col_]])) {
            for (idx_ptrn in seq_along(ptrns_)){
                cnd  <- stringr::str_detect(df_[[col_]][idx_row],
                    ptrns_[[idx_ptrn]])
                if (cnd) {
                    bg_color[idx_row] <- colors_[idx_ptrn]
                }
            }
        }
        tbl_ <- tbl_ |> kableExtra::column_spec(col_, background = bg_color)
    }
    return(tbl_)
}