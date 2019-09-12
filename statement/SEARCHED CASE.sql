DECLARE
  V_CODFIDELITY VARCHAR2(20) := :CODFID;
  V_BOLLINI NUMBER := 0;
BEGIN
  
  SELECT
    NVL(SUM(a.BOLLINI), 0)
  INTO
    V_BOLLINI
  FROM
    CORSOPLSQL.SCONTRINI a
  WHERE
    a.CODFID = V_CODFIDELITY;
  
  DBMS_OUTPUT.PUT_LINE('Bollini: ' || V_BOLLINI);
  
  -- Espressioni Searched Case
  CASE
  WHEN V_BOLLINI > 500 THEN
    DBMS_OUTPUT.PUT_LINE('Hai diritto ad un coupon da Euro 10');
  WHEN (V_BOLLINI > 300 AND V_BOLLINI < 500) THEN
    DBMS_OUTPUT.PUT_LINE('Hai diritto ad un coupon di Euro 5');
  WHEN (V_BOLLINI > 100 AND V_BOLLINI < 300) THEN
    DBMS_OUTPUT.PUT_LINE('Coraggio, un altro pò ed otterrai un coupon');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Purtroppo non hai diritto al coupon!!!');
  END CASE;
END;
