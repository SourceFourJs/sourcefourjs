# $Id$
#------------------------------------------------------------------------------#
# Copyright (c) 2007 Scott Newton <scottn@ihug.co.nz>                          #
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
# Unit Test Library
# @category System Library
# @author Scott Newton
# @date August 2007
# @version $Id$
#

DEFINE
   m_log_count       INTEGER,
   m_results_count   INTEGER,

   m_log       DYNAMIC ARRAY OF STRING,
   m_results   DYNAMIC ARRAY OF RECORD
      module   STRING,
      result   STRING
   END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_unittest_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function to initialise the unit testing system.
#

FUNCTION ut_init()

   LET m_log_count = 0
   LET m_results_count = 0
   CALL m_log.clear()
   CALL m_results.clear()
   CALL ui.interface.loadstyles("gt.4st")

   CLOSE WINDOW SCREEN

   OPEN WINDOW lib_unittest WITH FORM "lib_unittest"

   CALL ui.Dialog.setDefaultUnbuffered(TRUE)
   CALL ui.interface.loadactiondefaults("lib_unittest.4ad")
   CALL ui.interface.loadtopmenu("lib_unittest.4tm")
   CALL ui.interface.loadtoolbar("lib_unittest.4tb")

   DIALOG

   DISPLAY ARRAY m_results TO results_scr.*
   DISPLAY ARRAY m_log TO log_scr.*

      ON ACTION run
         CALL run_tests()

      ON ACTION cancel
         EXIT DIALOG

      ON ACTION close
         EXIT DIALOG

      ON ACTION help

      ON ACTION about

   END DIALOG

   CLOSE WINDOW lib_unittest

END FUNCTION

##
# Function to display the unit test results
# @param l_module The module being tested.
# @param l_result TRUE if the test was successful, FALSE otherwise.
#

FUNCTION ut_result(l_module, l_result)

DEFINE
   l_module   STRING,
   l_result   SMALLINT

   LET m_results_count = m_results_count + 1
   LET m_results[m_results_count].module = l_module

   IF l_result THEN
      LET m_results[m_results_count].result = "Passed"
      #CALL DIALOG.setArrayAttributes("", att)
   ELSE
      LET m_results[m_results_count].result = "FAILED"
   END IF

   CALL ui.interface.refresh()

END FUNCTION

##
# Function to display the unit test details.
# @param l_log The entry to log.
#

FUNCTION ut_log(l_log)

DEFINE
   l_log   STRING

   LET m_log_count = m_log_count + 1
   LET m_log[m_log_count] = l_log
   CALL ui.interface.refresh()

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#