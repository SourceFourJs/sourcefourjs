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

FUNCTION libgt_pop3_client_test_id()

DEFINE
    l_id   STRING

    WHENEVER ANY ERROR CALL gt_system_error
    LET l_id = "$Id$"

END FUNCTION

##
# Function to test the pop3 client library.
# @return l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_pop3_client_lib(l_pop3_server, l_pop3_port, l_username, l_password)

DEFINE
    l_pop3_server   STRING,
    l_pop3_port     INTEGER,
    l_username      STRING,
    l_password      STRING

DEFINE
    l_ok             SMALLINT,
    l_size           INTEGER,
    l_number         INTEGER,
    l_connections    INTEGER,
    l_bytesread      FLOAT,
    l_byteswritten   FLOAT,
    l_message        STRING,
    l_serverhdl      STRING

    CALL gt_ut_log("Testing gt_pop3_client_init...")
    CALL gt_pop3_client_init()

    CALL gt_ut_log("Testing gt_connect_to_pop3_server...")

    CALL gt_connect_to_pop3_server(l_pop3_server, l_pop3_port)
        RETURNING l_ok, l_serverhdl

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_username...")

    CALL gt_pop3_username(l_serverhdl, l_username)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_password...")

    CALL gt_pop3_password(l_serverhdl, l_password)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_status...")

    CALL gt_pop3_status(l_serverhdl)
        RETURNING l_ok, l_number, l_size

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_list...")

    CALL gt_pop3_list(l_serverhdl, l_number)
        RETURNING l_ok, l_size

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_retrieve...")

    CALL gt_pop3_retrieve(l_serverhdl, l_number)
        RETURNING l_ok, l_size, l_message

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_quit...")

    CALL gt_pop3_quit(l_serverhdl)
        RETURNING l_ok

    IF l_ok THEN
        CALL gt_ut_log("Passed")
    ELSE
        CALL gt_ut_log("FAILED")
        CALL gt_ut_log(gt_last_error())
        RETURN FALSE
    END IF

    CALL gt_ut_log("Testing gt_pop3_client_statistics...")

    CALL gt_pop3_client_statistics()
        RETURNING l_connections, l_bytesread, l_byteswritten

    CALL gt_ut_log("POP3 Client Statistics:")
    CALL gt_ut_log("No of Connections    : " || l_connections)
    CALL gt_ut_log("Total Bytes Read     : " || l_bytesread)
    CALL gt_ut_log("Total Bytes Written : " || l_byteswritten)

    RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
