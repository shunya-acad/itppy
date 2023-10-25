graph_1 <- DiagrammeR::grViz("
digraph G {

rankdir=LR
fontname='Helvetica,Arial,sans-serif'

edge [
    fontname='Helvetica,Arial,sans-serif'
    headport=w
    tailport=e
    minlen=2
    ]

node [
        shape=box
        fontname='Helvetica,Arial,sans-serif'
        // fontsize=25
];

    /* Entities */
    '0' [label='BaseException']

    '1-1' [label='Exception']

        '1-1-1' [label='AttributeError']

        '1-1-2' [label='ArithmeticError']
            '1-1-2-1' [label='FloatingPointError']
            '1-1-2-2' [label='OverflowError']
            '1-1-2-3' [label='ZeroDivisionError']

        '1-1-3' [label='EOFError']
        '1-1-4' [label='NameError']

        '1-1-5' [label='LookupError']
            '1-1-5-1' [label='IndexError']
            '1-1-5-2' [label='KeyError']

        '1-1-6' [label='StopIterationError']

        '1-1-7' [label='OSError']
            '1-1-7-1' [label='FileExistsError']
            '1-1-7-2' [label='PermissionError']

        '1-1-8' [label='TypeError']
        '1-1-9' [label='ValueError']


    '1-2' [label='KeyboardInterrupt']

    /* Relationships */
    '0' -> '1-1'
    '0' -> '1-2'

    '1-1' -> '1-1-1', '1-1-2', '1-1-3', '1-1-4',
    '1-1-5', '1-1-6', '1-1-7', '1-1-8', '1-1-9' [minlen=3]

    '1-1-2' -> '1-1-2-1', '1-1-2-2', '1-1-2-3'

    '1-1-5' -> '1-1-5-1', '1-1-5-2'

    '1-1-7' -> '1-1-7-1', '1-1-7-2'

    /* Ranks */

}
")

save_graph_as_png <- function(graph, path)  {
  DiagrammeRsvg::export_svg(graph) |>
    charToRaw() |>
    rsvg::rsvg() |>
    png::writePNG(path, dpi = c(400))
}

graph_1 |>
    save_graph_as_png(
        path = "resources/diagrams/control-flow/exceptions-hierarchy.png")
