# Introduction #

The -6366 Could Not Load Database Driver _driver-name_ error is perhaps the most frequent question I see on the support desk.  This page helps illustrate what is happening


# Details #

The -6366 error typically occurs when a developer is having their first attempt at running their application via the Genero Application Server rather than directly from the command line or a GDC Short-cut.

They can run the demo page and the demo application OK but when it comes to running their application the first time, they find that the application ends unexpectedly.

They look in the GAS log and see the following entry ...

```
gwcproxy ... "VM error data" Value=Program stopped at ..., line number ....
SQL statement error number -6366 (0).
Could not load database driver dbmdefault. Set FGLSQLDEBUG to get more details.
```

After counting to 10 and resisting the urge to ask if
you have set FGLSQLDEBUG to get more details as the error suggests,
or pointing them at http://www.4js.com/online_documentation/fjs-fgl-manual-html/User/FglErrors.html and the entry for 6366 ...

  * **Could not load database driver driver-name.**
  * **Description**: The runtime system failed to load the specified database driver. The database driver shared object (.so or .DLL) or a dependent library could not be found.
  * **Solution**:  Make sure that the specified driver name does not have a spelling mistake. If the driver name is correct, there is probably an environment problem. Make sure the database client software is installed. Check the UNIX LD\_LIBRARY\_PATH environment variable or the PATH variable on Windows. These must point to the database client libraries.

... we typically find that the error is caused by the fact that there is an environment problem.

The GAS Configuration file (as.xcf) will set a number of environment variables.  These include PATH and LD\_LIBRARY\_PATH (or their equivalents as per your operating system).  The default GAS configuration file has no knowledge of what database you are trying to connect to.  So the default values of environment variables such as PATH and LD\_LIBRARY\_PATH do not point at your database.

You need to refer to http://www.4js.com/online_documentation/fjs-fgl-manual-html/User/Connections.html#DBCENV and ensure that the environment variables needed by your database have been set in your GAS Configuration file.  So for Informix on Linux, check that INFORMIXDIR and INFORMIXSERVER are defined in your GAS Configuration file, and check that LD\_LIBRARY\_PATH includes INFORMIXDIR/lib and INFORMIXDIR/esql/lib in its list of values.  What variables need to be set and their values differs between databases and operating systems.

So you are probably asking why doesn't the error message say that, and it is probably a fair question.  What is happening is that the runner is trying to load the database driver FGLDIR/lib/dbmdefault, and it in turn is trying to load the appropriate libraries relevant to your database.  It is this loading of the database libraries that is failing because the environment variables are not set correctly, and this is propogating up and manifesting itself as a failure to load FGLDIR/lib/dbmdefault

If you want to see that happening, run your program from the command line via strace and note what happens if you don't set one of the environment variables required by the database libraries correctly.  You should get the 6366 error and if you look in the strace output you will see what library it is failing to load.

Another interesting thing to do when transitioning to the Genero Application Server is add the following line somewhere near the beginning of your program RUN "env | sort > my\_env.txt".  Run your program from the command line, and via the Genero Application Server, and ensure that the Genero Application Server is setting the environment as you expect before it launches your program.

Any suggestions on how we can improve this welcome.  I think the best way is to perhaps ask the questions when installing GAS what database are you using? and what environment variables does it require?, and incorporate these in the default as.xcf file.







