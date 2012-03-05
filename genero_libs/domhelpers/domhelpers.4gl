# Copyright (c) 2012 Mark Rees <mark dot john dot rees at gmail dot com>
#
#  MIT License (http://www.opensource.org/licenses/mit-license.php)  
#

#+ DOM Helpers Module
#+
#+ This module was originally created for my IIUG 2012 Conference talk -
#+ "RESTful Genero Applications" so that code samples were not cluttered
#+ with DOM queries. It has turned out to quite useful for everyday Genero
#+ DOM programming.
#+ 
#+ It was inspired by an article titled: 
#+  
#+  "Effective XML processing with DOM and XPath in Perl"
#+  (http://www.ibm.com/developerworks/xml/library/x-domprl/)
#+ 
#+ A paragraph in the article best sums up why it is useful:
#+
#+ "Your experience using DOM will be significantly improved if you 
#+  follow a few basic principles:
#+
#+   * Do not use DOM to traverse the document
#+
#+   * Whenever possible, use XPath to find nodes or traverse the document
#+
#+   * Use a library of higher-level functions to make DOM use easier"
#+
#+ This module attempts to provide some higher-level functions in Genero
#+ that make working with the XML DOM easier similar to x-domprl.
#+
#+ @code
#+ IMPORT FGL domhelpers
#+ ....
#+ LET p_text = domhelpers.getValue(d_mydoc.getDocumentElement,"/header/title")
#+
IMPORT XML

#+ Returns the concatenated vaules of the text nodes for the given DOM node.
#+
#+ @param d_node DOM node to search
#+
#+ @return Either concatenated text values or NULL
#
FUNCTION getTextContents(d_node)

	DEFINE
		d_node		xml.DomNode,
		d_child		xml.DomNode,
        p_text      STRING

    LET d_child = d_node.getFirstChild()
    WHILE d_child IS NOT NULL
        LET p_text = p_text , d_child.getNodeValue() CLIPPED
        LET d_child = d_child.getNextSibling()
    END WHILE

    IF p_text.getLength() > 0
    THEN
        RETURN p_text
    ELSE
		RETURN NULL
    END IF

END FUNCTION

#+ Find and return the first node that matches the given xpath expression
#+
#+ @param d_node DOM node to search
#+ @param p_xpath XPath expression to search p_node
#+
#+ @return Either first matched node or NULL
#
FUNCTION findNode(d_node, p_xpath)

	DEFINE
		d_node		xml.DomNode,
        d_nodelist  xml.DomNodeList,
		p_xpath		STRING

        LET d_nodelist = d_node.selectByXPath(p_xpath, NULL)

        IF d_nodelist IS NOT NULL
        THEN
            RETURN d_nodelist.getItem(1)
        ELSE
            RETURN NULL
        END IF

END FUNCTION

#+ Get the text value of an element that matches 
#+ the supplied xpath expression for a given DOM node.
#+
#+ @param d_node DOM node to search
#+ @param p_xpath XPath expression to search p_node
#+
#+ @return Either text value of first matched node or NULL
#+
FUNCTION getValue(d_node, p_xpath)

	DEFINE
		d_node, d_match	xml.DomNode,
		p_xpath		    STRING

        LET d_match = findNode(d_node, p_xpath)
        IF d_match IS NOT NULL
        THEN
            RETURN getTextContents(d_match)
        ELSE
            RETURN NULL
        END IF

END FUNCTION

