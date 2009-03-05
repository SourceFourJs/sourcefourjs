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
# PDF Format Library
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

DEFINE
    m_document_count   INTEGER,

    m_document_list DYNAMIC ARRAY OF RECORD
        pdfhdl       STRING,
        filename     STRING,
        stylesheet   STRING,
        class        STRING,
        pdf          om.saxdocumenthandler
    END RECORD

##
# Function to set WHENEVER ANY ERROR for this module
#

FUNCTION libgt_pdf_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function_description
# @param param Parameter_description.
# @return returning Return_description.
#

FUNCTION gt_create_pdf_document()
END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This function finds the relevant pdf document in the list.
# @param l_pdfhdl The document to find.
# @return l_pos The position in the list of the document, NULL otherwise.
#

FUNCTION gtp_find_pdf_document(l_pdfhdl)

DEFINE
    l_pdfhdl   STRING

DEFINE
    i       INTEGER,
    l_pos   INTEGER

    LET l_pos = NULL

    FOR i = 1 TO m_document_count
        IF m_document_list[i].pdfhdl == l_pdfhdl THEN
            LET l_pos = i
            EXIT FOR
        END IF
  END FOR

  RETURN l_pos

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
