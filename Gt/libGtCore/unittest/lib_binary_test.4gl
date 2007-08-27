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

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION lib_binary_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the binary library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_binary_lib()


   CALL ut_log("Testing rotateleftlong...")
   CALL ut_log(rotateleftlong("10001000000100011000100000010001", 3))
   RETURN FALSE

   CALL ut_log("Testing rotaterightlong...")
   CALL ut_log(rotaterightlong("10001000000100011000100000010001", 3))

   CALL ut_log("Testing shiftleftlong...")
   CALL ut_log(shiftleftlong("10001000000100011000100000010001", 3))

   CALL ut_log("Testing shiftrightlong...")
   CALL ut_log(shiftrightlong("10001000000100011000100000010001", 3))

   CALL ut_log("Testing rotateleft...")
   CALL ut_log(rotateleft("1000100000010001", 3))

   CALL ut_log("Testing rotateright...")
   CALL ut_log(rotateright("1000100000010001", 3))

   CALL ut_log("Testing shiftleft...")
   CALL ut_log(shiftleft("1000100000010001", 3))

   CALL ut_log("Testing shiftright...")
   CALL ut_log(shiftright("1000100000010001", 3))
   RETURN FALSE

   CALL ut_log("Testing byte2binary...")

   CALL ut_log("Testing word2binary...")

   CALL ut_log("Testing long2binary...")

   CALL ut_log("Testing binary2byte...")

   CALL ut_log("Testing binary2word...")

   CALL ut_log("Testing binary2long...")

   CALL ut_log("Testing bitclearbyte...")

   CALL ut_log("Testing bitclearword...")

   CALL ut_log("Testing bitclearlong...")

   CALL ut_log("Testing bitsetbyte...")

   CALL ut_log("Testing bitsetword...")

   CALL ut_log("Testing bitsetlong...")

   CALL ut_log("Testing bitorbyte...")

   CALL ut_log("Testing bitorword...")

   CALL ut_log("Testing bitorlong...")

   CALL ut_log("Testing bitandbyte...")

   CALL ut_log("Testing bitandword...")

   CALL ut_log("Testing bitandlong...")

   CALL ut_log("Testing bitxorbyte...")

   CALL ut_log("Testing bitxorword...")

   CALL ut_log("Testing bitxorlong...")

   CALL ut_log("Testing bitnotbyte...")

   CALL ut_log("Testing bitnotword...")

   CALL ut_log("Testing bitnotlong...")

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#