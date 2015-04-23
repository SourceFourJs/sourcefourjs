# Introduction #

The following lists the programs I used as part of my demonstrations on the 2010 Four J's Asia Pacific Tour.

A number of them were taken from the Four J's demo directories so I will direct you to the appropriate demo in the 2.30 release which is now available rather than duplicating them here.

Similarly some of the other programs I'll list the change I made (typically adding something to the .4st or a few lines of code) and you can apply this change to your code and note the effect

The number beside the entry is just something I added in the Genero Studio project workspace to get the programs in the order I intended to display them



# Releases prior to Genero 2.30 #
  * **10 Multi Dialog** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Multiple_Dialogs_2.10)

> Refer to $FGLDIR/demo/MultiDialogs for now. I intend to tidy up and embellish the four programs I demonstrated that illustrated the four design patterns I referred to.

  * **15 Tree Widget** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#tree-view-tables)

> Refer to $FGLDIR/demo/Tree/aui-tree

  * **16 Tree Widget BOM** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#tree-view-tables)

> Refer to $FGLDIR/demo/Tree/bill-of-material

  * **18 Picture Flow** (http://www.4js.com/techdocs/genero/gdc/devel/DocRoot/User/NewFeatures220.html#220TablePFlow)

> [Download this example](http://code.google.com/p/sourcefourjs/downloads/detail?name=PictureFlow_1_0.zip)

  * **20 Module** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Modules_2_21)

> TODO - This will appear as a separate download when I have completed the generic zoom window example I am using as an example

  * **25 Rich Text Edit** (http://www.4js.com/techdocs/genero/gdc/devel/DocRoot/User/NewFeatures222.html#222RichText)

> Add the following to your .4st stylesheet.  Run a program that has an INPUT on a TEXTEDIT.  You will get the rich text edit toolbox, and if you look at the text that is saved to the variable you will see that it is HTML
```
   <Style name="TextEdit" >
      <StyleAttribute name="textFormat" value="html" /> 
      <StyleAttribute name="showEditToolBox" value="yes" /> 
   </Style>
```

# Genero 2.30 Release #
  * **50 Drag & Drop** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Drag_and_Drop)

> Refer to $FGLDIR/demo/DragAndDrop/orders\_and\_trucks\_tree

  * **51 Drag & Drop Excel** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Drag_and_Drop

> Add the following to any DISPLAY ARRAY and compile in Genero 2.30 or later.  (you will need to also add a DEFINE dnd ui.DragDrop).  Run and then Drag & Drop one or more rows from this array to Excel.  Also select multiple rows, click editcopy and paste into Excel.

```
      BEFORE DISPLAY
         CALL DIALOG.setSelectionMode("scr",TRUE)

      -- Copy selected rows to clipboard
      -- Use DIALOG.selectionToString method
      ON ACTION editcopy
         CALL ui.Interface.frontCall("standard","cbset",DIALOG.selectionToString("scr"),[])

      -- Allow drag operations from here
      ON DRAG_START(dnd)
         CALL dnd.setOperation("copy")
```

  * **52 Drag & Drop Explorer** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Drag_and_Drop

> Compile and run the following program.  Simply drag some files from Explorer onto the DISPLAY ARRAY and the filenames will be added to the array.

> Key thing to note is in the ON DRAG\_ENTER we determine if dropping is allowed based on what is in the drag and drop content, and then when we drop it we interrogate the content to populate the DISPLAY ARRAY
```
MAIN
DEFINE dnd ui.DragDrop
DEFINE arr DYNAMIC ARRAY OF RECORD
   filename STRING
END RECORD
DEFINE tok base.StringTokenizer
DEFINE filename_list STRING
DEFINE ok INTEGER

   CLOSE WINDOW SCREEN
   
   OPEN WINDOW w WITH FORM "dropfilename"
   CALL ui.Interface.frontCall("standard","execute",["explorer",0],ok)

   DISPLAY ARRAY arr TO scr.* ATTRIBUTES(UNBUFFERED)
      -- When content dragged into array
      ON DRAG_ENTER(dnd)
         CASE
            WHEN dnd.selectMimeType("text/uri-list")
               -- This will set operation if contents are uri-list
            OTHERWISE
               -- Set operation to NULL if unexpected MIME type found
               CALL dnd.setOperation(NULL)
         END CASE

      -- When dragged around array
      ON DRAG_OVER(dnd)
         -- don't do anything special

      -- When dropped into array
      ON DROP(dnd)
         -- extract filenames from the buffer and populate array
         LET filename_list = dnd.getBuffer()
         LET tok = base.StringTokenizer.create(filename_list,"\n")
         WHILE tok.hasMoreTokens()
            CALL arr.appendElement()
            LET arr[arr.getLength()].filename = tok.nextToken()
         END WHILE
   END DISPLAY
END MAIN
```
```
LAYOUT (TEXT="Drop files into the array")
TABLE (WIDTH=80 COLUMNS)
{
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
[f01                                                                           ]
}
END
END
ATTRIBUTES
f01 = formonly.filename, TITLE="Filename";
INSTRUCTIONS
SCREEN RECORD scr(filename);
```

  * **53 Drag & Drop 2 List (A)** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Drag_and_Drop

> Refer to $FGLDIR/demo/DragAndDrop/two\_lists/nodnd.4gl

  * **54 Drag & Drop 2 List (B)** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Drag_and_Drop

> Refer to $FGLDIR/demo/DragAndDrop/two\_lists/dnd.4gl

  * **60 Image Map** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Web_Component)

> Refer to $FGLASDIR/demo/app/webComponentMap

  * **61 Google Maps** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Web_Component)

> [Download this example](http://code.google.com/p/sourcefourjs/downloads/detail?name=wc_googlemaps_1_0.zip)

  * **62 Charts** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#Web_Component)

> Refer to $FGLASDIR/demo/app/webComponentChart

  * **71 Presentation Styles**

> That program had the following entries in the .4st stylesheet file

> To make the ERROR in the statusbar, red, bold and double-size ...
```
   <Style name="Message:error">
      <StyleAttribute name="textColor" value="red" />
      <StyleAttribute name="fontWeight" value="bold" />
      <StyleAttribute name="fontStyle" value="normal" />
      <StyleAttribute name="fontSize" value="2em" />
   </Style>
```

> To make the Table column headings match the alignment of the data
```
   <Style name="Table" >
      <StyleAttribute name="headerAlignment" value="auto" />
   </Style>
```
> To allow the user to freeze table columns, and to freeze the first column
```
   <Style name="Table" >
      <StyleAttribute name="tableType" value="frozenTable" />
      <StyleAttribute name="leftFrozenColumns" value="1" />
   </Style>
      Change the background color of the toolbar  
   <Style name="ToolBar" >
      <StyleAttribute name="backgroundColor" value="yellow" />
   </Style>

```
> Its not new but in case you haven't seen how to get the alternate line shading
```
   <Style name="Table:odd" >
      <StyleAttribute name="backgroundColor" value="#EEEEEE" />
   </Style>
   <Style name="Table:even" >
      <StyleAttribute name="backgroundColor" value="#DDDDDD" />
   </Style>
```

> Again not new in 2.30 but how to change the appearance of buttons, you would need to add STYLE="commandLink" and STYLE="link" to the BUTTON definition in the form
```
   <Style name="Button.commandLink">
       <StyleAttribute name="buttonType" value="commandLink"/>
   </Style>
   <Style name="Button.link">
       <StyleAttribute name="buttonType" value="link"/>
   </Style>
```



  * **72 Animated GIF** (http://www.4js.com/techdocs/genero/gdc/devel/DocRoot/User/NewFeatures230.html#230AnimatedGifs)

> Display any animated gif to an IMAGE field and from 2.30 the animation will occur.  I used a file processing.gif that I downloaded from our documentation (use the link above).  Consider using an Animated GIF in places where you'd consider using a PROGRESSBAR but don't know how long the processing will take.

> For those that hadn't seen the code that interrupted a WHILE, FOR, FOREACH loop whilst it is in progress, the 4gl I had was ...

```
MAIN
DEFINE i INTEGER

   DEFER INTERRUPT
   MENU ""
      COMMAND "Run"
         OPEN WINDOW w WITH FORM "animatedgif"
         CALL ui.Interface.refresh()
         FOR i = 1 TO 10
            IF INT_FLAG THEN
               EXIT FOR
            END IF
            DISPLAY i TO progress
            CALL ui.Interface.refresh()
            SLEEP 1
         END FOR
         CLOSE WINDOW w
         LET INT_FLAG = 0
      COMMAND "Exit"
         EXIT MENU
   END MENU
END MAIN
```

```
LAYOUT (TEXT="Animated GIF")
GRID
{
[f01       ]
[          ]
[          ]
[          ]
[          ]
[p01       ]
[b01       ]
}
END
END
ATTRIBUTES

-- Nothing special required to indicate an animated GIF
IMAGE f01: IMAGE= "processing", HEIGHT=10, WIDTH=20, STRETCH=BOTH;
PROGRESSBAR p01 = formonly.progress, VALUEMIN=0, VALUEMAX=10;
BUTTON b01: interrupt;
```
> ... the key thing is to have a BUTTON named interrupt on the form, in your 4gl have a DEFER INTERRUPT, and then in your loop test if the int\_flag has been set, if it has exit the loop (don't forget to resest the int\_flag).   A BUTTON that is named interrupt will be made active when the back-end takes its time (I think it is more than 1 second).  If you click on it, int\_flag will be set to TRUE, and the 4gl loop can be made to exit by testing if int\_flag is TRUE on each iteration.

  * **73 Window Size** (http://www.4js.com/techdocs/genero/gdc/devel/DocRoot/User/NewFeatures230.html#230ResetFormSize)

> Compile and run this example in both 2.21 and 2.30 and note the difference in behaviour when you click on the big and small buttons.  In 2.21 the window will stay at the biggest size, it will never shrink.  In 2.30 the window will shrink or expand to match the form size

```
MAIN
   OPEN FORM big FROM "windowsize_big"
   OPEN FORM small FROM "windowsize_small"

   CALL ui.Interface.loadStyles("windowsize")
   MENU
      COMMAND "Big"
         DISPLAY FORM big 
      COMMAND "Small"
         DISPLAY FORM small
      ON ACTION CLOSE
         EXIT MENU
   END MENU
END MAIN
```

```
<!-- windowsize.4st -->
<StyleList>
   <Style name="Form">
     <StyleAttribute name="resetFormSize" value="yes" />
   </Style>
</StyleList>
```

```
-- windowsize_big.per
LAYOUT (TEXT="Big", MINWIDTH=80, MINHEIGHT=30)
GRID
{
Big
}
END
```

```
-- windowsize_small.per
LAYOUT (TEXT="Small", MINWIDTH=10, MINHEIGHT=10)
GRID
{
Small
}
END
```

  * **74 CSV** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#csv-channel-delimiter)

> The program below generates two 100 line files of random data.   Double-click on the files and note how csv.csv loads into Excel better then comma.csv

```
-- Generate 2 100 line files of random data, one using the "," delimiter, the other using the CSV delimiter
IMPORT util
MAIN

DEFINE comma,csv base.Channel
DEFINE i INTEGER
DEFINE code CHAR(3)
DEFINE qty DECIMAL(11,2)
DEFINE name STRING

   LET comma = base.Channel.create()
   LET csv = base.Channel.create()
   
   CALL comma.openFile("comma.csv","w")
   CALL csv.openFile("csv.csv","w")

   -- Note the two different delimiters
   CALL comma.setDelimiter(",")
   CALL csv.setDelimiter("CSV")

   FOR i = 1 TO 100
      LET code = random_letter("UPPER"),random_letter("UPPER"),random_letter("UPPER")
      LET name = random_name()
      LET qty = util.Math.rand(1000000)/100
      CALL comma.write([code,name,qty])
      CALL csv.write([code,name,qty])
   END FOR
   
   CALL comma.close()
   CALL csv.close()
END MAIN

FUNCTION random_letter(case)
DEFINE case STRING
   CASE case --
      WHEN "UPPER"  RETURN ASCII(util.Math.rand(26)+65)
      OTHERWISE RETURN ASCII(util.Math.rand(26)+97)
   END CASE
END FUNCTION

FUNCTION random_name()
DEFINE sb base.StringBuffer
DEFINE i INTEGER

   LET sb = base.StringBuffer.create()
   CALL sb.append(random_letter("UPPER"))
   FOR i = util.Math.rand(4)+4 TO 1 STEP -1
      CALL sb.append(random_letter("LOWER"))
   END FOR
   CALL sb.append(",")
   CALL sb.append(random_letter("UPPER"))
   FOR i = util.Math.rand(4)+4 TO 1 STEP -1
      CALL sb.append(random_letter("LOWER"))
   END FOR
   RETURN sb.toString()
END FUNCTION

```
  * **76 Folder Page** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#ensure-field-visible)

> This wasn't the example I used in the seminars but it is a better one.  It uses the new ensureElementVisible method instead of the new ensureFieldVisible method.  The ensureElementVisible method IMHO being better to use as you can use the name of the folder page element, and not an arbitrary field that happens to be on the page.

```
MAIN
DEFINE w ui.Window
DEFINE f ui.Form

   CLOSE WINDOW SCREEN

   OPEN WINDOW w WITH FORM "folderpage"
   LET w = ui.Window.getCurrent()
   LET f = w.getForm()

   MENU ""
      ON ACTION one
         CALL f.ensureElementVisible("pagone")

      ON ACTION two
         CALL f.ensureElementVisible("pagtwo")

      ON ACTION close
         EXIT MENU
   END MENU
END MAIN
```

```
LAYOUT
FOLDER
PAGE pagone(TEXT="Page One")
GRID 
{
Page One
}
END #GRID
END #PAGE
PAGE pagtwo (TEXT="Page Two")
GRID 
{
Page Two
}
END #GRID
END #PAGE
END #FOLDER
END #LAYOUT
```


# Genero 2.30 Release Migration Issues #
  * **90 Set Current Row** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/Mig0005.html#DIALOG.setCurrentRow)

> With a DISPLAY ARRAY you have that has multiple-row select, add the following action (replace "scr" with the name of your screen record)

```
      ON ACTION goto1
         CALL dialog.setCurrentRow("scr",1)
```
> Observe the difference in behaviour between 2.21 and 2.30 when you select some rows, and then click the goto1 action.  In 2.21 the selected rows will remain selected, in 2.30 the selected rows will be unselected.

  * **91 Menu Action Close** (http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/Mig0005.html#MenuAction-close)

> Compile and run this program in both 2.21 and 2.30, observe the difference in behaviour when you click on the red-cross (close) in the top right corner of the dialog box.  In 2.21, int\_flag would be set and the MENU would exit without setting the result variable.  Typical 4gl didn't cater for this case.
```
MAIN
DEFINE result CHAR(1)

   MENU "" ATTRIBUTES(COMMENT="Menu with two options", STYLE="dialog")
      COMMAND "Yes"
         LET result = "Y"
         EXIT MENU
      COMMAND "No"
         LET result = "N"
         EXIT MENU
      --ON ACTION close
         --LET result = "C"
         --EXIT MENU
   END MENU

   -- With 2.21 you can click on the red cross and int_flag will be set to 1 and result will be NULL!!!

   DISPLAY SFMT("int_flag=%1", int_flag)
   DISPLAY SFMT("result=%1", result )
   
END MAIN

```