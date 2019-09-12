DECLARE
  V_CODFID VARCHAR2(20) := :CODFID;
  V_NUMSPESE BINARY_INTEGER := 0;
  V_VALORETOT NUMBER := 0;
  V_VALMEDIO NUMBER;
BEGIN
  
  SELECT
    SUM(TOTALE)
  INTO
    V_VALORETOT
  FROM
    CORSOPLSQL.SCONTRINI
  WHERE
    CODFID = V_CODFID;
  
  SELECT
    COUNT(*)
  INTO
    V_NUMSPESE
  FROM
    CORSOPLSQL.SCONTRINI
  WHERE
    CODFID = V_CODFID;
  
  V_VALMEDIO := NVL(V_VALORETOT / V_NUMSPESE, 0);
  DBMS_OUTPUT.PUT_LINE('Valore Medio della Spesa: ' || V_VALMEDIO);
EXCEPTION
  WHEN ZERO_DIVIDE THEN
    DBMS_OUTPUT.PUT_LINE('ERRORE: Il Numero delle spese DEVE essere maggiore di 0');
END;