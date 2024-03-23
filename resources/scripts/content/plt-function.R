#' plot generic functions
#'
#'
#' @param func \emph{char}; vector of functions as strings
#' @param xc \emph{double}; vector of critical values to be marked
#' @param xlab \emph{character string}; label for x-axis
#' @param ylab \emph{character string}; label for y-axis
#' @param plt_title \emph{character string}; plot title
#' @param y_min \emph{double}; y-axis lower limit
#' @param y_max \emph{double}; y-axis upper limit
#' @param x_min \emph{double}; x-axis lower limit
#' @param x_max \emph{double}; x-axis upper limit
#' @param x_brks \emph{double}; x-axis tick marks
#' @param x_minor_brks \emph{double}; x-axis minor lines
#' @param x_labs \emph{double or character}; x-axis tick marks labels
#' @param y_brks \emph{double}; y-axis tick marks
#' @param y_minor_brks \emph{double}; y-axis minor lines
#' @param y_labs \emph{double or character}; x-axis tick marks labels
#' @param angle_x \emph{double}; can be 0 to 90; angle of x-axis labels
#' @param nx \emph{double}; number of points to generate
#' @param facets \emph{logical}; whether to facet wrap when multiple parameter
#' graphs are provided
#' @param nrow_facets \emph{integer};
#' @param ncol_facets \emph{integer};
#' @param scales_facet \emph{character string}; "free", "free_x", "free_y", "fixed"
#' passed to \code{ggplot2::facet_wrap(scales = scales_facet)}
#' @param lp_facet \emph{character string}; location of legend in facet plots;
#' \emph{only used when \code{facets = TRUE}}
#' @param lp \emph{character string}; location of legend in non-faceted plots;
#' \emph{only used when } \code{lpxy = FALSE}
#' @param lpxy \emph{logical}; indicating whether to use legend position within
#' non-faceted plot using coordinates
#' @param lpx \emph{double}; x coordinate for the legend position when
#' \code{lpxy = TRUE}
#' @param lpy \emph{double}; y coordinate for the legend position when
#' \code{lpxy = TRUE}
#' @param x_lim \emph{double}; applies x min max as -x_lim, x_lim
#' @param y_lim \emph{double}; applies y min max as -y_lim, y_lim
#' @param linewidth \emph{double}; width of line[s] for curve[s]
#'
#' @details
#'
#' \itemize{
#' \item `x_min`, `x_max`, `x_brks`, `x_minor_brks`, `x_labs` go to
#'   \code{scale_x_continuous(breaks = x_brks, minor_breaks = x_minor_brks,
#' labels = x_labs, limits = c(x_min, x_max))}
#' \item `y_min`, `y_max`, `y_brks`, `y_minor_brks`, `y_labs` go to
#'   \code{scale_y_continuous(breaks = y_brks, minor_breaks = y_minor_brks,
#' labels = y_labs, limits = c(y_min, y_max))}
#' }
#'
#' @return
#' @export
#'
#' @import ggplot2
#'
#' @examples
plt_function <- function(
    func = c("x^2", "x^3"), xc = NA, xlab = "x", ylab = NULL,
    plt_title = NULL, x_lim = NA, y_lim = NA,
    y_min = NA, y_max = NA, x_min = NA, x_max = NA,
    x_brks = NULL, x_minor_brks = NULL, x_labs = NULL,
    y_brks = NULL, y_minor_brks = NULL, y_labs = NULL,
    angle_x = 0, nx = 100, facets = FALSE,
    nrow_facets = 1, ncol_facets = NULL,
    scales_facet = "free_x", lp_facet = "bottom",
    lpxy = FALSE, lp = "bottom", lpx = 0.85, lpy = 0.7,
    l_direction = "horizontal", linewidth = .5) {
    library("ggplot2")

    if (!is.na(x_lim)) {
        x_min <- -x_lim
        x_max <- x_lim
    }
    if (!is.na(y_lim)) {
        y_min <- -y_lim
        y_max <- y_lim
    }

    x <- c(seq.int(from = x_min, to = x_max, length.out = nx))

    plt_df <- tibble::tibble(
        x = double(),
        y = double(),
        f = ""
    )

    for (i in seq_along(func)) {
        if (is.list(func)) {
            temp_rows <- (1 + (i - 1) * nx):(nx + (i - 1) * nx)
            plt_df[temp_rows, "x"] <- x
            plt_df[temp_rows, "y"] <- eval(str2expression(func[[i]][1]))
            plt_df[temp_rows, "f"] <- func[[i]][2]
        } else {
            temp_rows <- (1 + (i - 1) * nx):(nx + (i - 1) * nx)
            plt_df[temp_rows, "x"] <- x
            plt_df[temp_rows, "y"] <- eval(str2expression(func[i]))
            plt_df[temp_rows, "f"] <- func[i]
        }
    }

    if (is.null(plt_title)) plt_title <- "Plot"
    if (is.null(ylab)) {
        ylab <- str2expression(paste0(
            "bold(f(",
            stringr::str_to_lower(xlab), "))"
        ))
    }

    if (is.null(x_brks)) {
        x_brks <- waiver()
    }
    if (is.null(x_minor_brks)) {
        x_minor_brks <- waiver()
    }
    if (is.null(x_labs)) {
        x_labs <- waiver()
    }
    if (is.null(y_brks)) {
        y_brks <- waiver()
    }
    if (is.null(y_minor_brks)) {
        y_minor_brks <- waiver()
    }
    if (is.null(y_labs)) {
        y_labs <- waiver()
    }

    if (is.na(y_min)) {
        y_min <- min(min(plt_df$y), -abs(plt_df$y))
    }

    nxc <- length(xc)

    # update flag_xc ----------------------------------------------------------
    if (any(!is.na(xc))) {
        if (nxc > 0 && !is.na(xc)) {
            plt_df$flag_xc <- xlab

            xc <- sort(xc)

            plt_df$flag_xc[plt_df$x <= xc[1]] <- paste(
                "1:", xlab,
                expression("\u2264"), xc[1]
            )
            plt_df$flag_xc[plt_df$x >= xc[nxc]] <- paste(
                nxc + 1, ":", xlab, ">",
                xc[nxc]
            )
            for (j in 1:nxc) {
                plt_df$flag_xc[plt_df$x > xc[j] & plt_df$x < xc[j + 1]] <-
                    paste(j + 1, ":", xc[j], "<", xlab, expression("\u2264"), xc[j + 1])
            }
        }
    } else {
        plt_df$flag_xc <- xlab
    }


    if (lpxy) {
        lp <- c(lpx, lpy)
    }

    # create base plot with the data ------------------------------------------
    plt <- ggplot(data = plt_df)

    if (facets) {
        # create faceted plot for range of parameters ----------------------------
        plt <- plt +
            geom_line(
                mapping = aes(x = x, y = y, color = f),
                linewidth = linewidth
            ) +
            facet_wrap(
                facets = . ~ f, scales = scales_facet,
                nrow = nrow_facets, ncol = ncol_facets
            )

        # fill area under critical values -----------------------------------------
        if (nxc > 0 && !is.na(xc)) {
            plt <- plt +
                geom_area(mapping = aes(x = x, y = y, fill = flag_xc), alpha = 0.2)

            plt <- plt +
                scale_fill_discrete(
                    name = "Area",
                    guide = guide_legend(direction = "horizontal")
                ) +
                scale_color_discrete(name = "NULL", breaks = NULL)

            lp <- lp_facet
        }
    } else {
        # create multiple curves for range of parameters on same plot -------------
        plt <- plt +
            geom_line(
                mapping = aes(x = x, y = y, color = f),
                linewidth = linewidth
            )

        # fill area under critical values -----------------------------------------
        if (nxc > 0 && !is.na(xc)) {
            for (i in seq_along(unique(plt_df$f))) {
                df_tmp <- subset(plt_df, f == unique(plt_df$f)[i])
                plt <- plt +
                    geom_area(
                        data = df_tmp, mapping = aes(x = x, y = y, fill = flag_xc),
                        alpha = 0.2
                    )
            }

            plt <- plt +
                scale_fill_discrete(
                    name = "Area",
                    guide = guide_legend(direction = l_direction)
                ) +
                scale_color_discrete(
                    name = "Curve",
                    guide = guide_legend(direction = l_direction)
                )
        }
    }

    # decorate the plot -------------------------------------------------------
    plt <- plt +
        geom_vline(xintercept = 0) +
        geom_hline(yintercept = 0) +
        labs(title = plt_title, x = xlab, y = ylab) +
        scale_x_continuous(
            breaks = x_brks, minor_breaks = x_minor_brks,
            labels = x_labs, limits = c(x_min, x_max),
            guide = guide_axis(check.overlap = T)
        ) +
        scale_y_continuous(
            breaks = y_brks, minor_breaks = y_minor_brks,
            labels = y_labs, limits = c(y_min, y_max),
            guide = guide_axis(check.overlap = T)
        ) +
        theme_bw() +
        theme(
            legend.position = lp,
            legend.title = element_text(face = "bold"),
            axis.text = element_text(face = "bold"),
            axis.title.x = element_text(face = "bold", hjust = 1),
            axis.title.y = element_text(face = "bold", angle = 0, vjust = 1),
            axis.text.x = element_text(angle = angle_x),
            strip.background = element_rect(fill = "aliceblue"),
            strip.text = element_text(face = "bold")
        )

    # output: return plot -----------------------------------------------------
    assign("plt_df", plt_df, envir = globalenv())
    return(plt)
}
