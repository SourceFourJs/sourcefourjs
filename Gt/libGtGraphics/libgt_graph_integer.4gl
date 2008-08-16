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

CONSTANT Gt_GRAPH_X_MINIMUM = 0
CONSTANT Gt_GRAPH_Y_MINIMUM = 0
CONSTANT Gt_GRAPH_X_MAXIMUM = 1000
CONSTANT Gt_GRAPH_Y_MAXIMUM = 1000

#
# Basic colours taken from http://www.tayloredmktg.com/rgb/
#

# Whites/Pastels

CONSTANT Gt_COLOR_Snow                  = "#FFFAFA"
CONSTANT Gt_COLOR_Snow2                 = "#EEE9E9"
CONSTANT Gt_COLOR_Snow3                 = "#CDC9C9"
CONSTANT Gt_COLOR_Snow4                 = "#8B8989"
CONSTANT Gt_COLOR_GhostWhite            = "#F8F8FF"
CONSTANT Gt_COLOR_WhiteSmoke            = "#F5F5F5"
CONSTANT Gt_COLOR_Gainsboro             = "#DCDCDC"
CONSTANT Gt_COLOR_FloralWhite           = "#FFFAF0"
CONSTANT Gt_COLOR_OldLace               = "#FDF5E6"
CONSTANT Gt_COLOR_Linen                 = "#FAF0E6"
CONSTANT Gt_COLOR_AntiqueWhite          = "#FAEBD7"
CONSTANT Gt_COLOR_AntiqueWhite2         = "#EEDFCC"
CONSTANT Gt_COLOR_AntiqueWhite3         = "#CDC0B0"
CONSTANT Gt_COLOR_AntiqueWhite4         = "#8B8378"
CONSTANT Gt_COLOR_PapayaWhip            = "#FFEFD5"
CONSTANT Gt_COLOR_BlanchedAlmond        = "#FFEBCD"
CONSTANT Gt_COLOR_Bisque                = "#FFE4C4"
CONSTANT Gt_COLOR_Bisque2               = "#EED5B7"
CONSTANT Gt_COLOR_Bisque3               = "#CDB79E"
CONSTANT Gt_COLOR_Bisque4               = "#8B7D6B"
CONSTANT Gt_COLOR_PeachPuff             = "#FFDAB9"
CONSTANT Gt_COLOR_PeachPuff2            = "#EECBAD"
CONSTANT Gt_COLOR_PeachPuff3            = "#CDAF95"
CONSTANT Gt_COLOR_PeachPuff4            = "#8B7765"
CONSTANT Gt_COLOR_NavajoWhite           = "#FFDEAD"
CONSTANT Gt_COLOR_Moccasin              = "#FFE4B5"
CONSTANT Gt_COLOR_Cornsilk              = "#FFF8DC"
CONSTANT Gt_COLOR_Cornsilk2             = "#EEE8DC"
CONSTANT Gt_COLOR_Cornsilk3             = "#CDC8B1"
CONSTANT Gt_COLOR_Cornsilk4             = "#8B8878"
CONSTANT Gt_COLOR_Ivory                 = "#FFFFF0"
CONSTANT Gt_COLOR_Ivory2                = "#EEEEE0"
CONSTANT Gt_COLOR_Ivory3                = "#CDCDC1"
CONSTANT Gt_COLOR_Ivory4                = "#8B8B83"
CONSTANT Gt_COLOR_LemonChiffon          = "#FFFACD"
CONSTANT Gt_COLOR_Seashell              = "#FFF5EE"
CONSTANT Gt_COLOR_Seashell2             = "#EEE5DE"
CONSTANT Gt_COLOR_Seashell3             = "#CDC5BF"
CONSTANT Gt_COLOR_Seashell4             = "#8B8682"
CONSTANT Gt_COLOR_Honeydew              = "#F0FFF0"
CONSTANT Gt_COLOR_Honeydew2             = "#E0EEE0"
CONSTANT Gt_COLOR_Honeydew3             = "#C1CDC1"
CONSTANT Gt_COLOR_Honeydew4             = "#838B83"
CONSTANT Gt_COLOR_MintCream             = "#F5FFFA"
CONSTANT Gt_COLOR_Azure                 = "#F0FFFF"
CONSTANT Gt_COLOR_AliceBlue             = "#F0F8FF"
CONSTANT Gt_COLOR_Lavender              = "#E6E6FA"
CONSTANT Gt_COLOR_LavenderBlush         = "#FFF0F5"
CONSTANT Gt_COLOR_MistyRose             = "#FFE4E1"
CONSTANT Gt_COLOR_White                 = "#FFFFFF"

# Grays

CONSTANT Gt_COLOR_Black                 = "#000000"
CONSTANT Gt_COLOR_DarkSlateGray         = "#2F4F4F"
CONSTANT Gt_COLOR_DimGray               = "#696969"
CONSTANT Gt_COLOR_SlateGray             = "#708090"
CONSTANT Gt_COLOR_LightSlateGray        = "#778899"
CONSTANT Gt_COLOR_Gray                  = "#BEBEBE"
CONSTANT Gt_COLOR_LightGray             = "#D3D3D3"

# Blues

CONSTANT Gt_COLOR_MidnightBlue          = "#191970"
CONSTANT Gt_COLOR_Navy                  = "#000080"
CONSTANT Gt_COLOR_CornflowerBlue        = "#6495ED"
CONSTANT Gt_COLOR_DarkSlateBlue         = "#483D8B"
CONSTANT Gt_COLOR_SlateBlue             = "#6A5ACD"
CONSTANT Gt_COLOR_MediumSlateBlue       = "#7B68EE"
CONSTANT Gt_COLOR_LightSlateBlue        = "#8470FF"
CONSTANT Gt_COLOR_MediumBlue            = "#0000CD"
CONSTANT Gt_COLOR_RoyalBlue             = "#4169E1"
CONSTANT Gt_COLOR_Blue                  = "#0000FF"
CONSTANT Gt_COLOR_DodgerBlue            = "#1E90FF"
CONSTANT Gt_COLOR_DeepSkyBlue           = "#00BFFF"
CONSTANT Gt_COLOR_SkyBlue               = "#87CEEB"
CONSTANT Gt_COLOR_LightSkyBlue          = "#87CEFA"
CONSTANT Gt_COLOR_SteelBlue             = "#4682B4"
CONSTANT Gt_COLOR_LightSteelBlue        = "#B0C4DE"
CONSTANT Gt_COLOR_LightBlue             = "#ADD8E6"
CONSTANT Gt_COLOR_PowderBlue            = "#B0E0E6"
CONSTANT Gt_COLOR_PaleTurquoise         = "#AFEEEE"
CONSTANT Gt_COLOR_DarkTurquoise         = "#00CED1"
CONSTANT Gt_COLOR_MediumTurquoise       = "#48D1CC"
CONSTANT Gt_COLOR_Turquoise             = "#40E0D0"
CONSTANT Gt_COLOR_Cyan                  = "#00FFFF"
CONSTANT Gt_COLOR_LightCyan             = "#E0FFFF"
CONSTANT Gt_COLOR_CadetBlue             = "#5F9EA0"

# Greens

CONSTANT Gt_COLOR_MediumAquamarine      = "#66CDAA"
CONSTANT Gt_COLOR_Aquamarine            = "#7FFFD4"
CONSTANT Gt_COLOR_DarkGreen             = "#006400"
CONSTANT Gt_COLOR_DarkOliveGreen        = "#556B2F"
CONSTANT Gt_COLOR_DarkSeaGreen          = "#8FBC8F"
CONSTANT Gt_COLOR_SeaGreen              = "#2E8B57"
CONSTANT Gt_COLOR_MediumSeaGreen        = "#3CB371"
CONSTANT Gt_COLOR_LightSeaGreen         = "#20B2AA"
CONSTANT Gt_COLOR_PaleGreen             = "#98FB98"
CONSTANT Gt_COLOR_SpringGreen           = "#00FF7F"
CONSTANT Gt_COLOR_LawnGreen             = "#7CFC00"
CONSTANT Gt_COLOR_Chartreuse            = "#7FFF00"
CONSTANT Gt_COLOR_MediumSpringGreen     = "#00FA9A"
CONSTANT Gt_COLOR_GreenYellow           = "#ADFF2F"
CONSTANT Gt_COLOR_LimeGreen             = "#32CD32"
CONSTANT Gt_COLOR_YellowGreen           = "#9ACD32"
CONSTANT Gt_COLOR_ForestGreen           = "#228B22"
CONSTANT Gt_COLOR_OliveDrab             = "#6B8E23"
CONSTANT Gt_COLOR_DarkKhaki             = "#BDB76B"
CONSTANT Gt_COLOR_Khaki                 = "#F0E68C"

# Yellows

CONSTANT Gt_COLOR_PaleGoldenrod         = "#EEE8AA"
CONSTANT Gt_COLOR_LightGoldenrodYellow  = "#FAFAD2"
CONSTANT Gt_COLOR_LightYellow           = "#FFFFE0"
CONSTANT Gt_COLOR_Yellow                = "#FFFF00"
CONSTANT Gt_COLOR_Gold                  = "#FFD700"
CONSTANT Gt_COLOR_LightGoldenrod        = "#EEDD82"
CONSTANT Gt_COLOR_Goldenrod             = "#DAA520"
CONSTANT Gt_COLOR_DarkGoldenrod         = "#B8860B"

# Browns

CONSTANT Gt_COLOR_RosyBrown             = "#BC8F8F"
CONSTANT Gt_COLOR_IndianRed             = "#CD5C5C"
CONSTANT Gt_COLOR_SaddleBrown           = "#8B4513"
CONSTANT Gt_COLOR_Sienna                = "#A0522D"
CONSTANT Gt_COLOR_Peru                  = "#CD853F"
CONSTANT Gt_COLOR_Burlywood             = "#DEB887"
CONSTANT Gt_COLOR_Beige                 = "#F5F5DC"
CONSTANT Gt_COLOR_Wheat                 = "#F5DEB3"
CONSTANT Gt_COLOR_SandyBrown            = "#F4A460"
CONSTANT Gt_COLOR_Tan                   = "#D2B48C"
CONSTANT Gt_COLOR_Chocolate             = "#D2691E"
CONSTANT Gt_COLOR_Firebrick             = "#B22222"
CONSTANT Gt_COLOR_Brown                 = "#A52A2A"

# Oranges

CONSTANT Gt_COLOR_DarkSalmon            = "#E9967A"
CONSTANT Gt_COLOR_Salmon                = "#FA8072"
CONSTANT Gt_COLOR_LightSalmon           = "#FFA07A"
CONSTANT Gt_COLOR_Orange                = "#FFA500"
CONSTANT Gt_COLOR_DarkOrange            = "#FF8C00"
CONSTANT Gt_COLOR_Coral                 = "#FF7F50"
CONSTANT Gt_COLOR_LightCoral            = "#F08080"
CONSTANT Gt_COLOR_Tomato                = "#FF6347"
CONSTANT Gt_COLOR_OrangeRed             = "#FF4500"
CONSTANT Gt_COLOR_Red                   = "#FF0000"

# Pinks/Violets

CONSTANT Gt_COLOR_HotPink               = "#FF69B4"
CONSTANT Gt_COLOR_DeepPink              = "#FF1493"
CONSTANT Gt_COLOR_Pink                  = "#FFC0CB"
CONSTANT Gt_COLOR_LightPink             = "#FFB6C1"
CONSTANT Gt_COLOR_PaleVioletRed         = "#DB7093"
CONSTANT Gt_COLOR_Maroon                = "#B03060"
CONSTANT Gt_COLOR_MediumVioletRed       = "#C71585"
CONSTANT Gt_COLOR_VioletRed             = "#D02090"
CONSTANT Gt_COLOR_Violet                = "#EE82EE"
CONSTANT Gt_COLOR_Plum                  = "#DDA0DD"
CONSTANT Gt_COLOR_Orchid                = "#DA70D6"
CONSTANT Gt_COLOR_MediumOrchid          = "#BA55D3"
CONSTANT Gt_COLOR_DarkOrchid            = "#9932CC"
CONSTANT Gt_COLOR_DarkViolet            = "#9400D3"
CONSTANT Gt_COLOR_BlueViolet            = "#8A2BE2"
CONSTANT Gt_COLOR_Purple                = "#A020F0"
CONSTANT Gt_COLOR_MediumPurple          = "#9370DB"
CONSTANT Gt_COLOR_Thistle               = "#D8BFD8"

DEFINE
    m_x_size        INTEGER,
    m_y_size        INTEGER,
    m_graph_count   INTEGER,

    m_graph_list DYNAMIC ARRAY OF RECORD
        handle             STRING,
        canvas             STRING,
        no_of_plots        INTEGER,
        no_of_graphs       INTEGER,
        type               STRING,
        title              STRING,
        subtitle           STRING,
        x_label            STRING,
        x_label_color      STRING,
        y_label            STRING,
        y_label_color      STRING,
        x_minimum          INTEGER,
        y_minimum          INTEGER,
        x_maximum          INTEGER,
        y_maximum          INTEGER,
        x_no_of_ticks      INTEGER,
        x_no_of_labels     INTEGER,
        y_no_of_ticks      INTEGER,
        y_no_of_labels     INTEGER,
        fillcolor          STRING,
        draw_color         STRING,
        bar_spacing        INTEGER,
        bar_shadow_width   STRING,
        bar_shadow_color   STRING,
        #plot DYNAMIC ARRAY OF RECORD
            data DYNAMIC ARRAY OF RECORD
                color     STRING,
                x         INTEGER,
                x_label   STRING,
                y         INTEGER,
                y_label   STRING
            END RECORD
        #END RECORD
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

    LET m_x_size = 800
    LET m_y_size = 800
    LET m_graph_count = m_graph_count + 1
    LET m_graph_list[m_graph_count].handle = gt_next_serial("GRAPH")
    LET m_graph_list[m_graph_count].canvas = l_canvas
    LET m_graph_list[m_graph_count].no_of_plots = 0

    RETURN m_graph_list[m_graph_count].handle

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
            LET l_x_label_color = Gt_COLOR_Black
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
            LET l_y_label_color = Gt_COLOR_Black
        END IF

        LET m_graph_list[l_pos].y_label = l_y_label.trim()
        LET m_graph_list[l_pos].y_label_color = l_y_label_color.trim()
        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION set_min_x(l_graphhdl, l_x_min)

DEFINE
    l_graphhdl   STRING,
    l_x_min      INTEGER

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
    l_y_min      INTEGER

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
    l_x_max      INTEGER

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
    l_y_max      INTEGER

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
    l_distance   INTEGER

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

FUNCTION add_new_plot(l_graphhdl, l_name, l_type)

DEFINE
    l_graphhdl   STRING,
    l_name       STRING,
    l_type       STRING

DEFINE
    l_ok       SMALLINT,
    l_pos      INTEGER,
    l_number   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET l_number = m_graph_list[l_pos].no_of_plots
        LET l_number = l_number + 1
        LET m_graph_list[l_pos].no_of_plots = l_number
        LET m_graph_list[l_pos].type = l_type
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
            LET l_color = Gt_COLOR_Black
        END IF

        LET m_graph_list[l_pos].draw_color = l_color
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
    l_x          INTEGER,
    l_x_label    STRING,
    l_y          INTEGER,
    l_y_label    STRING,
    l_color      STRING

DEFINE
    l_ok      SMALLINT,
    l_pos     INTEGER,
    l_index   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        CALL m_graph_list[l_pos].data.appendElement()
        LET l_index = m_graph_list[l_pos].data.getLength()

        LET m_graph_list[l_pos].data[l_index].x = l_x
        LET m_graph_list[l_pos].data[l_index].x_label = l_x_label
        LET m_graph_list[l_pos].data[l_index].y = l_y
        LET m_graph_list[l_pos].data[l_index].y_label = l_y_label
        LET m_graph_list[l_pos].data[l_index].color = l_color

        IF l_x < m_graph_list[l_pos].x_minimum THEN
            LET m_graph_list[l_pos].x_minimum = l_x
        END IF

        IF l_x > m_graph_list[l_pos].x_maximum THEN
            LET m_graph_list[l_pos].x_maximum = l_x
        END IF

        IF l_y < m_graph_list[l_pos].y_minimum THEN
            LET m_graph_list[l_pos].y_minimum = l_y
        END IF

        IF l_y > m_graph_list[l_pos].y_maximum THEN
            LET m_graph_list[l_pos].y_maximum = l_y
        END IF

        LET l_ok = TRUE
    END IF

END FUNCTION

FUNCTION plot_graph(l_graphhdl, l_use_x_labels, l_use_y_labels)

DEFINE
    l_graphhdl       STRING,
    l_use_x_labels   SMALLINT,
    l_use_y_labels   SMALLINT

DEFINE
    l_ok          SMALLINT,
    l_pos         INTEGER,
    l_x           INTEGER,
    l_y           INTEGER,
    l_itmp        INTEGER,
    l_dtmp        INTEGER,
    l_x_count     SMALLINT,
    l_y_range     INTEGER,
    l_x_scale     INTEGER,
    l_y_scale     INTEGER,
    l_type        STRING,
    l_canvas      STRING,
    l_canvashdl   om.DomNode,
    l_window      ui.Window

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET l_canvas = m_graph_list[l_pos].canvas
        LET l_x_count = m_graph_list[l_pos].data.getLength()

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

        LET l_y_range = m_graph_list[l_pos].y_maximum - m_graph_list[l_pos].y_minimum

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

        LET l_type = m_graph_list[l_pos].type

        CASE
            WHEN l_type = "SCATTER"
                CALL plot_framework(l_pos, l_canvashdl, l_x_count, l_x_scale, l_use_x_labels, l_use_y_labels)
                CALL plot_scatter_graph(l_pos, l_canvashdl, l_x_scale, l_y_scale)

            WHEN l_type = "LINE"
                CALL plot_framework(l_pos, l_canvashdl, l_x_count, l_x_scale, l_use_x_labels, l_use_y_labels)
                CALL plot_line_graph(l_pos, l_canvashdl, l_x_scale, l_y_scale)

            WHEN l_type = "BAR"
                CALL plot_framework(l_pos, l_canvashdl, l_x_count, l_x_scale, l_use_x_labels, l_use_y_labels)
                CALL plot_bar_graph(l_pos, l_canvashdl, l_x_scale, l_y_scale)

            WHEN l_type = "PIE"
                CALL plot_pie_graph(l_pos, l_canvashdl, l_x, l_y)

            OTHERWISE
        END CASE
    END IF

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

FUNCTION plot_framework(l_pos, l_canvas, l_x_count, l_x_scale, l_use_x_labels, l_use_y_labels)

DEFINE
    l_pos            INTEGER,
    l_canvas         om.DomNode,
    l_x_count        INTEGER,
    l_x_scale        INTEGER,
    l_use_x_labels   SMALLINT,
    l_use_y_labels   SMALLINT

DEFINE
    l_x              INTEGER,
    l_y              INTEGER,
    l_pos1           INTEGER,
    l_count          INTEGER,
    l_start          INTEGER,
    l_x_min          INTEGER,
    l_x_max          INTEGER,
    l_y_min          INTEGER,
    l_y_max          INTEGER,
    l_tick_dx        INTEGER,
    l_tick_dy        INTEGER,
    l_label_dx       INTEGER,
    l_label_dy       INTEGER,
    l_x_tick_skip    INTEGER,
    l_y_tick_skip    INTEGER,
    l_x_label_skip   INTEGER,
    l_y_label_skip   INTEGER,
    l_max_x_label    INTEGER,
    l_char           STRING,
    l_text           STRING,
    l_label          STRING,
    l_title          STRING,
    l_subtitle       STRING,
    l_data           om.DomNode,
    l_linehdl        om.DomNode,
    l_texthdl        om.DomNode

    LET l_x_min = m_graph_list[l_pos].x_minimum
    LET l_x_max = m_graph_list[l_pos].x_maximum
    LET l_x_tick_skip = m_graph_list[l_pos].x_no_of_ticks
    LET l_x_label_skip = m_graph_list[l_pos].x_no_of_labels

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

    LET l_y_min = m_graph_list[l_pos].y_minimum
    LET l_y_max = m_graph_list[l_pos].y_maximum
    LET l_y_tick_skip = m_graph_list[l_pos].y_no_of_ticks
    LET l_y_label_skip = m_graph_list[l_pos].y_no_of_labels

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

    LET l_title = m_graph_list[l_pos].title
    LET l_start = 500 - ((l_title.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("startX", l_start)
    CALL l_texthdl.setAttribute("startY", 960)
    CALL l_texthdl.setAttribute("text", l_title)

    # Draw the subtitle

    LET l_subtitle = m_graph_list[l_pos].subtitle
    LET l_start = 500 - ((l_subtitle.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("startX", l_start)
    CALL l_texthdl.setAttribute("startY", 925)
    CALL l_texthdl.setAttribute("text", l_subtitle)

    # Draw the x-axis
    LET l_linehdl = l_canvas.createChild("CanvasLine")
    CALL l_linehdl.setAttribute("startX", 150)
    CALL l_linehdl.setAttribute("startY", 100)
    CALL l_linehdl.setAttribute("endX", (m_x_size + 150))
    CALL l_linehdl.setAttribute("endY", 100)

    # Draw the y-axis

    LET l_linehdl = l_canvas.createChild("CanvasLine")
    CALL l_linehdl.setAttribute("startX", 150)
    CALL l_linehdl.setAttribute("startY", 100)
    CALL l_linehdl.setAttribute("endX", 150)
    CALL l_linehdl.setAttribute("endY", (m_y_size + 100))

    # Draw the x-ticks

    LET l_x = l_x_min

    FOR l_x = 1 TO l_x_count
        LET l_pos1 = 150 + (l_x * l_x_scale)
        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("startX", l_pos1)
        CALL l_linehdl.setAttribute("startY", 85)
        CALL l_linehdl.setAttribute("endX", l_pos1)
        CALL l_linehdl.setAttribute("endY", 100)
    END FOR

    # Draw the x-tick values

    LET l_x = l_x_min
    LET l_max_x_label = FALSE

    FOR l_pos1 = 150 TO 950 STEP (800 / l_x_label_skip)
        LET l_texthdl = l_canvas.createChild("CanvasText")

        IF l_use_x_labels THEN
           LET l_text = m_graph_list[l_pos].data[l_count].x_label
        ELSE
            LET l_text = l_x
        END IF

        LET l_pos1 = 150 + (l_x * l_x_scale)
        LET l_start = l_pos1 - ((l_text.getLength() * 20) / 2)
        CALL l_texthdl.setAttribute("startX", l_start)
        CALL l_texthdl.setAttribute("startY", 40)
        CALL l_texthdl.setAttribute("text", l_text)

        LET l_x = l_x + l_label_dx
        LET l_count = l_count + (l_x_tick_skip / l_x_label_skip)
    END FOR

    # Draw the x-label text

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_pos].x_label_color)
    CALL l_texthdl.setAttribute("startX", 480)
    CALL l_texthdl.setAttribute("startY", 5)
    CALL l_texthdl.setAttribute("text", m_graph_list[l_pos].x_label )

    # Draw the y-ticks

    LET l_y = l_y_min

    FOR l_pos1 = 100 TO 900 STEP (800 / l_y_tick_skip)
        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("startX", 135)
        CALL l_linehdl.setAttribute("startY", l_pos1)
        CALL l_linehdl.setAttribute("endX", 150)
        CALL l_linehdl.setAttribute("endY", l_pos1)

        LET l_y = l_y + l_tick_dy
    END FOR

    # Draw the y-tick values

    LET l_count = 1
    LET l_y = l_y_min

    FOR l_pos1 = 100 TO 900 STEP (800 / l_y_label_skip)
        LET l_texthdl = l_canvas.createChild("CanvasText")

        IF l_use_y_labels THEN
           LET l_text = m_graph_list[l_pos].data[l_count].y_label
        ELSE
            LET l_text = l_y
        END IF

        LET l_start = 110 - (l_text.getLength() * 20)
        CALL l_texthdl.setAttribute("startX", l_start)
        CALL l_texthdl.setAttribute("startY", l_pos1 - 15)
        CALL l_texthdl.setAttribute("text", l_text)

        LET l_y = l_y + l_label_dy
        LET l_count = l_count + (l_y_tick_skip / l_y_label_skip)
    END FOR

    # Draw the y-label text

    LET l_label = m_graph_list[l_pos].y_label

    FOR l_pos1 = 1 TO l_label.getLength()
        LET l_char = l_label.getCharAt(l_pos1)
        LET l_texthdl = l_canvas.createChild("CanvasText")
        CALL l_texthdl.setAttribute("fillColor", m_graph_list[l_pos].y_label_color)
        CALL l_texthdl.setAttribute("startX", 10)
        CALL l_texthdl.setAttribute("startY", 700 - (l_pos1 * 48))
        CALL l_texthdl.setAttribute("text", l_char)
    END FOR

END FUNCTION

FUNCTION plot_scatter_graph(l_pos, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_pos       INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   INTEGER,
    l_y_scale   INTEGER

DEFINE
    i             INTEGER,
    l_x           INTEGER,
    l_y           INTEGER,
    l_dx          INTEGER,
    l_dy          INTEGER,
    l_x_min       INTEGER,
    l_y_min       INTEGER,
    l_color       STRING,
    l_linehdl     om.DomNode

    LET l_dx = NULL
    LET l_dy = NULL

    LET l_x_min = m_graph_list[l_pos].x_minimum
    LET l_y_min = m_graph_list[l_pos].y_minimum

    FOR i = 1 TO m_graph_list[l_pos].data.getLength()
        LET l_x = m_graph_list[l_pos].data[i].x
        LET l_x = i * l_x_scale + 150

        LET l_y = m_graph_list[l_pos].data[i].y
        LET l_y = l_y * l_y_scale - (l_y_min * l_y_scale) + 100

        LET l_color = m_graph_list[l_pos].data[i].color

        IF gt_string_is_empty(l_color) THEN
            LET l_color = "black"
        END IF

        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("fillColor", l_color)
        CALL l_linehdl.setAttribute("startX", (l_x))
        CALL l_linehdl.setAttribute("startY", (l_y - 5))
        CALL l_linehdl.setAttribute("endX", (l_x))
        CALL l_linehdl.setAttribute("endY", (l_y + 5))

        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("fillColor", l_color)
        CALL l_linehdl.setAttribute("startX", (l_x - 5))
        CALL l_linehdl.setAttribute("startY", (l_y))
        CALL l_linehdl.setAttribute("endX", (l_x + 5))
        CALL l_linehdl.setAttribute("endY", (l_y))
    END FOR

END FUNCTION

FUNCTION plot_line_graph(l_pos, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_pos       INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   INTEGER,
    l_y_scale   INTEGER

DEFINE
    i           INTEGER,
    l_x         INTEGER,
    l_y         INTEGER,
    l_dx        INTEGER,
    l_dy        INTEGER,
    l_y_min     INTEGER,
    l_color     STRING,
    l_linehdl   om.DomNode

    LET l_dx = NULL
    LET l_dy = NULL

    FOR i = 1 TO m_graph_list[l_pos].data.getLength()
        LET l_x = m_graph_list[l_pos].data[i].x
        LET l_x = i * l_x_scale + 150

        LET l_y = m_graph_list[l_pos].data[i].y
        LET l_y = l_y * l_y_scale - (l_y_min * l_y_scale) + 100

        LET l_color = m_graph_list[l_pos].data[i].color

        IF gt_string_is_empty(l_color) THEN
            LET l_color = "black"
        END IF

        LET l_linehdl = l_canvas.createChild("CanvasLine")
        CALL l_linehdl.setAttribute("fillColor", l_color)

        IF l_dx IS NULL OR l_dy IS NULL THEN
            LET l_dx = l_x
            LET l_dy = l_y
        ELSE
            CALL l_linehdl.setAttribute("startX", l_dx)
            CALL l_linehdl.setAttribute("startY", l_dy)
            CALL l_linehdl.setAttribute("endX", l_x)
            CALL l_linehdl.setAttribute("endY", l_y)
        END IF

        LET l_dx = l_x
        LET l_dy = l_y
    END FOR

END FUNCTION

FUNCTION plot_bar_graph(l_pos, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_pos       INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   INTEGER,
    l_y_scale   INTEGER

DEFINE
    i                INTEGER,
    l_x              INTEGER,
    l_y              INTEGER,
    l_dx             INTEGER,
    l_gap            INTEGER,
    l_width          INTEGER,
    l_shadow_width   INTEGER,
    l_color          STRING,
    l_shadow_color   STRING,
    l_rectanglehdl   om.DomNode

    LET l_shadow_color = m_graph_list[l_pos].bar_shadow_color

    IF gt_string_is_empty(l_shadow_color) THEN
        LET l_shadow_color = "cyan"
    END IF

    LET l_shadow_width = m_graph_list[l_pos].bar_shadow_width

    FOR i = 1 TO m_graph_list[l_pos].data.getLength()
        LET l_x = i * l_x_scale + 150 - l_x_scale / 2
        LET l_dx = (i + 1) * l_x_scale + 150 -l_x_scale / 2
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

        LET l_y = m_graph_list[l_pos].data[i].y
        LET l_y = l_y * l_y_scale + 100

        LET l_color = m_graph_list[l_pos].data[i].color

        IF gt_string_is_empty(l_color) THEN
            LET l_color = "yellow"
        END IF

        LET l_rectanglehdl = l_canvas.createChild("CanvasRectangle")
        CALL l_rectanglehdl.setAttribute("fillColor", l_color)
        CALL l_rectanglehdl.setAttribute("startX", l_x)
        CALL l_rectanglehdl.setAttribute("startY", 100)
        CALL l_rectanglehdl.setAttribute("endX", l_x + l_width - l_gap)
        CALL l_rectanglehdl.setAttribute("endY", l_y)

        IF l_y > 105 THEN
            LET l_rectanglehdl = l_canvas.createChild("CanvasRectangle")
            CALL l_rectanglehdl.setAttribute("fillColor", l_shadow_color)
            CALL l_rectanglehdl.setAttribute("startX", l_x + l_width - l_gap)
            CALL l_rectanglehdl.setAttribute("startY", 100)
            LET l_width = l_width - (l_gap * 0.4)
            CALL l_rectanglehdl.setAttribute("endX", l_x + l_width)
            CALL l_rectanglehdl.setAttribute("endY", l_y - 5)
        END IF
    END FOR

END FUNCTION

FUNCTION plot_pie_graph(l_pos, l_canvas, l_x_scale, l_y_scale)

DEFINE
    l_pos       INTEGER,
    l_canvas    om.DomNode,
    l_x_scale   INTEGER,
    l_y_scale   INTEGER

DEFINE
    i            INTEGER,
    l_y          INTEGER,
    l_count      INTEGER,
    l_total      INTEGER,
    l_angle      INTEGER,
    l_center     INTEGER,
    l_color      STRING,
    l_title      STRING,
    l_subtitle   STRING,
    l_archdl     om.DomNode,
    l_texthdl    om.DomNode

    LET l_title = m_graph_list[l_pos].title
    LET l_center = 500 - ((l_title.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("startX", l_center)
    CALL l_texthdl.setAttribute("startY", 960)
    CALL l_texthdl.setAttribute("text", l_title)

    LET l_subtitle = m_graph_list[l_pos].subtitle
    LET l_center = 500 - ((l_subtitle.getLength() * 20) / 2)

    LET l_texthdl = l_canvas.createChild("CanvasText")
    CALL l_texthdl.setAttribute("startX", l_center)
    CALL l_texthdl.setAttribute("startY", 925)
    CALL l_texthdl.setAttribute("text", l_subtitle)

    LET l_angle = 0
    LET l_count = 0
    LET l_total = 0

    FOR i = 1 TO m_graph_list[l_pos].data.getLength()
        LET l_count = l_count + 1
        LET l_total = l_total + m_graph_list[l_pos].data[i].y
    END FOR

    LET l_count = 0

    FOR i = 1 TO m_graph_list[l_pos].data.getLength()
        LET l_y = m_graph_list[l_pos].data[i].y

        IF l_y != 0 THEN
            LET l_y = (360 / l_total) * l_y
        END IF

        LET l_color = m_graph_list[l_pos].fillcolor

        IF gt_string_is_empty(l_color) THEN
            CASE
                WHEN l_count MOD 3 == 0
                    LET l_color = "yellow"

                WHEN l_count MOD 3 == 1
                    LET l_color = "red"

                WHEN l_count MOD 3 == 2
                    LET l_color = "blue"

                OTHERWISE
                    LET l_color = "black"
            END CASE
        END IF

        LET l_archdl = l_canvas.createChild("CanvasArc")
        CALL l_archdl.setAttribute("fillColor", l_color)
        CALL l_archdl.setAttribute("startX", 100)
        CALL l_archdl.setAttribute("startY", 850)
        CALL l_archdl.setAttribute("diameter", 800)
        CALL l_archdl.setAttribute("startDegrees", l_angle)
        CALL l_archdl.setAttribute("extentDegrees", l_y)

        LET l_angle = l_angle + l_y
        LET l_count = l_count + 1
        LET l_color = ""
    END FOR

END FUNCTION

FUNCTION set_number_of_graphs(l_graphhdl, l_number)

DEFINE
    l_graphhdl   STRING,
    l_number     INTEGER

DEFINE
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET m_graph_list[l_pos].no_of_graphs = l_number
        LET l_ok = TRUE
    END IF

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
    l_ok    SMALLINT,
    l_pos   INTEGER

    LET l_ok = FALSE
    LET l_pos = p_gt_find_graph(l_graphhdl)

    IF l_pos > 0 THEN
        LET l_window = ui.Window.getCurrent()
        LET l_canvas = m_graph_list[l_pos].canvas
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
# @return l_pos The position of the graph in the list, 0 if not found.
#

FUNCTION p_gt_find_graph(l_graphhdl)

DEFINE
    l_graphhdl   STRING

DEFINE
    i       INTEGER,
    l_pos   INTEGER

    LET l_pos = 0

    FOR i = 1 TO m_graph_count
        IF m_graph_list[i].handle == l_graphhdl THEN
            LET l_pos = i
            EXIT FOR
        END IF
    END FOR

    RETURN l_pos

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
