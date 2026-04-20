

SELECT DISTINCT
    site_id
INTO Dim_Site
FROM sensor_data_final;

ALTER TABLE Dim_Site
ADD site_type VARCHAR(50);

-- Assign site types
UPDATE Dim_Site SET site_type = 'RAN' WHERE site_id IN ('SITE_GSM_01', 'SITE_GSM_02');
UPDATE Dim_Site SET site_type = 'CO' WHERE site_id = 'SITE_MSAN_01';
UPDATE Dim_Site SET site_type = 'DataCenter' WHERE site_id = 'SITE_DC_01';
UPDATE Dim_Site SET site_type = 'Submarine' WHERE site_id = 'SITE_SUB_01';
