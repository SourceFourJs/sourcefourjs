# Introduction #

In Genero 2.10, a new channel method was added that allows 2-way ascii network communication. A simple example is provided in the documentation for retrieving a web page. This code snippet enhances the example to put the HTTP response into a record structure so you can inspect the headers as well as the content.


# Details #

```
DEFINE
    # Response record structure
    s_resp    RECORD
        statuscode           INT,
        statusdescription    STRING,
        headers DYNAMIC ARRAY OF RECORD
            key      STRING,
            value    STRING
        END RECORD,
        content DYNAMIC ARRAY OF STRING
    END RECORD
#---------------------------------------------------------------------------------------#
MAIN
    DEFINE i    INT

    CALL doGetRequest("www.w3c.org",80,"/",50)
    IF s_resp.statuscode = 200
    THEN
        # Display content type of page
        FOR i = 1 TO s_resp.headers.getLength()
            IF s_resp.headers[i].key.toLowerCase() = "content-type"
            THEN
                DISPLAY s_resp.headers[i].value
                EXIT FOR
            END IF
        END FOR
    ELSE
        DISPLAY SFMT("Request returned a status of %1",s_resp.statusdescription)
    END IF

END MAIN
#---------------------------------------------------------------------------------------#
FUNCTION doGetRequest(p_host, p_port, p_path, p_timeout)
# Create a channel and perform a GET request using openClientSocket.
# Populate response record structure by calling getResponse function.
    DEFINE
        p_host        STRING,
        p_port        STRING,
        p_path        STRING,
        p_timeout     INTEGER,
        ch            base.Channel,
        p_req         STRING

    LET ch = base.Channel.create()
    IF p_timeout IS NULL
    THEN
        LET p_timeout = 60
    END IF
    LET p_req = 'GET ',p_path,' HTTP/1.0'
    CALL ch.openClientSocket(p_host,p_port,'ub', p_timeout)
    CALL ch.writeLine(SFMT("%1\r", p_req))
    CALL ch.writeLine('\r')
    CALL getResponse(ch)
    CALL ch.close()

END FUNCTION
#---------------------------------------------------------------------------------------#
FUNCTION getResponse(p_ch)
# Populate response record structure.
DEFINE
    p_ch           base.Channel,
    p_line         STRING,
    p_lineno       INTEGER,
    p_inheaders    INTEGER,
    p_headerid     STRING,
    p_tok          base.StringTokenizer,
    i              INTEGER

    WHILE NOT p_ch.isEof()
        LET p_line = p_ch.readLine()
        LET p_lineno = p_lineno + 1
        IF p_lineno = 1
        THEN
            LET p_inheaders = TRUE
            # First header line will be a Status header
            LET p_tok = base.StringTokenizer.create(p_line,' ')
            LET p_headerid = p_tok.nextToken()
            LET s_resp.statuscode = p_tok.nextToken()
            WHILE p_tok.hasMoreTokens()
                LET s_resp.statusdescription = s_resp.statusdescription CLIPPED,
                                                " ", p_tok.nextToken()
            END WHILE
        END IF
        IF p_line.getLength() = 0
        THEN
            # A blank line is the break between headers and content
            LET p_inheaders = FALSE
        END IF
        IF p_inheaders
        THEN
            CALL s_resp.headers.appendElement()
            LET i = p_line.getIndexOf(":",1)
            LET s_resp.headers[s_resp.headers.getLength()].key = p_line.substring(1,i-1)
            LET s_resp.headers[s_resp.headers.getLength()].value = p_line.substring(i+1,p_line.getLength())
        ELSE
            CALL s_resp.content.appendElement()
            LET s_resp.content[s_resp.content.getLength()] = p_line
        END IF
    END WHILE

END FUNCTION
```

Running the example produces:
```
$ fglrun openClientSocketEx.42m
 text/html; charset=utf-8
```