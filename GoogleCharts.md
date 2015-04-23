# Introduction #

Some notes about the Google Charts demo available in the downloads section



# Details #

Charting is about the 4th most popular question I get asked about Genero.  You can use the CANVAS widget to draw various types of charts within Genero however there are a couple of limitations such as how do you draw a 3-d pie chart, and how do you manipulate the font inside a CANVAS.

Another option is to use the Google Chart API, more info about whicn can be found here http://code.google.com/apis/chart/.  This API allows you to specify a URL e.g. http://chart.apis.google.com/chart?cht=p3&chd=t:60,40&chs=250x100&chl=Hello|World and that will render in your browser based on the passed in parameters to the URL.

In Genero, if the IMAGE widget begins with a URL prefix, the front-end will try to download the image from the location specified by the URL.  So if your code says

DISPLAY "http://chart.apis.google.com/chart?cht=p3&chd=t:60,40&chs=250x100&chl=Hello|World" TO image\_widget

... then that image will be downloaded and displayed in the IMAGE widget.

This same concept is used in the Google Maps example to display a Google Maps.

You are constrained by the types of charts available.  For instance there is no 3-d bar chart, a type of chart you can draw in CANVAS if you desire.  Google Chart does give an ability to draw and colour in maps but again the number of maps is limited (no Australia for example).  Their is a genero charts developers discussion forum where requests for these types of charts many times.

The one thing both drawing charts in CANVAS and using Google Charts lack is the ability to respond to a click in the chart.

The following links are available to run Genero Google Charts

GWC: http://demo.4js.com.au/cgi-bin/gas/cxf/fglccgi/wa/r/fj/ajax-chart
GDC-AX: http://demo.4js.com.au/cgi-bin/gas/cxf/fglccgi/wa/r/fj/gdc-chart