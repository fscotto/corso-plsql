--Esempio di Cursore Esplicito con Ciclo LOOP

DECLARE
  -- CREAZIONE CURSORE
  CURSOR C_CLIENTI
  IS
    SELECT
      A.NOME
      || ' '
      || A.COGNOME AS Nominativo,
      B.NUMSPESE,
      B.VALTOT
    FROM
      CLIENTI A
    JOIN
      (
        SELECT
          CODFID,
          COUNT( * )  AS NUMSPESE,
          SUM(TOTALE) AS VALTOT
        FROM
          SCONTRINI
        GROUP BY
          CODFID
      )
    B
  ON
    A.CODFIDELITY = B.CODFID
  WHERE
    B.NUMSPESE  > 20
  AND B.VALTOT  > 200
  AND B.CODFID <> - 1
  ORDER BY
    B.VALTOT DESC;

  V_CLIENTI C_CLIENTI%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Apertura Cursore');
  OPEN C_CLIENTI; -- Apertura Cursore

  DBMS_OUTPUT.PUT_LINE ('Fetch Cursore');

  LOOP --Inizio del Ciclo LOOP
    FETCH
      C_CLIENTI
    INTO
      V_CLIENTI; --FETCH DEL CURSORE
    EXIT
  WHEN C_CLIENTI%NOTFOUND;

    --DBMS_OUTPUT.PUT_LINE ('RECORD TROVATO');

    IF V_CLIENTI.VALTOT > 400 THEN
      DBMS_OUTPUT.PUT_LINE(C_CLIENTI%ROWCOUNT || ') Il Cliente '||V_CLIENTI.Nominativo ||' ha fatto spese per  ' ||
      V_CLIENTI.VALTOT || ' ed ha diritto a 10 coupon');
    ELSIF V_CLIENTI.VALTOT > 300 AND V_CLIENTI.VALTOT < 400 THEN
      DBMS_OUTPUT.PUT_LINE(C_CLIENTI%ROWCOUNT || ') Il Cliente '||V_CLIENTI.Nominativo ||' ha fatto spese per  ' ||
      V_CLIENTI.VALTOT || ' ed ha diritto a 5 coupon');
    ELSE
      DBMS_OUTPUT.PUT_LINE(C_CLIENTI%ROWCOUNT || ') Il Cliente '||V_CLIENTI.Nominativo ||
      ' NON ha diritto ad alcun premio! ');
    END IF;

  END LOOP;

  DBMS_OUTPUT.PUT_LINE ('CHIUSURA DEL CURSORE');
  CLOSE C_CLIENTI;

EXCEPTION
  WHEN OTHERS THEN
    IF C_CLIENTI%ISOPEN THEN
      CLOSE C_CLIENTI;
    END IF;
END;
