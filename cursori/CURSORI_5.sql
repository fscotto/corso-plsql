--Esempio Cursore FOR LOOPS

DECLARE
  --Dichiarazione del cursore
  CURSOR C_CLIENTI
  IS
    SELECT
      CODFIDELITY,
      NOME,
      COGNOME
    FROM
      CLIENTI
    WHERE
      CODFIDELITY IN
      (
        SELECT DISTINCT
          CODFID
        FROM
          SCONTRINI
        WHERE
          CODFID <> - 1
        GROUP BY
          CODFID
        HAVING
          SUM(TOTALE) > 300
      );

BEGIN

  DELETE
  FROM
    TOP_CLI
  WHERE
    MESE = EXTRACT(MONTH FROM SYSDATE);

  FOR R_CLIENTI IN C_CLIENTI -- Fetch del cursore
  LOOP
    DBMS_OUTPUT.PUT_LINE ('Inserimento ' || R_CLIENTI.CODFIDELITY);

    INSERT
    INTO
      TOP_CLI
      (
        CODFID,
        MESE,
        NOME,
        COGNOME
      )
      VALUES
      (
        R_CLIENTI.CODFIDELITY,
        EXTRACT(MONTH FROM SYSDATE),
        R_CLIENTI.NOME,
        R_CLIENTI.COGNOME
      );

  END LOOP;

END;
