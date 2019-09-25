--Esempio di Index-by table
DECLARE
  CURSOR C_CLIENTI
  IS
    SELECT
      AA.*
    FROM
      (
        SELECT
          A.NOME
          || ' '
          || A.COGNOME AS NOMINATIVO
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
        B.NUMSPESE  > 0
      AND B.CODFID <> - 1
      ORDER BY
        B.VALTOT DESC
      )
      AA
    WHERE
      ROWNUM <= 10;

    --CREAZIONE NUOVA INDEX-BY TABLE
  TYPE NOMINATIVO_TYPE
IS
  TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;

  NOMINATIVO_TAB NOMINATIVO_TYPE;
  V_INDEX PLS_INTEGER := 0;

BEGIN

  FOR R_CLIENTI IN C_CLIENTI
  LOOP
    V_INDEX                 := V_INDEX + 1;

    NOMINATIVO_TAB(V_INDEX) := R_CLIENTI.NOMINATIVO;

    DBMS_OUTPUT.PUT_LINE ('RECORD(' || V_INDEX || '): ' || ' ' || NOMINATIVO_TAB(V_INDEX));
  END LOOP;

  DBMS_OUTPUT.PUT_LINE ('record(' || 11 || '):' || NOMINATIVO_TAB(11));
END;