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

FUNCTION libgt_encryption_test_id()

DEFINE
    l_id   STRING

    WHENEVER ANY ERROR CALL gt_system_error
    LET l_id = "$Id$"

END FUNCTION

##
# Function to test the encryption library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_encryption_lib()

DEFINE
    l_string   STRING

    LET l_string = ASCII(42), ASCII(70), ASCII(84), ASCII(84),
                   ASCII(51), ASCII(93), ASCII(90), ASCII(79),
                   ASCII(75), ASCII(66)

    CALL gt_ut_log("Testing gt_XORString encryption...")

    IF gt_xorstring("TestString", "") == l_string THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_XORString decryption...")

    IF gt_xorstring(l_string, "") == "TestString" THEN
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
