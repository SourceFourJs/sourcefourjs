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

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_exception_test_id()

DEFINE
    l_id   STRING

    WHENEVER ANY ERROR CALL gt_system_error
    LET l_id = "$Id$"

END FUNCTION

##
# Function to test the exception library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_exception_lib()

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE

    CALL gt_ut_log("Populating exception list...")

    CALL gt_set_message("INFORMATIONAL", "First Message")
    CALL gt_set_warning("WARNING", "First Warning")
    CALL gt_set_error("ERROR", "First Error")

    CALL gt_set_message("INFORMATIONAL", "Second Message")
    CALL gt_set_warning("WARNING", "Second Warning")
    CALL gt_set_error("ERROR", "Second Error")

    CALL gt_set_message("INFORMATIONAL", "Third Message")
    CALL gt_set_warning("WARNING", "Third Warning")
    CALL gt_set_error("ERROR", "Third Error")

    CALL gt_ut_log("Testing gt_exception_count...")

    IF gt_exception_count() == 9 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_error_count...")

    IF gt_error_count() == 3 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_warning_count...")

    IF gt_warning_count() == 3 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_message_count...")

    IF gt_message_count() == 3 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_last_message...")

    IF gt_last_message() == "Third Message" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_last_warning...")

    IF gt_last_warning() == "Third Warning" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_last_error...")

    IF gt_last_error() == "Third Error" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_exception...")

    IF gt_exception(5) == "Second Warning" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
