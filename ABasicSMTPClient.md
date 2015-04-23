# Introduction #

The base.channel.openClientSocket can be used to allow us to connect to a SMTP server and send email. To do this we need to know the SMTP protocol which can be found in RFC-2821.

At its simplest though the SMTP protocol requires the following sequence of commands:
```
HELO domain.com
MAIL FROM: <from.address@example.com>
RCPT TO: <to.address@example.com>
DATA
... the data for the email including headers and teminated with
<CR><LF>
.
<CR><LF>
QUIT
```

One way of doing this in Genero is given below (minus any error checking):

```
# $Id$
#------------------------------------------------------------------------------#
# Copyright (c) 2007 Scott Newton <scottn@ihug.co.nz>                          #
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
# Connect to the mail server                                                   #
#------------------------------------------------------------------------------#

FUNCTION connect_to_smtp_server(l_mailserver)

DEFINE
   l_mailserver   STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING,
   l_sockethdl       base.Channel

   LET l_sockethdl = base.Channel.create()
   CALL l_sockethdl.setDelimiter("")

   CALL l_sockethdl.openClientSocket(l_mailserver, "25", "ub", 10)

   IF STATUS == 0 THEN
      #------------------------------------------------------------------------#
      # Read the response from the mail server on connecting                   #
      #------------------------------------------------------------------------#

      CALL l_sockethdl.read(l_data)
         RETURNING l_ok

      LET l_response_code = l_data.subString(1, 3)

      CASE
         WHEN l_response_code == "220"
            LET l_ok = TRUE

         OTHERWISE
            RETURN FALSE, NULL
      END CASE
   ELSE
   END IF

   RETURN l_ok, l_sockethdl

END FUNCTION

#------------------------------------------------------------------------------#
# Send the HELO command to the mail server and read the response               #
#------------------------------------------------------------------------------#

FUNCTION smtp_helo(l_sockethdl, l_domainname)

DEFINE
   l_sockethdl    base.channel,
   l_domainname   STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "HELO ", l_domainname

   CALL l_sockethdl.write(l_data)

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# Send the MAIL FROM command and read the response                             #
#------------------------------------------------------------------------------#

FUNCTION smtp_mail_from(l_sockethdl, l_from)

DEFINE
   l_sockethdl   base.channel,
   l_from        STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSe
   LET l_data = "MAIL FROM: <", l_from, ">"

   CALL l_sockethdl.write(l_data)

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# Send the RCPT TO command and read the response                               #
#------------------------------------------------------------------------------#

FUNCTION smtp_rcpt_to(l_sockethdl, l_to)

DEFINE
   l_sockethdl   base.channel,
   l_to          STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "RCPT TO: <", l_to, ">"

   CALL l_sockethdl.write(l_data)

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# Send the DATA command                                                        #
#------------------------------------------------------------------------------#

FUNCTION smtp_data(l_sockethdl, l_email)

DEFINE
   l_sockethdl   base.channel,
   l_email       STRING

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "DATA"
   LET l_email = l_email

   CALL l_sockethdl.write(l_data)

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)

   CASE
      WHEN l_response_code == "354"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   #---------------------------------------------------------------------------#
   # Send the email                                                            #
   #---------------------------------------------------------------------------#

   CALL l_sockethdl.write(l_email)
   CALL l_sockethdl.write("\r\n")
   CALL l_sockethdl.write(".")

   CALL l_sockethdl.read(l_data)
      RETURNING l_bytesread

   LET l_response_code = l_data.subString(1, 3)

   CASE
      WHEN l_response_code == "250"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# Send the QUIT command                                                        #
#------------------------------------------------------------------------------#

FUNCTION smtp_quit(l_sockethdl)

DEFINE
   l_sockethdl   base.channel

DEFINE
   l_ok              SMALLINT,
   l_data            STRING,
   l_response_code   STRING

   LET l_ok = FALSE
   LET l_data = "QUIT"

   CALL l_sockethdl.write(l_data)

   CALL l_sockethdl.read(l_data)
      RETURNING l_ok

   LET l_response_code = l_data.subString(1, 3)

   CASE
      WHEN l_response_code == "221"
         LET l_ok = TRUE

      OTHERWISE
         RETURN FALSE
   END CASE

   CALL l_sockethdl.close()

   RETURN l_ok

END FUNCTION
```