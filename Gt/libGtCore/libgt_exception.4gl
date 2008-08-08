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
# Exception handling library.
# @category System Library
# @author Scott Newton
# @date August 2007
# @version $Id$
#

DEFINE
    m_count   INTEGER,

    m_exception_list DYNAMIC ARRAY OF RECORD
        type        STRING,
        code        STRING,
        text        STRING,
        mident      STRING,
        backtrace   STRING
    END RECORD

#------------------------------------------------------------------------------#
# Function to set ID and WHENEVER ANY ERROR                                    #
#------------------------------------------------------------------------------#

FUNCTION libgt_exception_id()

DEFINE
    l_id   STRING

    WHENEVER ANY ERROR CALL gt_system_error
    LET l_id = "$Id$"

END FUNCTION

##
# The final resting place of the program on an unrecoverable error.
#

FUNCTION gt_system_error()

    LET m_count = m_count + 1
    LET m_exception_list[m_count].type = "CRITICAL"
    LET m_exception_list[m_count].code = ""
    LET m_exception_list[m_count].text = ""
    LET m_exception_list[m_count].mident = ""
    LET m_exception_list[m_count].backtrace = base.application.getStackTrace()

END FUNCTION

##
# Function to abort the program. Should only be used when from a programming
# side there is no way to gracefully recover and should never have occurred in
# the first place.
# @param l_exception_code The exception code of the error.
# @param l_text The text of the error.
#

FUNCTION gt_set_abort(l_exception_code, l_text)

DEFINE
    l_exception_code   STRING,
    l_text             STRING

    LET m_count = m_count + 1
    LET m_exception_list[m_count].type = "ERROR"
    LET m_exception_list[m_count].code = l_exception_code.trim()
    LET m_exception_list[m_count].text = l_text.trim()
    LET m_exception_list[m_count].mident = ""
    LET m_exception_list[m_count].backtrace = base.application.getStackTrace()

    EXIT PROGRAM 1

END FUNCTION

##
# Function to set an error.
# @param l_exception_code The exception code of the error.
# @param l_text The text of the error.
#

FUNCTION gt_set_error(l_exception_code, l_text)

DEFINE
    l_exception_code   STRING,
    l_text             STRING

    LET m_count = m_count + 1
    LET m_exception_list[m_count].type = "ERROR"
    LET m_exception_list[m_count].code = l_exception_code.trim()
    LET m_exception_list[m_count].text = l_text.trim()
    LET m_exception_list[m_count].mident = ""
    LET m_exception_list[m_count].backtrace = base.application.getStackTrace()

END FUNCTION

##
# Function to set a warning.
# @param l_exception_code The exception code of the warning.
# @param l_text The text of the warning.
#

FUNCTION gt_set_warning(l_exception_code, l_text)

DEFINE
    l_exception_code   STRING,
    l_text             STRING

    LET m_count = m_count + 1
    LET m_exception_list[m_count].type = "WARNING"
    LET m_exception_list[m_count].code = l_exception_code.trim()
    LET m_exception_list[m_count].text = l_text.trim()
    LET m_exception_list[m_count].mident = ""

END FUNCTION

##
# Function to set a message.
# @param l_exception_code The exception code of the message.
# @param l_text The text of the message.
#

FUNCTION gt_set_message(l_exception_code, l_text)

DEFINE
    l_exception_code   STRING,
    l_text             STRING

    LET m_count = m_count + 1
    LET m_exception_list[m_count].type = "INFORMATIONAL"
    LET m_exception_list[m_count].code = l_exception_code.trim()
    LET m_exception_list[m_count].text = l_text.trim()

END FUNCTION

##
# Function to get the last exception raised.
# @return m_exception_list.type The type of the exception.
# @return m_exception_list.code The code of the last exception.
# @return m_exception_list.text The text of the last exception.
# @return m_exception_list.mident The mident of the last exception.
# @return m_exception_list.backtrace. The backtrace from the last exception.
#                                     This is only valid for errors.
#

FUNCTION gt_last_exception()

    IF m_count == 0 THEN
        RETURN NULL, NULL, NULL, NULL, NULL
    END IF

    RETURN m_exception_list[m_count].type,
             m_exception_list[m_count].code,
             m_exception_list[m_count].text,
             m_exception_list[m_count].mident,
             m_exception_list[m_count].backtrace

END FUNCTION

##
# Function to get the last error raised.
# @return m_exception_list.type The type of the exception.
# @return m_exception_list.code The code of the last exception.
# @return m_exception_list.text The text of the last exception.
# @return m_exception_list.mident The mident of the last exception.
# @return m_exception_list.backtrace. The backtrace from the last exception.
#                                     This is only valid for errors.
#

FUNCTION gt_last_error()

DEFINE
    i   INTEGER

    FOR i = m_count TO 1 STEP -1
        IF m_exception_list[i].type == "ERROR" THEN
            RETURN m_exception_list[i].text
        END IF
    END FOR

    RETURN NULL

END FUNCTION

##
# Function to get the last exception raised.
# @return m_exception_list.type The type of the exception.
# @return m_exception_list.code The code of the last exception.
# @return m_exception_list.text The text of the last exception.
# @return m_exception_list.mident The mident of the last exception.
# @return m_exception_list.backtrace. The backtrace from the last exception.
#                                     This is only valid for errors.
#

FUNCTION gt_last_warning()

DEFINE
    i   INTEGER

    FOR i = m_count TO 1 STEP -1
        IF m_exception_list[i].type == "WARNING" THEN
            RETURN m_exception_list[i].text
        END IF
    END FOR

    RETURN NULL

END FUNCTION

##
# Function to get the last exception raised.
# @return m_exception_list.type The type of the exception.
# @return m_exception_list.code The code of the last exception.
# @return m_exception_list.text The text of the last exception.
# @return m_exception_list.mident The mident of the last exception.
# @return m_exception_list.backtrace. The backtrace from the last exception.
#                                     This is only valid for errors.
#

FUNCTION gt_last_message()

DEFINE
    i   INTEGER

    FOR i = m_count TO 1 STEP -1
        IF m_exception_list[i].type == "INFORMATIONAL" THEN
            RETURN m_exception_list[i].text
        END IF
    END FOR

    RETURN NULL

END FUNCTION

##
# Function to return the number of exceptions in the exception list.
# @return The number of exceptions in the exception list.


FUNCTION gt_exception_count()

    RETURN m_count

END FUNCTION

##
# Function to return the number of errors in the exception list.
# @return l_errors The number of errors.
#

FUNCTION gt_error_count()

DEFINE
    i          INTEGER,
    l_errors   INTEGER

    LET l_errors = 0

    FOR i = 1 TO m_count
        IF m_exception_list[i].type == "ERROR" THEN
            LET l_errors = l_errors + 1
        END IF
    END FOR

    RETURN l_errors

END FUNCTION

##
# Function to return the number of warnings in the exception list.
# @return l_warnings The number of warnings.
#

FUNCTION gt_warning_count()

DEFINE
    i            INTEGER,
    l_warnings   INTEGER

    LET l_warnings = 0

    FOR i = 1 TO m_count
        IF m_exception_list[i].type == "WARNING" THEN
            LET l_warnings = l_warnings + 1
        END IF
    END FOR

    RETURN l_warnings
END FUNCTION

##
# Function to return the number of messages in the exception list.
# @return l_messages The number of messages.
#

FUNCTION gt_message_count()

DEFINE
    i            INTEGER,
    l_messages   INTEGER

    LET l_messages = 0

    FOR i = 1 TO m_count
        IF m_exception_list[i].type == "INFORMATIONAL" THEN
            LET l_messages = l_messages + 1
        END IF
    END FOR

    RETURN l_messages

END FUNCTION

##
# This function returns a particular exception.
# @return m_exception_list.type The type of the exception.
# @return m_exception_list.code The code of the last exception.
# @return m_exception_list.text The text of the last exception.
# @return m_exception_list.mident The mident of the last exception.
# @return m_exception_list.backtrace. The backtrace from the last exception.
#                                     This is only valid for errors.
#


FUNCTION gt_exception(l_count)

DEFINE
    l_count   INTEGER

    IF l_count > m_exception_list.getlength() THEN
        RETURN NULL
    END IF

    RETURN m_exception_list[l_count].text

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
