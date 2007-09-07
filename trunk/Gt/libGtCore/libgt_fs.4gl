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
# File System Interface Library
#
# This is mostly just a wrapper around base.channel and the file extension
# library though some functions have added functionality.
#
# @category System Program
# @author Scott Newton
# @date August 2007
# @version $Id$
#

IMPORT os

CONSTANT Gt_FS_EXCLUDE_HIDDEN = 1
CONSTANT Gt_FS_EXCLUDE_DIRECTORIES = 2
CONSTANT Gt_FS_EXCLUDE_SYMLINKS = 4
CONSTANT Gt_FS_EXCLUDE_FILES = 8

CONSTANT Gt_FS_UNDEFINED = 0
CONSTANT Gt_FS_NAME = 1
CONSTANT Gt_FS_SIZE = 2
CONSTANT Gt_FS_TYPE = 3
CONSTANT Gt_FS_ATIME = 4
CONSTANT Gt_FS_CTIME = 5
CONSTANT Gt_FS_EXTENSION = 6

CONSTANT Gt_FS_ASCENDING = 1
CONSTANT Gt_FS_DESCENDING = -1

CONSTANT Gt_FS_READ_ONLY = 1
CONSTANT Gt_FS_WRITE_ONLY = 2
CONSTANT Gt_FS_READ_WRITE = 4
CONSTANT Gt_FS_STDIO = 8
CONSTANT Gt_FS_BINARY = 16

CONSTANT Gt_IO_ASCII = 0
CONSTANT Gt_IO_BINARY = 1

DEFINE
   m_io_count   INTEGER,

   m_io_list   DYNAMIC ARRAY OF RECORD
      iohdl    STRING,
      handle   base.channel,
      buffer   STRING
   END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_fs_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# This function returns the separator used to delimit paths in enviroment
# variables.
# @return l_pathseparator The path separator.
#

FUNCTION gt_path_separator()

   RETURN os.path.pathseparator()

END FUNCTION

##
# This function returns whether the given path exists or not.
# @param l_path The path to check.
# @return TRUE if the path exists, FALSE otherwise.
#

FUNCTION gt_exists(l_path)

DEFINE
   l_path   STRING

   RETURN os.path.exists(l_path.trim())

END FUNCTION

##
# This function checks to see whether the given path is a root path or not.
# @param l_path The path to check.
# @return l_is_root TRUE if the is a root path, FALSE otherwise.
#

FUNCTION gt_is_root_path(l_path)

DEFINE
   l_path   STRING

   RETURN os.path.isroot(l_path.trim())

END FUNCTION

##
# This function returns the present working directory.
# @return l_pwd The present working directory.
#

FUNCTION gt_pwd()

   RETURN os.path.pwd()

END FUNCTION

##
# This function returns the current home directory.
# @return l_homedir The current home directory.
#

FUNCTION gt_home_directory()

   RETURN os.path.homedir()

END FUNCTION

##
# This function returns the root directory.
# @return l_rootdir The root directory.
#

FUNCTION gt_root_directory()

   RETURN os.path.rootdir()

END FUNCTION

##
# Function to return the available volumes.
# @return l_volumes. A list of volumes separated by |.
#

FUNCTION gt_volumes()

   RETURN os.path.volumes()

END FUNCTION

##
# Function to change the current working volume.
# @param l_volume The volume to change to.
# @return l_ok TRUE if the volume is successfully changed, FALSE otherwise.
#

FUNCTION gt_change_volume()

DEFINE
   l_volume   STRING

   RETURN os.path.chvolume(l_volume.trim())

END FUNCTION

##
# Functin to change the current working directory.
# @param l_directory The directory to change to.
# @return l_ok TRUE if directory successfully changed, FALSE otherwise.
#

FUNCTION gt_change_directory(l_directory)

DEFINE
   l_directory   STRING

   RETURN os.path.chdir(l_directory.trim())

END FUNCTION

##
# This function returns the filesystem separator.
# @return l_separator The filesystem separator.
#

FUNCTION gt_filesystem_separator()

   RETURN os.path.separator()

END FUNCTION

##
# This function returns the path excluding the last element.
# @param l_filename The filename to parse.
# @return l_dir The path excluding the last element.
#

FUNCTION gt_dirname(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.dirname(l_filename.trim())

END FUNCTION

##
# This function returns whether the given path is an absolute or a relative path.
# @param l_path The path to check.
# @param l_type The type of path, either "absolute" or "relative".
#

FUNCTION gt_pathtype(l_path)

DEFINE
   l_path   STRING

   RETURN os.path.pathtype(l_path.trim())

END FUNCTION

##
# This function returns the last element of a path.
# @param l_filename The filename to parse.
# @return l_base The last element of the path.
#

FUNCTION gt_basename(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.basename(l_filename.trim())

END FUNCTION

##
# This function returns the file path without the file extension.
# @param l_filename The filename to parse.
# @return l_root The file path without the file extension.
#

FUNCTION gt_rootname(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.rootname(l_filename.trim())

END FUNCTION

##
# Function used to join two file paths. The relevant separator is automatically
# added if required.
# @param l_first The first path.
# @param l_second The second path
# @return l_path The result of the concatentaion of the two paths.
#

FUNCTION gt_fs_join(l_first, l_second)

DEFINE
   l_first    STRING,
   l_second   STRING

   RETURN os.path.join(l_first.trim(), l_second.trim())

END FUNCTION

##
# This function checks to see whether the given filename is of type file or not.
# @param l_filename The filename to check.
# @return l_is_file TRUE if the file is of type file, FALSE otherwise.
#

FUNCTION gt_is_file(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.isfile(l_filename.trim())

END FUNCTION

##
# This function checks to see whether the given filename is of type directory
# or not.
# @param l_filename The filename to check.
# @return l_is_file TRUE if the file is of type directory, FALSE otherwise.
#

FUNCTION gt_is_directory(l_directory)

DEFINE
   l_directory   STRING

   RETURN os.path.isdirectory(l_directory.trim())

END FUNCTION

##
# This function checks to see whether the given filename is hidden or not.
# @param l_filename The filename to check.
# @return l_is_file TRUE if the file is hidden, FALSE otherwise.
#

FUNCTION gt_is_hidden(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.ishidden(l_filename.trim())

END FUNCTION

##
# This function checks to see whether the given filename is a link or not.
# @note UNIX only!
# @param l_filename The filename to check.
# @return l_is_file TRUE if the file is a link, FALSE otherwise.
#

FUNCTION gt_is_link(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.islink(l_filename.trim())

END FUNCTION

##
# This function checks to see whether the given file is readable or not.
# @param l_filename The file to check.
# @return l_is_readable TRUE if the file is readable, FALSE otherwise.
#

FUNCTION gt_is_readable(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.readable(l_filename.trim())

END FUNCTION

##
# This function checks to see whether the given file is writable or not.
# @param l_filename The file to check.
# @return l_is_writable TRUE if the file is writable, FALSE otherwise.
#

FUNCTION gt_is_writable(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.writable(l_filename.trim())

END FUNCTION

##
# This function checks to see whether the give file is executable or not.
# @param l_filename The file to check.
# @return l_is_executable TRUE if the file is executable, FALSE otherwise.
#

FUNCTION gt_is_executable(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.executable(l_filename.trim())

END FUNCTION

##
# This function returns the uid for the given user.
# @note UNIX only!
# @param l_user The user to get the uid for.
# @return l_uid The uid of the given user.
#

FUNCTION gt_uid(l_user)

DEFINE
   l_user   STRING

   RETURN os.path.uid(l_user.trim())

END FUNCTION

##
# This function returns the gid for the given group.
# @note UNIX only!
# @param l_group The group to get the gid for.
# @return l_gid The gid of the given group.
#

FUNCTION gt_gid(l_group)

DEFINE
   l_group   STRING

   RETURN os.path.gid(l_group.trim())

END FUNCTION

##
# This function returns the read write permissions for the given file.
# @note UNIX only!
# @param l_filename The filename to check.
# @return l_rwx The permissions for the given filename.
#

FUNCTION gt_rwx(l_filename)

DEFINE
   l_filename   STRING

DEFINE
   l_tmp     INTEGER,
   l_value   INTEGER,
   l_mode    STRING

   LET l_value = os.path.rwx(l_filename.trim())

   LET l_tmp = l_value / 64
   LET l_mode = l_tmp
   LET l_value = l_value - (l_tmp * 64)

   LET l_tmp = l_value / 8
   LET l_mode = l_mode, l_tmp
   LET l_value = l_value - (l_tmp * 8)

   LET l_mode = l_mode, l_value

   RETURN l_mode

END FUNCTION

##
# This function changes the owner on the given file.
# @param l_filename The file to change owner on.
# @return l_ok TRUE if the owner was successfully changed, FALSE otherwise.
#

FUNCTION gt_chmod(l_filename, l_mode)

DEFINE
   l_filename   STRING,
   l_mode       STRING

DEFINE
   l_value   INTEGER,
   l_char    STRING

   #---------------------------------------------------------------------------#
   # Allow modes to be entered as either 666 or 0666                           #
   #---------------------------------------------------------------------------#

   IF l_mode.getlength() == 3
   OR l_mode.getlength() == 4 THEN
      IF l_mode.getlength() == 4 THEN
         LET l_mode = l_mode.substring(2, 3)
      END IF

      LET l_value = ((l_mode.getcharat(1) * 64) +
                     (l_mode.getcharat(2) * 8) +
                     (l_mode.getcharat(3)))
   ELSE
      CALL gt_set_error("ERROR", SFMT(%"The mode value %1 given to gt_chmod is invalid", l_mode))
      RETURN FALSE
   END IF

   RETURN os.path.chrwx(l_filename, l_value)

END FUNCTION

##
# This function changes the owner on the given file.
# @note UNIX only!
# @param l_filename The file to change owner on.
# @return l_ok TRUE if the owner was successfully changed, FALSE otherwise.
#

FUNCTION gt_chown(l_filename, l_user, l_group)

DEFINE
   l_filename   STRING,
   l_user       STRING,
   l_group      STRING

DEFINE
   l_uid        INTEGER,
   l_gid        INTEGER

   LET l_uid = gt_uid(l_user)
   LET l_gid = gt_gid(l_group)

   RETURN os.path.chown(l_filename, l_uid, l_gid)

END FUNCTION

##
# This function returns whether the given file exists or not.
# @param l_filename The file to check.
# @return l_exists TRUE if the file exists, FALSE otherwise.
#

FUNCTION gt_file_exists(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.isfile(l_filename.trim())

END FUNCTION

##
# This function returns the file extension.
# @param l_filename The filename to find the extension of.
# @return l_extension The extension for the file.
#

FUNCTION gt_file_extension(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.extension(l_filename.trim())

END FUNCTION

##
# This function returns the given file type.
#
# The returned type can be "file", "directory", "socket", "fifo", "block" or
# "char".
# @param l_filename The filename to check.
# @return l_type Returns the type of the given file.
#

FUNCTION gt_file_type(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.type(l_filename.trim())

END FUNCTION

##
# This function tries to guess the file content based on contents of the file.
# @param l_filename The file to guess the contents of.
# @return l_extension The extension of the file contents. If the contents are
#                     cannot be determined NULL is returned.
#

FUNCTION gt_guess_file_content(l_filename)

DEFINE
   l_filename   STRING

DEFINE
   l_filehdl   base.channel

END FUNCTION

##
# This function returns the size of the given file.
# @param l_filename The file to get the size of.
# @return l_size The size of the file in bytes.
#

FUNCTION gt_file_size(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.size(l_filename.trim())

END FUNCTION

##
# This function returns the last access time of the given file.
# @param l_filename The file to check.
# @return l_atime The last access time of the given file.
#

FUNCTION gt_file_access_time(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.atime(l_filename.trim())

END FUNCTION

##
# This function returns the last modification time of the given file.
# @param l_filename The file to check.
# @return l_atime The last modification time of the given file.
#

FUNCTION gt_file_modification_time(l_filename)

DEFINE
   l_filename   STRING

   RETURN os.path.mtime(l_filename.trim())

END FUNCTION

##
# Function to copy a file or directory
# @param l_source The file or directory to copy.
# @param l_destination The destination name for the file or directory.
# @param l_overwrite TRUE if the copy can overwrite and existing file, FALSE
#                    otherwise.
# @return l_ok TRUE if the file or directory was successfully copied, FALSE
#              otherwise.
#

FUNCTION gt_copy(l_source, l_destination, l_overwrite)

DEFINE
   l_source        STRING,
   l_destination   STRING,
   l_overwrite     SMALLINT

DEFINE
   l_ok   SMALLINT

   LET l_ok = FALSE

   IF l_overwrite THEN
      LET l_ok = os.path.copy(l_source.trim(), l_destination.trim())
   ELSE
      IF gt_file_exists(l_destination.trim()) THEN
         CALL gt_set_warning("WARNING", SFMT(%"Warning: Copying of %1 to %2 denied because %3 already exists", l_source, l_destination, l_destination))
         LET l_ok = FALSE
      ELSE
         LET l_ok = os.path.copy(l_source.trim(), l_destination.trim())
      END IF
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to rename a directory or file.
# @param l_name The directory or file to rename.
# @param l_new_name The new name for the directory or file.
# @param l_overwrite TRUE if the copy can overwrite and existing file, FALSE
#                    otherwise.
# @return l_ok TRUE if the file or directory is successfully renamed, FALSE
#              otherwise.
#

FUNCTION gt_rename(l_old_name, l_new_name, l_overwrite)

DEFINE
   l_old_name    STRING,
   l_new_name    STRING,
   l_overwrite   STRING

DEFINE
   l_ok   SMALLINT

   IF l_overwrite THEN
      LET l_ok = os.path.rename(l_old_name.trim(), l_new_name.trim())
  ELSE
      IF gt_exists(l_new_name) THEN
         CALL gt_set_warning("WARNING", SFMT(%"Warning: Path rename of %1 to %2 failed because %3 already exists", l_old_name, l_new_name, l_new_name))
         LET l_ok = FALSE
      ELSE
         LET l_ok = os.path.rename(l_old_name.trim(), l_new_name.trim())
      END IF
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to delete a file or directory.
# @param l_filename The file or directory to delete.
# @return l_ok TRUE if the file or directory is successfully deleted, FALSE
#              otherwise.
#

FUNCTION gt_delete(l_filename)

DEFINE
   l_filename    STRING

   RETURN os.path.delete(l_filename.trim())

END FUNCTION

##
# Function to set the delimiter for the given handle.
# @param l_handle The handle to the file or pipe to set the delimiter for.
# @param l_delimiter The delimiter to set.
#

FUNCTION gt_set_delimiter(l_handle, l_delimiter)

DEFINE
   l_handle      base.channel,
   l_delimiter   STRING

   CALL l_handle.setdelimiter(l_delimiter)

END FUNCTION

##
# Function to retrieve the contents of the file buffer.
# @param l_filehdl The filehdl for the open file.
# @return l_buffer The buffer for the given filehdl.
#

FUNCTION gt_io_buffer(l_iohdl)

DEFINE
   l_iohdl   STRING

DEFINE
   i          INTEGER,
   l_pos      INTEGER,
   l_buffer   STRING,
   l_io       base.channel

   LET l_buffer = NULL

   CALL p_gt_find_io(l_iohdl)
      RETURNING l_pos, l_io

   IF l_io IS NOT NULL THEN
      LET l_buffer = m_io_list[l_pos].buffer
   ELSE
      CALL gt_set_error("ERROR", SFMT(%"The given iohdl %1 is invalid", l_iohdl))
   END IF

   RETURN l_buffer

END FUNCTION

##
# Function to open or create a file for reading or writing.
# @param l_filename The name of the file.
# @param l_mode The mode to open the file in.
# @param l_delimiter The delimiter for the file.
# @return l_ok TRUE if the file is successfully opened or created, FALSE
#              otherwise.
# @return l_filehdl The handle to the open file.
#

FUNCTION gt_file_open(l_filename, l_mode, l_delimiter)

DEFINE
   l_filename    STRING,
   l_mode        STRING,
   l_delimiter   STRING

DEFINE
   l_ok        SMALLINT,
   l_status    INTEGER,
   l_filehdl   STRING,
   l_file      base.channel

   LET l_ok = FALSE
   LET l_file = base.channel.create()

   IF l_file IS NOT NULL THEN
      LET m_io_count = m_io_count + 1
      LET l_filehdl = gt_next_serial("FILE")
      LET m_io_list[m_io_count].iohdl = l_filehdl
      LET m_io_list[m_io_count].handle = l_file
      LET m_io_list[m_io_count].buffer = NULL

      CALL l_file.setdelimiter(l_delimiter)

      CALL l_file.openFile(l_filename, l_mode)

      LET l_status = STATUS

      CASE
         WHEN l_status == 0
            LET l_ok = TRUE

         OTHERWISE
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"The attempt to open the file %1 resulted in an unknown status being returned", l_filename, l_status))
      END CASE
   END IF

   RETURN l_ok, l_filehdl

END FUNCTION

##
# This function reads from the file given by the filehdl.
# @param l_filehdl The handle of the file to read from.
# @return l_ok TRUE if the read was successful, FALSE otherwise.
#

FUNCTION gt_file_read(l_filehdl)

DEFINE
   l_filehdl   STRING

DEFINE
   l_ok       SMALLINT,
   l_pos      INTEGER,
   l_status   INTEGER,
   l_buffer   STRING,
   l_file     base.channel

   LET l_ok = FALSE
   CALL p_gt_find_io(l_filehdl)
      RETURNING l_pos, l_file

   IF l_file IS NOT NULL THEN
      LET l_ok = l_file.read(l_buffer)
      LET l_status = STATUS

      IF l_ok THEN
         LET m_io_list[l_pos].buffer = l_buffer
      ELSE
         CASE
            WHEN l_status == 0

            OTHERWISE
         END CASE
      END IF
   ELSE
      CALL gt_set_error("ERROR", SFMT(%"The given filehdl %1 is invalid", l_filehdl))
      LET l_ok = FALSE
   END IF

   RETURN l_ok

END FUNCTION

##
# This function writes to the given file handle.
# @param l_filehdl The handle to the file to write to.
# @param l_buffer The buffer to write to the file handle.
#

FUNCTION gt_file_write(l_filehdl, l_buffer)

DEFINE
   l_filehdl   STRING,
   l_buffer    STRING

DEFINE
   l_ok       SMALLINT,
   l_pos      INTEGER,
   l_mode     INTEGER,
   l_status   INTEGER,
   l_file     base.channel

   LET l_ok = FALSE

   CALL p_gt_find_io(l_filehdl)
      RETURNING l_pos, l_file

   IF l_file IS NOT NULL THEN
      #LET l_mode = m_io_list[l_pos].mode

      CASE
         WHEN l_mode == Gt_IO_ASCII
            CALL l_file.writeline(l_buffer)

         WHEN l_mode == Gt_IO_BINARY
            CALL l_file.write(l_buffer)

         OTHERWISE
            CALL l_file.write(l_buffer)
      END CASE

      LET l_status = STATUS

      CASE
         WHEN l_status == 0
         OTHERWISE
      END CASE
   ELSE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to close the given file handle.
# @param l_filehdl The file handle to close.
#

FUNCTION gt_file_close(l_filehdl)

DEFINE
   l_filehdl   STRING

DEFINE
   l_pos    INTEGER,
   l_file   base.channel

   CALL p_gt_find_io(l_filehdl)
      RETURNING l_pos, l_file

   IF l_file IS NOT NULL THEN
      CALL l_file.close()
      CALL m_io_list.deleteelement(l_pos)
   ELSE
      CALL gt_set_error("ERROR", SFMT(%"The given filehdl %1 is invalid", l_filehdl))
   END IF

END FUNCTION

##
# Function to open a pipe for a given command.
# @param l_command The command to run.
# @param l_mode The mode the pipe is to be opened in.
# @delimiter l_delimiter The delimiter to use for the pipe.
# @return l_ok TRUE if the pipe was successfully opened, FALSE otherwise.
# @return l_pipehdl The handle to the opened pipe.
#

FUNCTION gt_pipe_open(l_command, l_mode, l_delimiter)

DEFINE
   l_command     STRING,
   l_mode        STRING,
   l_delimiter   STRING

DEFINE
   l_ok        SMALLINT,
   l_status    INTEGER,
   l_pipehdl   STRING,
   l_pipe      base.channel

   LET l_ok = FALSE
   LET l_pipe = base.channel.create()

   IF l_pipe IS NOT NULL THEN
      LET m_io_count = m_io_count + 1
      LET l_pipehdl = gt_next_serial("PIPE")
      LET m_io_list[m_io_count].iohdl = l_pipehdl
      LET m_io_list[m_io_count].handle = l_pipe
      LET m_io_list[m_io_count].buffer = NULL

      CALL l_pipe.setdelimiter(l_delimiter)

      CALL l_pipe.openpipe(l_command, l_mode)

      LET l_status = STATUS

      CASE
         WHEN l_status == 0
            LET l_ok = TRUE

         OTHERWISE
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"The attempt to open the pipe with command %1 resulted in an unknown status %2 being returned", l_command, l_status))
      END CASE
   END IF

   RETURN l_ok, l_pipehdl

END FUNCTION

##
# This function reads from the pipe given by the pipehdl.
# @param l_pipehdl The handle of the pipe to read from.
# @return l_ok TRUE if the read was successful, FALSE otherwise.
#

FUNCTION gt_pipe_read(l_pipehdl)

DEFINE
   l_pipehdl   STRING

DEFINE
   l_ok       SMALLINT,
   l_pos      INTEGER,
   l_buffer   STRING,
   l_pipe     base.channel

   LET l_ok = FALSE
   CALL p_gt_find_io(l_pipehdl)
      RETURNING l_pos, l_pipe

   IF l_pipe IS NOT NULL THEN
      IF l_pipe.read(l_buffer) THEN
         LET m_io_list[l_pos].buffer = l_buffer
      END IF
   ELSE
      CALL gt_set_error("ERROR", SFMT(%"The given filehdl %1 is invalid", l_pipehdl))
      LET l_ok = FALSE
   END IF

   RETURN l_ok

END FUNCTION

##
# This function writes to the given pipe handle.
# @param l_pipehdl The handle to the pipe to write to.
# @param l_buffer The buffer to write to the pipe handle.
#

FUNCTION gt_pipe_write(l_pipehdl, l_buffer)

DEFINE
   l_pipehdl   STRING,
   l_buffer    STRING

DEFINE
   l_ok       SMALLINT,
   l_pos      INTEGER,
   l_mode     INTEGER,
   l_status   INTEGER,
   l_pipe     base.channel

   LET l_ok = FALSE

   CALL p_gt_find_io(l_pipehdl)
      RETURNING l_pos, l_pipe

   IF l_pipe IS NOT NULL THEN
      #LET l_mode = m_io_list[l_pos].mode

      CASE
         WHEN l_mode == Gt_IO_ASCII
            CALL l_pipe.writeline(l_buffer)

         WHEN l_mode == Gt_IO_BINARY
            CALL l_pipe.write(l_buffer)

         OTHERWISE
            CALL l_pipe.write(l_buffer)
      END CASE

      LET l_status = STATUS

      CASE
         WHEN l_status == 0
         OTHERWISE
      END CASE
   ELSE
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to close the given pipe handle.
# @param l_pipehdl The pipe handle to close
#

FUNCTION gt_pipe_close(l_pipehdl)

DEFINE
   l_pipehdl   STRING

DEFINE
   l_pos    INTEGER,
   l_pipe   base.channel

   CALL p_gt_find_io(l_pipehdl)
      RETURNING l_pos, l_pipe

   IF l_pipe IS NOT NULL THEN
      CALL l_pipe.close()
      CALL m_io_list.deleteelement(l_pos)
   ELSE
      CALL gt_set_error("ERROR", SFMT(%"The given pipehdl %1 is invalid", l_pipehdl))
   END IF

END FUNCTION

##
# This function returns whether the given directory exists or not.
# @param l_directory The directory to check.
# @return l_exists TRUE if the directory exists, FALSE otherwise.
#

FUNCTION gt_directory_exists()

DEFINE
   l_directory   STRING

   RETURN os.path.isdirectory(l_directory.trim())

END FUNCTION

##
# Function to create a directory.
# @param l_directory The directory to create.
# @return l_ok TRUE if the directory was successfully created, FALSE otherwise.
#

FUNCTION gt_mkdir(l_directory, l_recursive)

DEFINE
   l_directory   STRING,
   l_recursive   SMALLINT

DEFINE
   l_ok   SMALLINT

   IF l_recursive THEN
      # TODO
   ELSE
      LET l_ok = os.path.mkdir(l_directory.trim())
   END IF

   RETURN l_ok

END FUNCTION

##
# Function to delete a directory.
# @param l_filename The directory to delete.
# @return l_ok TRUE if the directory is successfully deleted, FALSE otherwise.
#

FUNCTION gt_rmdir(l_directory, l_recursive)

DEFINE
   l_directory   STRING,
   l_recursive   SMALLINT

DEFINE
   l_ok   SMALLINT

   LET l_ok = FALSE

   IF l_recursive THEN
   ELSE
      LET l_ok = os.path.delete(l_directory.trim())
   END IF

   RETURN l_ok

END FUNCTION

##
# This function sets the filter for directory listings.
# @param l_filter The filter to use.
#

FUNCTION gt_set_directory_filter(l_filter)

DEFINE
   l_filter   INTEGER

   CALL os.path.dirfmask(l_filter)

END FUNCTION

##
# Function to set the directory sorting criteria and order.
# @param l_criteria The directory sorting criteria.
# @param l_order The directory sorting order.
#

FUNCTION gt_set_directory_sorting(l_criteria, l_order)

DEFINE
   l_criteria   STRING,
   l_order      INTEGER

   CALL os.path.dirsort(l_criteria, l_order)

END FUNCTION

##
# Function to open the given directory.
# @param l_directory The directory to open.
# @param l_dirhdl The handle to the given directory.
#

FUNCTION gt_directory_open(l_directory)

DEFINE
   l_directory   STRING

   RETURN os.path.diropen(l_directory.trim())

END FUNCTION

##
# This function gets the next entry in the directory listing.
# @param l_dirhdl The handle to the require directory.
# @return l_file The next filename or NULL if there are no more files.

FUNCTION gt_directory_next(l_dirhdl)

DEFINE
   l_dirhdl   INTEGER

   RETURN os.path.dirnext(l_dirhdl)

END FUNCTION

##
# Function to close the given directory.
# @param l_dirhdl The handle to the required directory.
#

FUNCTION gt_directory_close(l_dirhdl)

DEFINE
   l_dirhdl   INTEGER

   CALL os.path.dirclose(l_dirhdl)

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This functions finds the relavent entry in the m_io_list array.
# @private
# @param l_iohdl The handle to the io channel.
# @return l_pos The position in the array on the io channel, 0 if not found.
# @return l_io The underlying handle to the io channel, NULL if not found.
#

FUNCTION p_gt_find_io(l_iohdl)

DEFINE
   l_iohdl   STRING

DEFINE
   i       INTEGER,
   l_pos   INTEGER,
   l_io    base.channel

   LET l_pos = 0
   LET l_io = NULL

   FOR i = 1 TO m_io_list.getlength()
      IF m_io_list[i].iohdl = l_iohdl THEN
         LET l_pos = i
         LET l_io = m_io_list[i].handle
         EXIT FOR
      END IF
   END FOR

   RETURN l_pos, l_io

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
