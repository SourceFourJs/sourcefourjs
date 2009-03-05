# $Id$
#------------------------------------------------------------------------------#
# Copyright (c) 2007 Scott Newton <scottn@ihug.co.nz>                          #
#                                                                              #
# MIT License (http://www.opensource.org/licenses/mit-license.php)             #
#                                                                              #
# Permission is hereby granted, free of charge, to any person obtaining a copy #
# of this software and associated documentation files (the "Software"), to     #
# deal in the Software without restriction, including without limitation the   #
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or  #
# sell copies of the Software, and to permit persons to whom the Software is   #
# furnished to do so, subject to the following conditions:                     #
# The above copyright notice and this permission notice shall be included in   #
# all copies or substantial portions of the Software.                          #
#                                                                              #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR   #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,     #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER       #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING      #
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS #
# IN THE SOFTWARE.                                                             #
#------------------------------------------------------------------------------#

##
# Validator Library
# @category System Program
# @author Scott Newton
# @date April 2008
# @version $Id$
#

DEFINE
    m_rules RECORD
        optional       SMALLINT,
        required       SMALLINT,
        minimum        SMALLINT,
        maximum        SMALLINT,
        minvalue       DECIMAL(32),
        maxvalue       DECIMAL(32),
        minlength      INTEGER,
        maxlength      INTEGER,
        range          SMALLINT,
        rangedata      STRING,
        integer        SMALLINT,
        decimal        SMALLINT,
        alphaonly      SMALLINT,
        alphanumeric   SMALLINT,
        any            SMALLINT,
        uppercase      SMALLINT,
        lowercase      SMALLINT,
        ignorecase     SMALLINT,
        values         STRING,
        create         SMALLINT,
        mustexist      SMALLINT,
        ispath         SMALLINT,
        isfile         SMALLINT,
        format         STRING,
        regex          STRING,
        mask           STRING,
        sql            STRING
    END RECORD

#------------------------------------------------------------------------------#
# Function to set WHENEVER ANY ERROR for this module                           #
#------------------------------------------------------------------------------#

FUNCTION libgt_validator_id()

DEFINE
	l_id   STRING

	WHENEVER ANY ERROR CALL gt_system_error
	LET l_id = "$Id$"

END FUNCTION

##
#
#
# @param l_type The type of the rule.
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_validator(l_type, l_rules, l_data)

DEFINE
    l_type    STRING,
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = FALSE

    LET m_rules.optional = FALSE
    LET m_rules.required = FALSE

    LET m_rules.minimum = FALSE
    LET m_rules.maximum = FALSE
    LET m_rules.minvalue = 0
    LET m_rules.maxvalue = 0
    LET m_rules.minlength = -1
    LET m_rules.maxlength = -1

    LET m_rules.range = FALSE
    LET m_rules.rangedata = NULL

    LET m_rules.integer = FALSE
    LET m_rules.decimal = FALSE
    LET m_rules.alphaonly = FALSE
    LET m_rules.alphanumeric = FALSE
    LET m_rules.any = FALSE
    LET m_rules.uppercase = FALSE
    LET m_rules.lowercase = FALSE
    LET m_rules.ignorecase = FALSE

    LET m_rules.values = NULL

    LET m_rules.create = FALSE
    LET m_rules.mustexist = FALSE
    LET m_rules.ispath = FALSE
    LET m_rules.isfile = FALSE
    LET m_rules.format = NULL

    LET m_rules.regex = NULL
    LET m_rules.mask = NULL
    LET m_rules.sql = NULL

    CASE
        WHEN l_type == "STRING"
            CALL gt_string_validator(l_rules, l_data)
                RETURNING l_ok

        WHEN l_type == "NUMERIC"
            CALL gt_numeric_validator(l_rules, l_data)
                RETURNING l_ok

        WHEN l_type == "CODE"
            CALL gt_code_validator(l_rules, l_data)
                RETURNING l_ok

        WHEN l_type == "PATH"
            CALL gt_path_validator(l_rules, l_data)
                RETURNING l_ok

        WHEN l_type == "DATE"
            CALL gt_date_validator(l_rules, l_data)
                RETURNING l_ok

        WHEN l_type == "DATETIME"
            CALL gt_datetime_validator(l_rules, l_data)
                RETURNING l_ok

        WHEN l_type == "YESNO"
            CALL gt_yesno_validator(l_rules, l_data)
                RETURNING l_ok

        OTHERWISE
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"Invalid type %s passed to the validator", l_type))
    END CASE

    RETURN l_ok

END FUNCTION

##
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_string_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            WHEN l_rule.subString(1, 9) == "MINLENGTH"
                LET m_rules.minimum = TRUE

                CALL gt_convert_string_to_integer(l_rule.subString(11, l_rule.getLength()))
                    RETURNING l_ok, m_rules.minlength

                IF NOT l_ok THEN
                    RETURN l_ok
                END IF

            WHEN l_rule.subString(1, 9) == "MAXLENGTH"
                LET m_rules.maximum = TRUE

                CALL gt_convert_string_to_integer(l_rule.subString(11, l_rule.getLength()))
                    RETURNING l_ok, m_rules.maxlength

                IF NOT l_ok THEN
                    RETURN l_ok
                END IF

            WHEN l_rule == "ALPHAONLY"
                LET m_rules.alphaonly = TRUE

            WHEN l_rule == "ALPHANUMERIC"
                LET m_rules.alphanumeric = TRUE

            WHEN l_rule == "ANY"
                LET m_rules.any = TRUE

            WHEN l_rule == "UPPERCASE"
                LET m_rules.uppercase = TRUE

            WHEN l_rule == "LOWERCASE"
                LET m_rules.lowercase = TRUE

            WHEN l_rule == "IGNORECASE"
                LET m_rules.ignorecase = TRUE

            WHEN l_rule.subString(1, 5) == "REGEX"
                LET m_rules.regex = l_rule.subString(7, l_rule.getLength())

            WHEN l_rule.subString(1, 4) == "MASK"
                LET m_rules.mask = l_rule.subString(6, l_rule.getLength())

            WHEN l_rule.subString(1, 3) == "SQL"
                LET m_rules.sql = l_rule.subString(5, l_rule.getLength())

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in string validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        IF gt_string_is_empty(m_rules.regex) THEN
            LET l_data = l_data.trim()
        END IF

        CALL gtp_validate_string_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
#
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_numeric_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            WHEN l_rule == "INTEGER"
                LET m_rules.integer = TRUE

            WHEN l_rule == "DECIMAL"
                LET m_rules.decimal = TRUE

            WHEN l_rule.subString(1, 5) == "RANGE"
                LET m_rules.range = TRUE
                LET m_rules.rangedata = l_rule.subString(7, l_rule.getLength())

            WHEN l_rule.subString(1, 8) == "MINVALUE"
                LET m_rules.minimum = TRUE
                CALL gt_convert_string_to_decimal(l_rule.subString(10, l_rule.getLength()))
                    RETURNING l_ok, m_rules.minvalue

                IF NOT l_ok THEN
                    RETURN l_ok
                END IF

            WHEN l_rule.subString(1, 8) == "MAXVALUE"
                LET m_rules.maximum = TRUE
                CALL gt_convert_string_to_decimal(l_rule.subString(10, l_rule.getLength()))
                    RETURNING l_ok, m_rules.maxvalue

                IF NOT l_ok THEN
                    RETURN l_ok
                END IF

            WHEN l_rule.subString(1, 4) == "MASK"
                LET m_rules.mask = l_rule.subString(6, l_rule.getLength())

            WHEN l_rule.subString(1, 3) == "SQL"
                LET m_rules.mask = l_rule.subString(5, l_rule.getLength())

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in numeric validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        LET l_data = l_data.trim()
        CALL gtp_validate_numeric_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_code_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            WHEN l_rule == "ANY"
                LET m_rules.any = TRUE

            WHEN l_rule == "UPPERCASE"
                LET m_rules.uppercase = TRUE
                LET l_data = l_data.toUpperCase()

            WHEN l_rule == "LOWERCASE"
                LET m_rules.lowercase = TRUE
                LET l_data = l_data.toLowerCase()

            WHEN l_rule == "IGNORECASE"
                LET m_rules.ignorecase = TRUE

            WHEN l_rule.subString(1, 6) == "VALUES"
                LET m_rules.values = l_rule.subString(9, l_rule.getLength() - 1)

            WHEN l_rule.subString(1, 3) == "SQL"
                LET m_rules.format = l_rule.subString(5, l_rule.getLength())

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in code validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        LET l_data = l_data.trim()
        CALL gtp_validate_code_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_path_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_format      STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            WHEN l_rule == "CREATE"
                LET m_rules.create = TRUE

            WHEN l_rule == "MUSTEXIST"
                LET m_rules.mustexist = TRUE

            WHEN l_rule.subString(1, 6) == "FORMAT"
                LET l_format = l_rule.subString(8, l_rule.getLength())

                CASE
                    WHEN l_format == "SHARE"
                        LET m_rules.format = "SHARE"

                    WHEN l_format == "WIN32"
                        LET m_rules.format = "WIN32"

                    WHEN l_format == "UNIX"
                        LET m_rules.format = "UNIX"

                    WHEN l_format == "LINUX"
                        LET m_rules.format = "LINUX"

                    OTHERWISE
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in path format validation rules", l_rule))
                        EXIT WHILE

                END CASE

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in path validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        LET l_data = l_data.trim()
        CALL gtp_validate_path_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_date_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    IF gt_string_is_empty(l_rules) THEN
        LET l_ok = TRUE
    END IF

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in date validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        LET l_data = l_data.trim()
        CALL gtp_validate_date_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_datetime_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    IF gt_string_is_empty(l_rules) THEN
        LET l_ok = TRUE
    END IF

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in dateetim validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        LET l_data = l_data.trim()
        CALL gtp_validate_datetime_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
#
# @param l_rules The rules to use for the validation.
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gt_yesno_validator(l_rules, l_data)

DEFINE
    l_rules   STRING,
    l_data    STRING

DEFINE
    l_ok          SMALLINT,
    l_rule        STRING,
    l_tokenizer   base.StringTokenizer

    LET l_ok = FALSE
    LET l_tokenizer = base.StringTokenizer.create(l_rules, ",")

    IF gt_string_is_empty(l_rules) THEN
        LET l_ok = TRUE
    END IF

    WHILE l_tokenizer.hasMoreTokens()
        LET l_ok = TRUE
        LET l_rule = l_tokenizer.nextToken()
        LET l_rule = l_rule.trim()

        CASE
            WHEN l_rule == "OPTIONAL"
                LET m_rules.optional = TRUE

            WHEN l_rule == "REQUIRED"
                LET m_rules.required = TRUE

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", SFMT(%"Invalid rule %1 in yesno validation rules", l_rule))
                EXIT WHILE
        END CASE
    END WHILE

    IF l_ok THEN
        LET l_data = l_data.trim()
        LET l_data = UPSHIFT(l_data)
        LET m_rules.uppercase = TRUE
        LET m_rules.values = "Y|N"
        CALL gtp_validate_code_data(l_data)
            RETURNING l_ok
    END IF

    RETURN l_ok

END FUNCTION

##
# This function validates the data against a given mask.
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_data_using_mask(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok            SMALLINT,
    l_pos           INTEGER,
    l_length        INTEGER,
    l_mask_pos      INTEGER,
    l_mask_length   INTEGER,
    l_char          STRING,
    l_mask_char     STRING,
    l_mask          STRING

    LET l_ok = FALSE

    LET l_mask = m_rules.mask
    LET l_length = l_data.getLength()
    LET l_mask_length = l_mask.getLength()

    #--------------------------------------------------------------------------#
    # If the length of the string is greater than the mask length then there   #
    # is something wrong.                                                      #
    #--------------------------------------------------------------------------#

    IF l_length > l_mask.getLength() THEN
        LET l_ok = FALSE
        CALL gt_set_error("ERROR", %"The string length is greater than the mask length")
        RETURN l_ok
    END IF

    LET l_mask_pos = l_mask.getLength()

    FOR l_pos = l_length TO 1 STEP -1
        LET l_char = l_data.getCharAt(l_pos)
        LET l_mask_char = l_mask.getCharAt(l_mask_pos)

        CASE
            WHEN l_mask_char == "a"
                IF ((l_char >= "a"
                AND  l_char <= "z")
                OR    l_char == " ") THEN
                    LET l_mask_pos = l_mask_pos - 1
                    CONTINUE FOR
                END IF

                IF m_rules.ignorecase THEN
                    IF ((l_char.toLowerCase() >= "a"
                    AND  l_char.toLowerCase() <= "z")
                    OR    l_char == " ") THEN
                        LET l_mask_pos = l_mask_pos - 1
                        CONTINUE FOR
                    END IF
                END IF

                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"")
                RETURN l_ok

            WHEN l_mask_char == "A"
                IF ((l_char >= "A"
                AND  l_char <= "Z")
                OR    l_char == " ") THEN
                    LET l_mask_pos = l_mask_pos - 1
                    CONTINUE FOR
                END IF

                IF m_rules.ignorecase THEN
                    IF ((l_char.toUpperCase() >= "A"
                    AND  l_char.toUpperCase() <= "Z")
                    OR    l_char == " ") THEN
                        LET l_mask_pos = l_mask_pos - 1
                        CONTINUE FOR
                    END IF
                END IF

                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"")
                RETURN l_ok

            WHEN l_mask_char == "x"
                IF ((l_char >= "a"
                AND  l_char <= "z")
                OR  (l_char >= "0"
                AND  l_char <= "9")
                OR    l_char == " ") THEN
                    LET l_mask_pos = l_mask_pos - 1
                    CONTINUE FOR
                END IF

                IF m_rules.ignorecase THEN
                    IF ((l_char >= "a"
                    AND  l_char <= "z")
                    OR  (l_char >= "0"
                    AND  l_char <= "9")
                    OR    l_char == " ") THEN
                        LET l_mask_pos = l_mask_pos - 1
                        CONTINUE FOR
                    END IF
                END IF

                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"")
                RETURN l_ok

            WHEN l_mask_char == "X"
                IF ((l_char >= "A"
                AND  l_char <= "Z")
                OR  (l_char >= "0"
                AND  l_char <= "9")
                OR    l_char == " ") THEN
                    LET l_mask_pos = l_mask_pos - 1
                    CONTINUE FOR
                END IF

                IF m_rules.ignorecase THEN
                    IF ((l_char >= "A"
                    AND  l_char <= "Z")
                    OR  (l_char >= "0"
                    AND  l_char <= "9")
                    OR    l_char == " ") THEN
                        LET l_mask_pos = l_mask_pos - 1
                        CONTINUE FOR
                    END IF
                END IF

                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"")
                RETURN l_ok

            WHEN l_mask_char == "d"
                IF (l_char >= "0"
                AND l_char <= "9") THEN
                    LET l_mask_pos = l_mask_pos - 1
                    CONTINUE FOR
                END IF

                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"")
                RETURN l_ok

            OTHERWISE
                IF l_char == l_mask_char THEN
                    LET l_mask_pos = l_mask_pos - 1
                    CONTINUE FOR
                ELSE
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"")
                    RETURN l_ok
                END IF
        END CASE
    END FOR

    RETURN TRUE

END FUNCTION

##
# This function validates the data against a given sql.
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_data_using_sql(l_data)

DEFINE
    l_data   CHAR(255)

DEFINE
    l_ok       SMALLINT,
    l_status   INTEGER,
    l_value    CHAR(255)

    LET l_ok = FALSE
    LET l_data = l_data CLIPPED

    WHENEVER ANY ERROR CONTINUE

    PREPARE s_rules_select_stmt FROM m_rules.sql

    LET l_status = STATUS

    IF l_status != 0 THEN
        LET l_ok = FALSE
        CALL gt_set_error("ERROR", SFMT(%"Unable to prepare the SQL statement %1 : Status %2", m_rules.sql, l_status))
        RETURN l_ok
    END IF

    EXECUTE s_rules_select_stmt
        INTO l_value
      USING l_data

    LET l_status = STATUS

    IF l_status == 0 THEN
        LET l_ok = TRUE
    ELSE
        LET l_ok = FALSE
        IF l_status = NOTFOUND THEN
            CALL gt_set_error("ERROR", SFMT(%"The value %1 does not exist on the database", l_value))
        ELSE
            CALL gt_set_error("ERROR", SFMT(%"Unable to execute the SQL statement %1 using %2 : Status %3", m_rules.sql, l_data CLIPPED, l_status))
        END IF
    END IF

    CLOSE s_rules_select_stmt
    FREE s_rules_select_stmt

    WHENEVER ANY ERROR CALL gt_system_error

    RETURN l_ok

END FUNCTION

#------------------------------------------------------------------------------#
# PRIVATE FUNCTIONS                                                            #
#------------------------------------------------------------------------------#

##
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_string_data(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok   SMALLINT,
    i      INTEGER

    LET l_ok = TRUE

    IF m_rules.required THEN
        IF gt_string_is_empty(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator requires string to not be empty")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.optional THEN
        IF gt_string_is_empty(l_data) THEN
            RETURN l_ok
        END IF
    END IF

    IF m_rules.minlength != -1 THEN
        IF l_data.getLength() < m_rules.minlength THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"Validator requires string length to be a minimum of %1" , m_rules.minlength))
            RETURN l_ok
        END IF
    END IF

    IF m_rules.maxlength != -1 THEN
        IF l_data.getLength() > m_rules.maxlength THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"Validator requires string length to be a maximum of %1" , m_rules.maxlength))
            RETURN l_ok
        END IF
    END IF

    IF m_rules.alphaonly THEN
        IF gt_string_is_alphabetic(l_data) == FALSE THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator requires string to be alpha only")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.alphanumeric THEN
        IF gt_string_is_alphanumeric(l_data) == FALSE THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator requires string to be alphanumeric only")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.uppercase THEN
        FOR i = 1 TO l_data.getLength()
            IF ( l_data.getCharAt(i) >= "a"
            AND  l_data.getCharAt(i) <= "z" ) THEN
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"Validator requires string to be upper case only")
                RETURN l_ok
            END IF
        END FOR
    END IF

    IF m_rules.lowercase THEN
         FOR i = 1 TO l_data.getLength()
            IF ( l_data.getCharAt(i) >= "A"
            AND  l_data.getCharAt(i) <= "Z" ) THEN
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"Validator requires string to be lower case only")
                RETURN l_ok
            END IF
        END FOR
    END IF

    IF NOT gt_string_is_empty(m_rules.regex) THEN
        DISPLAY "<", m_rules.regex, ">"
        DISPLAY "<", l_data, ">"   
        CALL gt_validate_data_using_regex(m_rules.regex, l_data)
            RETURNING l_ok

        IF NOT l_ok THEN
            RETURN l_ok
        END IF
    END IF

    IF NOT gt_string_is_empty(m_rules.mask) THEN
        CALL gtp_validate_data_using_mask(l_data)
            RETURNING l_ok

        IF NOT l_ok THEN
            RETURN l_ok
        END IF
    END IF

    IF NOT gt_string_is_empty(m_rules.sql) THEN
        CALL gtp_validate_data_using_sql(l_data)
            RETURNING l_ok

        IF NOT l_ok THEN
            RETURN l_ok
        END IF
    END IF

    RETURN TRUE

END FUNCTION

##
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_numeric_data(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok              SMALLINT,
    i                 INTEGER,
    l_min             DECIMAL(32),
    l_max             DECIMAL(32),
    l_decimal         DECIMAL(32),
    l_number_string   STRING,
    l_tokenizer       base.StringTokenizer

    LET l_ok = TRUE

    IF m_rules.required THEN
        IF gt_string_is_empty(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator does not allow numeric data to be empty")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.optional THEN
        IF gt_string_is_empty(l_data) THEN
            RETURN l_ok
        END IF
    END IF

    IF m_rules.integer THEN
        FOR i = 1 TO l_data.getLength()
            IF (l_data.getCharAt(i) < "0"
            OR  l_data.getCharAt(i) > "9") THEN
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"Validator requires the data to be integer")
                RETURN l_ok
            END IF
        END FOR
    END IF

    IF m_rules.decimal THEN
        CALL gt_convert_string_to_decimal(l_data)
            RETURNING l_ok, l_decimal

        IF NOT l_ok THEN
            RETURN l_ok
        END IF
    END IF

    IF m_rules.range THEN
        LET l_min = 0
        LET l_max = 0
        LET l_tokenizer = base.StringTokenizer.create(m_rules.rangedata, "-")

        CALL gt_convert_string_to_decimal(l_data)
            RETURNING l_ok, l_decimal

        IF NOT l_ok THEN
            RETURN l_ok
        END IF

        IF l_tokenizer.countTokens() == 2 THEN
            CALL gt_convert_string_to_decimal(l_tokenizer.nextToken())
                RETURNING l_ok, l_min

            IF NOT l_ok THEN
                RETURN l_ok
            END IF

            CALL gt_convert_string_to_decimal(l_tokenizer.nextToken())
                RETURNING l_ok, l_max

            IF NOT l_ok THEN
                RETURN l_ok
            END IF
        ELSE
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator requires a valid range to be specified")
            RETURN l_ok
        END IF

        IF (l_decimal < l_min
        OR  l_decimal > l_max) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator requires the data to be in the valid range")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.minimum THEN
        CALL gt_convert_string_to_decimal(l_data)
            RETURNING l_ok, l_decimal

        IF NOT l_ok THEN
            RETURN l_ok
        END IF

        CALL gt_convert_string_to_decimal(m_rules.minvalue)
            RETURNING l_ok, l_min

        IF NOT l_ok THEN
            RETURN l_ok
        END IF

        IF l_decimal < l_min THEN
            LET l_ok = FALSE
            IF m_rules.integer THEN
                LET l_number_string = m_rules.minvalue USING "<<<<<<<<<&"
            ELSE
                LET l_number_string = m_rules.minvalue
            END IF

            CALL gt_set_error("ERROR", SFMT(%"Validator requires the data to be greater than %1", m_rules.minvalue))
            RETURN l_ok
        END IF
    END IF

    IF m_rules.maximum THEN
        CALL gt_convert_string_to_decimal(l_data)
            RETURNING l_ok, l_decimal

        IF NOT l_ok THEN
            RETURN l_ok
        END IF

        CALL gt_convert_string_to_decimal(m_rules.maxvalue)
            RETURNING l_ok, l_max

        IF NOT l_ok THEN
            RETURN l_ok
        END IF

        IF l_decimal > l_max THEN
            LET l_ok = FALSE
            IF m_rules.integer THEN
                LET l_number_string = m_rules.maxvalue USING "<<<<<<<<<&"
            ELSE
                LET l_number_string = m_rules.maxvalue
            END IF

            CALL gt_set_error("ERROR", SFMT(%"Validator requires the data to be less than %1", m_rules.maxvalue))
            RETURN l_ok
        END IF
    END IF

    IF NOT gt_string_is_empty(m_rules.mask) THEN
        CALL gtp_validate_data_using_mask(l_data)
            RETURNING l_ok

        IF NOT l_ok THEN
            RETURN l_ok
        END IF
    END IF

    RETURN TRUE

END FUNCTION

##
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_code_data(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok            SMALLINT,
    i               INTEGER,
    l_code_string   STRING,
    l_codes         DYNAMIC ARRAY OF STRING,
    l_tokenizer     base.StringTokenizer

    LET l_ok = FALSE

    IF m_rules.required THEN
        IF gt_string_is_empty(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator does not allow empty code data.")
            RETURN l_ok
        END IF
    END IF

    IF NOT gt_string_is_empty(m_rules.values) AND
        NOT gt_string_is_empty(l_data) THEN
        LET i = 0
        LET l_tokenizer = base.StringTokenizer.create(m_rules.values, "|")

        WHILE l_tokenizer.hasMoreTokens()
            LET i = i + 1
            LET l_codes[i] = l_tokenizer.nextToken()
        END WHILE

        LET l_data = UPSHIFT(l_data)
        LET l_code_string = NULL
        FOR i = 1 TO l_codes.getLength()
            IF l_data = UPSHIFT(l_codes[i]) THEN
                LET l_ok = TRUE
                EXIT FOR
            END IF
            IF i > 1 THEN
                LET l_code_string = l_code_string, ", "
            END IF
            LET l_code_string = l_code_string, l_codes[i]
        END FOR

        IF NOT l_ok THEN
            CALL gt_set_error("ERROR", SFMT(%"Validator requires the given value to be one of the supplied codes %1", l_code_string))
            RETURN l_ok
        END IF
    END IF

    RETURN TRUE

END FUNCTION

##
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_path_data(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok   SMALLINT,
    i      INTEGER

    LET l_ok = TRUE

    IF m_rules.required THEN
        IF gt_string_is_empty(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator does not allow the path to be empty")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.optional THEN
        IF gt_string_is_empty(l_data) THEN
            RETURN l_ok
        END IF
    END IF

    IF m_rules.create THEN
        IF NOT gt_is_directory(l_data) THEN
            IF gt_mkdir(l_data, TRUE) THEN
            ELSE
                CALL gt_set_error("ERROR", SFMT(%"Unable to create directory %1", l_data))
                RETURN l_ok
            END IF
        END IF
    END IF

    IF m_rules.mustexist THEN
        IF NOT gt_is_directory(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", SFMT(%"The given directory %1 does not exist", l_data))
            RETURN l_ok
        END IF
    END IF

    IF NOT gt_string_is_empty(m_rules.format) THEN
        CASE
            WHEN m_rules.format == "SHARE"
                #--------------------------------------------------------------#
                # Valid format: \\\\[a-zA-Z0-9.-_]*[\\[a-zA-Z0-9.-_]*]+        #
                #--------------------------------------------------------------#
                IF l_data.getCharAt(1) != ASCII(92)
                OR l_data.getCharAt(2) != ASCII(92) THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"Validator requires a valid share path")
                    RETURN l_ok
                END IF

                FOR i = 3 TO l_data.getLength()
                    IF ((l_data.getCharAt(i) >= "a"
                    AND  l_data.getCharAt(i) <= "z")
                    OR  (l_data.getCharAt(i) >= "A"
                    AND  l_data.getCharAt(i) <= "Z")
                    OR  (l_data.getCharAt(i) >= "0"
                    AND  l_data.getCharAt(i) <= "9")
                    OR  (l_data.getCharAt(i) == ".")
                    OR  (l_data.getCharAt(i) == "-")
                    OR  (l_data.getCharAt(i) == "_")) THEN
                        CONTINUE FOR
                    END IF

                    IF l_data.getCharAt(i) == ASCII(92) THEN
                        IF l_data.getCharAt(i+1) == ASCII(92) THEN
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Validator requires a valid share path")
                            RETURN l_ok
                        END IF
                    ELSE
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"Validator requires a valid share path")
                        RETURN l_ok
                    END IF
                END FOR

            WHEN m_rules.format == "WIN32"
                #--------------------------------------------------------------#
                # Valid format: [a-zA-Z]:\\[a-zA-Z0-9.-_]*[\\[a-zA-Z0-9.-_]*]+ #
                #--------------------------------------------------------------#
                IF ((l_data.getCharAt(1) < "a"
                AND  l_data.getCharAt(1) > "z")
                OR  (l_data.getCharAt(1) < "A"
                AND  l_data.getCharAt(1) > "Z")) THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"Validator requires a valid drive to be specified for the path")
                    RETURN l_ok
                END IF

                IF l_data.getCharAt(2) != ":" THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"Validator requires a drive separator to be specified for the path")
                    RETURN l_ok
                END IF

                IF l_data.getCharAt(3) != ASCII(92) THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"Validator requires a valid path")
                    RETURN l_ok
                END IF

                FOR i = 4 TO l_data.getLength()
                    IF ((l_data.getCharAt(i) >= "a"
                    AND  l_data.getCharAt(i) <= "z")
                    OR  (l_data.getCharAt(i) >= "A"
                    AND  l_data.getCharAt(i) <= "Z")
                    OR  (l_data.getCharAt(i) >= "0"
                    AND  l_data.getCharAt(i) <= "9")
                    OR  (l_data.getCharAt(i) == ".")
                    OR  (l_data.getCharAt(i) == "-")
                    OR  (l_data.getCharAt(i) == "_")) THEN
                        CONTINUE FOR
                    END IF

                    IF l_data.getCharAt(i) == ASCII(92) THEN
                        IF l_data.getCharAt(i+1) == ASCII(92) THEN
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Validator requires a valid path")
                            RETURN l_ok
                        END IF
                    ELSE
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"Validator requires a valid path")
                        RETURN l_ok
                    END IF
                END FOR

            WHEN m_rules.format == "UNIX"
            OR    m_rules.format == "LINUX"
                #--------------------------------------------------------------#
                # Valid format: /[a-zA-Z0-9.-_]*[/[a-zA-Z0-9.-_]*]+            #
                #--------------------------------------------------------------#
                IF l_data.getCharAt(1) != ASCII(47) THEN
                    LET l_ok = FALSE
                    CALL gt_set_error("ERROR", %"Validator requires a valid path")
                    RETURN l_ok
                END IF

                FOR i = 2 TO l_data.getLength()
                    IF ((l_data.getCharAt(i) >= "a"
                    AND  l_data.getCharAt(i) <= "z")
                    OR  (l_data.getCharAt(i) >= "A"
                    AND  l_data.getCharAt(i) <= "Z")
                    OR  (l_data.getCharAt(i) >= "0"
                    AND  l_data.getCharAt(i) <= "9")
                    OR  (l_data.getCharAt(i) == ".")
                    OR  (l_data.getCharAt(i) == "-")
                    OR  (l_data.getCharAt(i) == "_")) THEN
                        CONTINUE FOR
                    END IF

                    IF l_data.getCharAt(i) == ASCII(47) THEN
                        IF l_data.getCharAt(i+1) == ASCII(47) THEN
                            LET l_ok = FALSE
                            CALL gt_set_error("ERROR", %"Validator requires a valid path")
                            RETURN l_ok
                        END IF
                    ELSE
                        LET l_ok = FALSE
                        CALL gt_set_error("ERROR", %"Validator requires a valid path")
                        RETURN l_ok
                    END IF
                END FOR

            OTHERWISE
                LET l_ok = FALSE
                CALL gt_set_error("ERROR", %"Validator requires a valid path format separator")
                RETURN l_ok
        END CASE
    END IF

    RETURN TRUE

END FUNCTION

##
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_date_data(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok   SMALLINT

    LET l_ok = TRUE

    IF m_rules.required THEN
        IF gt_string_is_empty(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator does not allow an empty date")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.optional THEN
        IF gt_string_is_empty(l_data) THEN
            RETURN l_ok
        END IF
    END IF

    IF NOT gt_string_is_date(l_data) THEN
        LET l_ok = FALSE
        CALL gt_set_error("ERROR", %"Validator requires a valid date")
        RETURN l_ok
    END IF

    RETURN TRUE

END FUNCTION

##
#
# @param l_data The data to be validated.
# @return l_ok TRUE if the data passes the validator tests, FALSE otherwise.
#

FUNCTION gtp_validate_datetime_data(l_data)

DEFINE
    l_data   STRING

DEFINE
    l_ok         SMALLINT,
    l_status     INTEGER,
    l_datetime   DATETIME YEAR TO FRACTION(3)

    LET l_ok = TRUE

    IF m_rules.required THEN
        IF gt_string_is_empty(l_data) THEN
            LET l_ok = FALSE
            CALL gt_set_error("ERROR", %"Validator does not allow an empty datetime")
            RETURN l_ok
        END IF
    END IF

    IF m_rules.optional THEN
        IF gt_string_is_empty(l_data) THEN
            RETURN l_ok
        END IF
    END IF

    WHENEVER ANY ERROR CONTINUE
    LET l_datetime = l_data
    LET l_status = STATUS
    WHENEVER ANY ERROR CALL gt_system_error

    IF l_status != 0 THEN
        LET l_ok = FALSE
        CALL gt_set_error("ERROR", %"Validator requires a valid datetime")
        RETURN l_ok
    END IF

    RETURN TRUE

END FUNCTION

#------------------------------------------------------------------------------#
# END OF MODULE                                                                #
#------------------------------------------------------------------------------#
