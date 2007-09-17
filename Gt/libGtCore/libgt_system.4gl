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
# This library contains some general purpose system functions.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

DEFINE
   m_serial_count   INTEGER,

   m_serial_list   DYNAMIC ARRAY OF RECORD
      type   STRING,
      next   INTEGER
  END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_system_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function to get the operating system
# @return l_os The current operating system
#

FUNCTION gt_os()

DEFINE
   l_os   STRING

   LET l_os = NULL

   IF fgl_getenv("SYSTEMROOT") IS NOT NULL THEN
      LET l_os = "WINDOWS"
   ELSE
      LET l_os = "UNIX"
   END IF

   RETURN l_os

END FUNCTION

##
# Function to get the Windows or UNIX operating system type
# @return l_os The current operating system type, otherwise NULL.
#

FUNCTION gt_os_type()

DEFINE
   l_ok        SMALLINT,
   l_os_type   STRING,
   l_pipehdl   STRING

   LET l_os_type = NULL

   IF gt_os() == "WINDOWS" THEN
      CALL gt_pipe_open("cmd /c ver", "r", "")
         RETURNING l_ok, l_pipehdl

      IF l_ok THEN
         IF gt_pipe_read(l_pipehdl) THEN
            LET l_os_type = gt_io_buffer(l_pipehdl)
            CALL gt_pipe_close(l_pipehdl)
         END IF
      ELSE
         CALL gt_set_error("ERROR", %"Unable to read cmd /c ver")
      END IF
   ELSE
      CALL gt_pipe_open("uname -s", "r", "")
         RETURNING l_ok, l_pipehdl

      IF l_ok THEN
         IF gt_pipe_read(l_pipehdl) THEN
            LET l_os_type = gt_io_buffer(l_pipehdl)
            CALL gt_pipe_close(l_pipehdl)
         END IF
      ELSE
         CALL gt_set_error("ERROR", %"Unable to read uname -s")
      END IF
   END IF

   RETURN l_os_type

END FUNCTION

##
# This function returns the next serial number for the given type.
# @param l_type The type to get the next serial number for. The type is a string
#               which identifies which particular serial you want to get next.
# @return l_serial The returned serial string. The format is l_type, the next
#                  serial number for that type and the process id of the current
#                  process.
#

FUNCTION gt_next_serial(l_type)

DEFINE
	l_type   STRING

DEFINE
   i          INTEGER,
   l_pos      INTEGER,
   l_serial   STRING

   LET l_pos = 0
   LET l_serial = NULL
   LET l_type = l_type.trim()

   FOR i = 1 TO m_serial_list.getlength()
      IF m_serial_list[i].type == l_type THEN
         LET l_pos = i
         EXIT FOR
      END IF
   END FOR

   IF l_pos == 0 THEN
      LET m_serial_count = m_serial_count + 1
      LET m_serial_list[m_serial_count].type = l_type.trim()
      LET m_serial_list[m_serial_count].next = 0
      LET l_pos = m_serial_count
   ELSE
      LET m_serial_list[l_pos].next = m_serial_list[l_pos].next + 1
   END IF

   #---------------------------------------------------------------------------#
   # Reset the number if it has grown larger than an INTEGER allows            #
   #---------------------------------------------------------------------------#

   IF m_serial_list[l_pos].next > 2147483647 THEN
      LET m_serial_list[l_pos].next = 0
   END IF

   LET l_serial = l_type, m_serial_list[l_pos].next USING "&&&&&&&&&&",
                  fgl_getpid() USING "&&&&&"

   RETURN l_serial

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
