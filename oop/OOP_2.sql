--Esempio di tipo Oggetto con costruttore e metodo
CREATE OR REPLACE TYPE cliente_obj_type_V2 AS OBJECT
(
Codice VARCHAR2(20),
Nominativo VARCHAR2(100),
 Residenza VARCHAR(20),
 Bollini int,
 UltimaSpesa Date,

CONSTRUCTOR FUNCTION cliente_obj_type_V2(CodFid VARCHAR2)
RETURN SELF AS RESULT,

MEMBER PROCEDURE getInfo(SELF IN OUT NOCOPY cliente_obj_type_V2)

)
INSTANTIABLE NOT FINAL;

--Corpo del tipo oggetto
CREATE OR REPLACE TYPE BODY cliente_obj_type_V2 IS

    -- costruttore
    CONSTRUCTOR FUNCTION cliente_obj_type_V2 (CodFid VARCHAR2)
    RETURN SELF AS RESULT IS
    BEGIN
        self.Codice := CodFid; 
        RETURN;
    END cliente_obj_type_V2;
    
     -- primo metodo
    MEMBER PROCEDURE getInfo(SELF IN OUT NOCOPY cliente_obj_type_V2) IS
    BEGIN
    
        SELECT  A.NOME || ' ' || A.COGNOME, A.COMUNE, B.Bollini, B.UltimaSpesa
        INTO SELF.Nominativo, SELF.Residenza, SELF.Bollini, SELF.UltimaSpesa
        FROM CLIENTI A
        JOIN CARDS B
        ON A.CODFIDELITY = b.codfidelity
        WHERE  A.CODFIDELITY = SELF.Codice;
        
        DBMS_OUTPUT.PUT_LINE ('Codice:' || SELF.Codice);
        DBMS_OUTPUT.PUT_LINE ('Nominativo:' || SELF.Nominativo);
        DBMS_OUTPUT.PUT_LINE ('Bollini:'|| SELF.Bollini);
        DBMS_OUTPUT.PUT_LINE ('Ultima Spesa:'|| SELF.UltimaSpesa);
               
        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        RETURN;
    END getInfo;
    
END;
    
    