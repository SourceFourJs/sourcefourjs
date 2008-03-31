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
# Binary Arithmetic Library
# @category System Library
# @author Dietmar Bos
# @author Scott Newton
# @date August 2007
# @version $Id$
#

##
# Function to set the WHENEVER ANY ERROR function for this module
#

FUNCTION libgt_binary_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# This function rotates the input left by the given number of bits.
# @param l_long The input to rotate.
# @param l_bits The number of bits to rotate by.
# @return l_long The rotated output.
#

FUNCTION gt_rotateleftlong(l_long, l_bits)

DEFINE
   l_long   FLOAT,
   l_bits   SMALLINT

DEFINE
   l_src   STRING,
   l_tmp   STRING

   LET l_tmp = gt_long2binary(l_long)
   LET l_src = l_tmp.subString(l_bits + 1, 32), l_tmp.subString(1, l_bits + 1)
   LET l_long = gt_binary2long(l_src)

   RETURN l_long

END FUNCTION

##
# This function rotates the input right by the given number of bits.
# @param l_long The input to rotate.
# @param l_bits The number of bits to rotate by.
# @return l_long The rotated output.
#

FUNCTION gt_rotaterightlong(l_long, l_bits)

DEFINE
   l_long   FLOAT,
   l_bits   SMALLINT

DEFINE
   l_src   STRING,
   l_tmp   STRING

   LET l_tmp = gt_long2binary(l_long)
   LET l_src = l_tmp.subString(32 - l_bits + 1, 32), l_tmp.subString(1, 32 - l_bits + 1)
   LET l_long = gt_binary2long(l_src)

   RETURN l_long

END FUNCTION

##
# This function shifts the input left by the given number of bits.
# @param l_long The input to rotate.
# @param l_bits The number of bits to shift by.
# @return l_long The shifted output.
#

FUNCTION gt_shiftleftlong(l_long, l_bits)

DEFINE
   l_long   FLOAT,
   l_bits   SMALLINT

DEFINE
   l_src     STRING,
   l_tmp     STRING,
   l_dummy   STRING

   LET l_dummy = "00000000000000000000000000000000"
   LET l_tmp = gt_long2binary(l_long)
   LET l_src = l_tmp.subString(l_bits + 1, 32), l_dummy.subString(1, l_bits + 1)
   LET l_long = gt_binary2long(l_src)

   RETURN l_long

END FUNCTION

##
# This function shifts the input right by the given number of bits.
# @param l_long The input to rotate.
# @param l_bits The number of bits to shift by.
# @return l_long The shifted output.
#

FUNCTION gt_shiftrightlong(l_long, l_bits)

DEFINE
   l_long   FLOAT,
   l_bits   SMALLINT

DEFINE
   l_src     STRING,
   l_tmp     STRING,
   l_dummy   STRING

   LET l_dummy = "00000000000000000000000000000000"
   LET l_tmp = gt_long2binary(l_long)
   LET l_src = l_dummy.subString(32 - l_bits + 1, 32), l_tmp.subString(1, 32 - l_bits + 1)
   LET l_long = gt_binary2long(l_src)

   RETURN l_long

END FUNCTION

##
# This function rotates the input left by the given number of bits.
# @param l_word The input to rotate.
# @param l_bits The number of bits to rotate by.
# @return l_long The rotated output.
#

FUNCTION gt_rotateleft(l_word, l_bits)

DEFINE
   l_word   INTEGER,
   l_bits   SMALLINT

DEFINE
   l_src   STRING,
   l_tmp   STRING

   LET l_tmp = gt_word2binary(l_word)
   LET l_src = l_tmp.subString(l_bits + 1, 16), l_tmp.subString(1, l_bits + 1)
   LET l_word = gt_binary2word(l_src)

   RETURN l_word

END FUNCTION

##
# This function rotates the input right by the given number of bits.
# @param l_word The input to rotate.
# @param l_bits The number of bits to rotate by.
# @return l_long The rotated output.
#

FUNCTION gt_rotateright(l_word, l_bits)

DEFINE
   l_word   INTEGER,
   l_bits   SMALLINT

DEFINE
   l_src   STRING,
   l_tmp   STRING

   LET l_tmp = gt_word2binary(l_word)
   LET l_src = l_tmp.subString(16 - l_bits + 1, 16), l_tmp.subString(1, 16 - l_bits + 1)
   LET l_word = gt_binary2word(l_src)

   RETURN l_word

END FUNCTION

##
# This function shifts the input left by the given number of bits.
# @param l_word The input to shift.
# @param l_bits The number of bits to shift by.
# @return l_long The shifted output.
#

FUNCTION gt_shiftleft(l_word, l_bits)

DEFINE
   l_word   INTEGER,
   l_bits   SMALLINT

DEFINE
   l_src     STRING,
   l_tmp     STRING,
   l_dummy   STRING

   LET l_dummy = "0000000000000000"
   LET l_tmp = gt_word2binary(l_word)
   LET l_src = l_tmp.subString(l_bits + 1, 16), l_dummy.subString(1, l_bits + 1)
   LET l_word = gt_binary2word(l_src)

   RETURN l_word

END FUNCTION

##
# This function shifts the input right by the given number of bits.
# @param l_word The input to shift.
# @param l_bits The number of bits to shift by.
# @return l_long The shifted output.
#

FUNCTION gt_shiftright(l_word, l_bits)

DEFINE
   l_word   INTEGER,
   l_bits   SMALLINT

DEFINE
   l_src     STRING,
   l_tmp     STRING,
   l_dummy   STRING

   LET l_dummy = "0000000000000000"
   LET l_tmp = gt_word2binary(l_word)
   LET l_src = l_dummy.subString(16 - l_bits + 1, 16), l_tmp.subString(1, 16 - l_bits + 1)
   LET l_word = gt_binary2word(l_src)

   RETURN l_word

END FUNCTION

##
# This function converts a byte value into a binary value.
# @param l_source The byte to convert.
# @return l_binary The output in binary.
#

FUNCTION gt_byte2binary(l_source)

DEFINE
   l_source   INTEGER

DEFINE
   l_binary   base.StringBuffer

   LET l_binary = base.StringBuffer.create()
   CALL l_binary.append("00000000")

   WHILE l_source >= 256
      LET l_source = l_source - 256
   END WHILE

   IF l_source - 128 >= 0 THEN
      LET l_source = l_source - 128
      CALL l_binary.replaceAt(1, 1, "1")
   END IF

   IF l_source - 64 >= 0 THEN
      LET l_source = l_source - 64
      CALL l_binary.replaceAt(2, 1, "1")
   END IF

   IF l_source - 32 >= 0 THEN
      LET l_source = l_source - 32
      CALL l_binary.replaceAt(3, 1, "1")
   END IF

   IF l_source - 16 >= 0 THEN
      LET l_source = l_source - 16
      CALL l_binary.replaceAt(4, 1, "1")
   END IF

   IF l_source - 8 >= 0 THEN
      LET l_source = l_source - 8
      CALL l_binary.replaceAt(5, 1, "1")
   END IF

   IF l_source - 4 >= 0 THEN
      LET l_source = l_source - 4
      CALL l_binary.replaceAt(6, 1, "1")
   END IF

   IF l_source - 2 >= 0 THEN
      LET l_source = l_source - 2
      CALL l_binary.replaceAt(7, 1, "1")
   END IF

   IF l_source - 1 >= 0 THEN
      CALL l_binary.replaceAt(8, 1, "1")
   END IF

   RETURN l_binary.toString()

END FUNCTION

##
# This function converts a word value to a binary value.
# @param l_source The word to convert.
# @return l_binary The output in binary.
#

FUNCTION gt_word2binary(l_source)

DEFINE
   l_source   INTEGER

DEFINE
   l_binary   base.StringBuffer

   LET l_binary = base.StringBuffer.create()
   CALL l_binary.append("0000000000000000")

   WHILE l_source >= 65536
      LET l_source = l_source - 65536
   END WHILE

   IF l_source - 32768 >= 0 THEN
      LET l_source = l_source - 32768
      CALL l_binary.replaceAt(1, 1, "1")
   END IF

   IF l_source - 16384 >= 0 THEN
      LET l_source = l_source - 16384
      CALL l_binary.replaceAt(2, 1, "1")
   END IF

   IF l_source - 8192 >= 0 THEN
      LET l_source = l_source - 8192
      CALL l_binary.replaceAt(3, 1, "1")
   END IF

   IF l_source - 4096 >= 0 THEN
      LET l_source = l_source - 4096
      CALL l_binary.replaceAt(4, 1, "1")
   END IF

   IF l_source - 2048 >= 0 THEN
      LET l_source = l_source - 2048
      CALL l_binary.replaceAt(5, 1, "1")
   END IF

   IF l_source - 1024 >= 0 THEN
      LET l_source = l_source - 1024
      CALL l_binary.replaceAt(6, 1, "1")
   END IF

   IF l_source - 512 >= 0 THEN
      LET l_source = l_source - 512
      CALL l_binary.replaceAt(7, 1, "1")
   END IF

   IF l_source - 256 >= 0 THEN
      LET l_source = l_source - 256
      CALL l_binary.replaceAt(8, 1, "1")
   END IF

   IF l_source - 128 >= 0 THEN
      LET l_source = l_source - 128
      CALL l_binary.replaceAt(9, 1, "1")
   END IF

   IF l_source - 64 >= 0 THEN
      LET l_source = l_source - 64
      CALL l_binary.replaceAt(10, 1, "1")
   END IF

   IF l_source - 32 >= 0 THEN
      LET l_source = l_source - 32
      CALL l_binary.replaceAt(11, 1, "1")
   END IF

   IF l_source - 16 >= 0 THEN
      LET l_source = l_source - 16
      CALL l_binary.replaceAt(12, 1, "1")
   END IF

   IF l_source - 8 >= 0 THEN
      LET l_source = l_source - 8
      CALL l_binary.replaceAt(13, 1, "1")
   END IF

   IF l_source - 4 >= 0 THEN
      LET l_source = l_source - 4
      CALL l_binary.replaceAt(14, 1, "1")
   END IF

   IF l_source - 2 >= 0 THEN
      LET l_source = l_source - 2
      CALL l_binary.replaceAt(15, 1, "1")
   END IF

   IF l_source - 1 >= 0 THEN
      CALL l_binary.replaceAt(16, 1, "1")
   END IF

   RETURN l_binary.toString()

END FUNCTION

##
# This function converts a long value to a binary value.
# @param l_source The long to convert.
# @return l_binary The output in binary.
#

FUNCTION gt_long2binary(l_source)

DEFINE
   l_source   FLOAT

DEFINE
   l_binary   base.StringBuffer

   LET l_binary = base.StringBuffer.create()
   CALL l_binary.append("00000000000000000000000000000000")

   WHILE l_source >= 4294967296.0
      LET l_source = l_source - 4294967296.0
   END WHILE

   IF l_source - 2147483648.0 >= 0 THEN
      LET l_source = l_source - 2147483648.0
      CALL l_binary.replaceAt(1, 1, "1")
   END IF

   IF l_source - 1073741824.0 >= 0 THEN
      LET l_source = l_source - 1073741824.0
      CALL l_binary.replaceAt(2, 1, "1")
   END IF

   IF l_source - 536870912.0 >= 0 THEN
      LET l_source = l_source - 536870912.0
      CALL l_binary.replaceAt(3, 1, "1")
   END IF

   IF l_source - 268435456.0 >= 0 THEN
      LET l_source = l_source - 268435456.0
      CALL l_binary.replaceAt(4, 1, "1")
   END IF

   IF l_source - 134217728.0 >= 0 THEN
      LET l_source = l_source - 134217728.0
      CALL l_binary.replaceAt(5, 1, "1")
   END IF

   IF l_source - 67108864.0 >= 0 THEN
      LET l_source = l_source - 67108864.0
      CALL l_binary.replaceAt(6, 1, "1")
   END IF

   IF l_source - 33554432.0 >= 0 THEN
      LET l_source = l_source - 33554432.0
      CALL l_binary.replaceAt(7, 1, "1")
   END IF

   IF l_source - 16777216.0 >= 0 THEN
      LET l_source = l_source - 16777216.0
      CALL l_binary.replaceAt(8, 1, "1")
   END IF

   IF l_source - 8388608.0 >= 0 THEN
      LET l_source = l_source - 8388608.0
      CALL l_binary.replaceAt(9, 1, "1")
   END IF

   IF l_source - 4194304.0 >= 0 THEN
      LET l_source = l_source - 4194304.0
      CALL l_binary.replaceAt(10, 1, "1")
   END IF

   IF l_source - 2097152.0 >= 0 THEN
      LET l_source = l_source - 2097152.0
      CALL l_binary.replaceAt(11, 1, "1")
   END IF

   IF l_source - 1048576.0 >= 0 THEN
      LET l_source = l_source - 1048576.0
      CALL l_binary.replaceAt(12, 1, "1")
   END IF

   IF l_source -524288.0 >= 0 THEN
      LET l_source = l_source - 524288.0
      CALL l_binary.replaceAt(13, 1, "1")
   END IF

   IF l_source - 262144.0 >= 0 THEN
      LET l_source = l_source - 262144.0
      CALL l_binary.replaceAt(14, 1, "1")
   END IF

   IF l_source - 131072.0 >= 0 THEN
      LET l_source = l_source - 131072.0
      CALL l_binary.replaceAt(15, 1, "1")
   END IF

   IF l_source - 65536.0 >= 0 THEN
      LET l_source = l_source - 65536.0
      CALL l_binary.replaceAt(16, 1, "1")
   END IF

   IF l_source - 32768.0 >= 0 THEN
      LET l_source = l_source - 32768.0
      CALL l_binary.replaceAt(17, 1, "1")
   END IF

   IF l_source - 16384 >= 0 THEN
      LET l_source = l_source - 16384
      CALL l_binary.replaceAt(18, 1, "1")
   END IF

   IF l_source - 8192 >= 0 THEN
      LET l_source = l_source - 8192
      CALL l_binary.replaceAt(19, 1, "1")
   END IF

   IF l_source - 4096 >= 0 THEN
      LET l_source = l_source - 4096
      CALL l_binary.replaceAt(20, 1, "1")
   END IF

   IF l_source - 2048 >= 0 THEN
      LET l_source = l_source - 2048
      CALL l_binary.replaceAt(21, 1, "1")
   END IF

   IF l_source - 1024 >= 0 THEN
      LET l_source = l_source - 1024
      CALL l_binary.replaceAt(22, 1, "1")
   END IF

   IF l_source - 512 >= 0 THEN
      LET l_source = l_source - 512
      CALL l_binary.replaceAt(23, 1, "1")
   END IF

   IF l_source - 256 >= 0 THEN
      LET l_source = l_source - 256
      CALL l_binary.replaceAt(24, 1, "1")
   END IF

   IF l_source - 128 >= 0 THEN
      LET l_source = l_source - 128
      CALL l_binary.replaceAt(25, 1, "1")
   END IF

   IF l_source - 64 >= 0 THEN
      LET l_source = l_source - 64
      CALL l_binary.replaceAt(26, 1, "1")
   END IF

   IF l_source - 32 >= 0 THEN
      LET l_source = l_source - 32
      CALL l_binary.replaceAt(27, 1, "1")
   END IF

   IF l_source - 16 >= 0 THEN
      LET l_source = l_source - 16
      CALL l_binary.replaceAt(28, 1, "1")
   END IF

   IF l_source - 8 >= 0 THEN
      LET l_source = l_source - 8
      CALL l_binary.replaceAt(29, 1, "1")
   END IF

   IF l_source - 4 >= 0 THEN
      LET l_source = l_source - 4
      CALL l_binary.replaceAt(30, 1, "1")
   END IF

   IF l_source - 2 >= 0 THEN
      LET l_source = l_source - 2
      CALL l_binary.replaceAt(31, 1, "1")
   END IF

   IF l_source - 1 >= 0 THEN
      CALL l_binary.replaceAt(32, 1, "1")
   END IF

   RETURN l_binary.toString()

END FUNCTION

##
# This function converts a binary value to a byte value.
# @param l_source The binary to convert.
# @return l_binary The output as a byte.
#

FUNCTION gt_binary2byte(l_source)

DEFINE
   l_source   STRING

DEFINE
   l_binary   INTEGER

   LET l_binary = 0
   LET l_source = l_source.subString(1,8)

   IF l_source.getCharAt(1) == "1" THEN
      LET l_binary = l_binary + 128
   END IF

   IF l_source.getCharAt(2) == "1" THEN
      LET l_binary = l_binary + 64
   END IF

   IF l_source.getCharAt(3) == "1" THEN
      LET l_binary = l_binary + 32
   END IF

   IF l_source.getCharAt(4) == "1" THEN
      LET l_binary = l_binary + 16
   END IF

   IF l_source.getCharAt(5) == "1" THEN
      LET l_binary = l_binary + 8
   END IF

   IF l_source.getCharAt(6) == "1" THEN
      LET l_binary = l_binary + 4
   END IF

   IF l_source.getCharAt(7) == "1" THEN
      LET l_binary = l_binary + 2
   END IF

   IF l_source.getCharAt(8) == "1" THEN
      LET l_binary = l_binary + 1
   END IF

   RETURN l_binary

END FUNCTION

##
# This function converts a binary value to a word value.
# @param l_source The binary to convert.
# @return l_binary The output as a word.
#

FUNCTION gt_binary2word(l_source)

DEFINE
   l_source   STRING

DEFINE
   l_binary   INTEGER

   LET l_binary = 0
   LET l_source = l_source.subString(1,16)

   IF l_source.getCharAt(1) == "1" THEN
      LET l_binary = l_binary + 32768
   END IF

   IF l_source.getCharAt(2) == "1" THEN
      LET l_binary = l_binary + 16384
   END IF

   IF l_source.getCharAT(3) == "1" THEN
      LET l_binary = l_binary + 8192
   END IF

   IF l_source.getCharAt(4) == "1" THEN
      LET l_binary = l_binary + 4096
   END IF

   IF l_source.getCharAt(5) == "1" THEN
      LET l_binary = l_binary + 2048
   END IF

   IF l_source.getCharAt(6) == "1" THEN
      LET l_binary = l_binary + 1024
   END IF

   IF l_source.getCharAt(7) == "1" THEN
      LET l_binary = l_binary + 512
   END IF

   IF l_source.getCharAt(8) == "1" THEN
      LET l_binary = l_binary + 256
   END IF

   IF l_source.getCharAt(9) == "1" THEN
      LET l_binary = l_binary + 128
   END IF

   IF l_source.getCharAt(10) == "1" THEN
      LET l_binary = l_binary + 64
   END IF

   IF l_source.getCharAt(11) == "1" THEN
      LET l_binary = l_binary + 32
   END IF

   IF l_source.getCharAt(12) == "1" THEN
      LET l_binary = l_binary + 16
   END IF

   IF l_source.getCharAt(13) == "1" THEN
      LET l_binary = l_binary + 8
   END IF

   IF l_source.getCharAt(14) == "1" THEN
      LET l_binary = l_binary + 4
   END IF

   IF l_source.getCharAt(15) == "1" THEN
      LET l_binary = l_binary + 2
   END IF

   IF l_source.getCharAt(16) == "1" THEN
      LET l_binary = l_binary + 1
   END IF

   RETURN l_binary

END FUNCTION

##
# This function converts a binary value to a long value.
# @param l_source The binary to convert.
# @return l_binary The output as a long.
#

FUNCTION gt_binary2long(l_source)

DEFINE
   l_source   STRING

DEFINE
   l_binary   FLOAT

   LET l_binary = 0
   LET l_source = l_source.subString(1,32)

   IF l_source.getCharAt(1) == "1" THEN
      LET l_binary = l_binary + 2147483648.0
   END IF

   IF l_source.getCharAt(2) == "1" THEN
      LET l_binary = l_binary + 1073741824.0
   END IF

   IF l_source.getCharAt(3) == "1" THEN
      LET l_binary = l_binary + 536870912.0
   END IF

   IF l_source.getCharAt(4) == "1" THEN
      LET l_binary = l_binary + 268435456.0
   END IF

   IF l_source.getCharAt(5) == "1" THEN
      LET l_binary = l_binary + 134217728.0
   END IF

   IF l_source.getCharAt(6) == "1" THEN
      LET l_binary = l_binary + 67108864.0
   END IF

   IF l_source.getCharAt(7) == "1" THEN
      LET l_binary = l_binary + 33554432.0
   END IF

   IF l_source.getCharAt(8) == "1" THEN
      LET l_binary = l_binary + 16777216.0
   END IF

   IF l_source.getCharAt(9) == "1" THEN
      LET l_binary = l_binary + 8388608.0
   END IF

   IF l_source.getCharAt(10) == "1" THEN
      LET l_binary = l_binary + 4194304.0
   END IF

   IF l_source.getCharAt(11) == "1" THEN
      LET l_binary = l_binary + 2097152.0
   END IF

   IF l_source.getCharAt(12) == "1" THEN
      LET l_binary = l_binary + 1048576.0
   END IF

   IF l_source.getCharAt(13) == "1" THEN
      LET l_binary = l_binary + 524288.0
   END IF

   IF l_source.getCharAt(14) == "1" THEN
      LET l_binary = l_binary + 262144.0
   END IF

   IF l_source.getCharAt(15) == "1" THEN
      LET l_binary = l_binary + 131072.0
   END IF

   IF l_source.getCharAt(16) == "1" THEN
      LET l_binary = l_binary + 65536.0
   END IF

   IF l_source.getCharAt(17) == "1" THEN
      LET l_binary = l_binary + 32768.0
   END IF

   IF l_source.getCharAt(18) == "1" THEN
      LET l_binary = l_binary + 16384
   END IF

   IF l_source.getCharAt(19) == "1" THEN
      LET l_binary = l_binary + 8192
   END IF

   IF l_source.getCharAt(20) == "1" THEN
      LET l_binary = l_binary + 4096
   END IF

   IF l_source.getCharAt(21) == "1" THEN
      LET l_binary = l_binary + 2048
   END IF

   IF l_source.getCharAt(22) == "1" THEN
      LET l_binary = l_binary + 1024
   END IF

   IF l_source.getCharAt(23) == "1" THEN
      LET l_binary = l_binary + 512
   END IF

   IF l_source.getCharAt(24) == "1" THEN
      LET l_binary = l_binary + 256
   END IF

   IF l_source.getCharAt(25) == "1" THEN
      LET l_binary = l_binary + 128
   END IF

   IF l_source.getCharAt(26) == "1" THEN
      LET l_binary = l_binary + 64
   END IF

   IF l_source.getCharAt(27) == "1" THEN
      LET l_binary = l_binary + 32
   END IF

   IF l_source.getCharAt(28) == "1" THEN
      LET l_binary = l_binary + 16
   END IF

   IF l_source.getCharAt(29) == "1" THEN
      LET l_binary = l_binary + 8
   END IF

   IF l_source.getCharAt(30) == "1" THEN
      LET l_binary = l_binary + 4
   END IF

   IF l_source.getCharAt(31) == "1" THEN
      LET l_binary = l_binary + 2
   END IF

   IF l_source.getCharAt(32) == "1" THEN
      LET l_binary = l_binary + 1
   END IF

   RETURN l_binary

END FUNCTION

##
# This function clears a bit in a byte.
# @param l_source The input byte.
# @param l_bit_position The bit to clear.
# @return l_source The resulting byte.
#

FUNCTION gt_bitclearbyte(l_source, l_bit_position)

DEFINE
   l_source         INTEGER,
   l_bit_position   SMALLINT

DEFINE
   l_bits   base.StringBuffer

   LET l_bits = base.StringBuffer.create()
   CALL l_bits.append(gt_byte2binary(l_source))
   CALL l_bits.replaceAt(9 - l_bit_position, 1, "0")
   LET l_source = gt_binary2byte(l_bits.toString())

   RETURN l_source

END FUNCTION

##
# This function clears a bit in a word.
# @param l_source The input word.
# @param l_bit_position The bit to clear.
# @return l_source The resulting word.
#

FUNCTION gt_bitclearword(l_source, l_bit_position)

DEFINE
   l_source         INTEGER,
   l_bit_position   SMALLINT

DEFINE
   l_bits   base.StringBuffer

   LET l_bits = base.StringBuffer.create()
   CALL l_bits.append(gt_word2binary(l_source))
   CALL l_bits.replaceAt(17 - l_bit_position, 1, "0")
   LET l_source = gt_binary2word(l_bits.toString())

   RETURN l_source

END FUNCTION

##
# This function clears a bit in a long.
# @param l_source The input long.
# @param l_bit_position The bit to clear.
# @return l_source The resulting long.
#

FUNCTION gt_bitclearlong(l_source, l_bit_position)

DEFINE
   l_source         FLOAT,
   l_bit_position   SMALLINT

DEFINE
   l_bits   base.StringBuffer

   LET l_bits = base.StringBuffer.create()
   CALL l_bits.append(gt_long2binary(l_source))
   CALL l_bits.replaceAt(33 - l_bit_position, 1, "0")
   LET l_source = gt_binary2long(l_bits.toString())

   RETURN l_source

END FUNCTION

##
# This function sets a bit in a byte.
# @param l_source The input byte.
# @param l_bit_position The bit to set.
# @return l_source The resulting byte.
#

FUNCTION gt_bitsetbyte(l_source, l_bit_position)

DEFINE
   l_source         INTEGER,
   l_bit_position   SMALLINT

DEFINE
   l_bits   base.StringBuffer

   LET l_bits = base.StringBuffer.create()
   CALL l_bits.append(gt_byte2binary(l_source))
   CALL l_bits.replaceAt(9 - l_bit_position, 1, "1")
   LET l_source = gt_binary2byte(l_bits.toString())

   RETURN l_source

END FUNCTION

##
# This function sets a bit in a word.
# @param l_source The input word.
# @param l_bit_position The bit to set.
# @return l_source The resulting word.
#

FUNCTION gt_bitsetword(l_source, l_bit_position)

DEFINE
   l_source         INTEGER,
   l_bit_position   SMALLINT

DEFINE
   l_bits   base.StringBuffer

   LET l_bits = base.StringBuffer.create()
   CALL l_bits.append(gt_word2binary(l_source))
   CALL l_bits.replaceAt(17 - l_bit_position, 1, "1")
   LET l_source = gt_binary2word(l_bits.toString())

   RETURN l_source

END FUNCTION

##
# This function sets a bit in a long.
# @param l_source The input long.
# @param l_bit_position The bit to set.
# @return l_source The resulting long.
#

FUNCTION gt_bitsetlong(l_source, l_bit_position)

DEFINE
   l_source         FLOAT,
   l_bit_position   SMALLINT

DEFINE
   l_bits   base.StringBuffer

   LET l_bits = base.StringBuffer.create()
   CALL l_bits.append(gt_long2binary(l_source))
   CALL l_bits.replaceAt(33 - l_bit_position, 1, "1")
   LET l_source = gt_binary2long(l_bits.toString())

   RETURN l_source

END FUNCTION

##
# This function or's a bit in a byte.
# @param l_source The input byte.
# @param l_bit_position The bit to or.
# @return l_source The resulting byte.
#

FUNCTION gt_bitorbyte(l_source1, l_source2)

DEFINE
   l_source1   INTEGER,
   l_source2   INTEGER

DEFINE
   i               SMALLINT,
   l_result        INTEGER,
   l_bits1         CHAR(8),
   l_bits2         CHAR(8),
   l_bits_result   CHAR(8)

   LET l_bits_result = "00000000"
   LET l_bits1 = gt_byte2binary(l_source1)
   LET l_bits2 = gt_byte2binary(l_source2)

   FOR i = 1 TO 8
      IF l_bits1[i,i] == "1"
      OR l_bits2[i,i] == "1" then
         LET l_bits_result[i,i] = "1"
      END IF
   END FOR

   LET l_result = gt_binary2byte(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function or's a bit in a word.
# @param l_source The input word.
# @param l_bit_position The bit to or.
# @return l_source The resulting word.
#

FUNCTION gt_bitorword(l_source1, l_source2)

DEFINE
   l_source1   INTEGER,
   l_source2   INTEGER

DEFINE
   i               SMALLINT,
   l_result        INTEGER,
   l_bits1         CHAR(16),
   l_bits2         CHAR(16),
   l_bits_result   CHAR(16)

   LET l_bits_result = "0000000000000000"
   LET l_bits1 = gt_word2binary(l_source1)
   LET l_bits2 = gt_word2binary(l_source2)

   FOR i = 1 TO 16
      IF l_bits1[i,i] == "1"
      OR l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF
   END FOR

   LET l_result = gt_binary2word(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function or's a bit in a long.
# @param l_source The input long.
# @param l_bit_position The bit to or.
# @return l_source The resulting long.
#

FUNCTION gt_bitorlong(l_source1, l_source2)

DEFINE
   l_source1   FLOAT,
   l_source2   FLOAT

DEFINE
   i               SMALLINT,
   l_result        FLOAT,
   l_bits1         CHAR(32),
   l_bits2         CHAR(32),
   l_bits_result   CHAR(32)

   LET l_bits1 = gt_long2binary(l_source1)
   LET l_bits2 = gt_long2binary(l_source2)
   LET l_bits_result = "00000000000000000000000000000000"

   FOR i = 1 TO 32
      IF l_bits1[i,i] == "1"
      OR l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF
   END FOR

   LET l_result = gt_binary2long(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function and's a bit in a byte.
# @param l_source The input byte.
# @param l_bit_position The bit to or.
# @return l_source The resulting byte.
#

FUNCTION gt_bitandbyte(l_source1, l_source2)

DEFINE
   l_source1   INTEGER,
   l_source2   INTEGER

DEFINE
   i               SMALLINT,
   l_result        INTEGER,
   l_bits1         CHAR(8),
   l_bits2         CHAR(8),
   l_bits_result   CHAR(8)

   LET l_bits_result = "00000000"
   LET l_bits1 = gt_byte2binary(l_source1)
   LET l_bits2 = gt_byte2binary(l_source2)

   FOR i = 1 TO 8
      IF l_bits1[i,i] == "1"
      AND l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF
   END FOR

   LET l_result = gt_binary2byte(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function and's a bit in a word.
# @param l_source The input word.
# @param l_bit_position The bit to or.
# @return l_source The resulting word.
#

FUNCTION gt_bitandword(l_source1, l_source2)

DEFINE
   l_source1   INTEGER,
   l_source2   INTEGER

DEFINE
   i               SMALLINT,
   l_result        INTEGER,
   l_bits1         CHAR(16),
   l_bits2         CHAR(16),
   l_bits_result   CHAR(16)

   LET l_bits_result = "0000000000000000"
   LET l_bits1 = gt_word2binary(l_source1)
   LET l_bits2 = gt_word2binary(l_source2)

   FOR i = 1 TO 16
      IF l_bits1[i,i] == "1"
      AND l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF
   END FOR

   LET l_result = gt_binary2word(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function and's a bit in a long.
# @param l_source The input long.
# @param l_bit_position The bit to or.
# @return l_source The resulting long.
#

FUNCTION gt_bitandlong(l_source1, l_source2)

DEFINE
   l_source1   FLOAT,
   l_source2   FLOAT

DEFINE
   i               SMALLINT,
   l_result        FLOAT,
   l_bits1         CHAR(32),
   l_bits2         CHAR(32),
   l_bits_result   CHAR(32)

   LET l_bits1 = gt_long2binary(l_source1)
   LET l_bits2 = gt_long2binary(l_source2)
   LET l_bits_result = "00000000000000000000000000000000"

   FOR i = 1 TO 32
      IF l_bits1[i,i] == "1"
      AND l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF
   END FOR

   LET l_result = gt_binary2long(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function xor's a bit in a byte.
# @param l_source The input byte.
# @param l_bit_position The bit to or.
# @return l_source The resulting byte.
#

FUNCTION gt_bitxorbyte(l_source1, l_source2)

DEFINE
   l_source1   INTEGER,
   l_source2   INTEGER

DEFINE
   i               SMALLINT,
   l_result        INTEGER,
   l_bits1         CHAR(8),
   l_bits2         CHAR(8),
   l_bits_result   CHAR(8)

   LET l_bits_result = "00000000"
   LET l_bits1 = gt_byte2binary(l_source1)
   LET l_bits2 = gt_byte2binary(l_source2)

   FOR i = 1 TO 8
      IF l_bits1[i,i] == "1"
      OR l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF

      IF (l_bits1[i,i] == "1" AND l_bits2[i,i] == "1")
      OR (l_bits1[i,i] == "0" AND l_bits2[i,i] == "0") THEN
         LET l_bits_result[i,i] = "0"
      END IF
   END FOR

   LET l_result = gt_binary2byte(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function xor's a bit in a word.
# @param l_source The input word.
# @param l_bit_position The bit to or.
# @return l_source The resulting word.
#

FUNCTION gt_bitxorword(l_source1, l_source2)

DEFINE
   l_source1   INTEGER,
   l_source2   INTEGER

DEFINE
   i               SMALLINT,
   l_result        INTEGER,
   l_bits1         CHAR(16),
   l_bits2         CHAR(16),
   l_bits_result   CHAR(16)

   LET l_bits_result = "0000000000000000"
   LET l_bits1 = gt_word2binary(l_source1)
   LET l_bits2 = gt_word2binary(l_source2)

    FOR i = 1 TO 16
      IF l_bits1[i,i] == "1"
      OR l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF

      IF (l_bits1[i,i] == "1" AND l_bits2[i,i] == "1")
      OR (l_bits1[i,i] == "0" AND l_bits2[i,i] == "0") THEN
         LET l_bits_result[i,i] = "0"
      END IF
   END FOR

   LET l_result=gt_binary2word(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function xor's a bit in a long.
# @param l_source The input long.
# @param l_bit_position The bit to or.
# @return l_source The resulting long.
#

FUNCTION gt_bitxorlong(l_source1, l_source2)

DEFINE
   l_source1   FLOAT,
   l_source2   FLOAT

DEFINE
   i               SMALLINT,
   l_result        FLOAT,
   l_bits1         CHAR(32),
   l_bits2         CHAR(32),
   l_bits_result   CHAR(32)

   LET l_bits1 = gt_long2binary(l_source1)
   LET l_bits2 = gt_long2binary(l_source2)
   LET l_bits_result = "00000000000000000000000000000000"

   FOR i = 1 TO 32
       IF l_bits1[i,i] == "1"
       OR l_bits2[i,i] == "1" THEN
         LET l_bits_result[i,i] = "1"
      END IF

       IF (l_bits1[i,i] == "1" AND l_bits2[i,i] =="1")
       OR (l_bits1[i,i] == "0" AND l_bits2[i,i] == "0") THEN
         LET l_bits_result[i,i] = "0"
      END IF
   END FOR

   LET l_result = gt_binary2long(l_bits_result)

   RETURN l_result

END FUNCTION

##
# This function toggles every bit in a byte.
# @param l_source The input byte.
# @return l_source The resulting byte.
#

FUNCTION gt_bitnotbyte(l_value)

DEFINE
   l_value   SMALLINT

   RETURN 255 - l_value # 255 = 0xff  or 0b11111111

END FUNCTION

##
# This function toggles every bit in a word.
# @param l_source The input word.
# @return l_source The resulting word.
#

FUNCTION gt_bitnotword(l_value)

DEFINE
   l_value   INTEGER

   RETURN 65535 - l_value # 65535 = 0xffff

END FUNCTION

##
# This function toggles every bit in a long.
# @param l_source The input long.
# @return l_source The resulting long.
#

FUNCTION gt_bitnotlong(l_value)

DEFINE
   l_value   FLOAT

   RETURN 4294967295.0 - l_value # 4294967295 = 0x00ffffff

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
