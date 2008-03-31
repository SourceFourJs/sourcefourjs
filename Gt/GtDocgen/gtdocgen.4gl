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
# Documentation Generator Module.
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

MAIN

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR STOP
	LET l_id = "$Id$"

   CALL gt_main_function()

END MAIN

##
# this is the main function. also a test for the documentation
#

FUNCTION gt_main_function()

DEFINE
   i                      INTEGER,
   l_log_file             STRING,
   l_configuration_file   STRING

   LET l_log_file = "gtdocgen.log"
   LET l_configuration_file = NULL

   FOR i = 1 TO base.application.getargumentcount()
	   IF base.application.getargument(i) == "-c" THEN
		   LET l_configuration_file = base.application.getargument(i + 1)
	   END IF

	   IF base.application.getargument(i) == "--configuration-file" THEN
		   LET l_configuration_file = base.application.getargument(i + 1)
	   END IF

       IF base.application.getargument(i) == "-l" THEN
		   LET l_log_file = base.application.getargument(i + 1)
	   END IF

	   IF base.application.getargument(i) == "--log-file" THEN
		   LET l_log_file = base.application.getargument(i + 1)
	   END IF
   END FOR

   CALL startlog(l_log_file)

	IF l_configuration_file IS NULL THEN
		CALL errorlog(%"No configuration file specified")
		EXIT PROGRAM
	END IF

	IF gt_read_configuration_file(l_configuration_file) THEN
		IF gt_parse_source(gt_source_directory()) THEN

         CASE
            WHEN gt_output_format() == "XHTML"
               CALL gt_generate_xhtml_documentation()
               CALL gt_generate_xhtml_index(gt_source_directory())

            OTHERWISE
         END CASE
      END IF
	END IF

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

FUNCTION gt_system_error()
END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#