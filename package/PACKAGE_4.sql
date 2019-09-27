--PACKAGE GestArt
CREATE OR REPLACE PACKAGE BODY GestArt
AS
    tSQL varchar2(300);
    
    --CORPO DELLA PROCEDURA IsArtPresent   
    PROCEDURE Sp_InsArticolo(CODART_I IN ARTICOLI.CODART%TYPE, 
        DESCRIZIONE_I IN ARTICOLI.DESCRIZIONE%TYPE, UM_I IN ARTICOLI.UM%TYPE,
        CODSTAT_I IN ARTICOLI.CODSTAT%TYPE, PZCART_I IN ARTICOLI.PZCART%TYPE,
        PESONETTO_I IN ARTICOLI.PESONETTO%TYPE, IDIVA_I IN ARTICOLI.IDIVA%TYPE,
        IDSTATO_I IN ARTICOLI.IDSTATOART%TYPE, IDFAMASS_I IN ARTICOLI.IDFAMASS%TYPE)
    IS
        V_IfExists BOOLEAN;
    BEGIN
    
    V_IfExists := IsArtPresent(CODART_I);
    
    IF V_IfExists = TRUE THEN
        UPDATE ARTICOLI
        SET 
        DESCRIZIONE = DESCRIZIONE_I,
        UM = UM_I,
        CODSTAT = CODSTAT_I,
        PZCART = PZCART_I,
        PESONETTO = PESONETTO_I,
        IDIVA = IDIVA_I,
        IDSTATOART = IDSTATO_I,
        IDFAMASS = IDFAMASS_I
        WHERE CODART = CODART_I;
    ELSE
        INSERT INTO ARTICOLI
        VALUES(CODART_I,DESCRIZIONE_I,UM_I,CODSTAT_I,PZCART_I,
        PESONETTO_I,IDIVA_I,IDSTATO_I,SYSDATE,IDFAMASS_I);
    END IF;
    
    END Sp_InsArticolo;
    
    --CORPO DELLA FUNZIONE Uf_GetQtaMag  
    FUNCTION Uf_GetQtaMag(CODART_I IN ARTICOLI.CODART%TYPE)
        RETURN NUMBER
    AS
        V_RetVal NUMBER;
    BEGIN
        SELECT (ACQUISTATO - RESO - VENDUTO - USCITE - SCADUTI) INTO V_RetVal
        FROM MOVIMENTI
        WHERE
        CODART = CODART_I;  
        
        RETURN V_RetVal;
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN 0;
            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR (-20001, 'Errore Calcolo Magazzino Articolo ' || CODART_I);
                RETURN 0;
                
    END Uf_GetQtaMag;
    
    --CORPO DELLA FUNZIONE Uf_GetVenMese   
    FUNCTION Uf_GetVenMese(CODART_I IN ARTICOLI.CODART%TYPE, MeseRif_I NUMBER, AnnoRif_I NUMBER)
        RETURN NUMBER
    AS
        V_RetVal NUMBER;
    BEGIN
        SELECT SUM(VALORE) INTO V_RetVal
        FROM VW_SCONTRINI
        WHERE
        CODART = CODART_I AND
        EXTRACT(MONTH FROM DATA) = MeseRif_I AND
        EXTRACT(YEAR FROM DATA) = AnnoRif_I; 
        
        RETURN V_RetVal;
        
        EXCEPTION
            WHEN OTHERS THEN
        RETURN 0;  
        
    END Uf_GetVenMese;
    
    --CORPO DELLA FUNZIONE IsArtPresent   
    FUNCTION IsArtPresent(CODART_I IN ARTICOLI.CODART%TYPE)
        RETURN BOOLEAN
    IS
        V_Count_Art number;
    BEGIN    
    SELECT COUNT(*) INTO V_Count_Art
    FROM ARTICOLI WHERE CODART = CODART_I;
    
    IF (V_Count_Art > 0) THEN
        RETURN TRUE;
    ELSE 
        RETURN FALSE;
    END IF;
    
    EXCEPTION
    WHEN OTHERS
    THEN
        RETURN FALSE;    
    END IsArtPresent;
    
    --CORPO DELLA PROCEDURA Sp_SelArticolo
    PROCEDURE Sp_SelArticolo(CODART_I IN ARTICOLI.CODART%TYPE, 
        ARTICOLO_O OUT Info_Articolo)
    IS
    BEGIN
    
        OPEN ARTICOLO_O FOR
            SELECT
            A.CODART,
            A.DESCRIZIONE,
            A.UM,
            A.PZCART,
            A.CODSTAT,
            A.PESONETTO,
            A.IDIVA AS IVA,
            A.IDSTATOART AS STATO,
            A.IDFAMASS,
            TRIM(B.DESCRIZIONE) AS REPARTO,
            Uf_GetQtaMag(A.CODART) AS QtaMag
            FROM ARTICOLI A JOIN FAMASSORT B
            ON A.IDFAMASS = B.ID
            WHERE CODART = CODART_I;
            
    END Sp_SelArticolo;
    
    --CORPO DELLA PROCEDURA Sp_SelArticolo 
    PROCEDURE Sp_SelArticolo(Parametro IN ARTICOLI.DESCRIZIONE%TYPE, Tipo IN NUMBER,
         RECORDSET_P OUT SYS_REFCURSOR)
    IS
   
    BEGIN
    
    tSQL := 'SELECT
            CODART,
            DESCRIZIONE,
            UM,
            PZCART,
            CODSTAT,
            PESONETTO,
            IDIVA AS IVA,
            IDSTATOART AS STATO,
            IDFAMASS
            FROM ARTICOLI ';
        
    IF Tipo = 1 THEN --CASO CODART
         OPEN RECORDSET_P FOR
         tSQL || ' WHERE CODART = :1'
         USING PARAMETRO;
    ELSIF TIPO = 2 THEN --CASO DESCRIZIONE
         OPEN RECORDSET_P FOR
         tSQL || ' WHERE DESCRIZIONE LIKE :1'
         USING PARAMETRO;
    ELSIF TIPO = 3 THEN --CASE BARCODE
         OPEN RECORDSET_P FOR
         tSQL || ' CODART IN (SELECT CODART FROM BARCODE WHERE BARCODE = :1)'
         USING PARAMETRO;
    END IF;
    
    END Sp_SelArticolo;
    
    --CORPO DELLA PROCEDURA Sp_DelArticolo
    PROCEDURE Sp_DelArticolo(CODART_I IN ARTICOLI.CODART%TYPE)
    AS
    BEGIN
        IF IsArtPresent(CODART_I) THEN
            DELETE FROM ARTICOLI WHERE CODART = CODART_I;
        END IF;
    END;
    
END GestArt;