--Creazione Procedura PremioBollini
CREATE OR REPLACE PROCEDURE Sp_GenPremioBollini(Anno_I IN NUMBER, Mese_I IN NUMBER)
AS
    --Creazione del cursore
    CURSOR C_BestCli(V_MeseRif NUMBER, V_AnnoRif NUMBER)
    IS
    SELECT DISTINCT CODFID
    FROM SCONTRINI
    WHERE CODFID <> '-1'
    AND EXTRACT(YEAR FROM DATA) = V_AnnoRif
    AND EXTRACT(MONTH FROM DATA) = V_MeseRif
    GROUP BY CODFID
    HAVING SUM(TOTALE) >= 500;
    
BEGIN

    FOR R_BestCli IN C_BestCli(Mese_I,Anno_I)
    LOOP
        UPDATE CARDS_TEMP
        SET BOLLINI = BOLLINI + 500
        WHERE CODFIDELITY = R_BestCli.CODFID;
        
        DBMS_OUTPUT.PUT_LINE ('Aggiunti 500 Punti alla Fidelity: ' ||  R_BestCli.CODFID || '.');
        
    END LOOP;
    
    commit;
    
END;
    
