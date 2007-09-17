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

FUNCTION libgt_fs_test_id()

DEFINE
   l_id   STRING

   WHENEVER ANY ERROR CALL gt_system_error
   LET l_id = "$Id$"

END FUNCTION

##
# Function to test the fs library.
# @param l_ok Returns TRUE if successful, FALSE otherwise.
#

FUNCTION test_fs_lib()

DEFINE
   l_ok          SMALLINT,
   l_fs          STRING,
   l_path        STRING,
   l_filehdl     STRING,
   l_volumes     STRING,
   l_tokenizer   base.stringtokenizer

   CALL gt_ut_log("Testing gt_filesystem_separator...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_path_separator() == ";" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_path_separator() == ":" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_exists with file that exists...")

   IF gt_exists("libgt_fs_test.42m") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_exists with file that does not exist...")

   IF gt_exists("this_should_not_exist") == FALSE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_is_root_path where path is root path...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_is_root_path("c:\\") == TRUE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_is_root_path("/") == TRUE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_is_root_path where path is not root path...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_is_root_path("c:\\windows") == FALSE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_is_root_path("/usr") == FALSE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_mkdir on multiple directories with recursion set to FALSE...")

   LET l_path = "gt_ut_dir_test1", gt_filesystem_separator(), "gt_ut_subdir_test1"

   IF gt_mkdir(l_path, FALSE) == FALSE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_mkdir with recursion...")

   IF gt_mkdir(l_path, TRUE) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_change_directory...")

   IF gt_change_directory("gt_ut_dir_test") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_change_directory...")

   LET l_path = "..", gt_filesystem_separator()

   IF gt_change_directory(l_path) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_mkdir without recursion...")

   IF gt_mkdir("gt_ut_dir_test2", FALSE) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_pwd...")
   # TODO Testing gt_pwd

   CALL gt_ut_log("Testing gt_home_directory...")
   # TODO Testing gt_home_directory

   CALL gt_ut_log("Testing gt_root_directory...")

   IF gt_os() == "WINDOWS" THEN
      # TODO Testing gt_root_directory (WINDOWS)
   ELSE
      IF gt_root_directory() == "/" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
      END IF
   END IF

   IF gt_os() == "WINDOWS" THEN
      CALL gt_ut_log("Testing gt_volumes...")
      # TODO Testing gt_volumes

      LET l_volumes = gt_volumes()

      CALL gt_ut_log("Testing gt_change_volume...")
      # TODO Testing gt_change_volume
   END IF

   CALL gt_ut_log("Testing gt_filesystem_separator...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_filesystem_separator() == "\\" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_filesystem_separator() == "/" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_dirname...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_dirname("c:\\windows\\system32\\cmd.exe") == "c:\\windows\\system32" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_dirname("/usr/bin/konsole") == "/usr/bin" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_pathtype with absolute path...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_pathtype("c:\\windows\\system32") == "absolute" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_pathtype("/usr/local/bin") == "absolute" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_pathtype with relative path...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_pathtype("\\windows\\system32") == "absolute" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_pathtype("/local/bin") == "absolute" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_basename...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_basename("c:\\windows\\system32\\cmd.exe") == "cmd.exe" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_basename("/usr/bin/konsole") == "konsole" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_rootname...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_rootname("c:\\windows\\system32\\cmd.exe") == "c:\\windows\\system32\\cmd" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_rootname("/usr/share/doc/manual.pdf") == "/usr/share/doc/manual" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_fs_join...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_fs_join("c:\\windows", "system32\\cmd.exe") == "c:\\windows\\system32\\cmd.exe" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_fs_join("/usr/bin", "konsole") == "/usr/bin/konsole" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_is_file on file...")

   IF gt_is_file("libgt_fs_test.4gl") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_is_file on directory...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_is_file("..\\unittest") == FALSE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_is_file("../unittest") == FALSE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_is_directory on file...")

   IF gt_is_directory("libgt_fs_test.4gl") == FALSE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_is_directory on directory...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_is_directory("..\\unittest") == TRUE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_is_directory("../unittest") == TRUE THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_is_hidden...")
   # TODO Testing gt_is_hidden

   CALL gt_ut_log("Testing gt_is_link...")
   # TODO Testing gt_is_link

   CALL gt_ut_log("Testing gt_is_readable...")
   # TODO Testing gt_is_readable

   CALL gt_ut_log("Testing gt_is_writable...")
   # TODO Testing gt_is_writable

   CALL gt_ut_log("Testing gt_is_executable...")
   # TODO Testing gt_is_executable

   CALL gt_ut_log("Testing gt_uid...")
   # TODO Testing gt_uid

   CALL gt_ut_log("Testing gt_gid...")
   # TODO Testing gt_gid

   CALL gt_ut_log("Testing gt_rwx...")
   # TODO Testing gt_rwx

   CALL gt_ut_log("Testing gt_chmod...")
   # TODO Testing gt_chmod

   CALL gt_ut_log("Testing gt_chown...")
   # TODO Testing gt_chown

   CALL gt_ut_log("Testing gt_file_exists...")

   IF gt_file_exists("libgt_fs_test.4gl") == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_file_extension...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_file_extension("c:\\windows\\system32\\cmd.exe") == "exe" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_file_extension("/usr/share/doc/manual.pdf") == "pdf" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_file_type with file...")

   IF gt_file_type("libgt_fs_test.4gl") == "file" THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_file_type with directory...")

   IF gt_os() == "WINDOWS" THEN
      IF gt_file_type("..\\unittest") == "directory" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   ELSE
      IF gt_file_type("../unittest") == "directory" THEN
         CALL gt_ut_log("Passed")
      ELSE
         CALL gt_ut_log("FAILED")
         RETURN FALSE
      END IF
   END IF

   CALL gt_ut_log("Testing gt_guess_file_content...")
   # TODO Testing gt_guess_file_content

   CALL gt_ut_log("Testing gt_file_size...")
   # TODO Testing gt_file_size

   CALL gt_ut_log("Testing gt_file_access_time...")
   # TODO Testing gt_file_access_time

   CALL gt_ut_log("Testing gt_file_modification_time...")
   # TOOD Testing gt_file_modification_time

   CALL gt_ut_log("Testing gt_copy...")
   # TODO Testing gt_copy

   CALL gt_ut_log("Testing gt_rename...")
   # TODO Testing gt_rename

   CALL gt_ut_log("Testing gt_delete...")
   # TODO Testing gt_delete

   CALL gt_ut_log("Testing gt_delimiter...")
   # TODO Testing gt_delimiter

   CALL gt_ut_log("Testing gt_io_buffer...")
   # TODO Testing gt_io_buffer

   CALL gt_ut_log("Testing gt_file_open...")

   CALL gt_file_open("libgt_fs_test.4gl", "r", "")
      RETURNING l_ok, l_filehdl

   IF l_ok THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_file_read...")

   IF gt_file_read(l_filehdl) THEN
   END IF

   CALL gt_ut_log("Testing gt_file_write...")

   CALL gt_ut_log("Testing gt_file_close...")

   CALL gt_ut_log("Testing gt_pipe_open...")

   CALL gt_ut_log("Testing gt_pipe_read...")

   CALL gt_ut_log("Testing gt_pipe_write...")

   CALL gt_ut_log("Testing gt_pipe_close...")

   CALL gt_ut_log("Testing gt_directory_exists...")

   CALL gt_ut_log("Testing gt_set_directory_filter...")

   CALL gt_ut_log("Testing gt_set_directory_sorting...")

   CALL gt_ut_log("Testing gt_directory_open...")

   CALL gt_ut_log("Testing gt_directory_next...")

   CALL gt_ut_log("Testing gt_directory_close...")

   CALL gt_ut_log("Testing gt_rmdir with recursion...")

   IF gt_rmdir("gt_ut_dir_test1", TRUE) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   CALL gt_ut_log("Testing gt_rmdir...")

   IF gt_rmdir("gt_ut_dir_test2", TRUE) == TRUE THEN
      CALL gt_ut_log("Passed")
   ELSE
      CALL gt_ut_log("FAILED")
      RETURN FALSE
   END IF

   RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#