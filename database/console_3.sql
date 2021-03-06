CREATE VIEW HOA_DON_CTY

AS

SELECT CT.MA_CT, CT.TEN_CT, DV.TEN_DV, SD.NGAY_BD, SD.NGAY_KT, DV.DON_GIA_CS, (CT.DIEN_TICH*300000) AS MAT_BANG,
CASE
    WHEN CT.SO_NV > 10 AND CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5) + FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
    WHEN CT.SO_NV > 10 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.SO_NV - 10)/5))*0.05)
    WHEN CT.DIEN_TICH > 100 THEN DV.DON_GIA_CS*(1 + (FLOOR((CT.DIEN_TICH - 100)/10))*0.05)
    ELSE DV.DON_GIA_CS
END AS THUC_TRA
FROM cong_ty AS CT, dich_vu AS DV, su_dung AS SD
WHERE CT.MA_CT = SD.MA_CT
AND DV.MA_DV = SD.MA_DV
;

