# Global Actions #
## Introduction ##

Ever want to have the same action available in every dialog statement?  The prime example is a a Help->About TopMenu option that is fairly standard in most Windows applications.  Other examples include help functionality, wizards, debugging tools, as well as an ON IDLE timeout, that you want available throughout your application, but you don't want to have to manually code them into every 4gl dialog statement.

There is an enhancement request for such functionality (quote Bz559 when talking to your local support)

In the interim, the following is a technique I used to implement what I called 'Global Actions' many years ago.  I have shared the technique with many people and I figured I'd better write it down...

This technique was relatively easy to implement and uses the built-in pre-processor in the Genero compiler


## Details ##

  * At the top of every .4gl file, if you don't already, add a line to include a file

```
  &include "my_include_file.4gl"

```

  * In this file, add a definition like so ...

```
  &define END_INPUT   ON ACTION action1 CALL my_global_action1() \
     ON ACTION action2 CALL my_global_action2() \
    ...
     ON IDLE 60 CALL dialog_timeout() \
  END INPUT
```

> Add as many global actions as you want.

> Repeat this for each different dialog type.  This allows you to have different functionality depending on the dialog type e.g. in CONSTRUCT you can add a wizard to help the user enter QBE criteria.

> You can also implement more than one for each dialog type if you want different actions available in some dialogs and not others e.g. I had a END\_MENU, and an END\_MENU\_DIALOG to differentiate actions I didn’t want available in a dialog menu

> With arrays you can also add the array variable and pass it to the generic function as a DomNode

```
  &define END_DISPLAY_ARRAY(p1) ON ACTION array_action1 CALL my_global_array_action1(base.TypeInfo.create(p1)) \
  END DISPLAY
```

  * In your .4gl code, search and replace all instances of END INPUT with END\_INPUT etc.


Once you have done this, from then on it is simply a case of educating your developers to type END\_INPUT etc instead of END INPUT, and add to your code-reviews and automated code checking scripts, checks that END INPUT etc is not being coded anywhere.

The example above had ON IDLE 60 CALL dialog\_timeout().  This simply meant that dialog\_timeout() was called every 60 seconds, and we had system configuration variables that allowed us to configure how many minutes we wanted to wait before exiting the program.


I had approx 12 of these global actions in END\_INPUT.  With DISPLAY ARRAY we had 40+ actions as we had 36 actions to respond to the user pressing A-Z0-9 inside the DISPLAY ARRAY and moving to the appropriate row.