IMPORT util

GLOBALS "../libgt_graph_colors.4gl"

FUNCTION test_graph_lib()

DEFINE
    i            INTEGER,
    l_graphhdl   STRING,

    l_dataset1 DYNAMIC ARRAY OF RECORD
        x         DECIMAL(32,16),
        x_label   STRING,
        y         DECIMAL(32,16),
        y_label   STRING,
        color     STRING
    END RECORD,

    l_dataset2 DYNAMIC ARRAY OF RECORD
        x         DECIMAL(32,16),
        x_label   STRING,
        y         DECIMAL(32,16),
        y_label   STRING,
        color     STRING
    END RECORD,

    l_dataset3 DYNAMIC ARRAY OF RECORD
        x         DECIMAL(32,16),
        x_label   STRING,
        y         DECIMAL(32,16),
        y_label   STRING,
        color     STRING
    END RECORD,

    l_dataset4 DYNAMIC ARRAY OF RECORD
        x         DECIMAL(32,16),
        x_label   STRING,
        y         DECIMAL(32,16),
        y_label   STRING,
        color     STRING
    END RECORD

    DISPLAY "Generating datasets..."

    CALL util.Math.srand()

    FOR i = 1 TO 50
        LET l_dataset1[i].x = i
        LET l_dataset1[i].y = i + util.Math.rand(10) - 5
    END FOR

    FOR i = 1 TO 50
        LET l_dataset2[i].x = i * 20
        LET l_dataset2[i].y = i * 20 + (util.Math.rand(100) - 50) - 500
    END FOR

    FOR i = 1 TO 50
        LET l_dataset3[i].x = i
        LET l_dataset3[i].y = util.Math.sin(i / 5)
    END FOR

    FOR i = 1 TO 50
        LET l_dataset4[i].x = i
        LET l_dataset4[i].y = 7 * util.Math.log(i)
    END FOR

    DISPLAY "Opening form..."

    OPEN WINDOW canvas WITH FORM "libgt_graph_demo"

    # Scatter graph
    LET l_graphhdl = new_graph("scatter1", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Scatter Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 50)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 50)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "SCATTER")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset1[i].x, "",
                                               l_dataset1[i].y, "", Gt_COLOR_DarkGoldenrod)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("scatter2", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Scatter Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 1000)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 500)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "SCATTER")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset2[i].x, "",
                                               l_dataset2[i].y, "", Gt_COLOR_DarkGoldenrod)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("scatter3", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Scatter Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 50)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 1)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "SCATTER")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset3[i].x, "",
                                               l_dataset3[i].y, "", Gt_COLOR_DarkGoldenrod)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("scatter4", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Scatter Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 50)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 1)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "SCATTER")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset4[i].x, "",
                                               l_dataset4[i].y, "", Gt_COLOR_Red)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    # Line graph

    LET l_graphhdl = new_graph("line1", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Line Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 50)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 50)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "LINE")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset1[i].x, "",
                                               l_dataset1[i].y, "", Gt_COLOR_DarkGoldenrod)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("line2", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Line Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 1000)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 500)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "LINE")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset2[i].x, "",
                                               l_dataset2[i].y, "", Gt_COLOR_DarkGoldenrod)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("line3", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Line Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 50)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 1)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "LINE")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset3[i].x, "",
                                               l_dataset3[i].y, "", Gt_COLOR_DarkGoldenrod)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("line4", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Line Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 50)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 1)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL add_new_plot(l_graphhdl, "Plot1", "LINE")

        FOR i = 1 TO 50
            CALL add_data(l_graphhdl, "Plot1", l_dataset4[i].x, "",
                                               l_dataset4[i].y, "", Gt_COLOR_Red)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    # Bar graph

    LET l_graphhdl = new_graph("bar1", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Bar Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 10)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 20)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL set_bar_shadow(l_graphhdl, "Plot3", 20, "")
        CALL add_new_plot(l_graphhdl, "Plot3", "BAR")
        CALL set_bar_shadow(l_graphhdl, "Plot3", 10, "")

        FOR i = 1 TO 50 STEP 5
            CALL add_data(l_graphhdl, "Plot3", l_dataset1[i].x, "",
                                               l_dataset1[i].y, "", "")
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("bar2", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Bar Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 10)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 20)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL set_bar_shadow(l_graphhdl, "Plot3", 20, "")
        CALL add_new_plot(l_graphhdl, "Plot3", "BAR")
        CALL set_bar_shadow(l_graphhdl, "Plot3", 10, "")

        FOR i = 1 TO 50 STEP 5
            CALL add_data(l_graphhdl, "Plot3", l_dataset2[i].x, "",
                                               l_dataset2[i].y, "", "")
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("bar3", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Bar Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 1)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 1)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL set_bar_shadow(l_graphhdl, "Plot3", 20, "")
        CALL add_new_plot(l_graphhdl, "Plot3", "BAR")
        CALL set_bar_shadow(l_graphhdl, "Plot3", 10, "")

        FOR i = 1 TO 50 STEP 2
            CALL add_data(l_graphhdl, "Plot3", l_dataset3[i].x, "",
                                               l_dataset3[i].y, "", "")
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("bar4", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Bar Graph", "Demo")
        CALL set_x_label(l_graphhdl, "X-Label", Gt_COLOR_Black)
        CALL set_y_label(l_graphhdl, "Y-Label", Gt_COLOR_Black)
        CALL set_min_x(l_graphhdl, 0)
        CALL set_max_x(l_graphhdl, 10)
        CALL set_min_y(l_graphhdl, 0)
        CALL set_max_y(l_graphhdl, 20)
        CALL set_x_labels(l_graphhdl, 10, 5)
        CALL set_y_labels(l_graphhdl, 10, 5)
        CALL set_bar_shadow(l_graphhdl, "Plot3", 20, "")
        CALL add_new_plot(l_graphhdl, "Plot3", "BAR")
        CALL set_bar_shadow(l_graphhdl, "Plot3", 10, "")

        FOR i = 1 TO 50 STEP 5
            CALL add_data(l_graphhdl, "Plot3", l_dataset4[i].x, "",
                                               l_dataset4[i].y, "", "")
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    # Pie graph

    LET l_graphhdl = new_graph("pie1", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Pie Graph", "Demo")
        CALL add_new_plot(l_graphhdl, "Plot4", "PIE")

        FOR i = 1 TO 10
            CALL add_data(l_graphhdl, "Plot4", l_dataset1[i].x, "",
                                               l_dataset1[i].y, "", Gt_COLOR_DarkGreen)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("pie2", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Pie Graph", "Demo")
        CALL add_new_plot(l_graphhdl, "Plot4", "PIE")

        FOR i = 1 TO 10
            CALL add_data(l_graphhdl, "Plot4", l_dataset2[i].x, "",
                                               l_dataset2[i].y, "", Gt_COLOR_DarkGreen)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("pie3", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Pie Graph", "Demo")
        CALL add_new_plot(l_graphhdl, "Plot4", "PIE")

        FOR i = 1 TO 10
            CALL add_data(l_graphhdl, "Plot4", l_dataset3[i].x, "",
                                               l_dataset3[i].y, "", Gt_COLOR_DarkGreen)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    LET l_graphhdl = new_graph("pie4", "GraphTest")

    IF l_graphhdl IS NOT NULL THEN
        CALL set_graph_title(l_graphhdl, "Pie Graph", "Demo")
        CALL add_new_plot(l_graphhdl, "Plot4", "PIE")

        FOR i = 1 TO 10
            CALL add_data(l_graphhdl, "Plot4", l_dataset4[i].x, "",
                                               l_dataset4[i].y, "", Gt_COLOR_DarkGreen)
        END FOR

        CALL plot_graph(l_graphhdl, FALSE, FALSE)
    END IF

    MENU
        ON ACTION close
            EXIT MENU

        ON ACTION exit
            EXIT MENU
    END MENU

    CLOSE WINDOW canvas

    RETURN TRUE

END FUNCTION
