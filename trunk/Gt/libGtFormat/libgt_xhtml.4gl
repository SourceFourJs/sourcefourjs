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
# Description_of_Module
# @category System Program
# @author Scott Newton
# @date September 2007
# @version $Id$
#

DEFINE
   m_document_count   INTEGER,

   m_document_list   DYNAMIC ARRAY OF RECORD
      xhtmlhdl     STRING,
      filename     STRING,
      stylesheet   STRING,
      class        STRING,
      nodeptr      om.domnode,
      xhtml        om.saxdocumenthandler
   END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_xhtml_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
# Function to read an xhtml document into memory
# @param l_filename The filename to read.
#

FUNCTION gt_read_xhtml_document(l_filename)

DEFINE
   l_filename   STRING

   # TODO Read XHTML document

END FUNCTION

##
# Function to write an xhtml document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_write_xhtml_document(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos    INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("body")
      CALL m_document_list[l_pos].xhtml.enddocument()
   END IF

END FUNCTION

##
# Function to create an xhtml document.
# @param l_filename The name of the file to create.
# @param l_stylesheet The stylesheet to use in the XHTML document.
# @param l_class The id class to use for the elements in the XHTML document.
# @return l_ok TRUE if the document was successfully created, FALSE otherwise.
#

FUNCTION gt_create_xhtml_document(l_filename, l_stylesheet, l_class)

DEFINE
   l_filename     STRING,
   l_stylesheet   STRING,
   l_class        STRING

DEFINE
   l_ok   SMALLINT

   LET l_ok = FALSE

   LET m_document_count = m_document_count + 1
   LET m_document_list[m_document_count].xhtmlhdl = gt_next_serial("XHTML")
   LET m_document_list[m_document_count].filename = l_filename.trim()
   LET m_document_list[m_document_count].stylesheet = l_stylesheet.trim()
   LET m_document_list[m_document_count].class = l_class.trim()
   LET m_document_list[m_document_count].xhtml = om.xmlwriter.createfilewriter(l_filename)

   IF m_document_list[m_document_count].xhtml IS NOT NULL THEN
      CALL m_document_list[m_document_count].xhtml.startdocument()
      CALL m_document_list[m_document_count].xhtml.setindent(TRUE)
      CALL m_document_list[m_document_count].xhtml.processinginstruction("DOCTYPE", "html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\"")
      LET l_ok = TRUE
   END IF

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# Structural Tags                                                              #
#------------------------------------------------------------------------------#

##
# Function to the header information for the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
# @param l_title The title for the XHTML document.
#

FUNCTION gt_xhtml_header(l_xhtmlhdl, l_title)

DEFINE
   l_xhtmlhdl     STRING,
   l_title        STRING,
   l_stylesheet   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("html", l_attributes)

      CALL l_attributes.addattribute("xmlns", "http://www.w3.org/1999/xhtml")
      CALL l_attributes.clear()

      CALL m_document_list[l_pos].xhtml.startelement("head", l_attributes)
      CALL m_document_list[l_pos].xhtml.startelement("title", l_attributes)
      CALL m_document_list[l_pos].xhtml.characters(l_title.trim())
      CALL m_document_list[l_pos].xhtml.endelement("title")
      CALL m_document_list[l_pos].xhtml.endelement("head")
      CALL l_attributes.clear()
   END IF

   #<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
   #<html xmlns="http://www.w3.org/1999/xhtml">
   #<head>
   #   <title>XHTML Reference</title>
   #</head>
   #<body>
   #...
   #</body>
   #</html>

END FUNCTION

##
# Function to write the body tag to the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_body(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("body", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Text Tags: Block-Level Elements                                              #
#------------------------------------------------------------------------------#

##
# Function to create an address tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_address(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("address", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("address")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to create a blockquote tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_blockquote(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("blockquote", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("blockquote")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to create a definition item tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_dd(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("dd", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("dd")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to start the division tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_div(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("div", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the division tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_div(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("div")
   END IF

END FUNCTION

##
# Function to start the definition list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_dl(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("dl", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the definition list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_dl(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("dl")
   END IF

END FUNCTION

##
# Function to start the definition term tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_dt(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("dt", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the definition term tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_dt(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("dt")
   END IF

END FUNCTION

##
# Function to create a heading tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_heading(l_xhtmlhdl, l_level, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_level      INTEGER,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()

      CASE
         WHEN l_level = 1
            CALL m_document_list[l_pos].xhtml.startelement("h1", l_attributes)

         WHEN l_level = 2
            CALL m_document_list[l_pos].xhtml.startelement("h2", l_attributes)

         WHEN l_level = 3
            CALL m_document_list[l_pos].xhtml.startelement("h3", l_attributes)

         WHEN l_level = 4
            CALL m_document_list[l_pos].xhtml.startelement("h4", l_attributes)

         WHEN l_level = 5
            CALL m_document_list[l_pos].xhtml.startelement("h5", l_attributes)

         WHEN l_level = 6
            CALL m_document_list[l_pos].xhtml.startelement("h6", l_attributes)

         OTHERWISE
      END CASE

      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)

      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())

      CASE
         WHEN l_level = 1
            CALL m_document_list[l_pos].xhtml.endelement("h1")

         WHEN l_level = 2
            CALL m_document_list[l_pos].xhtml.endelement("h2")

         WHEN l_level = 3
            CALL m_document_list[l_pos].xhtml.endelement("h3")

         WHEN l_level = 4
            CALL m_document_list[l_pos].xhtml.endelement("h4")

         WHEN l_level = 5
            CALL m_document_list[l_pos].xhtml.endelement("h5")

         WHEN l_level = 6
            CALL m_document_list[l_pos].xhtml.endelement("h6")

         OTHERWISE
      END CASE

      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to create a horizontical rule tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_hr(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("hr", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.endelement("hr")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to start the item list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_li(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("li", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the item list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_li(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("li")
   END IF

END FUNCTION

##
# Function to start the ordered list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_ol(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("ol", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the ordered list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_ol(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("ol")
   END IF

END FUNCTION

##
# Function to start the paragraph tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_p(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("p", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the paragraph tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_p(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("p")
   END IF

END FUNCTION

##
# Function to start the unordered list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_ul(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("ul", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the unordered list tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_ul(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("ul")
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Text Tags: Inline Styles                                                     #
#------------------------------------------------------------------------------#

##
# Function to start the bold tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_b(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("b", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the bold tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_b(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("b")
   END IF

END FUNCTION

##
# Function to start the big tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_big(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("big", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the big tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_big(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("big")
   END IF

END FUNCTION

##
# Function to create a citation tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_cite(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("cite", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("cite")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to create a code tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_code(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("code", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("code")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to start the emphasis tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_em(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("em", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the emphasis tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_em(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("em")
   END IF

END FUNCTION

##
# Function to start the italics tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_i(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("i", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the italics tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_i(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("i")
   END IF

END FUNCTION

##
# Function to create a keyboard tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_kdb(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("kbd", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("kbd")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to enter the preformatted tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_pre(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("pre", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("pre")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to create a sample tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_samp(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("samp", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("samp")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to start the small tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_small(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("small", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the small tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_small(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("small")
   END IF

END FUNCTION

##
# Function to start the spanning tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_span(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("span", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the spanning tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_span(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("span")
   END IF

END FUNCTION

##
# Function to start the strong tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_strong(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("strong", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the strong tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_strong(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("strong")
   END IF

END FUNCTION

##
# Function to enter the subscript tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_sub(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("sub", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("sub")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to enter the superscript tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_sup(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("sup", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("sup")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to enter the teletype tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_tt(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("tt", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("tt")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to enter the variable tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_var(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("var", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("var")
      CALL l_attributes.clear()
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Text Tags: Logical Styles                                                    #
#------------------------------------------------------------------------------#

##
# Function to enter the abbreviation tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_abbr(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("abbr", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("abbr")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to enter the acronym tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_acronym(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("acronym", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("acronym")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to start the deleted tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_del(l_xhtmlhdl, l_cite, l_datetime)

DEFINE
   l_xhtmlhdl   STRING,
   l_cite       STRING,
   l_datetime   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("del", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)

      IF l_cite.getlength() > 0 THEN
         CALL l_attributes.addattribute("cite", l_cite.trim())
      END IF

      IF l_datetime.getlength() > 0 THEN
         CALL l_attributes.addattribute("datetime", l_datetime.trim())
      END IF

      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the deleted tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_del(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("del")
   END IF

END FUNCTION

##
# Function to start the inserted tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_ins(l_xhtmlhdl, l_cite, l_datetime)

DEFINE
   l_xhtmlhdl   STRING,
   l_cite       STRING,
   l_datetime   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("ins", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)

      IF l_cite.getlength() > 0 THEN
         CALL l_attributes.addattribute("cite", l_cite.trim())
      END IF

      IF l_datetime.getlength() > 0 THEN
         CALL l_attributes.addattribute("datetime", l_datetime.trim())
      END IF

      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the inserted tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_ins(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("ins")
   END IF

END FUNCTION

##
# Function to enter the quote tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_q(l_xhtmlhdl, l_text, l_cite)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING,
   l_cite       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("q", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)

      IF l_cite.getLength() > 0 THEN
         CALL l_attributes.addattribute("cite", l_cite.trim())
      END IF

      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("q")
      CALL l_attributes.clear()
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Text Tags: Physical Styles                                                   #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# List Tags                                                                    #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Spacing and Positioning Tags                                                 #
#------------------------------------------------------------------------------#

##
# Function to enter the break tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_br(l_xhtmlhdl, l_clear)

DEFINE
   l_xhtmlhdl   STRING,
   l_clear      STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("br", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)

      IF l_clear.getLength() > 0 THEN
         CALL l_attributes.addattribute("clear", l_clear.trim())
      END IF

      CALL m_document_list[l_pos].xhtml.endelement("br")
      CALL l_attributes.clear()
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Linking Tags                                                                 #
#------------------------------------------------------------------------------#

##
# Function to add an anchor tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_a(l_xhtmlhdl, l_text, l_href, l_title)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING,
   l_href       STRING,
   l_title      STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("a", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.addattribute("href", l_href.trim())

      IF l_title.getlength() > 0 THEN
         CALL l_attributes.addattribute("title", l_title.trim())
      END IF

      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("a")
      CALL l_attributes.clear()
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Table Tags                                                                   #
#------------------------------------------------------------------------------#

FUNCTION gt_xhtml_caption(l_xhtmlhdl, l_text)

DEFINE
   l_xhtmlhdl   STRING,
   l_text       STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("caption", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL m_document_list[l_pos].xhtml.characters(l_text.trim())
      CALL m_document_list[l_pos].xhtml.endelement("caption")
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to start the table tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_table(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("table", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_table(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("table")
   END IF

END FUNCTION

##
# Function to start the table column group tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_colgroup(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("colgroup", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table column group tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_colgroup(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("colgroup")
   END IF

END FUNCTION

##
# Function to start the table column tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_col(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("col", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table column tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_col(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("col")
   END IF

END FUNCTION

##
# Function to start the table row tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_tr(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("tr", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table row tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_tr(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("tr")
   END IF

END FUNCTION

##
# Function to start the table header tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_th(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("th", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table header tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_th(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("th")
   END IF

END FUNCTION

##
# Function to start the table data tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_td(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("td", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table data tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_td(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("td")
   END IF

END FUNCTION

##
# Function to start the table header tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_thead(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("thead", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table header tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_thead(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("thead")
   END IF

END FUNCTION

##
# Function to start the table body tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_tbody(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("tbody", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table body tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_tbody(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("tbody")
   END IF

END FUNCTION

##
# Function to start the table footer tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_tfoot(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("tfoot", l_attributes)
      CALL l_attributes.addattribute("class", m_document_list[l_pos].class)
      CALL l_attributes.clear()
   END IF

END FUNCTION

##
# Function to end the table footer tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_end_tfoot(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   l_pos          INTEGER

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      CALL m_document_list[l_pos].xhtml.endelement("tfoot")
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# Form Tags                                                                    #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
# Script Tags                                                                  #
#------------------------------------------------------------------------------#

##
# Function to add a script tag in the XHTML document.
# @param l_xhtmlhdl The handle to the XHTML document.
#

FUNCTION gt_xhtml_script(l_xhtmlhdl, l_language, l_script)

DEFINE
   l_xhtmlhdl   STRING,
   l_language   STRING,
   l_script     STRING

DEFINE
   l_pos          INTEGER,
   l_attributes   om.saxattributes

   LET l_pos = p_gt_find_xhtml_document(l_xhtmlhdl)

   IF l_pos IS NOT NULL THEN
      LET l_attributes = om.saxattributes.create()
      CALL m_document_list[l_pos].xhtml.startelement("script", l_attributes)
      CALL l_attributes.addattribute("type", l_language.trim())

      IF l_script.getlength() > 0 THEN
         CALL m_document_list[l_pos].xhtml.characters(l_script.trim())
      END IF

      CALL m_document_list[l_pos].xhtml.endelement("script")
      CALL l_attributes.clear()
   END IF

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
# This function finds the relevant xhtml document in the list.
# @param l_xhtmlhdl The document to find.
# @return l_pos The position in the list of the document, NULL otherwise.
#

FUNCTION p_gt_find_xhtml_document(l_xhtmlhdl)

DEFINE
   l_xhtmlhdl   STRING

DEFINE
   i       INTEGER,
   l_pos   INTEGER

   LET l_pos = NULL

   FOR i = 1 TO m_document_count
      IF m_document_list[i].xhtmlhdl == l_xhtmlhdl THEN
         LET l_pos = i
         EXIT FOR
      END IF
  END FOR

  RETURN l_pos

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
