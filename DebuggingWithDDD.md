# Introduction #

The 4Js runner can utilise the graphical GNU [DDD](http://www.gnu.org/software/ddd/) (Data Display Debugger) for debugging programs. This HowTo documents how to do it. GNU DDD is a graphical front-end for command-line debuggers like GDB.

# Prerequisites #

  * A X-Server running on the same computer as the Genero Desktop Client.

> - For windows, either install cygwin or [Xming](http://www.straightrunning.com/XmingNotes/)

> - For Mac OS X, the X11 Server on CD 2

  * On the server running the 4Js runner, ddd and a supported commandline debugger like gdb.

# Usage Example #

This example shows how to debug a program called ap\_cat

Start the X-Server and GDC on the client computer. You will need to give permission for ddd to communicate with the client X-Server, so in the X-Server console enter:

```
xhost server.intra.net
```

Login to the development server using a SSH client, setup the 4Js runtime environment, and enter the following:

```
export DISPLAY=$FGLSERVER:0.0

ddd --debugger "fglrun -d ap_cat.42r DB=acct78test"

```