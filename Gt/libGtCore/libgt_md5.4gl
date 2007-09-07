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
# MD5 Library (RFC 1321)
# @category System Library
# @author Scott Newton
# @date August 2007
# @version $Id$
#

CONSTANT S11 = 7
CONSTANT S12 = 12
CONSTANT S13 = 17
CONSTANT S14 = 22
CONSTANT S21 = 5
CONSTANT S22 = 9
CONSTANT S23 = 14
CONSTANT S24 = 20
CONSTANT S31 = 4
CONSTANT S32 = 11
CONSTANT S33 = 16
CONSTANT S34 = 23
CONSTANT S41 = 6
CONSTANT S42 = 10
CONSTANT S43 = 15
CONSTANT S44 = 21

DEFINE
   m_initialized         SMALLINT,
   m_state               ARRAY[4] OF FLOAT,
   m_count               ARRAY[2] OF FLOAT,
   m_buffer              ARRAY[64] OF FLOAT,
   m_padding             ARRAY[64] OF FLOAT,
   m_digest              ARRAY[16] OF FLOAT,
   m_encryption_string   CHAR(128),
   m_encryption_array    ARRAY[2,128] OF CHAR(1)

#------------------------------------------------------------------------------#
# Function to set the WHENEVER ANY ERROR function for this module              #
#------------------------------------------------------------------------------#

FUNCTION libgt_md5_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# This function calculates the MD5 value for the given string.
# @param l_input The string to calculate the MD5 value for.
# @return l_md5 The MD5 value of the string
#

FUNCTION gt_md5string(l_input)

DEFINE
   l_input   STRING

DEFINE
   i          INTEGER,
   l_length   INTEGER,
   l_x        STRING,
   l_tmp      STRING,
   l_string   ARRAY[1024] OF FLOAT

   LET l_length = l_input.getLength()

   FOR i = 1 TO l_length
      LET l_string[i] = gt_asc(l_input.getCharAt(i))
   END FOR

   FOR i = l_length + 1 TO 1024
      LET l_string[i] = NULL
   END FOR

   CALL p_gt_md5init()
   CALL p_gt_md5update(l_string, l_length)
   CALL p_gt_md5final()

   FOR i = 1 TO 16
      LET l_tmp = gt_dec2hex(m_digest[i])

      CASE
         WHEN l_tmp.getLength() == 0
            LET l_x = l_x, "00"

         WHEN l_tmp.getLength() == 1
            LET l_x = l_x, "0", l_tmp

         OTHERWISE
            LET l_x = l_x, l_tmp
      END CASE
   END FOR

   RETURN l_x

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This function initialises the MD5 variables
#

FUNCTION p_gt_md5init()

DEFINE
   i   INTEGER

   LET m_count[1] = 0
   LET m_count[2] = 0

   LET m_state[1] = gt_hex2dec("67452301")
   LET m_state[2] = gt_hex2dec("efcdab89")
   LET m_state[3] = gt_hex2dec("98badcfe")
   LET m_state[4] = gt_hex2dec("10325476")

   LET m_buffer[1] = NULL

   FOR i = 2 TO 64
      LET m_buffer[i] = m_buffer[1]
   END FOR

   LET m_padding[1] = gt_hex2dec("80")
   LET m_padding[2] = NULL

   FOR i = 3 TO 64
      LET m_padding[i] = m_padding[2]
   END FOR

END FUNCTION

##
# This function does the updating of the MD5 values.
# @param l_input The input to the MD5 update.
# @param l_inputLen The length of the input.
#

FUNCTION p_gt_md5update(l_input, l_inputLen)

DEFINE
   l_input      ARRAY[1024] OF FLOAT,
   l_inputLen   INTEGER

DEFINE
   i           INTEGER,
   j           INTEGER,
   l_index     INTEGER,
   l_partLen   INTEGER,
   l_part      ARRAY[64] OF FLOAT

   LET l_index = gt_bitandlong(gt_shiftrightlong(m_count[1], 3), gt_hex2dec("3f"))
   LET m_count[1] = p_gt_truncate32(m_count[1] + gt_shiftleftlong(l_inputLen, 3))

   IF m_count[1] < gt_shiftleftlong(l_inputLen, 3) THEN
      LET m_count[2] = m_count[2] + 1
   END IF

   LET m_count[2] = p_gt_truncate32(m_count[2] + gt_shiftrightlong(l_inputLen, 29))
   LET l_partLen = 64 - l_index

   IF l_inputLen >= l_partLen THEN
      FOR j = 1 TO l_partLen
         LET m_buffer[l_index + j] = l_input[j]
      END FOR

      CALL p_gt_md5transform(m_buffer)

      FOR i = l_partLen TO (i + 63 < l_inputLen) STEP 64
         FOR j = 1 TO 64
            LET l_part[j] = l_input[i + j]
         END FOR

         CALL p_gt_md5transform(l_part)
      END FOR

      LET l_index = 0
   ELSE
      LET i = 0
   END IF

   FOR j = 1 TO (l_inputLen - i)
      LET m_buffer[l_index + j] = l_input[i + j]
   END FOR

END FUNCTION

##
# This function does the finalizing of the MD5 value.
#

FUNCTION p_gt_md5final()

DEFINE
   i INTEGER,
   j INTEGER,
   l_bits     ARRAY[1024] OF FLOAT,
   l_index    INTEGER,
   l_padLen   INTEGER

   LET i = 1

   FOR j = 1 TO 8 STEP 4
      LET l_bits[j] = gt_bitandlong(m_count[i], gt_hex2dec("ff"))
      LET l_bits[j + 1] = gt_bitandlong(gt_shiftrightlong(m_count[i], 8), gt_hex2dec("ff"))
      LET l_bits[j + 2] = gt_bitandlong(gt_shiftrightlong(m_count[i], 16), gt_hex2dec("ff"))
      LET l_bits[j + 3] = gt_bitandlong(gt_shiftrightlong(m_count[i], 24), gt_hex2dec("ff"))

      LET l_bits[j] = p_gt_truncate32(l_bits[j])
      LET l_bits[j + 1] = p_gt_truncate32(l_bits[j + 1])
      LET l_bits[j + 2] = p_gt_truncate32(l_bits[j + 2])
      LET l_bits[j + 3] = p_gt_truncate32(l_bits[j + 3])

      LET i = i + 1
   END FOR

   LET l_index = p_gt_truncate32(gt_bitandlong(gt_shiftrightlong(m_count[1], 3), gt_hex2dec("3f")))

   IF l_index < 56 THEN
      LET l_padLen = 56 - l_index
   ELSE
      LET l_padLen = 120 - l_index
   END IF

   CALL p_gt_md5update(m_padding, l_padLen)
   CALL p_gt_md5update(l_bits, 8)

   LET i = 1

   FOR j = 1 TO 16 STEP 4
      LET m_digest[j] = gt_bitandlong(m_state[i], gt_hex2dec("ff"))
      LET m_digest[j + 1] = gt_bitandlong(gt_shiftrightlong(m_state[i], 8), gt_hex2dec("ff"))
      LET m_digest[j + 2] = gt_bitandlong(gt_shiftrightlong(m_state[i], 16), gt_hex2dec("ff"))
      LET m_digest[j + 3] = gt_bitandlong(gt_shiftrightlong(m_state[i], 24), gt_hex2dec("ff"))

      LET m_digest[j] = p_gt_truncate32(m_digest[j])
      LET m_digest[j + 1] = p_gt_truncate32(m_digest[j + 1])
      LET m_digest[j + 2] = p_gt_truncate32(m_digest[j + 2])
      LET m_digest[j + 3] = p_gt_truncate32(m_digest[j + 3])

      LET i = i + 1
   END FOR

   FOR i = 1 TO 4
      LET m_state[i] = 0
   END FOR

   FOR i = 1 TO 2
      LET m_count[i] = 0
   END FOR

   FOR i = 1 to 64
      LET m_buffer[i] = 0
   END FOR

END FUNCTION

##
# This function does the transformations converting the string into the MD5
# value.
# @param l_block The input to the transformtion.
#

FUNCTION p_gt_md5transform(l_block)

DEFINE
   l_block   ARRAY[64] OF FLOAT

DEFINE
   i       INTEGER,
   j       INTEGER,
   l_a     FLOAT,
   l_b     FLOAT,
   l_c     FLOAT,
   l_d     FLOAT,
   l_tmp   FLOAT,
   l_x     ARRAY[16] OF FLOAT

   LET l_a = m_state[1]
   LET l_b = m_state[2]
   LET l_c = m_state[3]
   LET l_d = m_state[4]

   LET l_x[1] = 0

   FOR i = 2 TO 16
      LET l_x[i] = l_x[1]
   END FOR

   LET i = 1

   FOR j = 1 TO 64 STEP 4
      LET l_tmp = p_gt_truncate32(l_block[j])
      LET l_tmp = p_gt_truncate32(gt_bitorlong(l_tmp, gt_shiftleftlong(p_gt_truncate32(l_block[j + 1]), 8)))
      LET l_tmp = p_gt_truncate32(gt_bitorlong(l_tmp, gt_shiftleftlong(p_gt_truncate32(l_block[j + 2]), 16)))
      LET l_tmp = p_gt_truncate32(gt_bitorlong(l_tmp, gt_shiftleftlong(p_gt_truncate32(l_block[j + 3]), 24)))
      LET l_x[i] = l_tmp

      LET i = i + 1
   END FOR

   LET l_a = p_gt_ff(l_a, l_b, l_c, l_d, l_x[ 1], S11, gt_hex2dec("d76aa478"))   # 1
   LET l_d = p_gt_ff(l_d, l_a, l_b, l_c, l_x[ 2], S12, gt_hex2dec("e8c7b756"))   # 2
   LET l_c = p_gt_ff(l_c, l_d, l_a, l_b, l_x[ 3], S13, gt_hex2dec("242070db"))   # 3
   LET l_b = p_gt_ff(l_b, l_c, l_d, l_a, l_x[ 4], S14, gt_hex2dec("c1bdceee"))   # 4

   LET l_a = p_gt_ff(l_a, l_b, l_c, l_d, l_x[ 5], S11, gt_hex2dec("f57c0faf"))   # 5
   LET l_d = p_gt_ff(l_d, l_a, l_b, l_c, l_x[ 6], S12, gt_hex2dec("4787c62a"))   # 6
   LET l_c = p_gt_ff(l_c, l_d, l_a, l_b, l_x[ 7], S13, gt_hex2dec("a8304613"))   # 7
   LET l_b = p_gt_ff(l_b, l_c, l_d, l_a, l_x[ 8], S14, gt_hex2dec("fd469501"))   # 8

   LET l_a = p_gt_ff(l_a, l_b, l_c, l_d, l_x[ 9], S11, gt_hex2dec("698098d8"))   # 9
   LET l_d = p_gt_ff(l_d, l_a, l_b, l_c, l_x[10], S12, gt_hex2dec("8b44f7af"))   # 10
   LET l_c = p_gt_ff(l_c, l_d, l_a, l_b, l_x[11], S13, gt_hex2dec("ffff5bb1"))   # 11
   LET l_b = p_gt_ff(l_b, l_c, l_d, l_a, l_x[12], S14, gt_hex2dec("895cd7be"))   # 12

   LET l_a = p_gt_ff(l_a, l_b, l_c, l_d, l_x[13], S11, gt_hex2dec("6b901122"))   # 13
   LET l_d = p_gt_ff(l_d, l_a, l_b, l_c, l_x[14], S12, gt_hex2dec("fd987193"))   # 14
   LET l_c = p_gt_ff(l_c, l_d, l_a, l_b, l_x[15], S13, gt_hex2dec("a679438e"))   # 15
   LET l_b = p_gt_ff(l_b, l_c, l_d, l_a, l_x[16], S14, gt_hex2dec("49b40821"))   # 16

   LET l_a = p_gt_gg(l_a, l_b, l_c, l_d, l_x[ 2], S21, gt_hex2dec("f61e2562"))   # 17
   LET l_d = p_gt_gg(l_d, l_a, l_b, l_c, l_x[ 7], S22, gt_hex2dec("c040b340"))   # 18
   LET l_c = p_gt_gg(l_c, l_d, l_a, l_b, l_x[12], S23, gt_hex2dec("265e5a51"))   # 19
   LET l_b = p_gt_gg(l_b, l_c, l_d, l_a, l_x[ 1], S24, gt_hex2dec("e9b6c7aa"))   # 20

   LET l_a = p_gt_gg(l_a, l_b, l_c, l_d, l_x[ 6], S21, gt_hex2dec("d62f105d"))   # 21
   LET l_d = p_gt_gg(l_d, l_a, l_b, l_c, l_x[11], S22, gt_hex2dec("02441453"))   # 22
   LET l_c = p_gt_gg(l_c, l_d, l_a, l_b, l_x[16], S23, gt_hex2dec("d8a1e681"))   # 23
   LET l_b = p_gt_gg(l_b, l_c, l_d, l_a, l_x[ 5], S24, gt_hex2dec("e7d3fbc8"))   # 24

   LET l_a = p_gt_gg(l_a, l_b, l_c, l_d, l_x[10], S21, gt_hex2dec("21e1cde6"))   # 25
   LET l_d = p_gt_gg(l_d, l_a, l_b, l_c, l_x[15], S22, gt_hex2dec("c33707d6"))   # 26
   LET l_c = p_gt_gg(l_c, l_d, l_a, l_b, l_x[ 4], S23, gt_hex2dec("f4d50d87"))   # 27
   LET l_b = p_gt_gg(l_b, l_c, l_d, l_a, l_x[ 9], S24, gt_hex2dec("455a14ed"))   # 28

   LET l_a = p_gt_gg(l_a, l_b, l_c, l_d, l_x[14], S21, gt_hex2dec("a9e3e905"))   # 29
   LET l_d = p_gt_gg(l_d, l_a, l_b, l_c, l_x[ 3], S22, gt_hex2dec("fcefa3f8"))   # 30
   LET l_c = p_gt_gg(l_c, l_d, l_a, l_b, l_x[ 8], S23, gt_hex2dec("676f02d9"))   # 31
   LET l_b = p_gt_gg(l_b, l_c, l_d, l_a, l_x[13], S24, gt_hex2dec("8d2a4c8a"))   # 32

   LET l_a = p_gt_hh(l_a, l_b, l_c, l_d, l_x[ 6], S31, gt_hex2dec("fffa3942"))   # 33
   LET l_d = p_gt_hh(l_d, l_a, l_b, l_c, l_x[ 9], S32, gt_hex2dec("8771f681"))   # 34
   LET l_c = p_gt_hh(l_c, l_d, l_a, l_b, l_x[12], S33, gt_hex2dec("6d9d6122"))   # 35
   LET l_b = p_gt_hh(l_b, l_c, l_d, l_a, l_x[15], S34, gt_hex2dec("fde5380c"))   # 36

   LET l_a = p_gt_hh(l_a, l_b, l_c, l_d, l_x[ 2], S31, gt_hex2dec("a4beea44"))   # 37
   LET l_d = p_gt_hh(l_d, l_a, l_b, l_c, l_x[ 5], S32, gt_hex2dec("4bdecfa9"))   # 38
   LET l_c = p_gt_hh(l_c, l_d, l_a, l_b, l_x[ 8], S33, gt_hex2dec("f6bb4b60"))   # 39
   LET l_b = p_gt_hh(l_b, l_c, l_d, l_a, l_x[11], S34, gt_hex2dec("bebfbc70"))   # 40

   LET l_a = p_gt_hh(l_a, l_b, l_c, l_d, l_x[14], S31, gt_hex2dec("289b7ec6"))   # 41
   LET l_d = p_gt_hh(l_d, l_a, l_b, l_c, l_x[ 1], S32, gt_hex2dec("eaa127fa"))   # 42
   LET l_c = p_gt_hh(l_c, l_d, l_a, l_b, l_x[ 4], S33, gt_hex2dec("d4ef3085"))   # 43
   LET l_b = p_gt_hh(l_b, l_c, l_d, l_a, l_x[ 7], S34, gt_hex2dec("04881d05"))   # 44

   LET l_a = p_gt_hh(l_a, l_b, l_c, l_d, l_x[10], S31, gt_hex2dec("d9d4d039"))   # 45
   LET l_d = p_gt_hh(l_d, l_a, l_b, l_c, l_x[13], S32, gt_hex2dec("e6db99e5"))   # 46
   LET l_c = p_gt_hh(l_c, l_d, l_a, l_b, l_x[16], S33, gt_hex2dec("1fa27cf8"))   # 47
   LET l_b = p_gt_hh(l_b, l_c, l_d, l_a, l_x[ 3], S34, gt_hex2dec("c4ac5665"))   # 48

   LET l_a = p_gt_ii(l_a, l_b, l_c, l_d, l_x[ 1], S41, gt_hex2dec("f4292244"))   # 49
   LET l_d = p_gt_ii(l_d, l_a, l_b, l_c, l_x[ 8], S42, gt_hex2dec("432aff97"))   # 50
   LET l_c = p_gt_ii(l_c, l_d, l_a, l_b, l_x[15], S43, gt_hex2dec("ab9423a7"))   # 51
   LET l_b = p_gt_ii(l_b, l_c, l_d, l_a, l_x[ 6], S44, gt_hex2dec("fc93a039"))   # 52

   LET l_a = p_gt_ii(l_a, l_b, l_c, l_d, l_x[13], S41, gt_hex2dec("655b59c3"))   # 53
   LET l_d = p_gt_ii(l_d, l_a, l_b, l_c, l_x[ 4], S42, gt_hex2dec("8f0ccc92"))   # 54
   LET l_c = p_gt_ii(l_c, l_d, l_a, l_b, l_x[11], S43, gt_hex2dec("ffeff47d"))   # 55
   LET l_b = p_gt_ii(l_b, l_c, l_d, l_a, l_x[ 2], S44, gt_hex2dec("85845dd1"))   # 56

   LET l_a = p_gt_ii(l_a, l_b, l_c, l_d, l_x[ 9], S41, gt_hex2dec("6fa87e4f"))   # 57
   LET l_d = p_gt_ii(l_d, l_a, l_b, l_c, l_x[16], S42, gt_hex2dec("fe2ce6e0"))   # 58
   LET l_c = p_gt_ii(l_c, l_d, l_a, l_b, l_x[ 7], S43, gt_hex2dec("a3014314"))   # 59
   LET l_b = p_gt_ii(l_b, l_c, l_d, l_a, l_x[14], S44, gt_hex2dec("4e0811a1"))   # 60

   LET l_a = p_gt_ii(l_a, l_b, l_c, l_d, l_x[ 5], S41, gt_hex2dec("f7537e82"))   # 61
   LET l_d = p_gt_ii(l_d, l_a, l_b, l_c, l_x[12], S42, gt_hex2dec("bd3af235"))   # 62
   LET l_c = p_gt_ii(l_c, l_d, l_a, l_b, l_x[ 3], S43, gt_hex2dec("2ad7d2bb"))   # 63
   LET l_b = p_gt_ii(l_b, l_c, l_d, l_a, l_x[10], S44, gt_hex2dec("eb86d391"))   # 64

   LET m_state[1] = m_state[1] + l_a
   LET m_state[2] = m_state[2] + l_b
   LET m_state[3] = m_state[3] + l_c
   LET m_state[4] = m_state[4] + l_d

   LET m_state[1] = p_gt_truncate32(m_state[1])
   LET m_state[2] = p_gt_truncate32(m_state[2])
   LET m_state[3] = p_gt_truncate32(m_state[3])
   LET m_state[4] = p_gt_truncate32(m_state[4])

END FUNCTION

##
# This function truncates the value of the given float to be equivalent to that
# of a 32 bit integer. This is required as the float values can go higher than
# a 32 bit integer.
# @param l_a The value to check.
# @return l_a The truncated value.
#

FUNCTION p_gt_truncate32(l_a)

DEFINE
   l_a FLOAT

   WHILE l_a >= 4294967296.0
      LET l_a = l_a - 4294967296.0
   END WHILE

   RETURN l_a

END FUNCTION

##
# One of the MD5 transformation functions.
# @param l_a First input.
# @param l_b Second input.
# @param l_c Third input.
# @param l_d Fourth input.
# @param l_x Fifth input.
# @param l_s Sixth input.
# @param l_ac Seventh input.
# @return l_a The result.

FUNCTION p_gt_ff(l_a, l_b, l_c, l_d, l_x, l_s, l_ac)

DEFINE
   l_a    FLOAT,
   l_b    FLOAT,
   l_c    FLOAT,
   l_d    FLOAT,
   l_x    FLOAT,
   l_s    FLOAT,
   l_ac   FLOAT

   LET l_a = l_a + gt_bitorlong(gt_bitandlong(l_b, l_c), gt_bitandlong((gt_bitnotlong(l_b)),l_d)) + l_x + l_ac
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = gt_bitorlong(gt_shiftleftlong(l_a, l_s), gt_shiftrightlong(l_a, (32 - l_s)))
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = l_a + l_b
   LET l_a = p_gt_truncate32(l_a)

   RETURN l_a

END FUNCTION

##
# One of the MD5 transformation functions.
# @param l_a First input.
# @param l_b Second input.
# @param l_c Third input.
# @param l_d Fourth input.
# @param l_x Fifth input.
# @param l_s Sixth input.
# @param l_ac Seventh input.
# @return l_a The result.

FUNCTION p_gt_gg(l_a, l_b, l_c, l_d, l_x, l_s, l_ac)

DEFINE
   l_a    FLOAT,
   l_b    FLOAT,
   l_c    FLOAT,
   l_d    FLOAT,
   l_x    FLOAT,
   l_s    FLOAT,
   l_ac   FLOAT

   LET l_a = l_a + gt_bitorlong(gt_bitandlong(l_b, l_d), (gt_bitandlong(l_c, (gt_bitnotlong(l_d))))) + l_x + l_ac
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = gt_bitorlong(gt_shiftleftlong(l_a, l_s), gt_shiftrightlong(l_a, (32 - l_s)))
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = l_a + l_b
   LET l_a = p_gt_truncate32(l_a)

   RETURN l_a

END FUNCTION

##
# One of the MD5 transformation functions.
# @param l_a First input.
# @param l_b Second input.
# @param l_c Third input.
# @param l_d Fourth input.
# @param l_x Fifth input.
# @param l_s Sixth input.
# @param l_ac Seventh input.
# @return l_a The result.

FUNCTION p_gt_hh(l_a, l_b, l_c, l_d, l_x, l_s, l_ac)

DEFINE
   l_a    FLOAT,
   l_b    FLOAT,
   l_c    FLOAT,
   l_d    FLOAT,
   l_x    FLOAT,
   l_s    FLOAT,
   l_ac   FLOAT

   LET l_a = l_a + gt_bitxorlong((gt_bitxorlong(l_b, l_c)), l_d) + l_x + l_ac
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = gt_bitorlong(gt_shiftleftlong(l_a, l_s), gt_shiftrightlong(l_a, (32 - l_s)))
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = l_a + l_b
   LET l_a = p_gt_truncate32(l_a)

   RETURN l_a

END FUNCTION

##
# One of the MD5 transformation functions.
# @param l_a First input.
# @param l_b Second input.
# @param l_c Third input.
# @param l_d Fourth input.
# @param l_x Fifth input.
# @param l_s Sixth input.
# @param l_ac Seventh input.
# @return l_a The result.

FUNCTION p_gt_ii(l_a, l_b, l_c, l_d, l_x, l_s, l_ac)

DEFINE
   l_a    FLOAT,
   l_b    FLOAT,
   l_c    FLOAT,
   l_d    FLOAT,
   l_x    FLOAT,
   l_s    FLOAT,
   l_ac   FLOAT

   LET l_a = l_a + gt_bitxorlong(l_c, (gt_bitorlong(l_b, (gt_bitnotlong(l_d))))) + l_x + l_ac
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = gt_bitorlong(gt_shiftleftlong(l_a, l_s), gt_shiftrightlong(l_a, (32 - l_s)))
   LET l_a = p_gt_truncate32(l_a)
   LET l_a = l_a + l_b
   LET l_a = p_gt_truncate32(l_a)

   RETURN l_a

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
