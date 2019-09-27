CREATE OR REPLACE PACKAGE BODY GestClienti
AS

--CORPO DELLA PROCEDURA Sp_SelStorSpese   
PROCEDURE Sp_SelStorSpese(CODFID_I IN CARDS.CODFIDELITY%TYPE, 
        RECORDSET_P OUT SYS_REFCURSOR)
    IS
    BEGIN
        OPEN RECORDSET_P FOR
        
        SELECT
        A.DATA,
        A.IDDEPOSITO,
        A.CASSA,
        A.SCONTRINO,
        A.BOLLINI,
        B.CODFIDELITY,
        B.NOME || ' ' || B.COGNOME AS Nominativo
        FROM SCONTRINI A JOIN CLIENTI B
        ON a.CODFID = B.CODFIDELITY
        WHERE B.CODFIDELITY = CODFID_I
        ORDER BY A.DATA DESC;
        
    END Sp_SelStorSpese;

--CORPO DELLA FUNZIONE Uf_GetMonteBollini   
FUNCTION Uf_GetMonteBollini(CODFID_I IN CARDS.CODFIDELITY%TYPE)
    RETURN NUMBER
IS
        V_RetVal number;
BEGIN    
    SELECT BOLLINI INTO V_RetVal
    FROM CARDS WHERE CODFIDELITY = CODFID_I;
    
     RETURN V_RetVal;
    
EXCEPTION
    WHEN OTHERS
    THEN
        RETURN 0;    
END Uf_GetMonteBollini;


END GestClienti;