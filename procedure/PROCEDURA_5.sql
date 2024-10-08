CREATE OR REPLACE PROCEDURE Sp_GenCoupon 
(NumSpese_I IN NUMBER, Mese_I IN NUMBER)
AS
ValSpesa_FascA CONSTANT NUMBER := 800;
QtaCoup_FascA CONSTANT NUMBER := 5;
ValSpesa_FascB CONSTANT NUMBER := 500;
QtaCoup_FascB CONSTANT NUMBER := 3;
ValSpesa_FascC CONSTANT NUMBER := 200;
QtaCoup_FascC CONSTANT NUMBER := 1;

--Creazione Cursore: I migliori n clienti
CURSOR C_BestCli IS
    SELECT AA.* FROM
    (
    SELECT 
    CODFID,
    TOTVEND,
    QTASPESE,
    MESE
    FROM VW_SpeseCliFid
    WHERE CODFID <> '-1' AND
    MESE = Mese_I
    ) AA
    WHERE rownum <= NumSpese_I;

BEGIN
    DELETE FROM COUPONS WHERE MESE = Mese_I + 1;

    FOR R_BestCli IN C_BestCli
    LOOP
         IF R_BestCli.TOTVEND >= ValSpesa_FascA THEN
             INSERT INTO COUPONS
             VALUES(to_char(sysdate, 'YYYY'), R_BestCli.MESE + 1, R_BestCli.CODFID, QtaCoup_FascA);
         ELSIF R_BestCli.TOTVEND >= ValSpesa_FascB  AND R_BestCli.TOTVEND < ValSpesa_FascA THEN 
            INSERT INTO COUPONS
             VALUES(to_char(sysdate, 'YYYY'), R_BestCli.MESE + 1, R_BestCli.CODFID, QtaCoup_FascB);
         ELSIF R_BestCli.TOTVEND >= ValSpesa_FascC  AND R_BestCli.TOTVEND < ValSpesa_FascB THEN 
            INSERT INTO COUPONS
             VALUES(to_char(sysdate, 'YYYY'), R_BestCli.MESE + 1, R_BestCli.CODFID, QtaCoup_FascC);
        END IF;
    END LOOP;
    
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Creazione Coupon Eseguita con Successo');

    EXCEPTION
    WHEN NO_DATA_FOUND
    THEN
    DBMS_OUTPUT.PUT_LINE('Non � stato trovato alcun cliente con i criteri ricercati');
END Sp_GenCoupon;