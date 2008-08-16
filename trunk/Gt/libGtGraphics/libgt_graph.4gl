# $Id$
#------------------------------------------------------------------------------#
# Copyright (c) 2007 Scott Newton <scottn@ihug.co.nz>                          #
#                                                                              #
# MIT License (http://www.opensource.org/licenses/mit-license.php)             #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation files (the "Software"), to     #
# deal in the Software without restriction, including without limitation the   #
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  #
# sell copies of the Software, and to permit persons to whom the Software is   #
# furnished to do so, subject to the following conditions:                     #
# The above copyright notice and this permission notice shall be included in   #
# all copies or substantial portions of the Software.                          #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
# IN THE SOFTWARE.                                                             #
#------------------------------------------------------------------------------#

##
# Description_of_Module
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

IMPORT os
IMPORT util

CONSTANT Gt_GRAPH_X_MAXIMUM = 800
CONSTANT Gt_GRAPH_Y_MAXIMUM = 800

GLOBALS "libgt_graph_colors.4gl"

DEFINE
    m_x_size        INTEGER,
    m_y_size        INTEGER,
    m_graph_count   INTEGER,
    m_colors        DYNAMIC ARRAY OF STRING,

    m_graph_list DYNAMIC ARRAY OF RECORD
        handle             STRING,
        canvas             STRING,
        type               STRING,
        title              STRING,
        subtitle           STRING,
        x_label            STRING,
        x_label_color      STRING,
        y_label            STRING,
        y_label_color      STRING,
        x_minimum          DECIMAL(32,16),
        y_minimum          DECIMAL(32,16),
        x_maximum          DECIMAL(32,16),
        y_maximum          DECIMAL(32,16),
        x_no_of_ticks      INTEGER,
        x_no_of_labels     INTEGER,
        y_no_of_ticks      INTEGER,
        y_no_of_labels     INTEGER,
        color              STRING,
        fillcolor          STRING,
        bar_spacing        INTEGER,
        bar_shadow_width   STRING,
        bar_shadow_color   STRING,
        plot DYNAMIC ARRAY OF RECORD
            name   STRING,
            type   STRING,
            data DYNAMIC ARRAY OF RECORD
                color     STRING,
                x         DECIMAL(32,16),
                x_label   STRING,
                y         DECIMAL(32,16),
                y_label   STRING
            END RECORD
        END RECORD
    END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_graph_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function_description
# @param param Parameter_description.
# @return returning Return_description.
#

FUNCTION new_graph(l_canvas, l_type)

DEFINE
    l_canvas   STRING,
    l_type     STRING

    LET m_colors[1] = "#EEE8AA"
	LET m_colors[2] = "#FAFAD2"
	LET m_colors[3] = "#FFFFE0"
	LET m_colors[4] = "#FFFF00"
	LET m_colors[5] = "#FFD700"
	LET m_colors[6] = "#EEDD82"
	LET m_colors[7] = "#DAA520"
	LET m_colors[8] = "#B8860B"

    LET m_x_size = Gt_GRAPH_X_MAXIMUM
    LET m_y_size = Gt_GRAPH_Y_MAXIMUM
    LET m_graph_count = m_graph_count + 1
    LET m_graph_list[m_graph_count].handle = gt_next_serial("GRAPH")
    LET m_graph_list[m_graph_count].canvas = l_canvas.trim()
    LET m_graph_list[m_graph_count].type = l_type.trim()

    RETURN m_graph_list[m_graph_count].handle

END FUNCTION

FUNCTION add_new_plot(l_graphhdl, l_name, l_type)

DEFINE
    l_graphhdl   STRING,
    l_name       STRING,
    l_type       STRING

DEFINE
    l_plotid    INTEGER,
    l_graphid   INTEGER

    LET l_graphid = p_gt_find_graph(l_graphhdl)

    IF l_graphid > 0 THEN
        CALL m_graph_list[l_graphid].plot.appendElement()
        LET l_plotid = m_graph_list[l_graphid].plot.getLength()
        LET m_graph_list[l_graphid].plot[l_plotid].name = l_name.trim()
        LET m_graph_list[l_graphid].plot[l_plotid].type = l_type.trim()
    END IF

END FUNCTION

FUNCTION set_graph_title(l_graphhdl, l_title, l_subtitle)

DEFINE
    l_graphhdl   STRING,
    l_title      STRING,
    l_subtitle   STRING

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].title = l_title.trim()
        LET m_graph_list[l_pos].subtitle = l_subtitle.trim()
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_x_label(l_graphhdl, l_x_label, l_x_label_color)

DEFINE
    l_graphhdl        STRING,
    l_x_label         STRING,
    l_x_label_color   STRING

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        IF gt_string_is_empty(l_x_label_color) THEN
            LET l_x_label_color = Gt_COLOR_DarkSlateGray
        END IF

        LET m_graph_list[l_pos].x_label = l_x_label.trim()
        LET m_graph_list[l_pos].x_label_color = l_x_label_color.trim()
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_y_label(l_graphhdl, l_y_label, l_y_label_color)

DEFINE
    l_graphhdl        STRING,
    l_y_label         STRING,
    l_y_label_color   STRING

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        IF gt_string_is_empty(l_y_label_color) THEN
            LET l_y_label_color = Gt_COLOR_DarkSlateGray
        END IF

        LET m_graph_list[l_pos].y_label = l_y_label.trim()
        LET m_graph_list[l_pos].y_label_color = l_y_label_color.trim()
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_min_x(l_graphhdl, l_x_min)

DEFINE
    l_graphhdl   STRING,
    l_x_min      DECIMAL(32,16)

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].x_minimum = l_x_min
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_min_y(l_graphhdl, l_y_min)

DEFINE
    l_graphhdl   STRING,
    l_y_min      DECIMAL(32,16)

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].y_minimum = l_y_min
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_max_x(l_graphhdl, l_x_max)

DEFINE
    l_graphhdl   STRING,
    l_x_max      DECIMAL(32,16)

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].x_maximum = l_x_max
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_max_y(l_graphhdl, l_y_max)

DEFINE
    l_graphhdl   STRING,
    l_y_max      DECIMAL(32,16)

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].y_maximum = l_y_max
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_x_labels(l_graphhdl, l_no_of_ticks, l_no_of_labels)

DEFINE
    l_graphhdl       STRING,
    l_no_of_ticks    INTEGER,
    l_no_of_labels   INTEGER

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].x_no_of_ticks = l_no_of_ticks
        LET m_graph_list[l_pos].x_no_of_labels = l_no_of_labels
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_y_labels(l_graphhdl, l_no_of_ticks, l_no_of_labels)

DEFINE
    l_graphhdl        STRING,
    l_no_of_ticks    INTEGER,
    l_no_of_labels   INTEGER

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].y_no_of_ticks = l_no_of_ticks
        LET m_graph_list[l_pos].y_no_of_labels = l_no_of_labels
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_bar_spacing(l_graphhdl, l_distance)

DEFINE
    l_graphhdl   STRING,
    l_distance   DECIMAL(32,16)

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].bar_spacing = l_distance
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_draw_color(l_graphhdl, l_name, l_color)

DEFINE
    l_graphhdl   STRING,
    l_name       STRING,
    l_color      STRING

DEFINE
    l_ok       SMALLINT,
    l_pos      INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        IF gt_string_is_empty(l_color) THEN
            LET l_color = Gt_COLOR_DarkSlateGray
        END IF

        LET m_graph_list[l_pos].color = l_color
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_bar_shadow(l_graphhdl, l_name, l_shadow_width, l_shadow_color)

DEFINE
    l_graphhdl       STRING,
    l_name           STRING,
    l_shadow_width   INTEGER,
    l_shadow_color   STRING

DEFINE
    l_ok       SMALLINT,
    l_pos      INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        IF gt_string_is_empty(l_shadow_color) THEN
            LET l_shadow_color = Gt_COLOR_Snow2
        END IF

        LET m_graph_list[l_pos].bar_shadow_width = l_shadow_width
        LET m_graph_list[l_pos].bar_shadow_color = l_shadow_color
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION add_data(l_graphhdl, l_name, l_x, l_x_label, l_y, l_y_label, l_color)

DEFINE
    l_graphhdl   STRING,
    l_name       STRING,
    l_x          DECIMAL(32,16),
    l_x_label    STRING,
    l_y          DECIMAL(32,16),
    l_y_label    STRING,
    l_color      STRING

DEFINE
    l_ok        SMALLINT,
    l_length    INTEGER,
    l_plotid    INTEGER,
    l_graphid   INTEGER

    LET l_ok = FALSE
    LET l_graphid = p_gt_find_graph(l_graphhdl)

    IF l_graphid > 0 THEN
        LET l_plotid = p_gt_find_plot(l_graphid, l_name)

        IF l_plotid == 0 THEN
            CALL add_new_plot(l_graphhdl, l_name, m_graph_list[l_graphid].type)
            LET l_plotid = p_gt_find_plot(l_graphid, l_name)
        END IF

        IF l_plotid > 0 THEN
            CALL m_graph_list[l_graphid].plot[l_plotid].data.appendElement()
            LET l_length = m_graph_list[l_graphid].plot[l_plotid].data.getLength()

            LET m_graph_list[l_graphid].plot[l_plotid].data[l_length].color = l_color
            LET m_graph_list[l_graphid].plot[l_plotid].data[l_length].x = l_x
            LET m_graph_list[l_graphid].plot[l_plotid].data[l_length].x_label = l_x_label
            LET m_graph_list[l_graphid].plot[l_plotid].data[l_length].y = l_y
            LET m_graph_list[l_graphid].plot[l_plotid].data[l_length].y_label = l_y_label

            IF l_x < m_graph_list[l_graphid].x_minimum THEN
                LET m_graph_list[l_graphid].x_minimum = l_x
            END IF

            IF l_x > m_graph_list[l_graphid].x_maximum THEN
                LET m_graph_list[l_graphid].x_maximum = l_x
            END IF

            IF l_y < m_graph_list[l_graphid].y_minimum THEN
                LET m_graph_list[l_graphid].y_minimum = l_y
            END IF

            IF l_y > m_graph_list[l_graphid].y_maximum THEN
                LET m_graph_list[l_graphid].y_maximum = l_y
            END IF

            LET l_ok = TRUE
        END IF
    END IF

END FUNCTION

FUNCTION plot_graph(l_graphhdl, l_use_x_labels, l_use_y_labels)

DEFINE
    l_graphhdl       STRING,
    l_use_x_labels   SMALLINT,
    l_use_y_labels   SMALLINT

DEFINE
    l_ok          SMALLINT,
    l_plotid      INTEGER,
    l_graphid     INTEGER,
    l_x           DECIMAL(32,16),
    l_y           DECIMAL(32,16),
    l_itmp        DECIMAL(32,16),
    l_dtmp        DECIMAL(32,16),
    l_x_count     SMALLINT,
    l_y_range     DECIMAL(32,16),
    l_x_scale     DECIMAL(32,16),
    l_y_scale     DECIMAL(32,16),
    l_type        STRING,
    l_canvas      STRING,
    l_canvashdl   om.DomNode,
    l_window      ui.Window

    LET l_ok = FALSE
    LET l_x_count = 0
    LET l_graphid = p_gt_find_graph(l_graphhdl)

    IF l_graphid > 0 THEN
        LET l_canvas = m_graph_list[l_graphid].canvas

        FOR l_plotid = 1 TO m_graph_list[l_graphid].plot.getLength()
            IF m_graph_list[l_graphid].plot[l_plotid].data.getLength() > l_x_count THEN
                LET l_x_count = m_graph_list[l_graphid].plot[l_plotid].data.getLength()
            END IF
        END FOR

        IF l_x_count == 0 THEN
            LET l_dtmp = 1
        ELSE
            LET l_dtmp = m_x_size / l_x_count
        END IF

        LET l_itmp = l_dtmp
        LET l_dtmp = l_dtmp - l_itmp

        IF l_dtmp >= 0.5 THEN
            LET l_itmp = l_itmp + 1
        END IF

        LET m_x_size = l_itmp * l_x_count

        IF l_x_count == 0 THEN
            LET l_x_scale = 1
        ELSE
            LET l_x_scale = m_x_size / l_x_count
        END IF

        IF l_x_scale == 0 THEN
            LET l_x_scale = 1
        END IF

        LET l_y_range = m_graph_list[l_graphid].y_maximum - m_graph_list[l_graphid].y_minimum

        IF l_y_range == 0 THEN
            LET l_y_scale = 1
        ELSE
            LET l_y_scale = m_y_size / l_y_range
        END IF

        IF l_y_scale == 0 THEN
            LET l_y_scale = 1
        END IF

        LET l_window = ui.Window.getCurrent()
        LET l_canvashdl = l_window.findNode("Canvas", l_canvas)

        FOR l_plotid = 1 TO m_graph_list[l_graphid].plot.getLength()
            LET l_type = m_graph_list[l_graphid].type

            IF m_graph_list[l_graphid].plot[l_plotid].type.getLength() > 0 THEN
                LET l_type = m_graph_list[l_graphid].plot[l_plotid].type
            END IF

            IF l_plotid == 1
            AND l_type != "PIE" THEN
                CALL plot_framework(l_graphid, l_canvashdl, l_x_count, l_x_scale, l_use_x_labels, l_y_scale, l_use_y_labels)
            END IF


            CASE
                WHEN l_type = "SCATTER"
                    CALL plot_scatter_graph(l_graphid, l_plotid, l_canvashdl, l_x_scale, l_y_scale)

                WHEN l_type = "LINE"
                    CALL plot_line_graph(l_graphid, l_plotid, l_canvashdl, l_x_scale, l_y_scale)

                WHEN l_type = "BAR"
                    CALL plot_bar_graph(l_graphid, l_plotid, l_canvashdl, l_x_scale, l_y_scale)

                WHEN l_type = "PIE"
                    CALL plot_pie_graph(l_graphid, l_plotid, l_canvashdl, l_x, l_y)

                OTHERWISE
            END CASE
        END FOR
    END IF

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

FUNCTION plot_framework(l_graphid, l_canvas, l_x_count, l_x_scale, l_use_x_labels, l_y_scale, l_use_y_labels)

DEFINE
    l_graphid        INTEGER,
    l_canvas         om.DomNode,
    l_x_count        INTEGER,
    l_x_scale        DECIMAL(32,16),
    l_use_x_labels   SMALLINT,
    l_y_scale        DECIMAL(32,16),
    l_use_y_labels   SMALLINT

DEFINE
    l_x              INTEGER,
    l_y              INTEGER,
    l_pos            INTEGER,
    l_count          INTEGER,
    l_start          INTEGER,
    l_x_min          DECIMAL(32,16),
    l_x_max          DECIMAL(32,16),
    l_y_min          DECIMAL(32,16),
    l_y_max          DECIMAL(32,16),
    l_tick_dx        DECIMAL(32,16),
    l_tick_dy        DECIMAL(32,16),
    l_label_dx       DECIMAL(32,16),
    l_label_dy       DECIMAL(32,16),
    l_x_tick_skip    INTEGER,
    l_y_tick_skip    INTEGER,
    l_x_label_skip   INTEGER,
    l_y_label_skip   INTEGER,
    l_x_axis_start   INTEGER,
    l_char           STRING,
    l_text           STRING,
    l_label          STRING,
    l_title          STRING,
    l_subtitle       STRING,
    l_linehdl        om.DomNode,
    l_texthdl        om.DomNode

    LET l_x_min = m_graph_list[l_graphid].x_minimum
    LET l_x_max = m_graph_list[l_graphid].x_maximum
    LET l_x_tick_skip = m_graph_list[l_graphid].x_no_of_ticks
    LET l_x_label_skip = m_graph_list[l_graphid].x_no_of_labels

    IF l_x_tick_skip == 0 THEN
        LET l_tick_dx = 1
    ELSE
        LET l_tick_dx = (l_x_max - l_x_min) / l_x_tick_skip
    END IF

    IF l_x_label_skip == 0 THEN
        LET l_label_dx = 1
    ELSE
        LET l_label_dx = (l_x_max - l_x_min) / l_x_label_skip
    END IF

    LET l_y_min = m_graph_list[l_graphid].y_minimum
    LET l_y_max = m_graph_list[l_graphid].y_maximum
    LET l_y_tick_skip = m_graph_list[l_graphid].y_no_of_ticks
    LET l_y_label_skip = m_graph_list[l_graphid].y_no_of_labels

    IF l_y_tick_skip == 0 THEN
        LET l_tick_dy = 1
    ELSE
        LET l_tick_dy = (l_y_max - l_y_min) / l_y_tick_skip
    END IF

    IF l_y_label_skip == 0 THEN
        LET l_label_dy = 1
    ELSE
        LET l_label_dy = (l_y_max - l_y_min) / l_y_label_skip
    END IF

    # Draw the title

    LET l_title = m_graph_list[l_graphid].title
    LET l_start = 500 - ((l_title.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
    CALL l_texthdl.setAttribute("startX", l_start)
    CALL l_texthdl.setAttribute("startY", 960)
    CALL l_texthdl.setAttribute("text", l_title)

    # Draw the subtitle

    LET l_subtitle = m_graph_list[l_graphid].subtitle
    LET l_start = 500 - ((l_subtitle.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
    CALL l_texthdl.setAttribute("startX", l_start)
    CALL l_texthdl.setAttribute("startY", 925)
    CALL l_texthdl.setAttribute("text", l_subtitle)

    # Draw the x-axis

    IF  m_graph_list[l_graphid].y_minimum <= 0
    AND m_graph_list[l_graphid].y_maximum < 0 THEN
        LET l_x_axis_start = 900
    ELSE
        IF  m_graph_list[l_graphid].y_minimum >= 0
        AND m_graph_list[l_graphid].y_maximum > 0 THEN
            LET l_x_axis_start = 100
        ELSE
            LET l_x_axis_start = 100 + ((0 -  l_y_min) * l_y_scale)
        END IF
    END IF

    LET l_linehdl = l_canvas.createChild("CanvasLine")
    CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
    CALL l_linehdl.setAttribute("startX", 150)
    CALL l_linehdl.setAttribute("startY", l_x_axis_start)
    CALL l_linehdl.setAttribute("endX", (m_x_size + 150))
    CALL l_linehdl.setAttribute("endY", l_x_axis_start)

    # Draw the y-axis

    LET l_linehdl = l_canvas.createChild("CanvasLine")
    CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
    CALL l_linehdl.setAttribute("startX", 150)
    CALL l_linehdl.setAttribute("startY", 100)
    CALL l_linehdl.setAttribute("endX", 150)
    CALL l_linehdl.setAttribute("endY", (m_y_size + 100))

    # Draw the x-ticks

    LET l_x = l_x_min

    FOR l_pos = 150 TO 950 STEP (800 / l_x_tick_skip)
        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
        CALL l_linehdl.setAttribute("startX", l_pos)
        CALL l_linehdl.setAttribute("startY", 85)
        CALL l_linehdl.setAttribute("endX", l_pos)
        CALL l_linehdl.setAttribute("endY", 100)

        LET l_x = l_x + l_tick_dx
    END FOR

    # Draw the x-tick values

    LET l_count = 0
    LET l_x = l_x_min

    FOR l_pos = 150 TO 950 STEP (800 / l_x_label_skip)
        LET l_texthdl = l_canvas.createChild("CanvasText")

        IF l_use_x_labels THEN
           LET l_text = m_graph_list[l_graphid].plot[1].data[l_count].x_label
        ELSE
            IF (l_x_max - l_x_min ) < 5 THEN
                LET l_text = l_x_min + (((l_x_max - l_x_min) / l_x_label_skip) * l_count) USING "---.##"
            ELSE
                LET l_text = l_x
            END IF
        END IF

        LET l_start = l_pos - ((l_text.getLength() * 20) / 2)
        CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
        CALL l_texthdl.setAttribute("startX", l_start)
        CALL l_texthdl.setAttribute("startY", 40)
        CALL l_texthdl.setAttribute("text", l_text)

        LET l_x = l_x + l_label_dx
        LET l_count = l_count + (l_x_tick_skip / l_x_label_skip)
    END FOR

    # Draw the x-label text

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].x_label_color)
    CALL l_texthdl.setAttribute("startX", 480)
    CALL l_texthdl.setAttribute("startY", 5)
    CALL l_texthdl.setAttribute("text", m_graph_list[l_graphid].x_label )

    # Draw the y-ticks

    LET l_y = l_y_min

    FOR l_pos = 100 TO 900 STEP (800 / l_y_tick_skip)
        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
        CALL l_linehdl.setAttribute("startX", 135)
        CALL l_linehdl.setAttribute("startY", l_pos)
        CALL l_linehdl.setAttribute("endX", 150)
        CALL l_linehdl.setAttribute("endY", l_pos)

        LET l_y = l_y + l_tick_dy
    END FOR

    # Draw the y-tick values

    LET l_count = 0
    LET l_y = l_y_min

    FOR l_pos = 100 TO 900 STEP (800 / l_y_label_skip)
        LET l_texthdl = l_canvas.createChild("CanvasText")

        IF l_use_y_labels THEN
           LET l_text = m_graph_list[l_graphid].plot[1].data[l_count].y_label
        ELSE
            IF (l_y_max - l_y_min ) < 5 THEN
                LET l_text = l_y_min + (((l_y_max - l_y_min) / l_y_label_skip) * l_count) USING "---.##"
            ELSE
                LET l_text = l_y
            END IF
        END IF

        LET l_start = 110 - (l_text.getLength() * 20)
        CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].color)
        CALL l_texthdl.setAttribute("startX", l_start)
        CALL l_texthdl.setAttribute("startY", l_pos - 15)
        CALL l_texthdl.setAttribute("text", l_text)

        LET l_y = l_y + l_label_dy
        LET l_count = l_count + 1
    END FOR

    # Draw the y-label text

    LET l_label = m_graph_list[l_graphid].y_label

    FOR l_pos = 1 TO l_label.getLength()
        LET l_char = l_label.getCharAt(l_pos)
        LET l_texthdl = l_canvas.createChild("CanvasText")
        CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_graphid].y_label_color)
        CALL l_texthdl.setAttribute("startX", 10)
        CALL l_texthdl.setAttribute("startY", 700 - (l_pos * 48))
        CALL l_texthdl.setAttribute("text", l_char)
    END FOR

END FUNCTION

FUNCTION plot_scatter_graph(l_graphid, l_plotid, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_graphid   INTEGER,
    l_plotid    INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   DECIMAL(32,16),
    l_y_scale   DECIMAL(32,16)

DEFINE
    i             INTEGER,
    x             INTEGER,
    y             INTEGER,
    l_x           DECIMAL(32,16),
    l_y           DECIMAL(32,16),
    l_x_min       DECIMAL(32,16),
    l_y_min       DECIMAL(32,16),
    l_color       STRING,
    l_linehdl     om.DomNode

    LET l_x_min = m_graph_list[l_graphid].x_minimum
    LET l_y_min = m_graph_list[l_graphid].y_minimum

    FOR i = 1 TO m_graph_list[l_graphid].plot[l_plotid].data.getLength()
        LET l_x = m_graph_list[l_graphid].plot[l_plotid].data[i].x
        LET l_x = i * l_x_scale + 150

        LET l_y = m_graph_list[l_graphid].plot[l_plotid].data[i].y
        LET l_y = l_y * l_y_scale - (l_y_min * l_y_scale) + 100

        LET l_color = m_graph_list[l_graphid].plot[l_plotid].data[i].color

        IF gt_string_is_empty(l_color) THEN
            LET l_color = Gt_COLOR_DarkSlateGray
        END IF

        LET x = l_x
        LET y = l_y

        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("fillColor", l_color)
        CALL l_linehdl.setAttribute("startX", x)
        CALL l_linehdl.setAttribute("startY", (y - 5))
        CALL l_linehdl.setAttribute("endX", (x))
        CALL l_linehdl.setAttribute("endY", (y + 5))

        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("fillColor", l_color)
        CALL l_linehdl.setAttribute("startX", (x - 5))
        CALL l_linehdl.setAttribute("startY", (y))
        CALL l_linehdl.setAttribute("endX", (x + 5))
        CALL l_linehdl.setAttribute("endY", (y))
    END FOR

END FUNCTION

FUNCTION plot_line_graph(l_graphid, l_plotid, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_graphid   INTEGER,
    l_plotid    INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   DECIMAL(32,16),
    l_y_scale   DECIMAL(32,16)

DEFINE
    i           INTEGER,
    x           INTEGER,
    y           INTEGER,
    dx          INTEGER,
    dy          INTEGER,
    l_x         DECIMAL(32,16),
    l_y         DECIMAL(32,16),
    l_dx        DECIMAL(32,16),
    l_dy        DECIMAL(32,16),
    l_x_min     DECIMAL(32,16),
    l_y_min     DECIMAL(32,16),
    l_color     STRING,
    l_linehdl   om.DomNode

    LET l_x_min = m_graph_list[l_graphid].x_minimum
    LET l_y_min = m_graph_list[l_graphid].y_minimum

    FOR i = 1 TO m_graph_list[l_graphid].plot[l_plotid].data.getLength()
        LET l_x = m_graph_list[l_graphid].plot[l_plotid].data[i].x
        LET l_x = i * l_x_scale + 150

        LET l_y = m_graph_list[l_graphid].plot[l_plotid].data[i].y
        LET l_y = l_y * l_y_scale - (l_y_min * l_y_scale) + 100

        LET l_color = m_graph_list[l_graphid].plot[l_plotid].data[i].color

        IF gt_string_is_empty(l_color) THEN
            LET l_color = Gt_COLOR_DarkSlateGray
        END IF

        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("fillColor", l_color)

        IF i == 1 THEN
            LET l_dx = l_x
            LET l_dy = l_y
        ELSE
            LET x = l_x
            LET y = l_y
            LET dx = l_dx
            LET dy = l_dy

            CALL l_linehdl.setAttribute("startX", dx)
            CALL l_linehdl.setAttribute("startY", dy)
            CALL l_linehdl.setAttribute("endX", x)
            CALL l_linehdl.setAttribute("endY", y)
        END IF

        LET l_dx = l_x
        LET l_dy = l_y
    END FOR

END FUNCTION

FUNCTION plot_bar_graph(l_graphid, l_plotid, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_graphid   INTEGER,
    l_plotid    INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   DECIMAL(32,16),
    l_y_scale   DECIMAL(32,16)

DEFINE
    i                INTEGER,
    j                INTEGER,
    x                INTEGER,
    y                INTEGER,
    l_x              DECIMAL(32,16),
    l_y              DECIMAL(32,16),
    l_dx             DECIMAL(32,16),
    l_y_min          DECIMAL(32,16),
    l_start_y        INTEGER,
    l_gap            INTEGER,
    l_width          INTEGER,
    l_shadow_width   INTEGER,
    l_color          STRING,
    l_shadow_color   STRING,
    l_rectanglehdl   om.DomNode

    LET j = 1
    LET l_y_min = m_graph_list[l_graphid].y_minimum
    LET l_shadow_color = m_graph_list[l_graphid].bar_shadow_color

    IF gt_string_is_empty(l_shadow_color) THEN
        LET l_shadow_color = Gt_COLOR_Black
    END IF

    LET l_shadow_width = m_graph_list[l_graphid].bar_shadow_width

    FOR i = 1 TO m_graph_list[l_graphid].plot[l_plotid].data.getLength()
        LET l_x = (i * l_x_scale) + 150
        LET l_dx = ((i + 1) * l_x_scale) + 150
        LET l_width = l_dx - l_x

        IF l_shadow_width == 0 THEN
            LET l_gap = l_width * 0.2
        ELSE
            IF l_shadow_width > 20 THEN
                LET l_gap = l_width * (l_shadow_width / 100)
            ELSE
                LET l_gap = l_width * 0.2
            END IF
        END IF

        LET l_y = m_graph_list[l_graphid].plot[l_plotid].data[i].y
        LET l_color = m_graph_list[l_graphid].plot[l_plotid].data[i].color

        IF gt_string_is_empty(l_color) THEN
            IF j > m_colors.getLength() THEN
                LET j = 1
            END IF

            LET l_color = m_colors[j]
            LET j = j + 1
        END IF

        #
        # Convert to integers
        #

        LET x = l_x
        LET y = 100 + (l_y * l_y_scale) + ((0 - l_y_min) * l_y_scale)
        LET l_start_y = 100 + ((0 - l_y_min) * l_y_scale)

        #
        # Draw the bars
        #

        LET l_rectanglehdl = l_canvas.createChild("CanvasRectangle")
        CALL l_rectanglehdl.setAttribute("fillColor", l_color)
        CALL l_rectanglehdl.setAttribute("startX", x)
        CALL l_rectanglehdl.setAttribute("startY", l_start_y)
        CALL l_rectanglehdl.setAttribute("endX", x + l_width - l_gap)
        CALL l_rectanglehdl.setAttribute("endY", y)

        #
        # Draw the shadows
        #

        IF y > 5 THEN
            LET l_rectanglehdl = l_canvas.createChild("CanvasRectangle")
            CALL l_rectanglehdl.setAttribute("fillColor", l_shadow_color)
            CALL l_rectanglehdl.setAttribute("startX", x + l_width - l_gap)
            CALL l_rectanglehdl.setAttribute("startY", l_start_y)
            LET l_width = l_width - (l_gap * 0.4)
            CALL l_rectanglehdl.setAttribute("endX", x + l_width)

            IF l_y >= 0 THEN
                CALL l_rectanglehdl.setAttribute("endY", y - 5)
            ELSE
                CALL l_rectanglehdl.setAttribute("endY", y + 5)
            END IF
        END IF
    END FOR

END FUNCTION

FUNCTION plot_pie_graph(l_graphid, l_plotid, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_graphid   INTEGER,
    l_plotid    INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   DECIMAL(32,16),
    l_y_scale   DECIMAL(32,16)

DEFINE
    i            INTEGER,
    j            INTEGER,
    y            INTEGER,
    angle        INTEGER,
    l_y          DECIMAL(32,16),
    l_total      DECIMAL(32,16),
    l_angle      DECIMAL(32,16),
    l_center     INTEGER,
    l_color      STRING,
    l_title      STRING,
    l_subtitle   STRING,
    l_archdl     om.DomNode,
    l_texthdl    om.DomNode

    LET l_title = m_graph_list[l_graphid].title
    LET l_center = 500 - ((l_title.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("startX", l_center)
    CALL l_texthdl.setAttribute("startY", 960)
    CALL l_texthdl.setAttribute("text", l_title)

    LET l_subtitle = m_graph_list[l_graphid].subtitle
    LET l_center = 500 - ((l_subtitle.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("startX", l_center)
    CALL l_texthdl.setAttribute("startY", 925)
    CALL l_texthdl.setAttribute("text", l_subtitle)

    LET j = 1
    LET l_angle = 0
    LET l_total = 0

    FOR i = 1 TO m_graph_list[l_graphid].plot[l_plotid].data.getLength()
        IF m_graph_list[l_graphid].plot[l_plotid].data[i].y >= 0 THEN
            LET l_total = l_total + m_graph_list[l_graphid].plot[l_plotid].data[i].y
        ELSE
            LET l_total = l_total + (m_graph_list[l_graphid].plot[l_plotid].data[i].y * -1)
        END IF
    END FOR

    FOR i = 1 TO m_graph_list[l_graphid].plot[l_plotid].data.getLength()
        IF m_graph_list[l_graphid].plot[l_plotid].data[i].y >= 0 THEN
            LET l_y = m_graph_list[l_graphid].plot[l_plotid].data[i].y
        ELSE
            LET l_y = m_graph_list[l_graphid].plot[l_plotid].data[i].y * -1
        END IF

        IF l_y != 0 THEN
            LET l_y = l_y * (360 / l_total)
        END IF

        LET l_color = m_graph_list[l_graphid].fillcolor

        IF gt_string_is_empty(l_color) THEN
            IF j > m_colors.getLength() THEN
                LET j = 1
            END IF

            LET l_color = m_colors[j]
            LET j = j + 1
        END IF

        LET y = l_y
        LET angle = l_angle

        LET l_archdl = l_canvas.createChild("CanvasArc")
        CALL l_archdl.setAttribute("fillColor", l_color)
        CALL l_archdl.setAttribute("startX", 100)
        CALL l_archdl.setAttribute("startY", 850)
        CALL l_archdl.setAttribute("diameter", 800)
        CALL l_archdl.setAttribute("startDegrees", angle)
        CALL l_archdl.setAttribute("extentDegrees", y)

        LET l_angle = l_angle + l_y
        LET l_color = ""
    END FOR

END FUNCTION

FUNCTION clear_graph(l_graphhdl)

DEFINE
    l_graphhdl    STRING

DEFINE
    l_canvas      STRING,
    l_node        om.DomNode,
    l_canvashdl   om.DomNode,
    l_window      ui.Window

DEFINE
    l_ok        SMALLINT,
    l_graphid   INTEGER

    LET l_ok = FALSE
    LET l_graphid = p_gt_find_graph(l_graphhdl)

    IF l_graphid > 0 THEN
        LET l_window = ui.Window.getCurrent()
        LET l_canvas = m_graph_list[l_graphid].canvas
        LET l_canvashdl = l_window.findNode("Canvas", l_canvas)
        LET l_node = l_canvashdl.getFirstChild()

        WHILE l_node IS NOT NULL
            CALL l_canvashdl.removeChild(l_node)
            LET l_node = l_canvashdl.getFirstChild()
        END WHILE

        LET l_ok = TRUE
    END IF

    CALL ui.Interface.refresh()

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# Function to find a particular graph in the list.
# @private
# @param l_graphhdl The handle to the graph.
# @return l_graphid The position of the graph in the list, 0 if not found.
#

FUNCTION p_gt_find_graph(l_graphhdl)

DEFINE
    l_graphhdl   STRING

DEFINE
    i           INTEGER,
    l_graphid   INTEGER

    LET l_graphid = 0

    FOR i = 1 TO m_graph_count
        IF m_graph_list[i].handle == l_graphhdl THEN
            LET l_graphid = i
            EXIT FOR
        END IF
    END FOR

    RETURN l_graphid

END FUNCTION

##
# Function to find a particular graph in the list.
# @private
# @param l_graphhdl The handle to the graph.
# @return l_graphid The position of the graph in the list, 0 if not found.
#

FUNCTION p_gt_find_plot(l_graphid, l_name)

DEFINE
    l_graphid    INTEGER,
    l_name   STRING

DEFINE
    i          INTEGER,
    l_plotid   INTEGER

    LET l_plotid = 0

    FOR i = 1 TO m_graph_list[l_graphid].plot.getLength()
        IF m_graph_list[l_graphid].plot[i].name == l_name THEN
            LET l_plotid = i
            EXIT FOR
        END IF
    END FOR

    RETURN l_plotid

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
