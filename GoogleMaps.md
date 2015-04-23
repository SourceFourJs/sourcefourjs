# Introduction #

One of our demos that has some wow factor and gets some positive feedback is the GoogleMaps Web Services example I added to the Downloads section recently.  It utilises a web service to determine the latitude and longitude of an address and then draws a map based on that location.  This is something that could be applied anywhere you have an address in your existing Genero application.

# Details #

The Genero Web Services COM extension library provides classes and methods that allow you to make request and receive responses over HTTP for a specified URL.

I have taken advantage of that functionality to produce an example interacting with google maps.  Amongst the many services google offer there is a web service documented here  http://code.google.com/apis/maps/documentation/services.html#Geocoding_Direct that allows you to pass an address and the web service will return the latitude and longitude of the address.  From that you can then draw an image using a URL that google offers that will draw a map centred on a latitude and longitude.

You can run my GoogleMaps example app via GDC-Active X here http://demo.4js.com.au/cgi-bin/gas/cxf/fglccgi/wa/r/fj/gdc-googlemaps, or even better create a HTTP short-cut in a 2.1x GDC  with the same URL.  It can also be run through GWC and a Web Browser http://demo.4js.com.au/cgi-bin/gas/cxf/fglccgi/wa/r/fj/ajax-googlemaps. The source is available for download from http://code.google.com/p/sourcefourjs/downloads/list

If you have a screen in your application with an address, it would be very easy to adapt and incorporate this into your existing Genero application.

Documentation for the Genero Web Services COM extension library can be found here http://www.4js.com/online_documentation/fjs-gws-2.11.01-manual-html/User/WseCOMLibrary.html.  Coding an http request and response is itself very simple...

```
IMPORT com
...
DEFINE url STRING
DEFINE l_http_req com.HTTPRequest
DEFINE l_http_resp com.HTTPResponse
...
LET l_http_req = com.HTTPRequest.Create(url)
CALL l_http_req.doRequest()
LET l_http_resp = l_http_req.getResponse()
```

... but around this you have to code to a) determine the url beforehand b) interpret the response, and c) handle any errors.

To determine the URL you have to read the documentation of the service provider and see what they are expecting to receive.  It is then simply a case of populating a string variable with the url they are expecting to receive.  In the case of the googlemaps example, they are expecting a URL of http://maps.google.com/maps/geo and 3 arguments i) q, the address to determine the latitude/longitude of ii) output, the format of the response iii) key,  a unique integer to identify yourself to Google.

The output of the response will not necessarily be an XML.  In this example, the google web service allows you to determine the format of the response and I selected XML.  If you call a web service with an XML response you can do the following whilst you are developing...

```
IMPORT xml
...
DEFINE l_result_dom xml.DomDocument
DEFINE l_root xml.DomNode
...
LET l_result_dom = l_http_resp.getXMLResponse()
LET l_root = l_result_dom.getDocumentElement()
DISPLAY l_root.toString()
```

This will display the XML that is received and in the absence of a formal DTD you can review this XML to determine what is being sent back.  You can then use the xmlDomDocument routines to parse and get out of the XML document the information you are interested in.  In this case I looked for all elements with coordinates as the tag name and read the text child element of the first one that I found...

```
DEFINE l_result_list xml.DomNodeList
DEFINE l_result_element_node, l_text_node xml.DomNode
...

LET l_result_list = l_root.getElementsByTagNameNS("coordinates","http://earth.google.com/kml/2.0")
IF l_result_list.getCount() > 0 THEN
   LET l_result_element_node = l_result_list.getItem(1)
   LET l_text_node = l_result_element_node.getChildNodeItem(1)
   LET m_address.latlong = l_text_node.getNodeValue()   
```

(the eagle eyed of you will note that the last line above is coded slightly different in the example, that is because the comma separated latitude and longitude values are returned in a different order then how I want to use them later in the program so the program has a few extra lines to swap the values at this point.) .

There is a similar method to getXMLResponse(), getTextResponse() that I could’ve used that returns the result to a string variable.

Finally to write a proper program you have to handle the errors.  After I have receive the HTTP response I check that the status code is 200 (a successful response in HTTP world) otherwise I exit with an error

```
IF l_http_resp.getStatusCode() != 200 THEN
   DISPLAY SFMT("HTTP ERROR(%1) %2",l_http_resp.getStatusCode(), l_http_resp.getStatusDescription())
   RETURN FALSE
```

Also I wrapped the text with a TRY/CATCH...

```
TRY
...
CATCH
   DISPLAY SFMT("ERROR (%1) %2",l_http_resp.getStatusCode(), l_http_resp.getStatusDescription())
   RETURN FALSE
END TRY
```

... to also display the http response status code if something unexpected occurs.



In the googlemaps application, once I have received the latitude/longitude for an address via a web service, I then took advantage of another google facility to draw a map based on a google URL, that will return an image that is a map based on the latitude/longitude passed in as arguments.  The Google documentation can be found here http://code.google.com/apis/maps/documentation/staticmaps/ and in my code it is simply a case of constructing a URL and displaying it to an image widget

```
LET url = SFMT("http://maps.google.com/staticmap?center=%1&zoom=%3&size=512x512&key=%2&markers=%1,reda",m_address.latlong, c_googlekey, -m_zoom USING "<<")
DISPLAY url TO url
```

Note: the c\_googlekey is a constant from Google that helps limit the use of this service.  The key is linked to the URL so you'll need to apply for your own key.

My program does the above in two steps but it could be easily be written as 1 click of a button instead of 2, and there are a few extra google services that could be incorporated as well.  The GWC tutorial also shows another way to interact with Googlemaps. http://www.4js.com/online_documentation/fjs-gas-2.11.01-manual-html/User/GWC_Tutorial.html