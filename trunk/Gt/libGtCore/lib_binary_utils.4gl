# $Id$
#------------------------------------------------------------------------------#
# Based on the original work by Dietmar Bos                                    #
# Copyright (c) September 2002 Dietmar Bos <Dietmar.Bos@gmx.net>               #
# URL: http://www.iiug.org/software/archive/binary                             #
#                                                                              #
# binary.README in the source reads as follows for this module:                #
#                                                                              #
# Hello,                                                                       #
#                                                                              #
# I would like to contribute to the software repository.                       #
#                                                                              #
# The file bin.4gl is a 4GL module that contains all the functionality needed  #
# to have binary arithmetic in 4GL. The problem was, that on our machine was   #
# no C-compiler installed, but we could have made good use of binary math,     #
# for password encryption for instance.                                        #
#                                                                              #
# As a result I wrote this module that has all in it: AND,OR,XOR,NOT as binary #
# operators, together with bit rotation and shifting and negation.             #
#                                                                              #
# Due to the nature of how I had to do it, it is not really fast, so no one    #
# should apply this on mass media, but for every day usage, like password      #
# encryption it is more than sufficient.                                       #
#                                                                              #
# I hope you can make use of the code.                                         #
#                                                                              #
# Kind regards,                                                                #
#                                                                              #
# Dietmar Bos                                                                  #
#------------------------------------------------------------------------------#
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
# Binary Arithmetic Utilitys Library
# @category System Library
# @author Dietmar Bos
# @author Scott Newton
# @date August 2007
# @version $Id$
#

DEFINE
    m_ascii_table_initialized   SMALLINT,
    m_ascii_table               CHAR(256)

#------------------------------------------------------------------------------#
# Function to set the WHENEVER ANY ERROR function for this module              #
#------------------------------------------------------------------------------#

FUNCTION lib_binary_utils_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# This function returns the ASCII value of a character.
# @param l_source The input character.
# @return l_source The ASCII value of the character.
#

FUNCTION gt_asc(l_string)

DEFINE
   l_string   CHAR(1)

DEFINE
   i   SMALLINT

   # init table if not done already
   IF NOT m_ascii_table_initialized THEN
        LET m_ascii_table_initialized = TRUE

        FOR i = 1 TO 256
            LET m_ascii_table[i,i] = ASCII i
        END FOR
    END IF

    FOR i = 1 TO 256
        IF l_string[1,1] == m_ascii_table[i] THEN
            RETURN i
            EXIT FOR
        END IF
    END FOR

    # still nothing found, return 0 as an error
    RETURN 0

END FUNCTION

##
# This function returns the ASCII character associated with a number.
# @param l_source The input number.
# @return l_source The ASCII character of that number.
#

FUNCTION gt_chr(l_char)

DEFINE
   l_char   SMALLINT

DEFINE
   i   SMALLINT

   # init table if not done already
   IF NOT m_ascii_table_initialized THEN
      LET m_ascii_table_initialized = TRUE

      FOR i = 1 TO 256
         LET m_ascii_table[i,i] = ASCII i
      END FOR
   END IF

   IF l_char > 0 AND l_char < 257 THEN
      RETURN m_ascii_table[l_char]
   ELSE
      RETURN 0
   END IF

END FUNCTION

##
# This method xor's a string. The major advantage of XORString is that two
# identical calls of this function, where the result of the first call is passed
# as an argument to the second call,gives the original input as the result. The
# disadvantage is if your encryption key has the same characters at the same
# position as the string to encrypt - then we end up with 0 (NULL) characters
# (n xor n -> 0). 0 charaters are hard to handle in 4GL so take care that if you
# must do your own encryption key that it consists of characters that do not
# appear in the string to encrypt.Basically you're safe to not pass an
# encryption key anyway. The code takes care of it on its own then and ensures
# no 0-clashes if the string to encrypt is plain ASCII.
# @param l_text The input text.
# @param l_crypt The string to use for encryption. Pass in NULL if you want
#                the routine to use it's own internal encryption string.
# @return l_result The encrypted string.
#

FUNCTION gt_xorstring(l_text, l_crypt)

DEFINE
   l_text    STRING,
   l_crypt   STRING

DEFINE
   i          SMALLINT,
   l_length   SMALLINT,
   l_tmp      STRING,
   l_result   STRING

   LET l_tmp = ""
   LET l_result = ""

   IF l_crypt.getLength() == 0 THEN
     	LET l_crypt = ASCII(126), ASCII(35),  ASCII(39),  ASCII(180),
                    ASCII(96),  ASCII(41),  ASCII(40),  ASCII(38),
						  ASCII(37),  ASCII(37),  ASCII(36),  ASCII(167),
						  ASCII(178), ASCII(179), ASCII(91),  ASCII(93),
						  ASCII(33),  ASCII(63),  ASCII(125), ASCII(123)
   END IF

   WHILE l_crypt.getLength() < 1024
      LET l_crypt = l_crypt, l_crypt
   END WHILE

   LET l_length = l_text.getLength()

   FOR i = 1 TO l_length
      LET l_result = l_result, gt_chr(gt_bitxorbyte(gt_asc(l_text.getCharAt(i)), gt_asc(l_crypt.getCharAt(i))))
   END FOR

   RETURN l_result.subString(1, l_length)

END FUNCTION

##
# This function converts a hexadecimal value to decimal.
# @param l_hex The hexadecimal input.
# @return l_result The decimal output.
#

FUNCTION gt_hex2dec(l_hex)

DEFINE
   l_hex   STRING

DEFINE
   i          SMALLINT,
   l_length   SMALLINT,
   l_value    SMALLINT,
   l_result   FLOAT,
   l_char     STRING

   LET l_result = 0
   LET l_hex = l_hex.toUpperCase()

   IF l_hex.getLength() > 8 THEN
      LET l_hex = l_hex.subString(1, 8)
   END IF

   LET l_length = l_hex.getLength()

   FOR i = 0 TO l_length - 1
      LET l_char = l_hex.getCharAt(l_hex.getLength() - i)
      LET l_value = 0

      CASE
         WHEN l_char == "0"
            LET l_value = l_char
         WHEN l_char == "1"
            LET l_value = l_char
         WHEN l_char == "2"
            LET l_value = l_char
         WHEN l_char == "3"
            LET l_value = l_char
         WHEN l_char == "4"
            LET l_value = l_char
         WHEN l_char == "5"
            LET l_value = l_char
         WHEN l_char == "6"
            LET l_value = l_char
         WHEN l_char == "7"
            LET l_value = l_char
         WHEN l_char == "8"
            LET l_value = l_char
         WHEN l_char == "9"
            LET l_value = l_char
         WHEN l_char == "A"
            LET l_value = 10
         WHEN l_char == "B"
            LET l_value = 11
         WHEN l_char == "C"
            LET l_value = 12
         WHEN l_char == "D"
            LET l_value = 13
         WHEN l_char == "E"
            LET l_value = 14
         WHEN l_char == "F"
            LET l_value = 15
      END CASE

      LET l_result = l_result + (l_value * (16 ** i))

   END FOR

   RETURN l_result

END FUNCTION

##
# This function converts a decimal value to hexadecimal.
# @param l_hex The decimal input.
# @return l_result The hexadecimal output.
#

FUNCTION gt_dec2hex(l_decimal)

DEFINE
   l_decimal   FLOAT

DEFINE
   l_modulus   SMALLINT,
   l_old       SMALLINT,
   l_table     CHAR(16),
   l_hex       CHAR(64)

   LET l_hex = ""
   LET l_table = "0123456789ABCDEF"

   WHILE l_decimal > 0
      LET l_modulus = l_decimal MOD 16

      IF l_decimal - l_modulus <= 0 THEN
         LET l_hex = l_hex clipped, l_table[l_modulus+1, l_modulus+1]
         LET l_decimal = 0
      ELSE
         LET l_decimal = l_decimal - l_modulus
         LET l_old = l_decimal
         LET l_decimal = l_decimal / 16
         LET l_hex = l_hex clipped, l_table[l_modulus+1, l_modulus+1]
      END IF
   END WHILE

   IF Length(l_hex) MOD 2 <> 0 THEN
      LET l_hex = l_hex clipped,"0"
   END IF

   RETURN gt_string_reverse(l_hex clipped)

END FUNCTION

##
# This function converts a number to EBCDIC format.
# @param l_number The input number.
# @return l_BCD The EBCDIC output.
#

FUNCTION gt_num2BCD(l_number)

DEFINE
   l_number   INTEGER

DEFINE
   i          SMALLINT,
   l_length   SMALLINT,
   l_string   STRING,
   l_BCD      STRING

   LET l_BCD = ""
   LET l_string = l_number
   LET l_string = l_string.trimLeft()

   IF l_string.getLength() MOD 2 <> 0 THEN
      LET l_string = "0", l_string
   END IF

   LET l_length = l_string.getLength()

   FOR i = 0 TO (l_length / 2) - 1
      LET l_BCD = l_BCD, gt_chr(l_string.subString((i * 2) + 1, 2))
   END FOR

   RETURN l_BCD

END FUNCTION

##
# This function converts a number an EBCDIC number to decimal.
# @param l_BCD The EBCDIC input.
# @return l_number The decimal output.
#

FUNCTION gt_BCD2num(l_BCD)

DEFINE
   l_BCD   STRING

DEFINE
   i          SMALLINT,
   l_length   SMALLINT,
   l_number   INTEGER,
   l_string   STRING,
   l_copy     STRING

   LET l_string = ""
   LET l_copy = l_BCD
   LET l_length = l_copy.getLength()

   FOR i = 1 TO l_length
      LET l_string = l_string, gt_asc(l_copy.subString(i, 1))
   END FOR

   LET l_number=l_string

   RETURN l_number

END FUNCTION

##
# This function reverses the given string.
# @param l_text The string reverse.
# @return l_copy The reversed output.
#

FUNCTION gt_string_reverse(l_text)

DEFINE
   l_text   STRING

DEFINE
   i          SMALLINT,
   l_length   INTEGER,
   l_copy     STRING

   LET l_copy = ""
   LET l_length = l_text.getLength()

   FOR i = 1 TO l_length
      LET l_copy = l_copy, l_text.getCharAt(l_length - i + 1)
   END FOR

   RETURN l_copy

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
