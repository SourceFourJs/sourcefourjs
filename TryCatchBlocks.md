# Introduction #

With Genero 2.10 Four J's introduced the try...catch pseudo statement. Currently at this time the try statement can be compared to the WHENEVER ERROR GOTO label.


# Usage #

Say we have the following two 4gl source modules:

```
MAIN

    WHENEVER ANY ERROR CALL system_error

    DISPLAY "Start test try...catch..."

    CALL generate_error1()

    TRY
        DISPLAY "Call to local function to generate error..."
        CALL generate_error2()
    CATCH
        DISPLAY "Local error caught..."
    END TRY

    TRY
        DISPLAY "Call to function in a different module to generate error..."
        CALL generate_error3()
    CATCH
        DISPLAY "Module error caught..."
    END TRY

    CALL generate_error3()

    DISPLAY "Done."

END MAIN

FUNCTION generate_error1()

DEFINE
    l_value   INTEGER

    TRY
        LET l_value = 1 / 0
    CATCH
        DISPLAY "Try...catch error..."
    END TRY

END FUNCTION

FUNCTION generate_error2()

DEFINE
    l_value   INTEGER

    LET l_value = 1 / 0

END FUNCTION

FUNCTION system_error()

    DISPLAY "System error called..."

END FUNCTION
```

and

```
FUNCTION dummy()

    WHENEVER ANY ERROR CALL sub_system_error

END FUNCTION

FUNCTION generate_error3()

DEFINE
    l_value   INTEGER

    LET l_value = 1 / 0

END FUNCTION

FUNCTION sub_system_error()

    DISPLAY "Sub-system error called..."

END FUNCTION
```

Running this code you would probably assume that the following would be printed out to stdout:

```
Start test try...catch...
Try...catch error...
Call to local function to generate error...
Local error caught...
Call to function in a different module to generate error...
Module error caught...
Done.
```

Actually what would get printed out is the following:

```
Start test try...catch...
Try...catch error...
Call to local function to generate error...
System error called...
Call to function in a different module to generate error...
Sub-system error called...
Done.
```

This is because try...catch is only a pseudo statement. To make this work as expected you need to add WHENEVER ANY ERROR RAISE, as follows:

```
MAIN

    WHENEVER ANY ERROR CALL system_error

    DISPLAY "Start test try...catch..."

    CALL generate_error1()

    TRY
        DISPLAY "Call to local function to generate error..."
        CALL generate_error2()
    CATCH
        DISPLAY "Local error caught..."
    END TRY

    TRY
        DISPLAY "Call to function in a different module to generate error..."
        CALL generate_error3()
    CATCH
        DISPLAY "Module error caught..."
    END TRY

    CALL generate_error3()

    DISPLAY "Done."

END MAIN

FUNCTION generate_error1()

DEFINE
    l_value   INTEGER

    TRY
        LET l_value = 1 / 0
    CATCH
        DISPLAY "Try...catch error..."
    END TRY

END FUNCTION

FUNCTION generate_error2()

DEFINE
    l_value   INTEGER

    WHENEVER ANY ERROR RAISE

    LET l_value = 1 / 0

    WHENEVER ANY ERROR CALL system_error

END FUNCTION

FUNCTION system_error()

    DISPLAY "System error called..."

END FUNCTION
```

and

```
FUNCTION dummy()

    WHENEVER ANY ERROR CALL sub_system_error

END FUNCTION

FUNCTION generate_error3()

DEFINE
    l_value   INTEGER

    WHENEVER ANY ERROR RAISE

    LET l_value = 1 / 0

    WHENEVER ANY ERROR CALL sub_system_error

END FUNCTION

FUNCTION sub_system_error()

    DISPLAY "Sub-system error called..."

END FUNCTION
```

The other option is to replace the WHENEVER ANY ERROR calls with WHENEVER ANY ERROR RAISE.

# Limitations #

  * If you replace the WHENEVER ANY ERROR system\_error calls with WHENEVER ANY ERROR RAISE there you need to make sure that all the code within that module is called from within a try...catch block.
  * There is no way to unwind the stack. If you have a try...catch within a try...catch block, the exception will be caught by the first catch and there is no way to pass the exception any further up the stack. So be very careful where you place your try...catch blocks.