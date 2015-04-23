# Introduction #

Some notes on the AUI Tree reading and writing example I recently [added](http://sourcefourjs.googlecode.com/files/auitree_1_0.zip) in the downloads section.


# Details #

I have noticed in recent periods a few questions in the Genero forums to do with reading and writing to the AUI tree.

Early Genero adapters had to do more AUI tree manipulation as early versions of the product didn't have methods such as DIALOG.setActionActive, ui.Form.setElementHidden etc. and so you will find developers who were early adapters of Genero are more familiar with the concept as they had used it more often.

If you start the GDC with the -D option specified, then when you move the cursor over a widget, press Control and right-click, and you will see a window opened that shows the AUI tree at that point.

In your Genero code, you can read any of those values, and within reason you can also change some of those values at run-time.  These examples show places where you may still conceivably read and write these values.

I'm a believer that sometimes the best way to learn is by example so download and run the program and look at the code.  You will see the AUI tree is being read and written to achieve a result that you can't currently do with a single Genero command, and certainly something you couldn't do in 4gl days.  (If you aren't using Studio, you should just be able to link the .4gl files together to create your .42r)

Finally if you want do any AUI tree mods yourself, some useful hints...

  1. Start the  GDC option with the -D option and use control right+click to see the current strucuture of the AUI tree.
  1. 4Js may change the strucuture of the AUI tree between versions.  Every new release, get a copy of the new version and test your functions still read and write to the AUI tree as expected.  In practise it hasn't changed much, even multi-dialog only had a small impact.
  1. note how some attributes are properties of the FormField node whilst some attributes are properties of the widget node.
  1. start small e.g. change field comment or action text, and work your way up
  1. experiment changing attributes in the .per to see the effect in the AUI tree.
  1. When 4Js introduce a function to do what your function is doing, switch your code to use that function.

If you do something yourself that you think will be useful let me know and I'll add it to the example.