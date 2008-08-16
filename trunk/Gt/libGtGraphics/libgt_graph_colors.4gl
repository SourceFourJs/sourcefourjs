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

GLOBALS
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
    CONSTANT Gt_COLOR_Green                 = "#00FF00"
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
END GLOBALS

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
