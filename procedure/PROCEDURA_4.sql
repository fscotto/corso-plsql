
 CREATE OR REPLACE PROCEDURE Sp_SelCliente(CODFID_I IN CLIENTI.CODFIDELITY%TYPE, 
         RECORDSET_P OUT SYS_REFCURSOR)
    IS
    BEGIN

        OPEN RECORDSET_P FOR
            SELECT
            A.CODFIDELITY,
            A.NOME,
            A.COGNOME,
            A.COMUNE,
            A.PROV,
            A.STATO
            FROM CLIENTI A 
            WHERE A.CODFIDELITY = CODFID_I;

END Sp_SelCliente;
