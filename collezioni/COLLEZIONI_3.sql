--Esempio di varray
DECLARE
  CURSOR c_clienti
  IS
    SELECT
      AA.*
    FROM
      (
        SELECT
          A.NOME
          || ' '
          || A.COGNOME AS Nominativo
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
      rownum <= 10;

    --CREAZIONE NUOVA VARRAY
  TYPE nominativo_type IS VARRAY(11) OF VARCHAR2(100);
  nominativo_tab nominativo_type := nominativo_type();

  v_index PLS_INTEGER            := 0;

BEGIN
  FOR r_clienti IN c_clienti
  LOOP
    v_index := v_index + 1;

    nominativo_tab.EXTEND;
    nominativo_tab(v_index) := r_clienti.Nominativo;

    DBMS_OUTPUT.PUT_LINE ('RECORD(' || v_index || '): ' || ' ' || nominativo_tab(v_index));

  END LOOP;


  nominativo_tab.EXTEND;
  nominativo_tab(11) := 'NICOLA LA ROCCA';

  IF NOMINATIVO_TAB.EXISTS(11) THEN
    DBMS_OUTPUT.PUT_LINE ('RECORD(' || 11 || '): ' || nominativo_tab(11));
  END IF;

  /*
  nominativo_tab.EXTEND;
  IF NOMINATIVO_TAB.EXISTS(12) THEN
  DBMS_OUTPUT.PUT_LINE ('RECORD(' || 12 || '):' || nominativo_tab(12));
  END IF;
  DBMS_OUTPUT.PUT_LINE ('Numero Totale Record: ' || NOMINATIVO_TAB.COUNT);
  nominativo_tab.DELETE(12);
  DBMS_OUTPUT.PUT_LINE ('Numero Totale Record: ' || NOMINATIVO_TAB.COUNT);
  DBMS_OUTPUT.PUT_LINE ('Primo Record: ' || NOMINATIVO_TAB.FIRST);
  DBMS_OUTPUT.PUT_LINE ('Ultimo Record: ' || NOMINATIVO_TAB.LAST);
  NOMINATIVO_TAB.TRIM(3);
  FOR i IN 1..NOMINATIVO_TAB.LAST
  LOOP
  DBMS_OUTPUT.PUT_LINE ('RECORD(' || i || '): ' || ' ' || nominativo_tab(i));
  END LOOP;
  */


END;