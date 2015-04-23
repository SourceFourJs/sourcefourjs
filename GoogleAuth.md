# Introduction #

Some of the Google Service API's require the application accessing them to be authenticated to perform operations. Google provides a specific method of authentication for installed applications (which in Google's definition is none web applications) and it is documented [here](http://code.google.com/apis/accounts/docs/AuthForInstalledApps.html). This snippet shows how you can perform this type of authentication with Genero BDL 2.30+. (It is still a work in progress but have put the code here as someone requested to see it)

# Details #

```
IMPORT com
IMPORT xml

MAIN

    DEFINE
        req         com.HTTPRequest,
        resp        com.HTTPResponse,
        doc         STRING,
        qrybuf      base.StringBuffer,
        statcode    INTEGER,
        login       STRING,
        passwd      STRING,
        googlesvc   STRING   # Google service id

    LET login = "your-google-account-id@gmail.com"
    LET passwd = "your-google-password"
    LET googlesvc = "xapi"  # Google generic service id

    TRY
        LET req = com.HTTPRequest.create("https://www.google.com/accounts/ClientLogin")
        CALL req.setMethod("POST")
        LET qrybuf = base.StringBuffer.create()
        CALL qrybuf.append("accountType=HOSTED_OR_GOOGLE")
        CALL qrybuf.append(SFMT("&Email=%1", login))
        CALL qrybuf.append(SFMT("&Passwd=%1", passwd))
        CALL qrybuf.append(SFMT("&service=%1", googlesvc))
        CALL qrybuf.append("&source=genero-agent-1")
        DISPLAY qrybuf.toString()
        CALL req.doFormEncodedRequest(qrybuf.tostring(), FALSE)
        LET resp = req.getResponse()
        LET statcode = resp.getStatusCode()
        CASE statcode
            WHEN 200
                LET  doc = resp.getTextResponse()
                DISPLAY  "HTTP 200 Text Response is : ",doc
            WHEN 403
                LET  doc = resp.getTextResponse()
                DISPLAY  "HTTP 403 Text Response is : ",doc
            OTHERWISE
                DISPLAY  "HTTP Error ("||resp.getStatusCode()||") ",resp.getStatusDescription()
        END CASE
    CATCH
        DISPLAY "ERROR :",STATUS||" ("||SQLCA.SQLERRM||")"
    END TRY

END MAIN
```