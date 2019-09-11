DECLARE 
  VAL_SPESA NUMBER;
BEGIN
  
  VAL_SPESA := 400;
  IF VAL_SPESA > 500 THEN
    DBMS_OUTPUT.PUT_LINE('Complimenti sei un cliente GOLD con una spesa di: ' || VAL_SPESA);
  ELSIF (VAL_SPESA > 300 AND VAL_SPESA < 500) THEN 
    DBMS_OUTPUT.PUT_LINE('Complimenti se un cliente SILVER con una spesa di: ' || VAL_SPESA);
  ELSE 
    DBMS_OUTPUT.PUT_LINE('Spiacente NON hai raggiunto il valore di spesa minimo (500):' || VAL_SPESA);
  END IF;

END;
