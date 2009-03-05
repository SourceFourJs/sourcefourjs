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

FUNCTION libgt_validator_test_id()

DEFINE
    l_id   STRING

    WHENEVER ANY ERROR CALL gt_system_error
    LET l_id = "$Id$"

END FUNCTION

##
# Function to test
# @return l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_validator_lib()

DEFINE
    l_ok   SMALLINT

    CALL gt_ut_log("Testing string required with blank string ...")

    CALL gt_validator("STRING", "REQUIRED", "")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string required with valid string ...")

    CALL gt_validator("STRING", "REQUIRED", "DATA")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string minimum length with string to short ...")

    CALL gt_validator("STRING", "MINLENGTH=5", "DATA")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string minimum length with valid string ...")

    CALL gt_validator("STRING", "MINLENGTH=4", "DATA")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string maximum length with string to long ...")

    CALL gt_validator("STRING", "MAXLENGTH=3", "DATA")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string maximum length with valid string ...")

    CALL gt_validator("STRING", "MAXLENGTH=4", "DATA")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string alphaonly with invalid string ...")

    CALL gt_validator("STRING", "ALPHAONLY", "Data_0")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string alphaonly with valid string ...")

    CALL gt_validator("STRING", "ALPHAONLY", "Data_")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string alphanumeric with invalid string ...")

    CALL gt_validator("STRING", "ALPHANUMERIC", "Data-0")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string alphanumeric with valid string ...")

    CALL gt_validator("STRING", "ALPHANUMERIC", "Data_0")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string uppercase with invalid string ...")

    CALL gt_validator("STRING", "UPPERCASE", "Data_0")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string uppercase with valid string ...")

    CALL gt_validator("STRING", "ALPHANUMERIC", "DATA_0")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string lowercase with invalid string ...")

    CALL gt_validator("STRING", "LOWERCASE", "Data_0")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string lowercase with valid string ...")

    CALL gt_validator("STRING", "LOWERCASE", "data_0")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string regex with invalid string...")

    CALL gt_validator("STRING", "REGEX=\\s+\\w+", " TEST_TEST!")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string regex with valid string...")

    CALL gt_validator("STRING", "REGEX=\\s+\\w+", " TEST_TEST")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string regex with invalid string...")

    CALL gt_validator("STRING", "REGEX=^EDI\\w+", "EDL009")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string regex with valid string...")

    CALL gt_validator("STRING", "REGEX=^EDI\\w+", "EDI009")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string regex with invalid string...")

    CALL gt_validator("STRING", "REGEX=\\d+.\\d+.\\d+.\\d+", "10.19.48-0")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string regex with valid string...")

    CALL gt_validator("STRING", "REGEX=\\d+.\\d+.\\d+.\\d+", "10.19.48.0")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string mask with invalid string...")

    CALL gt_validator("STRING", "MASK=XXX#XXXXXXX", "AATT#AAAAAA")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string mask with invalid string...")

    CALL gt_validator("STRING", "MASK=XXX#XXXXXXX", "AATT#AAAAAA")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string mask with valid string...")

    CALL gt_validator("STRING", "MASK=XXX#XXXXXXX", "AAT#J0001XC")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string sql with invalid string...")

    CALL gt_validator("STRING", "SQL=SELECT UNIQUE lutabid FROM lukup WHERE lutabid = ? ", "QQ")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing string sql with valid string...")

    CALL gt_validator("STRING", "SQL=SELECT UNIQUE lutabid FROM lukup WHERE lutabid = ? ", "CA")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric required with invalid number ...")

    CALL gt_validator("NUMERIC", "REQUIRED", "")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric required with valid number ...")

    CALL gt_validator("NUMERIC", "REQUIRED", 0)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric integer with invalid number ...")

    CALL gt_validator("NUMERIC", "INTEGER", 1.1)
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric integer with valid number ...")

    CALL gt_validator("NUMERIC", "INTEGER", 1)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric decimal with invalid number ...")

    CALL gt_validator("NUMERIC", "DECIMAL", "1..1")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric decimal with valid number ...")

    CALL gt_validator("NUMERIC", "DECIMAL", 1.1)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric range with invalid number ...")

    CALL gt_validator("NUMERIC", "RANGE=1-10", 11)
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric range with valid number ...")

    CALL gt_validator("NUMERIC", "RANGE=1-10", 5)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric minvalue with invalid number ...")

    CALL gt_validator("NUMERIC", "MINVALUE=5", 1)
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric minvalue with valid number ...")

    CALL gt_validator("NUMERIC", "MINVALUE=5", 10)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric maxvalue with invalid number ...")

    CALL gt_validator("NUMERIC", "MAXVALUE=5", 10)
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric maxvalue with valid number ...")

    CALL gt_validator("NUMERIC", "MAXVALUE=5", 2)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric mask with invalid number...")

    CALL gt_validator("NUMERIC", "MASK=ddddd.dd", 123.456)
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric mask with valid number...")

    CALL gt_validator("NUMERIC", "MASK=ddddd.dd", 123.45)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric mask with invalid number...")

    CALL gt_validator("NUMERIC", "MASK=(ddd) ddd-dddd", "(064) 3219876")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing numeric mask with valid number...")

    CALL gt_validator("NUMERIC", "MASK=(ddd) ddd-dddd", "(064) 321-9876" )
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing code required with invalid code ...")

    CALL gt_validator("CODE", "REQUIRED", "")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing code required with valid code ...")

    CALL gt_validator("CODE", "REQUIRED", "T")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing code values with invalid code (matchcase=FALSE) ...")

    CALL gt_validator("CODE", "VALUES=[A|B|C]", "x")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing code values with valid code (matchcase=FALSE) ...")

    CALL gt_validator("CODE", "VALUES=[A|B|C]", "b")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing code values with invalid code (matchcase=TRUE) ...")

    CALL gt_validator("CODE", "VALUES=[A|B|C], MATCHCASE=TRUE", "b")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing code values with valid code (matchcase=TRUE) ...")

    CALL gt_validator("CODE", "VALUES=[A|B|C], MATCHCASE=TRUE", "B")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path required with invalid path ...")

    CALL gt_validator("PATH", "REQUIRED", "")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path required with valid path ...")

    CALL gt_validator("PATH", "REQUIRED", "/quanta/scott")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path mustexist with nonexistent path ...")

    CALL gt_validator("PATH", "MUSTEXIST", "/quanta/scott/abc")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path mustexist with existing path ...")

    CALL gt_validator("PATH", "MUSTEXIST", "/quanta/scott")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path create with nonexistent path ...")

    CALL gt_validator("PATH", "CREATE", "/quanta/scott/xyz/abc")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path create with existing path ...")

    CALL gt_validator("PATH", "CREATE", "/quanta/scott")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    #CALL delete_directory_tree("/quanta/scott/xyz", TRUE, FALSE)
    #    RETURNING l_ok

    CALL gt_ut_log("Testing path format = SHARE with invalid path ...")

    CALL gt_validator("PATH", "FORMAT=SHARE", "\\share\test")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = SHARE with valid path ...")

    CALL gt_validator("PATH", "FORMAT=SHARE", "\\\\share\\test")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = WIN32 with invalid drive letter ...")

    CALL gt_validator("PATH", "FORMAT=WIN32", "\\\\share\\test")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = WIN32 with no drive separator ...")

    CALL gt_validator("PATH", "FORMAT=WIN32", "c\\share\\test")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = WIN32 with invalid path ...")

    CALL gt_validator("PATH", "FORMAT=WIN32", "c:\\share\test")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = WIN32 with valid path ...")

    CALL gt_validator("PATH", "FORMAT=WIN32", "c:\\share\\test")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = UNIX with invalid characters in name ...")

    CALL gt_validator("PATH", "FORMAT=UNIX", "/share/t_3-st.#")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = UNIX with invalid path ...")

    CALL gt_validator("PATH", "FORMAT=UNIX", "c:/share/test")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing path format = UNIX with valid path ...")

    CALL gt_validator("PATH", "FORMAT=UNIX", "/share/test")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing date required with invalid date ...")

    CALL gt_validator("DATE", "REQUIRED", "")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing date required with valid date ...")

    CALL gt_validator("DATE", "REQUIRED", "31/07/2004")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF


    CALL gt_ut_log("Testing date with invalid date ...")

    CALL gt_validator("DATE", "", "31/31/2004")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing date with valid date ...")

    CALL gt_validator("DATE", "", "31/01/2004")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing datetime required with invalid datetime ...")

    CALL gt_validator("DATETIME", "REQUIRED", "")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing datetime required with valid datetime ...")

    CALL gt_validator("DATETIME", "REQUIRED", "2004-07-31 00:00:00.000")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF


    CALL gt_ut_log("Testing datetime with invalid datetime ...")

    CALL gt_validator("DATETIME", "", "2004-31-31 00:00:00.000")
        RETURNING l_ok

    IF NOT l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing datetime with valid datetime ...")

    CALL gt_validator("DATETIME", "", "2004-07-31 00:00:00.000")
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
