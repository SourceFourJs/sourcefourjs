# Copyright (c) 2012 Century Software (M) Sdn. Bhd. 
# http://www.centurysoftware.com.my/
#
# MIT License (http://www.opensource.org/licenses/mit-license.php)  
#
# Author: Mark J. Rees

#+ urlparse Module
#+
#+ Parse (absolute and relative) URLS.
#+
#+ This module was originally created for my IIUG 2012 Conference talk -
#+ "RESTful Genero Applications". Currently correctly supports
#+ parsing of URL's with a scheme of eiher http or https.
#+
#+ @code
#+ IMPORT FGL parse
#+ ....
#+ DEFINE url_parts urlparse_result
#+ ....
#+ CALL urlparse.urlparse("http://www.centurysoftware.com.my/support?rfs=222222")
#+  RETURNING url_parts.*
#+ DISPLAY url_parts.scheme
#+ DISPLAY url_parts.netloc
#+ DISPLAY url_parts.path
#+ DISPLAY url_parts.query
#+

#+ Data type that is returned from urlparse.urlparse
PUBLIC TYPE urlparse_result RECORD
    scheme      STRING,
    netloc      STRING,        
    host        STRING,
    port        STRING,
    path        STRING,
    params      STRING,
    query       STRING,
    fragmnt     STRING
END RECORD

#+ Data type that is returned from urlparse.urlsplit
PUBLIC TYPE urlsplit_result RECORD
    scheme      STRING,
    netloc      STRING,        
    path        STRING,
    query       STRING,
    fragmnt     STRING
END RECORD

#+ Parse a URL into 6 main components & host & port:
#+ <scheme>://<netloc>/<path>;<params>?<query>#<fragment>
#+
#+ @param url to parse
#+
#+ @return 6 components & host & port as type urlparse_result
#+
#+ Note: com.HttpServiceRequest url strips off parameters & fragment components
#+ so this function will always return a NULL parameters & fragment. 
#+ The code is there to separate the parameters & fragment if #+ 4Js fix this 
#+ issue.
#+
#+ ToDo: extract hostname & port from netloc
#+
FUNCTION urlparse(url)
    DEFINE
        url     STRING,
        result  urlparse_result,
        split   urlsplit_result,
        tok     base.StringTokenizer,
        i       SMALLINT

    CALL urlsplit(url) RETURNING split.*

    LET result.scheme = split.scheme
    LET result.netloc = split.netloc
    LET result.path = split.path
    LET result.query = split.query
    LET result.fragmnt = split.fragmnt

    LET i = result.path.getIndexOf(";",1)    
    IF i > 0 THEN
        # url has params component
        LET tok = base.StringTokenizer.create(result.path,";")
        LET result.path = tok.nextToken()
        LET result.params = tok.nextToken()
    END IF
    
    RETURN result.*
    
END FUNCTION

#+ Parse a URL into 5 components
#+ <scheme>://<netloc>/<path>?<query>#<fragment>
#+
#+ @param url to parse
#+
#+ @return 5 components as type urlsplit_result
#+
FUNCTION urlsplit(url)
    DEFINE
        url     STRING,
        tok     base.StringTokenizer,
        result  urlsplit_result,
        i       SMALLINT

    LET i = url.getIndexOf(":",1)
    IF i > 0
    THEN
        LET result.scheme = url.subString(1,i)
    END IF

    LET url = url.subString(i+1,url.getLength())    

    IF url.subString(1,2) = "//"
    THEN
        # absolute URL, so get network location
        LET url = url.subString(3,url.getLength())
        LET tok = base.StringTokenizer.create(url,"/?#")
        WHILE tok.hasMoreTokens()
            LET result.netloc = tok.nextToken()
            EXIT WHILE # we are only interested in first token
        END WHILE
    END IF

    IF result.netloc IS NOT NULL
    THEN
        LET url = url.subString(result.netloc.getLength()+1,url.getLength()) 
    END IF

    # get fragment
    LET i = url.getIndexOf("#",1)
    IF i > 0
    THEN
        LET result.fragmnt = url.subString(i+1,url.getLength())
        LET url = url.subString(result.fragmnt.getLength()+1,url.getLength()) 
    END IF

    # get query
    LET i = url.getIndexOf("?",1)
    IF i > 0
    THEN
        LET result.query = url.subString(i+1,url.getLength())
        LET result.path = url.subString(1,i-1)
    ELSE
        LET result.path = url
    END IF
    
    RETURN result.*
    
END FUNCTION