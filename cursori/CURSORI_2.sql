-- Esempio di cursore esplicito
DECLARE
  V_CODICEFID SCONTRINI.CODFID%TYPE := &CODFID;
  V_AMMPREMIO NUMBER;
  -- CREAZIONE CURSORE
  CURSOR C_PREMIO
  IS
    SELECT
      NVL(COUNT(*), 0) AS NUMSPESE
    FROM
      SCONTRINI
    WHERE
      CODFID = V_CODICEFID;
  V_PREMIO C_PREMIO%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Apertura Cursore');
  OPEN C_PREMIO;

  DBMS_OUTPUT.PUT_LINE('Fetch Cursore');
  FETCH
    C_PREMIO
  INTO
    V_PREMIO;

  IF C_PREMIO%FOUND THEN
    DBMS_OUTPUT.PUT_LINE('RECORD TROVATO');
    DBMS_OUTPUT.PUT_LINE('Numero di Spese: ' || V_PREMIO.NUMSPESE);

    IF V_PREMIO.NUMSPESE    > 10 THEN
      V_AMMPREMIO          := 10;
    ELSIF V_PREMIO.NUMSPESE > 5 AND V_PREMIO.NUMSPESE < 10 THEN
      V_AMMPREMIO          := 5;
    ELSE
      V_AMMPREMIO := 0;
    END IF;
  END IF;

  DBMS_OUTPUT.PUT_LINE ('CHIUSURA DEL CURSORE');
  CLOSE C_PREMIO;

  IF V_AMMPREMIO > 0 THEN
    DBMS_OUTPUT.PUT_LINE('Complimenti hai ottenuto un premio di ' || V_AMMPREMIO || ' coupon' );
  ELSE
    DBMS_OUTPUT.PUT_LINE('Spiacente, non hai ottenuto alcun premio');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    IF C_PREMIO%ISOPEN THEN
      CLOSE C_PREMIO;
    END IF;
END;
