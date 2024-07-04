/* Create a package (header and Body) that includes the following
- Calculate the factorial of a number
-Given a number in dollars convert to euro
- Given a number in euro convert to dollars
-Given a number in digits (max 7 digits and 3 decimals), 
convert to characters with the thou and decimal separators
having in consideration the followingL
--9: indicates subtitution for a digit
--G: thou separator
--D: Decimal separator
- Indicate a constant for the conversion EUR/USD
*/
DROP PACKAGE P1;
CREATE OR REPLACE PACKAGE P1 IS
    FUNCTION factorial (v_number NUMBER) RETURN NUMBER;
    f_result NUMBER;
    FUNCTION conversion(v_amount NUMBER, rate_bool NUMBER) RETURN NUMBER;
    c_rate CONSTANT NUMBER := 1.108;
    FUNCTION num_to_char(v_to_convert NUMBER) RETURN VARCHAR2;
END;
/
CREATE OR REPLACE PACKAGE BODY P1 Is
    FUNCTION factorial (v_number NUMBER) RETURN NUMBER
    is 
    BEGIN
        f_result:=1;
        for i in  1 .. v_number
        loop
            f_result:=f_result*i;
        END LOOP;
        RETURN f_result;
    END;
    FUNCTION conversion(v_amount NUMBER, rate_bool NUMBER) RETURN NUMBER
    is
    BEGIN
        IF rate_bool = 1
        THEN  
            RETURN ROUND(v_amount/c_rate,2);
        ELSIF rate_bool = 0 THEN 
            RETURN ROUND(V_amount* c_rate,2);
        ELSE
            RETURN NULL;
        END IF;
    END;
    FUNCTION num_to_char(v_to_convert NUMBER) RETURN VARCHAR2
    IS
    BEGIN
        RETURN TO_CHAR (v_to_convert,'999,999.99');
    END;
END P1; 
/
SELECT P1.NUM_TO_CHAR(P1.conversion(22600,0)) FROM DUAL;
SELECT P1.FACTORIAL(6) FROM DUAL;


