--Esempio di tipo Oggetto di base
CREATE OR REPLACE TYPE cliente_obj_type AS OBJECT
(Codice VARCHAR2(20),
 Nominativo VARCHAR2(100),
 Residenza VARCHAR(20),
 Bollini int,
 UltimaSpesa Date)