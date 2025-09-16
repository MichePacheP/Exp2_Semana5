-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2025-09-15 20:57:58 CLST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



DROP TABLE AFP CASCADE CONSTRAINTS 
;

DROP TABLE COMUNA CASCADE CONSTRAINTS 
;

DROP TABLE ESPECIALIDAD CASCADE CONSTRAINTS 
;

DROP TABLE EXAMEN_LAB CASCADE CONSTRAINTS 
;

DROP TABLE FICHA_MEDICA CASCADE CONSTRAINTS 
;

DROP TABLE INSTITUCION_SALUD CASCADE CONSTRAINTS 
;

DROP TABLE MEDICO CASCADE CONSTRAINTS 
;

DROP TABLE PACIENTE CASCADE CONSTRAINTS 
;

DROP TABLE PAGO CASCADE CONSTRAINTS 
;

DROP TABLE REGION CASCADE CONSTRAINTS 
;

DROP TABLE SERVICIO CASCADE CONSTRAINTS 
;

-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE
CREATE TABLE AFP 
    ( 
     id_afp NUMBER NOT NULL, 
     nombre VARCHAR2(50) NOT NULL
    );

ALTER TABLE AFP 
    ADD CONSTRAINT AFP_PK PRIMARY KEY (id_afp);

ALTER TABLE AFP 
    ADD CONSTRAINT UK_AFP_NOMBRE UNIQUE (nombre);

CREATE TABLE REGION 
    ( 
     id_region NUMBER NOT NULL, 
     nombre    VARCHAR2(50) NOT NULL
    );

ALTER TABLE REGION 
    ADD CONSTRAINT REGION_PK PRIMARY KEY (id_region);

ALTER TABLE REGION 
    ADD CONSTRAINT UK_REGION_NOMBRE UNIQUE (nombre);

CREATE TABLE COMUNA 
    ( 
     id_comuna        NUMBER NOT NULL, 
     nombre           VARCHAR2(50) NOT NULL, 
     REGION_id_region NUMBER NOT NULL
    );

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_PK PRIMARY KEY (id_comuna);

ALTER TABLE COMUNA 
    ADD CONSTRAINT UK_COMUNA_NOMBRE UNIQUE (nombre);

CREATE TABLE ESPECIALIDAD 
    ( 
     id_especialidad NUMBER NOT NULL, 
     nombre          VARCHAR2(50) NOT NULL
    );

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT ESPECIALIDAD_PK PRIMARY KEY (id_especialidad);

ALTER TABLE ESPECIALIDAD 
    ADD CONSTRAINT UK_ESPECIALIDAD_NOMBRE UNIQUE (nombre);

CREATE TABLE SERVICIO 
    ( 
     id_servicio NUMBER NOT NULL, 
     nombre      VARCHAR2(20) NOT NULL
    );

ALTER TABLE SERVICIO 
    ADD CONSTRAINT SERVICIO_PK PRIMARY KEY (id_servicio);

ALTER TABLE SERVICIO 
    ADD CONSTRAINT UK_SERVICIO_NOMBRE UNIQUE (nombre);

CREATE TABLE PAGO 
    ( 
     id_pago      NUMBER NOT NULL, 
     tipo_pago    VARCHAR2(20) NOT NULL, 
     monto_pagado NUMBER NOT NULL
    );

ALTER TABLE PAGO 
    ADD CONSTRAINT CK_PAGO CHECK (MONTO_PAGADO > 0);

ALTER TABLE PAGO 
    ADD CONSTRAINT PAGO_PK PRIMARY KEY (id_pago);

CREATE TABLE INSTITUCION_SALUD 
    ( 
     id_institucion NUMBER NOT NULL, 
     nombre         VARCHAR2(50) NOT NULL
    );

ALTER TABLE INSTITUCION_SALUD 
    ADD CONSTRAINT INSTITUCION_SALUD_PK PRIMARY KEY (id_institucion);

ALTER TABLE INSTITUCION_SALUD 
    ADD CONSTRAINT UK_INSTITUCION_SALUD_NOMBRE UNIQUE (nombre);

CREATE TABLE MEDICO 
    ( 
     id_medico            NUMBER NOT NULL, 
     nombre_completo      VARCHAR2(100) NOT NULL, 
     rut                  NUMBER NOT NULL, 
     digito_verificador   VARCHAR2(1) NOT NULL, 
     fecha_ingreso        DATE NOT NULL, 
     AFP_id_afp           NUMBER, 
     INSTSALUD_id_inst    NUMBER, 
     ESPECIALIDAD_id_especialidad NUMBER NOT NULL, 
     MEDICO_id_medico     NUMBER
    );

ALTER TABLE MEDICO 
    ADD CONSTRAINT CK_MEDICO_FECHA_INGRESO CHECK (FECHA_INGRESO < SYSDATE);

ALTER TABLE MEDICO 
    ADD CONSTRAINT Arc_2 CHECK (
        ( (INSTSALUD_id_inst IS NOT NULL) AND (AFP_id_afp IS NULL) ) OR
        ( (AFP_id_afp IS NOT NULL) AND (INSTSALUD_id_inst IS NULL) )
    );

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_PK PRIMARY KEY (id_medico);

ALTER TABLE MEDICO 
    ADD CONSTRAINT UK_MEDICO_NOMBRE_COMPLETO UNIQUE (nombre_completo);

ALTER TABLE MEDICO 
    ADD CONSTRAINT UK_MEDICO_RUT UNIQUE (rut);

CREATE TABLE PACIENTE 
    ( 
     id_paciente           NUMBER NOT NULL, 
     nombre_completo       VARCHAR2(100) NOT NULL, 
     rut                   NUMBER NOT NULL, 
     digito_verificador    VARCHAR2(1) NOT NULL, 
     fecha_nacimiento      DATE NOT NULL, 
     tipo_usuario          VARCHAR2(50) NOT NULL, 
     direccion             VARCHAR2(100) NOT NULL, 
     fecha_consulta_pasada DATE, 
     correo                VARCHAR2(100) NOT NULL, 
     telefono              NUMBER(15), 
     COMUNA_id_comuna      NUMBER NOT NULL
    );

ALTER TABLE PACIENTE 
    ADD CONSTRAINT CK_PACIENTE_DIGITO_VERIFICADOR
    CHECK (digito_verificador IN ('0','1','2','3','4','5','6','7','8','9','K'));

ALTER TABLE PACIENTE 
    ADD CONSTRAINT CK_PACIENTE_FECHA_NACIMIENTO 
    CHECK (FECHA_NACIMIENTO < SYSDATE);

ALTER TABLE PACIENTE 
    ADD CONSTRAINT CK_PAC_FECHA_CONS_PASADA
    CHECK (FECHA_CONSULTA_PASADA < SYSDATE);

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_PK PRIMARY KEY (id_paciente);

ALTER TABLE PACIENTE 
    ADD CONSTRAINT UK_PACIENTE_NOMBRE_COMPLETO UNIQUE (nombre_completo);

ALTER TABLE PACIENTE 
    ADD CONSTRAINT UK_PACIENTE_RUT UNIQUE (rut);

CREATE TABLE FICHA_MEDICA 
    ( 
     id_ficha             NUMBER NOT NULL, 
     modo                 VARCHAR2(50) NOT NULL, 
     tipo                 VARCHAR2(50) NOT NULL, 
     fecha                DATE NOT NULL, 
     hora                 VARCHAR2(5) NOT NULL, 
     diagnostico          VARCHAR2(100) NOT NULL, 
     SERVICIO_id_servicio NUMBER NOT NULL, 
     PACIENTE_id_paciente NUMBER, 
     MEDICO_id_medico     NUMBER, 
     PAGO_id_pago         NUMBER
    );

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT CK_FICHA_MEDICA_FECHA CHECK (FECHA < SYSDATE);

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT Arc_1 CHECK (
        ( (PACIENTE_id_paciente IS NOT NULL) AND (MEDICO_id_medico IS NULL) AND (PAGO_id_pago IS NULL) ) OR
        ( (MEDICO_id_medico IS NOT NULL) AND (PACIENTE_id_paciente IS NULL) AND (PAGO_id_pago IS NULL) ) OR
        ( (PAGO_id_pago IS NOT NULL) AND (PACIENTE_id_paciente IS NULL) AND (MEDICO_id_medico IS NULL) )
    );

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT FICHA_MEDICA_PK PRIMARY KEY (id_ficha);

CREATE TABLE EXAMEN_LAB 
    ( 
     id_examen             NUMBER NOT NULL, 
     nombre                VARCHAR2(50) NOT NULL, 
     tipo_muestra          VARCHAR2(50) NOT NULL, 
     condicion_previa      VARCHAR2(100) NOT NULL, 
     FICHA_MEDICA_id_ficha NUMBER NOT NULL
    );

ALTER TABLE EXAMEN_LAB 
    ADD CONSTRAINT EXAMEN_LAB_PK PRIMARY KEY (id_examen);

ALTER TABLE EXAMEN_LAB 
    ADD CONSTRAINT UK_EXAMEN_LAB_NOMBRE UNIQUE (nombre);

ALTER TABLE COMUNA 
    ADD CONSTRAINT COMUNA_REGION_FK FOREIGN KEY (REGION_id_region)
    REFERENCES REGION (id_region);

ALTER TABLE EXAMEN_LAB 
    ADD CONSTRAINT EXAMEN_LAB_FICHA_MEDICA_FK FOREIGN KEY (FICHA_MEDICA_id_ficha)
    REFERENCES FICHA_MEDICA (id_ficha);

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT FICHA_MEDICA_MEDICO_FK FOREIGN KEY (MEDICO_id_medico)
    REFERENCES MEDICO (id_medico);

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT FICHA_MEDICA_PACIENTE_FK FOREIGN KEY (PACIENTE_id_paciente)
    REFERENCES PACIENTE (id_paciente);

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT FICHA_MEDICA_PAGO_FK FOREIGN KEY (PAGO_id_pago)
    REFERENCES PAGO (id_pago);

ALTER TABLE FICHA_MEDICA 
    ADD CONSTRAINT FICHA_MEDICA_SERVICIO_FK FOREIGN KEY (SERVICIO_id_servicio)
    REFERENCES SERVICIO (id_servicio);

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_AFP_FK FOREIGN KEY (AFP_id_afp)
    REFERENCES AFP (id_afp);

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_ESPECIALIDAD_FK FOREIGN KEY (ESPECIALIDAD_id_especialidad)
    REFERENCES ESPECIALIDAD (id_especialidad);

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_INSTITUCION_SALUD_FK FOREIGN KEY (INSTSALUD_id_inst)
    REFERENCES INSTITUCION_SALUD (id_institucion);

ALTER TABLE MEDICO 
    ADD CONSTRAINT MEDICO_MEDICO_FK FOREIGN KEY (MEDICO_id_medico)
    REFERENCES MEDICO (id_medico);

ALTER TABLE PACIENTE 
    ADD CONSTRAINT PACIENTE_COMUNA_FK FOREIGN KEY (COMUNA_id_comuna)
    REFERENCES COMUNA (id_comuna);

-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             41
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
