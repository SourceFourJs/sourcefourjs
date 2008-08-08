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
# Test controller module for libgtformat.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

MAIN

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

    CALL gt_ut_init()

END MAIN

##
# Function which controls the tests for libgtformat.
#

FUNCTION run_tests()

DEFINE
    l_all           SMALLINT,
    i               INTEGER,
    l_smtp_port     INTEGER,
    l_to            STRING,
    l_from          STRING,
    l_smtp_server   STRING

    LET l_all = FALSE

    IF gt_find_argument("all") THEN
        LET l_all = TRUE
    END IF

    IF base.application.getargumentcount() == 0 THEN
        DISPLAY "Argument Count = ", base.application.getargumentcount()
        LET l_all = TRUE
    END IF

    IF l_all OR gt_find_argument("xhtml") THEN
        CALL gt_ut_log("******* XHTML Format Library *******")
        CALL gt_ut_result("XHTML Format Library", TRUE)
    END IF

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
