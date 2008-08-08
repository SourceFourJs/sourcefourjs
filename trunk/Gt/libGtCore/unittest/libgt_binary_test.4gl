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

FUNCTION libgt_binary_test_id()

DEFINE
    l_id   STRING

    WHENEVER ANY ERROR CALL gt_system_error
    LET l_id = "$Id$"

END FUNCTION

##
# Function to test the binary library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_binary_lib()

DEFINE
    l_byte   INTEGER,
    l_word   INTEGER,
    l_long   FLOAT

    LET l_byte = 256 / 2
    LET l_word = 65536 / 2
    LET l_long = 4294967296.0 / 2

    CALL gt_ut_log("Testing gt_rotateleftlong...")

    IF gt_rotateleftlong(l_long, 3) == 4.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_rotaterightlong...")

    IF gt_rotaterightlong(l_long, 3) == 268435456.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_shiftleftlong...")

    IF gt_shiftleftlong(l_long, 3) == 0.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_shiftrightlong...")

    IF gt_shiftrightlong(l_long, 3) == 268435456.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_rotateleft...")

    IF gt_rotateleft(l_word, 3) == 4 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_rotateright...")

    IF gt_rotateright(l_word, 3) == 4096 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_shiftleft...")

    IF gt_shiftleft(l_word, 3) == 0 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_shiftright...")

    IF gt_shiftright(l_word, 3) == 4096 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_byte2binary...")

    IF gt_byte2binary(l_byte) == "10000000" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_word2binary...")

    IF gt_word2binary(l_word) == "1000000000000000" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_long2binary...")

    IF gt_long2binary(l_long) == "10000000000000000000000000000000" THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_binary2byte...")

    IF gt_binary2byte("10000000") == l_byte THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_binary2word...")

    IF gt_binary2word("1000000000000000") == l_word THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_binary2long...")

    IF gt_binary2long("10000000000000000000000000000000") == l_long THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitclearbyte...")

    IF gt_bitclearbyte(l_byte, 3) == 128 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitclearword...")

    IF gt_bitclearword(l_word, 3) == 32768 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitclearlong...")

    IF gt_bitclearlong(l_long, 3) == 2147483648.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitsetbyte...")

    IF gt_bitsetbyte(l_byte, 3) == 132 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitsetword...")

    IF gt_bitsetword(l_word, 3) == 32772 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitsetlong...")

    IF gt_bitsetlong(l_long, 3) == 2147483652.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitorbyte...")

    IF gt_bitorbyte(128, 64) == 192 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitorword...")

    IF gt_bitorword(32768, 16384) == 49152 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitorlong...")

    IF gt_bitorlong(2147483648.00, 1073741824.00) == 3221225472.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitandbyte...")

    IF gt_bitandbyte(128, 64) == 0 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitandword...")

    IF gt_bitandword(32768, 16384) == 0 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitandlong...")

    IF gt_bitandlong(2147483648.00, 1073741824.00) == 0.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitxorbyte...")

    IF gt_bitxorbyte(128, 64) == 192 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitxorword...")

    IF gt_bitxorword(32768, 16384) == 49152 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitxorlong...")

    IF gt_bitxorlong(2147483648.00, 1073741824.00) == 3221225472.00 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitnotbyte...")

    IF gt_bitnotbyte(l_byte) == 127 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitnotword...")

    IF gt_bitnotword(l_word) == 32767 THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_bitnotlong...")

    IF gt_bitnotlong(l_long) == 2147483647.00 THEN
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
