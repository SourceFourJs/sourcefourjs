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
# Module to read the configuration file for GtDocgen.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

IMPORT os

DEFINE
	m_configuration   RECORD
      source_directory   STRING,
      recursive          SMALLINT,
      output_directory   STRING,
      output_format      STRING,
      stylesheet         STRING,
      class_id           STRING
	END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION gtdocgen_config_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR STOP
	LET l_id = "$Id$"

END FUNCTION

##
# This function returns the directory containing the source to parse.
# @return m_configuration.source_directory The source directory to parse.
#

FUNCTION gt_source_directory()

   RETURN m_configuration.source_directory

END FUNCTION

##
# This function returns whether subdirectories of the source path are to be
# parsed or not.
# @return m_configuration.recursive TRUE if the parse should processes
#                                   subdirectories, FALSE otherwise.
#

FUNCTION gt_recursive()

   RETURN m_configuration.recursive

END FUNCTION

##
# This function returns the directory where the documentation is to be written to.
# @return m_configuation.output_directory The output directory.
#

FUNCTION gt_output_directory()

   RETURN m_configuration.output_directory

END FUNCTION

##
# This function returns the type of output to generate for the documentation.
# @return m_configuration.output_format The output format required.
#

FUNCTION gt_output_format()

   RETURN m_configuration.output_format

END FUNCTION

##
# This function returns the stylesheet to be used for the documentation.
# @return m_configuration.stylesheet The stylesheet to use.
#

FUNCTION gt_stylesheet()

   RETURN m_configuration.stylesheet

END FUNCTION

##
# This function returns the class id to be used for the documentation.
# @return m_configuration.class_id The class id to use.
#

FUNCTION gt_class_id()

   RETURN m_configuration.class_id

END FUNCTION

##
# This function reads the given configuration file.
# @param l_configuration_file The configuraton file to read.
# @return l_ok TRUE if the configuration file was successfully parsed, FALSE
#              otherwise.
#

FUNCTION gt_read_configuration_file(l_configuration_file)

DEFINE
	l_configuration_file   STRING

DEFINE
   l_ok          SMALLINT,
   l_value       STRING,
   l_buffer      STRING,
   l_variable    STRING,
   l_filehdl     base.Channel,
   l_tokenizer   base.StringTokenizer

   LET l_ok = FALSE
   LET m_configuration.source_directory = NULL
   LET m_configuration.recursive = NULL
   LET m_configuration.output_directory = NULL
   LET m_configuration.output_format = NULL
   LET m_configuration.stylesheet = NULL
   LET m_configuration.class_id = NULL

   IF os.path.isfile(l_configuration_file) THEN
      LET l_filehdl = base.channel.create()

      CALL l_filehdl.openfile(l_configuration_file, "r")

      IF STATUS == 0 THEN
         WHILE NOT l_filehdl.iseof()
            LET l_buffer = l_filehdl.readline()

            IF l_buffer.getCharAt(1) == "#" THEN
               CONTINUE WHILE
            END IF

            LET l_tokenizer = base.stringtokenizer.create(l_buffer, "=")
            LET l_variable = l_tokenizer.nexttoken()
            LET l_value = l_tokenizer.nexttoken()

            LET l_variable = l_variable.trim()
            LET l_value = l_value.trim()

            CASE
               WHEN l_variable == "source_directory"
                  LET m_configuration.source_directory = l_value

               WHEN l_variable == "recursive"
                  IF l_value.touppercase() == "TRUE"
                  OR l_value.touppercase() == "YES"
                  OR l_value.touppercase() == "Y" THEN
                     LET m_configuration.recursive = TRUE
                  ELSE
                     LET m_configuration.recursive = FALSE
                  END IF

               WHEN l_variable == "output_directory"
                  LET m_configuration.output_directory = l_value

               WHEN l_variable == "output_format"
                  LET m_configuration.output_format = l_value

               WHEN l_variable == "stylesheet"
                  LET m_configuration.stylesheet = l_value

               WHEN l_variable == "class_id"
                  LET m_configuration.class_id = l_value

               OTHERWISE
            END CASE
         END WHILE

         CALL l_filehdl.close()
      END IF
   ELSE
   END IF

   IF m_configuration.source_directory IS NOT NULL
   AND m_configuration.recursive IS NOT NULL
   AND m_configuration.output_directory IS NOT NULL
   AND m_configuration.output_format IS NOT NULL
   AND m_configuration.stylesheet IS NOT NULL
   AND m_configuration.class_id IS NOT NULL THEN
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#