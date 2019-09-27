--Esempio Creazione Package Articolato

CREATE OR REPLACE PACKAGE GestArt
AS

    TYPE articoli_type IS RECORD
    (CodArt ARTICOLI.CODART%TYPE,
    Descrizione ARTICOLI.DESCRIZIONE%TYPE,
    Um ARTICOLI.UM%TYPE,
    PzCart  ARTICOLI.PZCART%TYPE,
    CodStat ARTICOLI.CODSTAT%TYPE,
    PesoNetto  ARTICOLI.PESONETTO%TYPE,
    Iva  ARTICOLI.IDIVA%TYPE,
    Stato  ARTICOLI.IDSTATOART%TYPE,
    IdFamAss ARTICOLI.IDFAMASS%TYPE,
    Reparto FAMASSORT.DESCRIZIONE%TYPE,
    QtaMag NUMBER
    );
    
    TYPE Info_Articolo IS REF CURSOR RETURN articoli_type;
     
    PROCEDURE Sp_SelArticolo(CODART_I IN ARTICOLI.CODART%TYPE, 
        ARTICOLO_O OUT Info_Articolo);
        
    PROCEDURE Sp_SelArticolo(Parametro IN ARTICOLI.DESCRIZIONE%TYPE, Tipo IN NUMBER,
        RECORDSET_P OUT SYS_REFCURSOR);
        
    PROCEDURE Sp_DelArticolo(CODART_I IN ARTICOLI.CODART%TYPE);
        
    PROCEDURE Sp_InsArticolo(CODART_I IN ARTICOLI.CODART%TYPE, 
        DESCRIZIONE_I IN ARTICOLI.DESCRIZIONE%TYPE, UM_I IN ARTICOLI.UM%TYPE,
        CODSTAT_I IN ARTICOLI.CODSTAT%TYPE, PZCART_I IN ARTICOLI.PZCART%TYPE,
        PESONETTO_I IN ARTICOLI.PESONETTO%TYPE, IDIVA_I IN ARTICOLI.IDIVA%TYPE,
        IDSTATO_I IN ARTICOLI.IDSTATOART%TYPE, IDFAMASS_I IN ARTICOLI.IDFAMASS%TYPE);
        
    FUNCTION Uf_GetQtaMag(CODART_I IN ARTICOLI.CODART%TYPE)
        RETURN NUMBER;
    
    FUNCTION IsArtPresent(CODART_I IN ARTICOLI.CODART%TYPE)
        RETURN BOOLEAN;
        
    FUNCTION Uf_GetVenMese(CODART_I IN ARTICOLI.CODART%TYPE, MeseRif_I NUMBER, AnnoRif_I NUMBER)
        RETURN NUMBER;
        
END GestArt;