-- Esempio di scope delle eccezioni
<<BLOCCO_ESTERNO>>
DECLARE
  V_CODICEFID CORSOPLSQL.CLIENTI.CODFIDELITY%TYPE := :CODFID;
  V_QTABOLLINI NUMBER := 0;
  V_NOMINATIVO VARCHAR2(50);
BEGIN
  
  SELECT
    NOME || ' ' || COGNOME
  INTO
    V_NOMINATIVO
  FROM
    CORSOPLSQL.CLIENTI
  WHERE
    CODFIDELITY = V_CODICEFID;
    
  DBMS_OUTPUT.PUT_LINE('Il Nome del Cliente è ' || V_NOMINATIVO);

  <<BLOCCO_INTERNO>>
  BEGIN
    SELECT
      SUM(BOLLINI)
    INTO
      V_QTABOLLINI
    FROM
      SCONTRINI
    WHERE
      CODFID = V_CODICEFID;
    
    DBMS_OUTPUT.PUT_LINE('Il Cliente ha un monte bollini di ' || NVL(V_QTABOLLINI, 0));
  EXCEPTION
    WHEN VALUE_ERROR OR ZERO_DIVIDE THEN
      DBMS_OUTPUT.PUT_LINE('Errore nel calcolo del monte bollini');
  END;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NON è stato trovato alcun cliente!!!');
END;
