--Esempio Cursore con parametro

DECLARE

  V_NUMSPESE NUMBER := &NumSpese;

  --CREAZIONE CURSORE
  CURSOR C_CLIENTI(P_NUMSPESE IN NUMBER)
  IS
    SELECT
      A.NOME
      || ' '
      || A.COGNOME AS NOMINATIVO,
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
    B.NUMSPESE  > P_NUMSPESE
  AND B.CODFID <> - 1
  ORDER BY
    B.VALTOT DESC;

  V_CLIENTI C_CLIENTI%ROWTYPE;

BEGIN
  DBMS_OUTPUT.PUT_LINE ('Apertura Cursore');
  OPEN C_CLIENTI(V_NUMSPESE); -- Apertura Cursore

  DBMS_OUTPUT.PUT_LINE ('Fetch Cursore');

  LOOP

    FETCH
      C_CLIENTI
    INTO
      V_CLIENTI; --FETCH DEL CURSORE
    EXIT
  WHEN C_CLIENTI%NOTFOUND;

    --DBMS_OUTPUT.PUT_LINE ('RECORD TROVATO');

    IF V_CLIENTI.VALTOT > 400 THEN
      DBMS_OUTPUT.PUT_LINE(C_CLIENTI%ROWCOUNT || ') Il Cliente '||V_CLIENTI.NOMINATIVO ||' ha fatto spese per  ' ||
      V_CLIENTI.VALTOT || ' ed ha diritto a 10 coupon');
    ELSIF V_CLIENTI.VALTOT > 300 AND V_CLIENTI.VALTOT < 400 THEN
      DBMS_OUTPUT.PUT_LINE(C_CLIENTI%ROWCOUNT || ') Il Cliente '||V_CLIENTI.NOMINATIVO ||' ha fatto spese per  ' ||
      V_CLIENTI.VALTOT || ' ed ha diritto a 5 coupon');
    ELSE
      DBMS_OUTPUT.PUT_LINE(C_CLIENTI%ROWCOUNT || ') Il Cliente '||V_CLIENTI.NOMINATIVO ||
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