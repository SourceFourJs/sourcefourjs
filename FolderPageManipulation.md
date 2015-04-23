<font color='red'>
<b>AUGUST 2010: In Genero 2.30, new methods were added to ensure that a certain form field or form element was visible.  The ui.Form.ensureElementVisible(<i>element-name</i>) method can be used to ensure that the named Folder page is visible <a href='http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#ensure-field-visible'>http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/NewFeatures.html#ensure-field-visible</a></b>
</font>

# Introduction #

One of the often repeated questions in the 4js developer mailing lists is how to manipulate the FOLDER widgets so that a particular PAGE is on top.  Here are some tips/advice for manipulating the FOLDER widget.


# Details #

The one golden rule to remember is that when the GDC renders the FOLDER widget is that the PAGE that contains the field with the current focus will be drawn on top.

So the simplest way to render a particular folder page on top is to "NEXT FIELD field" where field is a field on that folder page (preferably the field in the top-left corner of the page).

However what do you do if you are in a MENU dialog where no field has the focus, or you  want the focus to be on a field that is not in the FOLDER.

In the case of a MENU you do have the option of allowing the user to manipulate the folder page.  They can do this with the mouse.  If they want to do this with the keyboard, choose a unique letter in the text attributes for each PAGE and in the text attribute precede that letter with an &.  Then Alt-

&lt;letter&gt;

 accelerator will allow the user to change to the selected folder page e.g.

FOLDER ...
PAGE (TEXT="&One")
...
PAGE (TEXT="&Two")

Alt-O will switch to the first page, Alt-T will switch to the second page.

The standard Windows accelerator Control-Tab can also be used to manipulate the folder page if the focus is in the folder page.  (For the reaon why the focus must be in a folder page think of the case 'what if there were two folders?, what folder widget would Control-Tab then apply to'?)

If you want to programmatically change the folder page then there is an algorithm that I first referred to in the Genero developer mailing lists in August 2004.  This makes use of the fact that if there is only one visible PAGE it will be drawn on top and that any hidden pages that are then shown will not change what the current folder page is.  So the algorithm has three steps
1) hide all folder pages except the one you want to display on top.
2) CALL ui.Interface.Refresh()
3) unhide the pages you just hid.

The algorithm assumes that all the folders and page widgets in the current form have a unique name.

The following code extract implements that algorithm.

This routine is typically used in a MENU statement to place a particular folder page on top.  It is also used in other types of dialogs where the field focus is on a field outside the FOLDER.

```
-- Written by reuben@4js.com.au March 2008 to show technique used to bring a selected
-- folder page to the top
-- Based on algorithm I published in Genero mailing lists in August 2004.  The algorithm
-- being i) hide all the pages except the one you want to display
--      ii) do a ui.Interface.Refresh()
--     iii) unhide the pages you just hid 
-- Function takes as input two names, one the name of a folder widget,
-- the second the name of a page widget
-- This function will not override the default Genero behaviour where if a
-- folder page contains the widget that has the keyboard focus then that folder
-- page will be drawn on top
-- The underlying DOM tree strucuture that this routine is based on may change
-- between Genero versions, and hence everytime you upgrade Genero versions it
-- is prudent to check that this routine still works as expected.

FUNCTION folderpage_to_top(l_folder_name, l_page_name)
DEFINE l_folder_name, l_page_name STRING -- Folder and page to hide

DEFINE w ui.Window
DEFINE f ui.Form
DEFINE r om.DomNode
DEFINE l_folder_list om.nodelist
DEFINE l_folder_node, l_child_node om.domnode
DEFINE i INTEGER
DEFINE l_name STRING
DEFINE l_page_list DYNAMIC ARRAY OF STRING

   -- Get the root node for the current window/form
   LET w = ui.Window.getCurrent()
   LET f = w.getForm()
   LET r = f.getNode()

   -- Find the node corresponding to the selected folder
   LET l_folder_list = r.selectbypath(SFMT("//%1[@%2=\"%3\"]", "Folder", "name", l_folder_name))
   IF l_folder_list.getLength() = 1 THEN
      LET l_folder_node = l_folder_list.item(1)
      
      -- For this folder, hide every page except the one we want on top
      FOR i = 1 TO l_folder_node.getChildCount()
         LET l_child_node = l_folder_node.getChildByIndex(i)
         IF l_child_node.getTagName() = "Page" THEN
            IF l_child_node.getAttribute("hidden") = 1 THEN
               -- This page is already hidden so don't hide it 
            ELSE
               LET l_name = l_child_node.getAttribute("name")
               IF l_name = l_page_name THEN
                  -- This is the top page so don't hide it
               ELSE
                  -- Hide the page and record the pages we have hidden
                  CALL f.setElementHidden(l_name, TRUE)
                  LET l_page_list[l_page_list.getLength()+1] = l_name
               END IF
            END IF
         ELSE
            -- Just in case the folder node has a child that is not a page 
         END IF
      END FOR
      
      -- Draw the screen with only one folder page.  As it is the only page
      -- it will now be the folder page on top
      CALL ui.Interface.Refresh()
      
      -- Redisplay the pages we have just hidden
      FOR i = 1 TO l_page_list.getLength()
         CALL f.setElementHidden(l_page_list[i], FALSE)
      END FOR
   ELSE
      ERROR "Incorrect folder page"
   END IF
END FUNCTION   
```
