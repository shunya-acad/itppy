library(ggplot2)

data_file_path <- here::here("resources/tables/product_survey.xlsx")

plt_title <- "Product survey: data analysis with tabular data structure"

attribute_order <- c(
    "Learning Curve",
    "Repeatability/Automation",
    "Functionality",
    "Performance",
    "Overall"
)

df <- readxl::read_xlsx(path = data_file_path, sheet = "data")

product_survey_plot <- ggplot(data = df,
    mapping = aes(x = Score, y = Attribute, fill = Product)) +
    geom_bar(stat = "identity", position = "dodge", color = "black",
        width = .5) +
    scale_x_continuous(breaks = c(1:10)) +
    scale_y_discrete(limits = attribute_order) +
    labs(title = plt_title) +
    theme_classic() +
    scale_fill_brewer(palette = "Spectral") +
    theme(
        text = element_text(size = 12, face = "bold"),
        axis.title.y = element_text(angle = 0),
        axis.text = element_text(size = 12),
        legend.position = "top",
        plot.background = element_rect(colour = "black"),
        panel.background = element_rect(colour = "black"),
    )

# ggsave(plot = p1, dpi = 500,
#     filename = here::here("inputs/diagrams/pybcb-data/product-survey.png"))