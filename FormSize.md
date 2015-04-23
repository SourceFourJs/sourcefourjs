# Introduction #

Sometimes a window has a small form (or no form) and the action panels
and/or toolbars are clipped. The Form\_SizeInit() function can be used to
force the form area to be sized to a specified height and width.
Note that as proportional fonts are used, height and width are
relative to the font size used.

# Syntax #
```
        CALL Form_SizeInit(p_height, p_width)

where:
        p_height        Approximate height in "rows"
        p_width         Approximate width in "columns"

returns:
        none
```

# Details #

By default, Genero renders the form "shrink-wrapped", ie. packed to the
contents of the form. However, there are some widgets like the image widget
that can be fixed in size.

First of all, we will need a form (blank.per) with an image widget:

```
database formonly

layout
  vbox
    grid
      {
      [i]
      }
    end --grid
  end --vbox
end --layout

attributes
image i : i000, style="noborder" ;
```

We want to hide the border, so we then add to our default presentation
style (default.4st) the following style:

```
  <Style name=".noborder">
     <StyleAttribute name="border" value="no" />
  </Style>
```

In Form\_SizeInit(), we
  * look for a current window, and force screen to open if no current window
  * look for a form in the current window, saving form name if exists
  * display the blank form
  * resize according to requested dimensions
  * re-display previous form (if any)

```
#
#       (c) Copyright 2007, Four Js AsiaPac - www.4js.com.au/local
#
#       MIT License (http://www.opensource.org/licenses/mit-license.php)
#
#       Permission is hereby granted, free of charge, to any person
#       obtaining a copy of this software and associated documentation
#       files (the "Software"), to deal in the Software without restriction,
#       including without limitation the rights to use, copy, modify, merge,
#       publish, distribute, sublicense, and/or sell copies of the Software,
#       and to permit persons to whom the Software is furnished to do so,
#       subject to the following conditions:
#
#       The above copyright notice and this permission notice shall be
#       included in all copies or substantial portions of the Software.
#
#       THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#       EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
#       OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#       NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
#       BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
#       ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#       CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#       THE SOFTWARE.
#
#       formsize.4gl    Resize current form area in current window
#
#       28aug07 MoHo
#


#
#       Form_SizeInit           Set initial size of form area
#                               Must be called before form display
#
# Syntax:
#       call Form_SizeInit(p_peight, p_width)
#
# where:
#       p_height        height in rows
#       p_width         widht in columns
# returns:
#       none
#
# Method:
# - save current form name if any
# - display blank form
# - resize blank form with borderless image widget
# - re-display original form
#
# Caveat:
#   This should be used to initialize the form area.
#   Any data in the form before this call will need to be re-displayed.
#
function Form_SizeInit(p_height, p_width)

    define
        p_height integer,
        p_width integer,

        w_curr ui.Window,
        f_curr ui.Form,
        d_form om.DomNode,
        d_blank om.DomNode,
        dl_image om.NodeList,
        d_node om.DomNode,
        p_formName string


    ### Get current window ###
    let w_curr = ui.Window.getCurrent()
    if w_curr is null
    then
        ### something to force open screen ###
        display "" at 1,1
        let w_curr = ui.Window.getCurrent()
        if w_curr is null
        then
            return
        end if
    end if

    ### and form in window? ###
    let f_curr = w_curr.getForm()
    if f_curr is not null
    then
        ### get node of current form, and name, then close it ###
        let d_form = f_curr.getNode()
        let p_formName = d_form.getAttribute("name")
    end if

    ### need to load a blank form ###
    open form f_blank from "blank"
    display form f_blank

    ### try and get form again $###
    let f_curr = w_curr.getForm()
    if f_curr is null
    then
        return
    end if
    let d_blank = f_curr.getNode()

    ### Find screen in blank form ###
    let dl_image = d_blank.selectByTagName("Image")
    if dl_image.getLength()
    then
        let d_node = dl_image.item(1)
        call d_node.setAttribute("width", p_width)
        call d_node.setAttribute("height", p_height)
    end if
    call ui.interface.refresh()

    ### Restore previous form ###
    if p_formName.getLength()
    then
        open form f_org from p_formName
        display form f_org
    end if
end function
```