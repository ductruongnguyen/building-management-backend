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
('T004', 'HOAI LAM', '2002-09-04', '34 HOANG CAU, HA NOI', '0948776572'),
('T005', 'VAN LAM', '1998-09-04', '16 HOANG CAU, HA NOI', '0948776592')
;

INSERT INTO lam_viec
VALUES ('VL001', 'DV01', 'T001', 'NHAN VIEN', '200000', '2020-7-3', '2020-7-15'),
       ('VL002', 'DV01', 'T002', 'NHAN VIEN', '200000', '2020-7-4', '2020-7-15'),
       ('VL003', 'DV01', 'T003', 'NHAN VIEN', '200000', '2020-7-2', '2020-7-15'),
       ('VL004', 'DV02', 'T004', 'NHAN VIEN', '250000', '2020-7-1', '2020-7-25'),
       ('VL005', 'DV02', 'T005', 'NHAN VIEN', '250000', '2020-7-1', '2020-7-25'),
       ('VL006', 'DV05', 'T001', 'NHAN VIEN', '150000', '2020-7-16', '2020-7-30'),
       ('VL007', 'DV05', 'T004', 'NHAN VIEN', '150000', '2020-7-26', '2020-7-30')
;
