-- Esempio eccezioni dinamiche definite dall'utente
<<BLOCCO_ESTERNO>>
DECLARE
  V_CODICEFID CLIENTI.CODFIDELITY%TYPE := :CODFID;
  V_QTABOLLINI NUMBER := 0;
  V_NOMINATIVO VARCHAR2(50);
BEGIN
  
  IF V_CODICEFID < 67000000 THEN
    -- Valore compreso fra -20000 e -20999
    RAISE_APPLICATION_ERROR(-20001, 'Il Codice Fidelity deve essere > di 67000000');
  END IF;

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
    IF V_CODICEFID = 67000031 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Non è possibile visualizzare i dati del codice 67000031');
    END IF;

    SELECT
      SUM(BOLLINI)
    INTO
      V_QTABOLLINI
    FROM
      SCONTRINI
    WHERE
      CODFID = V_CODICEFID;
    
    DBMS_OUTPUT.PUT_LINE('Il Cliente ha un monte bollini di ' || NVL(V_QTABOLLINI, 0));
  END;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NON è stato trovato alcun cliente!!!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
