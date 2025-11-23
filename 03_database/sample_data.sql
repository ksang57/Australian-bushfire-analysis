-- =============================================
-- Sample Data for Australian Bushfire Analysis
-- =============================================

USE BushfireAnalysis;
GO

-- =============================================
-- Insert Sample Locations
-- =============================================
INSERT INTO Locations (state, region, lga, latitude, longitude, elevation, vegetation_type, population_density) VALUES
('NSW', 'Blue Mountains', 'Blue Mountains City Council', -33.7128, 150.3111, 1017, 'Eucalyptus Forest', 'Low'),
('VIC', 'East Gippsland', 'East Gippsland Shire', -37.5622, 148.1769, 120, 'Mixed Forest', 'Low'),
('SA', 'Adelaide Hills', 'Adelaide Hills Council', -34.9792, 138.7869, 400, 'Native Scrub', 'Medium'),
('QLD', 'Sunshine Coast', 'Noosa Shire', -26.3984, 153.0881, 50, 'Coastal Woodland', 'Medium'),
('WA', 'Perth Hills', 'Mundaring Shire', -31.8989, 116.1678, 300, 'Jarrah Forest', 'Low'),
('TAS', 'Central Highlands', 'Central Highlands Council', -42.1369, 146.7281, 850, 'Alpine Vegetation', 'Very Low'),
('NSW', 'South Coast', 'Bega Valley Shire', -36.6742, 149.8411, 10, 'Coastal Forest', 'Low'),
('VIC', 'Dandenong Ranges', 'Yarra Ranges Shire', -37.8339, 145.3500, 600, 'Mountain Ash Forest', 'Medium');
GO

-- =============================================
-- Insert Sample Weather Data
-- =============================================
INSERT INTO Weather (location_id, observation_date, temperature_max, temperature_min, humidity_avg, wind_speed_max, wind_direction, rainfall_mm, fire_danger_index, fire_danger_rating, drought_index, fuel_moisture_content, data_source) VALUES
(1, '2024-01-15 14:00:00', 42.5, 28.3, 18, 65, 'NW', 0.0, 95, 'Catastrophic', 8.5, 5, 'Bureau of Meteorology'),
(1, '2024-01-16 14:00:00', 38.2, 26.1, 22, 45, 'W', 0.0, 85, 'Extreme', 8.2, 6, 'Bureau of Meteorology'),
(2, '2023-12-20 14:00:00', 39.8, 24.5, 20, 55, 'N', 0.0, 88, 'Extreme', 7.8, 7, 'Bureau of Meteorology'),
(3, '2024-02-10 14:00:00', 44.1, 29.7, 15, 70, 'NE', 0.0, 98, 'Catastrophic', 9.1, 4, 'Bureau of Meteorology'),
(4, '2023-11-05 14:00:00', 36.5, 22.8, 28, 40, 'SE', 2.5, 72, 'Severe', 6.5, 10, 'Bureau of Meteorology'),
(5, '2024-01-22 14:00:00', 41.3, 27.4, 19, 60, 'E', 0.0, 90, 'Extreme', 8.0, 6, 'Bureau of Meteorology'),
(6, '2023-12-28 14:00:00', 32.1, 18.5, 35, 35, 'W', 5.0, 65, 'High', 5.5, 12, 'Bureau of Meteorology'),
(7, '2024-01-10 14:00:00', 38.9, 25.6, 21, 50, 'NW', 0.0, 82, 'Severe', 7.5, 8, 'Bureau of Meteorology');
GO

-- =============================================
-- Insert Sample Fires
-- =============================================
INSERT INTO Fires (fire_name, location_id, severity_id, cause_id, start_date, end_date, detection_method, area_burnt_ha, perimeter_km, containment_percentage, structures_damaged, structures_destroyed, fatalities, injuries, evacuations, estimated_cost, response_time_hours, firefighters_deployed, aircraft_used, notes, data_source) VALUES
('Blue Mountains Blaze 2024', 1, 5, 1, '2024-01-15 11:30:00', '2024-01-20 18:00:00', 'Satellite', 15000.00, 180.5, 100, 45, 89, 3, 15, 5000, 125000000.00, 2.5, 450, 12, 'Major bushfire during extreme heat wave. Multiple communities evacuated.', 'NSW Rural Fire Service'),
('Gippsland Forest Fire', 2, 4, 8, '2023-12-20 09:15:00', '2023-12-28 16:30:00', 'Ground Report', 8500.00, 125.3, 100, 12, 23, 0, 8, 1200, 45000000.00, 1.8, 280, 8, 'Lightning strike suspected. Difficult terrain challenged firefighting efforts.', 'CFA Victoria'),
('Adelaide Hills Fire', 3, 5, 2, '2024-02-10 14:00:00', '2024-02-15 20:00:00', 'Public Report', 12000.00, 156.8, 100, 67, 134, 1, 25, 8000, 185000000.00, 0.5, 520, 15, 'Arson confirmed. Catastrophic fire danger day. Worst fire in region since 1983.', 'SA CFS'),
('Noosa Hinterland Fire', 4, 3, 7, '2023-11-05 10:30:00', '2023-11-08 14:00:00', 'Satellite', 3200.00, 68.5, 100, 8, 15, 0, 3, 450, 12000000.00, 3.2, 150, 5, 'Escaped controlled burn. Quickly brought under control.', 'QFES'),
('Perth Hills Bushfire', 5, 4, 4, '2024-01-22 13:45:00', '2024-01-26 19:00:00', 'Ground Report', 6800.00, 98.2, 100, 28, 47, 0, 12, 2500, 68000000.00, 2.0, 320, 10, 'Powerline fault during extreme heat. Heritage forests affected.', 'DFES WA'),
('Central Highlands Fire', 6, 2, 5, '2023-12-28 16:20:00', '2023-12-30 12:00:00', 'Public Report', 450.00, 28.5, 100, 2, 3, 0, 0, 50, 2500000.00, 4.5, 80, 2, 'Unattended campfire. Quickly contained due to rainfall.', 'Tasmania Fire Service'),
('Bega Valley Fire', 7, 3, 1, '2024-01-10 08:00:00', '2024-01-14 16:00:00', 'Satellite', 5200.00, 85.6, 100, 15, 28, 0, 5, 800, 32000000.00, 2.8, 210, 7, 'Lightning strike. Threatened coastal communities.', 'NSW RFS'),
('Dandenong Ranges Fire', 8, 2, 6, '2024-01-18 15:30:00', '2024-01-19 22:00:00', 'Public Report', 280.00, 18.2, 100, 3, 1, 0, 1, 120, 5000000.00, 1.2, 95, 3, 'Discarded cigarette from vehicle. Tourist area affected.', 'CFA Victoria');
GO

-- =============================================
-- Link Fires to Weather Observations
-- =============================================
INSERT INTO Fire_Weather_Link (fire_id, weather_id, observation_type) VALUES
(1, 1, 'During'),
(1, 2, 'Post-fire'),
(2, 3, 'During'),
(3, 4, 'During'),
(4, 5, 'During'),
(5, 6, 'During'),
(6, 7, 'During'),
(7, 8, 'During');
GO

PRINT 'Sample data inserted successfully!';
GO
