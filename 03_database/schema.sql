-- =============================================
-- Australian Bushfire Analysis Database Schema
-- =============================================

USE BushfireAnalysis;
GO

-- =============================================
-- 1. LOCATIONS TABLE
-- Stores geographic information for bushfire locations
-- =============================================
CREATE TABLE Locations (
    location_id INT PRIMARY KEY IDENTITY(1,1),
    state VARCHAR(50) NOT NULL,
    region VARCHAR(100),
    lga VARCHAR(100),  -- Local Government Area
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    elevation INT,  -- meters above sea level
    vegetation_type VARCHAR(100),
    population_density VARCHAR(20),
    created_date DATETIME DEFAULT GETDATE(),
    CONSTRAINT chk_latitude CHECK (latitude BETWEEN -44 AND -10),
    CONSTRAINT chk_longitude CHECK (longitude BETWEEN 113 AND 154)
);
GO

-- =============================================
-- 2. FIRE_SEVERITY TABLE
-- Reference table for fire severity levels
-- =============================================
CREATE TABLE Fire_Severity (
    severity_id INT PRIMARY KEY IDENTITY(1,1),
    severity_level VARCHAR(20) NOT NULL UNIQUE,
    severity_description VARCHAR(200),
    severity_order INT NOT NULL
);
GO

-- Insert severity levels
INSERT INTO Fire_Severity (severity_level, severity_description, severity_order) VALUES
('Low', 'Minor fire with minimal impact', 1),
('Medium', 'Moderate fire requiring attention', 2),
('High', 'Significant fire with substantial impact', 3),
('Severe', 'Major fire with widespread damage', 4),
('Catastrophic', 'Extreme fire with devastating impact', 5);
GO

-- =============================================
-- 3. FIRE_CAUSES TABLE
-- Reference table for fire cause categories
-- =============================================
CREATE TABLE Fire_Causes (
    cause_id INT PRIMARY KEY IDENTITY(1,1),
    cause_name VARCHAR(50) NOT NULL UNIQUE,
    cause_category VARCHAR(50) NOT NULL,
    cause_description VARCHAR(200)
);
GO

-- Insert common fire causes
INSERT INTO Fire_Causes (cause_name, cause_category, cause_description) VALUES
('Lightning', 'Natural', 'Fire started by lightning strike'),
('Arson', 'Human', 'Deliberately lit fire'),
('Equipment', 'Human', 'Fire from machinery or equipment'),
('Powerlines', 'Infrastructure', 'Fire caused by electrical infrastructure'),
('Campfire', 'Human', 'Fire from unattended or escaped campfire'),
('Cigarette', 'Human', 'Fire from discarded cigarette'),
('Controlled Burn Escape', 'Human', 'Escaped hazard reduction burn'),
('Unknown', 'Unknown', 'Cause not determined'),
('Under Investigation', 'Unknown', 'Cause being investigated');
GO

-- =============================================
-- 4. FIRES TABLE
-- Main table storing bushfire incident data
-- =============================================
CREATE TABLE Fires (
    fire_id INT PRIMARY KEY IDENTITY(1,1),
    fire_name VARCHAR(100),
    location_id INT NOT NULL,
    severity_id INT NOT NULL,
    cause_id INT,
    start_date DATETIME NOT NULL,
    end_date DATETIME,
    detection_method VARCHAR(50),  -- Satellite, Ground Report, etc.
    area_burnt_ha DECIMAL(12, 2),  -- hectares
    perimeter_km DECIMAL(10, 2),  -- kilometers
    containment_percentage INT,
    structures_damaged INT DEFAULT 0,
    structures_destroyed INT DEFAULT 0,
    fatalities INT DEFAULT 0,
    injuries INT DEFAULT 0,
    evacuations INT DEFAULT 0,
    estimated_cost DECIMAL(15, 2),  -- in AUD
    response_time_hours DECIMAL(6, 2),
    firefighters_deployed INT,
    aircraft_used INT,
    notes TEXT,
    data_source VARCHAR(100),
    created_date DATETIME DEFAULT GETDATE(),
    updated_date DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_fires_location FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    CONSTRAINT fk_fires_severity FOREIGN KEY (severity_id) REFERENCES Fire_Severity(severity_id),
    CONSTRAINT fk_fires_cause FOREIGN KEY (cause_id) REFERENCES Fire_Causes(cause_id),
    CONSTRAINT chk_end_after_start CHECK (end_date IS NULL OR end_date >= start_date),
    CONSTRAINT chk_containment CHECK (containment_percentage BETWEEN 0 AND 100),
    CONSTRAINT chk_area_positive CHECK (area_burnt_ha >= 0)
);
GO

-- =============================================
-- 5. WEATHER TABLE
-- Weather conditions associated with fires
-- =============================================
CREATE TABLE Weather (
    weather_id INT PRIMARY KEY IDENTITY(1,1),
    location_id INT NOT NULL,
    observation_date DATETIME NOT NULL,
    temperature_max DECIMAL(5, 2),  -- Celsius
    temperature_min DECIMAL(5, 2),  -- Celsius
    humidity_avg INT,  -- percentage
    wind_speed_max DECIMAL(6, 2),  -- km/h
    wind_direction VARCHAR(10),  -- N, NE, E, SE, S, SW, W, NW
    rainfall_mm DECIMAL(6, 2),  -- millimeters
    fire_danger_index INT,  -- 0-100+ scale
    fire_danger_rating VARCHAR(20),  -- Low-Moderate-High-Very High-Severe-Extreme-Catastrophic
    drought_index DECIMAL(5, 2),
    fuel_moisture_content INT,  -- percentage
    data_source VARCHAR(100),
    created_date DATETIME DEFAULT GETDATE(),
    CONSTRAINT fk_weather_location FOREIGN KEY (location_id) REFERENCES Locations(location_id),
    CONSTRAINT chk_humidity CHECK (humidity_avg BETWEEN 0 AND 100),
    CONSTRAINT chk_temperature CHECK (temperature_max >= temperature_min),
    CONSTRAINT chk_rainfall CHECK (rainfall_mm >= 0)
);
GO

-- =============================================
-- 6. FIRE_WEATHER_LINK TABLE
-- Links specific fires to relevant weather observations
-- =============================================
CREATE TABLE Fire_Weather_Link (
    link_id INT PRIMARY KEY IDENTITY(1,1),
    fire_id INT NOT NULL,
    weather_id INT NOT NULL,
    observation_type VARCHAR(50),  -- 'Pre-fire', 'During', 'Post-fire'
    CONSTRAINT fk_link_fire FOREIGN KEY (fire_id) REFERENCES Fires(fire_id),
    CONSTRAINT fk_link_weather FOREIGN KEY (weather_id) REFERENCES Weather(weather_id),
    CONSTRAINT uq_fire_weather UNIQUE (fire_id, weather_id)
);
GO

-- =============================================
-- 7. ANALYSIS_RESULTS TABLE
-- Store results from data analysis
-- =============================================
CREATE TABLE Analysis_Results (
    analysis_id INT PRIMARY KEY IDENTITY(1,1),
    analysis_name VARCHAR(100) NOT NULL,
    analysis_type VARCHAR(50),  -- 'Correlation', 'Trend', 'Prediction', etc.
    analysis_date DATETIME DEFAULT GETDATE(),
    parameters TEXT,  -- JSON or description of analysis parameters
    results TEXT,  -- JSON or description of results
    visualizations VARCHAR(500),  -- path to saved visualizations
    analyst_notes TEXT,
    created_by VARCHAR(100)
);
GO

-- =============================================
-- INDEXES for Performance
-- =============================================

-- Fires table indexes
CREATE INDEX idx_fires_start_date ON Fires(start_date);
CREATE INDEX idx_fires_location ON Fires(location_id);
CREATE INDEX idx_fires_severity ON Fires(severity_id);

-- Weather table indexes
CREATE INDEX idx_weather_location ON Weather(location_id);
CREATE INDEX idx_weather_date ON Weather(observation_date);
CREATE INDEX idx_weather_danger ON Weather(fire_danger_rating);

-- Locations table indexes
CREATE INDEX idx_locations_state ON Locations(state);
CREATE INDEX idx_locations_coords ON Locations(latitude, longitude);

GO

-- =============================================
-- VIEWS for Common Queries
-- =============================================

-- View: Fire Summary with Location and Severity Details
CREATE VIEW vw_Fire_Summary AS
SELECT 
    f.fire_id,
    f.fire_name,
    f.start_date,
    f.end_date,
    DATEDIFF(day, f.start_date, ISNULL(f.end_date, GETDATE())) as duration_days,
    l.state,
    l.region,
    l.lga,
    fs.severity_level,
    fc.cause_name,
    f.area_burnt_ha,
    f.structures_destroyed,
    f.fatalities,
    f.estimated_cost
FROM Fires f
INNER JOIN Locations l ON f.location_id = l.location_id
INNER JOIN Fire_Severity fs ON f.severity_id = fs.severity_id
LEFT JOIN Fire_Causes fc ON f.cause_id = fc.cause_id;
GO

-- View: High Risk Weather Conditions
CREATE VIEW vw_High_Risk_Weather AS
SELECT 
    w.weather_id,
    w.observation_date,
    l.state,
    l.region,
    w.temperature_max,
    w.humidity_avg,
    w.wind_speed_max,
    w.fire_danger_rating
FROM Weather w
INNER JOIN Locations l ON w.location_id = l.location_id
WHERE w.fire_danger_rating IN ('Severe', 'Extreme', 'Catastrophic')
   OR (w.temperature_max > 35 AND w.humidity_avg < 30 AND w.wind_speed_max > 40);
GO

PRINT 'Database schema created successfully!';
PRINT 'Tables created: Locations, Fire_Severity, Fire_Causes, Fires, Weather, Fire_Weather_Link, Analysis_Results';
PRINT 'Views created: vw_Fire_Summary, vw_High_Risk_Weather';
GO
