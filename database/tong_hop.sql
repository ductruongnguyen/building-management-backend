DROP DATABASE IF EXISTS QLTOANHA;
CREATE DATABASE IF NOT EXISTS QLTOANHA;
USE QLTOANHA;

CREATE TABLE NHAN_VIEN_TOA(
    MA_NV VARCHAR(50) NOT NULL,
    TEN VARCHAR(50) NOT NULL,
    NS DATE,
    DIA_CHI VARCHAR(100),
    SDT VARCHAR(50),
    PRIMARY KEY (MA_NV)
);

CREATE TABLE CONG_TY(
    MA_CT VARCHAR(50) NOT NULL,
    TEN_CT VARCHAR(50) NOT NULL,
    MST VARCHAR(50) NOT NULL UNIQUE,
    LINH_VUC VARCHAR(50),
    DIA_CHI VARCHAR(50),
    SDT VARCHAR(10),
    SO_NV INT,
    DIEN_TICH FLOAT,
    PRIMARY KEY (MA_CT)
);

CREATE TABLE NHAN_VIEN_CT(
    MA_NV VARCHAR(50) NOT NULL,
    MA_CT VARCHAR(50) NOT NULL,
    TEN VARCHAR(50) NOT NULL,
    NGAY_SINH DATE,
    CMT VARCHAR(100) UNIQUE,
    SDT VARCHAR(10),
    PRIMARY KEY (MA_NV),
    FOREIGN KEY (MA_CT) REFERENCES CONG_TY(MA_CT)
);

CREATE TABLE DICH_VU(
    MA_DV VARCHAR(50) NOT NULL,
    TEN_DV VARCHAR(50) NOT NULL,
    LOAI_DV VARCHAR(50),
    DON_GIA_CS FLOAT,
    PRIMARY KEY (MA_DV)
);

CREATE TABLE SU_DUNG(
    MA_DK INT NOT NULL AUTO_INCREMENT,
    MA_CT VARCHAR(50) NOT NULL,
    MA_DV VARCHAR(50) NOT NULL,
    NGAY_BD DATE,
    NGAY_KT DATE,
    PRIMARY KEY (MA_DK),
    FOREIGN KEY (MA_CT) REFERENCES CONG_TY(MA_CT),
    FOREIGN KEY (MA_DV) REFERENCES DICH_VU(MA_DV)
);

CREATE TABLE THE_RA_VAO(
    MA_THE VARCHAR(50) NOT NULL,
    MA_NV VARCHAR(50) NOT NULL,
    PRIMARY KEY (MA_THE),
    FOREIGN KEY (MA_NV) REFERENCES NHAN_VIEN_CT(MA_NV)
);

CREATE TABLE LAM_VIEC(
    MA_LV INT NOT NULL AUTO_INCREMENT,
    MA_DV VARCHAR(50) NOT NULL,
    MA_NV VARCHAR(50) NOT NULL,
    VI_TRI VARCHAR(50) NOT NULL,
    RATE_LUONG FLOAT NOT NULL,
    NGAY_BD DATE NOT NULL,
    NGAY_KT DATE NOT NULL,
    PRIMARY KEY (MA_LV),
    FOREIGN KEY (MA_DV) REFERENCES DICH_VU(MA_DV),
    FOREIGN KEY (MA_NV) REFERENCES NHAN_VIEN_TOA(MA_NV)
);

CREATE TABLE RA_VAO(
    MA_RV INT NOT NULL AUTO_INCREMENT,
    MA_THE VARCHAR(50) NOT NULL,
    VI_TRI VARCHAR(50) NOT NULL,
    TRANG_THAI VARCHAR(20) NOT NULL,
    CHECK_TIME DATETIME,
    PRIMARY KEY (MA_RV),
    FOREIGN KEY (MA_THE) REFERENCES THE_RA_VAO(MA_THE)
);

#1 TU DONG THEM 2 DICH VU MAC DINH KHI INSERT VAO CONG TY
DELIMITER //
CREATE TRIGGER DV_DEFAULT AFTER INSERT ON CONG_TY FOR EACH ROW
    BEGIN
        #KHAI BAO GIA CS
        DECLARE GIA_CS_1 FLOAT;
        DECLARE GIA_CS_2 FLOAT;

        DECLARE START_DATE DATE;
        DECLARE END_DATE DATE;
        SET START_DATE = CURRENT_DATE;
        SET END_DATE = DATE_ADD(START_DATE, INTERVAL 1 YEAR);

        #TU DONG THEM DICH VU BAO VE VA VE SINH LA DINH VU MAC DINH
        SELECT DON_GIA_CS INTO GIA_CS_1 FROM DICH_VU WHERE TEN_DV = 'VE SINH';
        SELECT DON_GIA_CS INTO GIA_CS_2 FROM DICH_VU WHERE TEN_DV = 'BAO VE';
        #INSERT VAO BANG SU_DUNG
        INSERT INTO SU_DUNG(MA_CT, MA_DV, NGAY_BD, NGAY_KT) VALUES (NEW.MA_CT, 'DV01', START_DATE, END_DATE);
        INSERT INTO SU_DUNG(MA_CT, MA_DV, NGAY_BD, NGAY_KT) VALUES (NEW.MA_CT, 'DV02', START_DATE, END_DATE);
    END
//

# DROP TRIGGER DV_DEFAULT;

#2 TU DONG UPDATE SO NHAN VIEN
DELIMITER //
CREATE TRIGGER ADD_SLNV AFTER INSERT ON NHAN_VIEN_CT FOR EACH ROW
    BEGIN
        UPDATE CONG_TY SET SO_NV = SO_NV + 1 WHERE CONG_TY.MA_CT = NEW.MA_CT;
    END
//

# DROP TRIGGER ADD_SLNV;

DELIMITER //
CREATE TRIGGER SUBTRACT_SLNV AFTER DELETE ON NHAN_VIEN_CT FOR EACH ROW
    BEGIN
        UPDATE CONG_TY SET SO_NV = SO_NV - 1 WHERE CONG_TY.MA_CT = OLD.MA_CT;
    END
//

# DROP TRIGGER SUBTRACT_SLNV;

DELIMITER //
CREATE TRIGGER UPDATE_SLNV AFTER UPDATE ON NHAN_VIEN_CT FOR EACH ROW
    BEGIN
        DECLARE SO_NV_CU INT;
        DECLARE SO_NV_MOI INT;
        SET SO_NV_CU = 0;
        SET SO_NV_MOI = 0;

        SELECT COUNT(*) INTO SO_NV_CU FROM NHAN_VIEN_CT WHERE MA_CT = OLD.MA_CT;
        SELECT COUNT(*) INTO SO_NV_MOI FROM NHAN_VIEN_CT WHERE MA_CT = NEW.MA_CT;

        UPDATE CONG_TY SET SO_NV = SO_NV_CU WHERE CONG_TY.MA_CT = OLD.MA_CT;
        UPDATE CONG_TY SET SO_NV = SO_NV_MOI WHERE CONG_TY.MA_CT = NEW.MA_CT;
    END
//

# DROP TRIGGER UPDATE_SLNV;

#VIEW_1: HOA DON CONG TY
CREATE VIEW HOA_DON_CTY
AS
SELECT SD.MA_DK, SD.MA_CT, CT.TEN_CT, DV.TEN_DV, SD.NGAY_BD, SD.NGAY_KT, DV.DON_GIA_CS, (CT.DIEN_TICH*300000) AS MAT_BANG,
CASE
    WHEN CT.SO_NV > 10 AND CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5) + FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
    WHEN CT.SO_NV > 10 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5))*0.05)
    WHEN CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
    ELSE DV.DON_GIA_CS
END AS THUC_TRA
FROM CONG_TY AS CT, dich_vu AS DV, SU_DUNG AS SD
WHERE CT.MA_CT = SD.MA_CT
AND DV.MA_DV = SD.MA_DV
;

#################VIEW_2 : THONG TIN LUONG NHAN VIEN TOA NHA
SELECT DISTINCT LV.MA_NV , LV.MA_DV,(LV.NGAY_KT - LV.NGAY_BD) AS SO_NGAY, ((LV.NGAY_KT - LV.NGAY_BD)*LV.RATE_LUONG) AS LUONG, (HD.THUC_TRA/HD.DON_GIA_CS) AS PT
#     CASE
#     WHEN CT.SO_NV > 10 AND CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5) + FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
#     ELSE DV.DON_GIA_CS
# END AS THUC_TRA
FROM LAM_VIEC AS LV, HOA_DON_CTY AS HD, NHAN_VIEN_TOA AS NV, DICH_VU AS DV
WHERE  LV.MA_NV = NV.MA_NV AND DV.MA_DV = LV.MA_DV AND LV.MA_DV = HD.MA_DV
;

SELECT * FROM LAM_VIEC;
SELECT * FROM NHAN_VIEN_TOA;
SELECT * FROM HOA_DON_CTY;
SELECT * FROM DICH_VU;
SELECT * FROM SU_DUNG;
SELECT * FROM CONG_TY;



#####################SELECT hoa don theo ngay chon tren client
SELECT SD.MA_DK, SD.MA_CT, CT.TEN_CT, DV.TEN_DV,IF(SD.NGAY_BD < SD.NGAY_BD,0,SD.NGAY_BD) AS NGAY_BD, SD.NGAY_KT, DV.DON_GIA_CS, (CT.DIEN_TICH*300000) AS MAT_BANG,
CASE
    WHEN CT.SO_NV > 10 AND CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5) + FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
    WHEN CT.SO_NV > 10 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5))*0.05)
    WHEN CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
    ELSE DV.DON_GIA_CS
END AS THUC_TRA
FROM CONG_TY AS CT, dich_vu AS DV, SU_DUNG AS SD
WHERE CT.MA_CT = SD.MA_CT
AND DV.MA_DV = SD.MA_DV;


#VIEW_3: Tra ve ra vao cho client
SELECT RV.MA_RV,RV.MA_THE, NV.MA_NV, NV.TEN, RV.VI_TRI, RV.TRANG_THAI, RV.CHECK_TIME, COUNT(RV.MA_RV) AS TONG
FROM RA_VAO AS RV, THE_RA_VAO AS TR, NHAN_VIEN_CT AS NV
WHERE RV.MA_THE = TR.MA_THE AND TR.MA_NV = NV.MA_NV
GROUP BY RV.MA_THE,RV.VI_TRI,RV.TRANG_THAI
;

#THEM DATA DICH VU
INSERT INTO DICH_VU
VALUES
('DV01', 'VE SINH', 'CHUAN', '1000000'),
('DV02', 'BAO VE' , 'CHUAN' , '1000000'),
('DV03', 'AN UONG', 'EXTRA', '4000000'),
('DV04', 'TRONG XE', 'EXTRA', '1000000'),
('DV05', 'BAO TRI THIET BI', 'EXTRA', '1000000')
;

#THEM CONG TY
INSERT INTO CONG_TY
VALUES
('CT01', 'MULTICAMPUS', '0122112', 'CONG NGHE', 'P201', '0123456789', 15, 120),
('CT02', 'NIPA', '0122113', 'CHINH PHU', 'P301', '0123556789', 9, 111),
('CT03', 'SAMSUNGSDS', '01452113', 'GIAO DUC', 'P402', '0123576782', 10, 100)
;

#THEM NHAN VIEN CONG TY
INSERT INTO NHAN_VIEN_CT
VALUES
('E0001','CT01', 'DINH BAC', '1997-10-10', '00111888', '038777621'),
('E0002','CT01', 'DINH TU', '1992-10-10', '00121888', '038767621'),
('E0003','CT01', 'DINH BINH', '1999-10-10', '00131888', '038757621')
;

#THEM NHAN VIEN TOA NHA
INSERT INTO nhan_vien_toa
VALUES
('T001', 'HOAI LAM', '1999-09-04', '36 HOANG CAU, HA NOI', '0948776512'),
('T002', 'VAN NAM', '1998-09-04', '21 HOANG CAU, HA NOI', '0948776522'),
('T003', 'DUC PHUC', '2001-09-04', '24 HOANG CAU, HA NOI', '0948776542'),
('T004', 'HOAI LAM', '1997-09-04', '34 HOANG CAU, HA NOI', '0948776572'),
('T005', 'HOAI LAM', '1994-09-04', '16 HOANG CAU, HA NOI', '0948776592')
;

#THEM MA LAM VIEC
INSERT INTO lam_viec(ma_dv, ma_nv, vi_tri, rate_luong, ngay_bd, ngay_kt)
VALUES ('DV01', 'T001', 'NHAN VIEN', '200000', '2020-7-3', '2020-7-15'),
       ('DV01', 'T002', 'NHAN VIEN', '200000', '2020-7-4', '2020-7-15'),
       ('DV01', 'T003', 'NHAN VIEN', '200000', '2020-7-2', '2020-7-15'),
       ('DV02', 'T004', 'NHAN VIEN', '250000', '2020-7-1', '2020-7-25'),
       ('DV02', 'T005', 'NHAN VIEN', '250000', '2020-7-1', '2020-7-25'),
       ('DV05', 'T001', 'NHAN VIEN', '150000', '2020-7-16', '2020-7-30'),
       ('DV05', 'T004', 'NHAN VIEN', '150000', '2020-7-26', '2020-7-30')
;