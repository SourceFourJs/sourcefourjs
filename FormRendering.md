# Introduction #

One of the questions most asked when someone starts developing with Genero is how the form rendering is calculated, in particular the width of cells.  This routine can be used to graphically illustrate the width of a column of cells in a grid.

# Details #

The link http://www.4js.com/techdocs/genero/fgl/devel/DocRoot/User/Layout.html illustrates how the form is rendered.  New Genero users sometimes struggle with this concept and expect to have pixel level control of where a widget is positioned.  As Genero is for multiple front-ends, you shouldn't expect to have this level of control as different widgets will be rendered with different sizes in different front-ends.  What is important is that the widgets are still positioned correctly relative to each other.

In editing a form, a developer may unintentionally only allocate a narrow width to a widget which naturally takes up some width e.g. a combobox, a checkbox, a radiogroup.  They then wonder why elements above and below this widget are wider than they expect.  The show\_spacing() routine graphically illustrates the width of the cells in a group or grid. Later versions of the GDC and the Genero Studio form previewer may also provide similar functionality.

Run this program and select a form.  Press SPACE and the width of each column will be illustrated with alternating red and blue vertical lines.  I have also included a test form which will illustrate the typical mistake where a combobox and a checkbox have large widths and hence the widgets directly above and below expand to match this width.

```
MAIN
DEFINE l_formfile STRING       # Name of file passed as argument

   # Must pass in at least one argument
   LET l_formfile = base.Application.getArgument(1)

   IF l_formfile.getLength() = 0 THEN
      PROMPT "Enter form filename" FOR l_formfile
   END IF

   IF l_formfile.getLength() = 0 THEN
      EXIT PROGRAM 1
   END IF
   OPEN WINDOW w WITH FORM l_formfile

   MENU "Show Form"
      BEFORE MENU
         MESSAGE "Press SPACE to see cell widths"
      COMMAND KEY(" ")
         CALL show_spacing()
      ON ACTION accept
         EXIT MENU
      ON ACTION cancel
         EXIT MENU
      ON ACTION close
         EXIT MENU
   END MENU
END MAIN

FUNCTION show_spacing()
DEFINE l_window ui.Window
DEFINE l_window_node om.DomNode
DEFINE l_nodelist om.NodeList
DEFINE l_node om.DomNode
DEFINE i,j,k,l INTEGER
DEFINE l_child om.DomNode
DEFINE l_width INTEGER
DEFINE l_height INTEGER

   LET l_window = ui.Window.GetCurrent()
   LET l_window_node = l_window.getNode()

   FOR k = 1 TO 2
      CASE k
         WHEN 1 LET l_nodelist = l_window_node.SelectByTagName("Grid")
         WHEN 2 LET l_nodelist = l_window_node.SelectByTagName("Group")
      END CASE
      FOR i = 1 TO l_nodelist.getLength()
         LET l_node = l_nodelist.item(i)
         LET l_width = l_node.getAttribute("width")
         LET l_height = l_node.getAttribute("height")
         FOR j = 1 TO l_width
            LET l_child = l_node.CreateChild("Label")
            CALL l_child.setAttribute("posX",j)
            CALL l_child.setAttribute("posY",l_height)
            CALL l_child.setAttribute("text","|")
            CASE j MOD 2
               WHEN 0 CALL l_child.setAttribute("color","red")
               WHEN 1 CALL l_child.setAttribute("color","blue")
            END CASE
         END FOR
      END FOR
   END FOR
   CALL ui.Interface.Refresh()
END FUNCTION

```


Example Form

```
LAYOUT
VBOX
GRID
{
[f01   ][f02   ][f03   ]
[f04   ][f05   ][f06   ]
}
END
GRID
{
[f11   ][f12   ][f13   ]
[f14   ][f15   ][f16   ]
}
END
END
END
ATTRIBUTES
f01 = formonly.field01;
COMBOBOX f02 = formonly.field02, ITEMS=("Large value so large");
f03 = formonly.field03;
f04 = formonly.field04;
f05 = formonly.field05;
f06 = formonly.field06;
f11 = formonly.field11;
CHECKBOX f12 = formonly.field12, TEXT="Large amount of text";
f13 = formonly.field13;
f14 = formonly.field14;
f15 = formonly.field15;
f16 = formonly.field16;


```