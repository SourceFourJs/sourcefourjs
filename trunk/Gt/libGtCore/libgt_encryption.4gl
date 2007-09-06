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

IMPORT util

DEFINE
   m_initialized   SMALLINT

#------------------------------------------------------------------------------#
# Function to set the WHENEVER ANY ERROR function for this module              #
#------------------------------------------------------------------------------#

FUNCTION lib_encryption_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# This function generates a random number in the range 0 to the given value.
# @param l_range The value to be used for the range.
# @return l_number The generated random number in the given range.
#

FUNCTION generate_random_number(l_range)

DEFINE
   l_range   INTEGER

   IF m_initialized != TRUE THEN
      CALL util.Math.srand()
      LET m_initialized = TRUE
   END IF

   RETURN util.Math.rand(l_range)

END FUNCTION

##
# This function encrypts the given string.
# @param l_input The string to encrypted.
# @param l_type The type of encryption to be used (XORString|MD5|None).
# @return l_encrypted_string The encrypted string.
#

FUNCTION gt_encrypt(l_input, l_type)

DEFINE
   l_input   STRING,
   l_type    STRING

DEFINE
   l_encrypted_string   STRING

   CASE
      WHEN l_type == "MD5"
         LET l_encrypted_string = md5string(l_input)

      WHEN l_type == "XORString"
         LET l_encrypted_string = xorstring(l_input, "")

      WHEN l_type == "NONE"
         LET l_encrypted_string = l_input

      OTHERWISE
         CALL gt_set_error("ERROR", SFMT(%"Invalid encryption type %1 specified", l_type))
   END CASE

   RETURN l_encrypted_string

END FUNCTION

##
# This function decrypts the given string.
# @param l_input The string to be decrypted.
# @param l_type The type of encryption the string is encrypted with.
#               (XORString|MD5|None).
# @return l_decrypted_string The decrypted string.
#

FUNCTION gt_decrypt(l_input, l_type)

DEFINE
   l_input   STRING,
   l_type    STRING

DEFINE
   l_decrypted_string   STRING

   CASE
      WHEN l_type == "MD5"
         CALL assert(FALSE, %"MD5 encrypted strings cannot be decrypted!")

      WHEN l_type == "XORString"
         LET l_decrypted_string = xorstring(l_input, "")

      WHEN l_type == "NONE"
         LET l_decrypted_string = l_input

      OTHERWISE
         DISPLAY "Invalid type"
         # Raise error
   END CASE

   RETURN l_decrypted_string

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
