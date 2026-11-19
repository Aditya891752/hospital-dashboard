-- ============================================================
--   PROJECT 1: HOSPITAL PATIENT MANAGEMENT DATABASE
--   Tool: DB Browser for SQLite
--   Author: Your Name | Date: June 2026
--   Description: Manages patients, doctors, appointments,
--                medications, billing, and wards for a
--                multi-specialty hospital in Delhi NCR.
-- ============================================================

PRAGMA foreign_keys = ON;

-- ============================================================
-- TABLE 1: WARDS
-- Represents hospital departments/sections
-- ============================================================
CREATE TABLE IF NOT EXISTS wards (
    ward_id       INTEGER PRIMARY KEY AUTOINCREMENT,
    ward_name     TEXT NOT NULL,
    ward_type     TEXT NOT NULL,  -- ICU, General, Pediatric, Surgical, etc.
    total_beds    INTEGER NOT NULL,
    occupied_beds INTEGER DEFAULT 0,
    floor_number  INTEGER,
    head_nurse    TEXT
);

-- ============================================================
-- TABLE 2: DOCTORS
-- Stores doctor profiles and specializations
-- ============================================================
CREATE TABLE IF NOT EXISTS doctors (
    doctor_id      INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name     TEXT NOT NULL,
    last_name      TEXT NOT NULL,
    specialization TEXT NOT NULL,
    qualification  TEXT,
    experience_yrs INTEGER,
    contact_phone  TEXT,
    email          TEXT UNIQUE,
    ward_id        INTEGER,
    joining_date   DATE,
    salary         REAL,
    FOREIGN KEY (ward_id) REFERENCES wards(ward_id)
);

-- ============================================================
-- TABLE 3: PATIENTS
-- Core patient demographics and admission data
-- ============================================================
CREATE TABLE IF NOT EXISTS patients (
    patient_id     INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name     TEXT NOT NULL,
    last_name      TEXT NOT NULL,
    date_of_birth  DATE NOT NULL,
    gender         TEXT CHECK(gender IN ('Male', 'Female', 'Other')),
    blood_group    TEXT,
    contact_phone  TEXT,
    email          TEXT,
    address        TEXT,
    city           TEXT DEFAULT 'Delhi',
    emergency_contact TEXT,
    admission_date DATE,
    discharge_date DATE,
    ward_id        INTEGER,
    primary_doctor INTEGER,
    insurance_provider TEXT,
    insurance_id   TEXT,
    FOREIGN KEY (ward_id) REFERENCES wards(ward_id),
    FOREIGN KEY (primary_doctor) REFERENCES doctors(doctor_id)
);

-- ============================================================
-- TABLE 4: APPOINTMENTS
-- Tracks scheduled and completed consultations
-- ============================================================
CREATE TABLE IF NOT EXISTS appointments (
    appointment_id  INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id      INTEGER NOT NULL,
    doctor_id       INTEGER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TEXT NOT NULL,
    appointment_type TEXT DEFAULT 'OPD',  -- OPD, Emergency, Follow-up, Surgical
    status          TEXT DEFAULT 'Scheduled',  -- Scheduled, Completed, Cancelled, No-show
    diagnosis       TEXT,
    notes           TEXT,
    duration_mins   INTEGER DEFAULT 20,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- ============================================================
-- TABLE 5: MEDICATIONS
-- Prescriptions linked to appointments
-- ============================================================
CREATE TABLE IF NOT EXISTS medications (
    medication_id   INTEGER PRIMARY KEY AUTOINCREMENT,
    appointment_id  INTEGER NOT NULL,
    patient_id      INTEGER NOT NULL,
    drug_name       TEXT NOT NULL,
    dosage          TEXT,
    frequency       TEXT,   -- Once daily, Twice daily, etc.
    duration_days   INTEGER,
    prescribed_date DATE,
    refills_allowed INTEGER DEFAULT 0,
    cost_per_unit   REAL,
    units_prescribed INTEGER,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- ============================================================
-- TABLE 6: BILLING
-- Financial records per patient stay or visit
-- ============================================================
CREATE TABLE IF NOT EXISTS billing (
    bill_id         INTEGER PRIMARY KEY AUTOINCREMENT,
    patient_id      INTEGER NOT NULL,
    appointment_id  INTEGER,
    bill_date       DATE NOT NULL,
    consultation_fee REAL DEFAULT 0,
    medication_cost  REAL DEFAULT 0,
    bed_charges      REAL DEFAULT 0,
    lab_charges      REAL DEFAULT 0,
    surgery_charges  REAL DEFAULT 0,
    total_amount     REAL,
    insurance_covered REAL DEFAULT 0,
    amount_paid      REAL DEFAULT 0,
    payment_status   TEXT DEFAULT 'Pending',  -- Pending, Partial, Paid
    payment_method   TEXT,  -- Cash, UPI, Card, Insurance
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);


-- ============================================================
-- INSERT DATA: WARDS (10 rows)
-- ============================================================
INSERT INTO wards VALUES
(1, 'General Medicine',   'General',   40, 32, 1, 'Sr. Nurse Priya Sharma'),
(2, 'Intensive Care Unit','ICU',        12,  9, 2, 'Sr. Nurse Kavita Rao'),
(3, 'Cardiology',         'Surgical',  20, 15, 3, 'Sr. Nurse Sunita Mehta'),
(4, 'Pediatrics',         'Pediatric', 25, 18, 1, 'Sr. Nurse Anjali Gupta'),
(5, 'Orthopedics',        'Surgical',  18, 12, 4, 'Sr. Nurse Rekha Jain'),
(6, 'Neurology',          'General',   16, 11, 3, 'Sr. Nurse Deepa Verma'),
(7, 'Oncology',           'General',   14,  9, 5, 'Sr. Nurse Nisha Patel'),
(8, 'Gynecology',         'General',   22, 16, 2, 'Sr. Nurse Pooja Singh'),
(9, 'Emergency',          'Emergency', 10,  7, 1, 'Sr. Nurse Usha Tiwari'),
(10,'Dermatology',        'General',    8,  3, 4, 'Sr. Nurse Meera Chaudhary');


-- ============================================================
-- INSERT DATA: DOCTORS (20 rows)
-- ============================================================
INSERT INTO doctors VALUES
(1,  'Rajesh',   'Sharma',   'Cardiologist',       'MD, DM Cardiology', 18, '9810001001', 'rajesh.sharma@hospital.in',    3, '2006-03-15', 180000),
(2,  'Priya',    'Mehta',    'Pediatrician',        'MD Pediatrics',     12, '9810001002', 'priya.mehta@hospital.in',      4, '2012-07-01', 140000),
(3,  'Anil',     'Kapoor',   'Orthopedic Surgeon',  'MS Ortho',          22, '9810001003', 'anil.kapoor@hospital.in',      5, '2002-11-20', 200000),
(4,  'Sunita',   'Rao',      'Neurologist',         'MD, DM Neurology',  15, '9810001004', 'sunita.rao@hospital.in',       6, '2009-05-10', 175000),
(5,  'Vikram',   'Singh',    'General Physician',   'MBBS, MD',           9, '9810001005', 'vikram.singh@hospital.in',     1, '2015-01-22', 120000),
(6,  'Deepa',    'Gupta',    'Gynecologist',        'MS OBG',            16, '9810001006', 'deepa.gupta@hospital.in',      8, '2008-08-08', 160000),
(7,  'Mohan',    'Verma',    'Oncologist',          'MD, DM Oncology',   20, '9810001007', 'mohan.verma@hospital.in',      7, '2004-02-14', 220000),
(8,  'Kavita',   'Joshi',    'Dermatologist',       'MD Dermatology',     7, '9810001008', 'kavita.joshi@hospital.in',    10, '2017-09-30', 110000),
(9,  'Suresh',   'Patel',    'Intensivist',         'MD, IDCCM',         13, '9810001009', 'suresh.patel@hospital.in',     2, '2011-04-17', 190000),
(10, 'Anita',    'Nair',     'General Physician',   'MBBS, MD',           5, '9810001010', 'anita.nair@hospital.in',       1, '2019-06-01', 105000),
(11, 'Ramesh',   'Tiwari',   'Cardiologist',        'MD, DM Cardiology', 10, '9810001011', 'ramesh.tiwari@hospital.in',    3, '2014-03-22', 160000),
(12, 'Neha',     'Bhatia',   'Pediatrician',        'MD Pediatrics',      8, '9810001012', 'neha.bhatia@hospital.in',      4, '2016-11-05', 130000),
(13, 'Arjun',    'Mishra',   'Orthopedic Surgeon',  'MS Ortho',          14, '9810001013', 'arjun.mishra@hospital.in',     5, '2010-07-19', 185000),
(14, 'Seema',    'Chandra',  'Neurologist',         'MD, DM Neurology',  11, '9810001014', 'seema.chandra@hospital.in',    6, '2013-02-28', 165000),
(15, 'Pankaj',   'Dubey',    'Emergency Medicine',  'MBBS, MD Emergency', 6, '9810001015', 'pankaj.dubey@hospital.in',     9, '2018-08-14', 125000),
(16, 'Lata',     'Krishnan', 'Gynecologist',        'MS OBG',            19, '9810001016', 'lata.krishnan@hospital.in',    8, '2005-01-11', 170000),
(17, 'Gaurav',   'Saxena',   'Oncologist',          'MD Oncology',       12, '9810001017', 'gaurav.saxena@hospital.in',    7, '2012-05-23', 200000),
(18, 'Pooja',    'Malhotra', 'Dermatologist',       'MD Dermatology',     4, '9810001018', 'pooja.malhotra@hospital.in',  10, '2020-09-01', 100000),
(19, 'Sanjay',   'Chauhan',  'Intensivist',         'MD, IDCCM',         17, '9810001019', 'sanjay.chauhan@hospital.in',   2, '2007-12-25', 195000),
(20, 'Ritu',     'Agarwal',  'General Physician',   'MBBS, MD',           3, '9810001020', 'ritu.agarwal@hospital.in',     1, '2021-03-15', 98000);


-- ============================================================
-- INSERT DATA: PATIENTS (60 rows)
-- ============================================================
INSERT INTO patients VALUES
(1,  'Amit',     'Sharma',   '1985-04-12', 'Male',   'B+',  '9911001001', 'amit.s@email.com',    'Sector 15, Noida',     'Noida',        '9911001099', '2026-01-10', '2026-01-17', 1, 5,  'Star Health',   'SH-001234'),
(2,  'Priti',    'Verma',    '1990-08-25', 'Female', 'A+',  '9911001002', 'priti.v@email.com',   'Lajpat Nagar, Delhi',  'Delhi',        '9911001098', '2026-01-11', '2026-01-14', 3, 1,  'HDFC Ergo',     'HE-005678'),
(3,  'Rohit',    'Kumar',    '1975-11-03', 'Male',   'O-',  '9911001003', 'rohit.k@email.com',   'Sector 62, Noida',     'Noida',        '9911001097', '2026-01-12', NULL,         2, 9,  'None',          NULL),
(4,  'Sunita',   'Singh',    '1968-03-18', 'Female', 'AB+', '9911001004', 'sunita.si@email.com', 'Dwarka, Delhi',        'Delhi',        '9911001096', '2026-01-13', '2026-01-20', 6, 4,  'Max Bupa',      'MB-009012'),
(5,  'Aakash',   'Pandey',   '2010-06-22', 'Male',   'A-',  '9911001005', NULL,                  'Vasundhara, Ghaziabad','Ghaziabad',    '9911001095', '2026-01-14', '2026-01-16', 4, 2,  'Bajaj Allianz', 'BA-003456'),
(6,  'Meena',    'Gupta',    '1955-09-09', 'Female', 'B-',  '9911001006', 'meena.g@email.com',   'Rohini, Delhi',        'Delhi',        '9911001094', '2026-01-15', '2026-01-25', 7, 7,  'Star Health',   'SH-007890'),
(7,  'Vikas',    'Jain',     '1982-12-30', 'Male',   'O+',  '9911001007', 'vikas.j@email.com',   'Greater Noida West',   'Greater Noida','9911001093', '2026-01-16', '2026-01-19', 5, 3,  'HDFC Ergo',     'HE-001122'),
(8,  'Kavya',    'Reddy',    '1995-02-14', 'Female', 'A+',  '9911001008', 'kavya.r@email.com',   'Sector 50, Noida',     'Noida',        '9911001092', '2026-01-17', '2026-01-21', 8, 6,  'None',          NULL),
(9,  'Suresh',   'Yadav',    '1960-07-07', 'Male',   'B+',  '9911001009', 'suresh.y@email.com',  'Mayur Vihar, Delhi',   'Delhi',        '9911001091', '2026-01-18', '2026-01-30', 1, 5,  'Max Bupa',      'MB-004567'),
(10, 'Anita',    'Patel',    '1978-05-20', 'Female', 'O+',  '9911001010', 'anita.p@email.com',   'Indirapuram, Gzb',     'Ghaziabad',    '9911001090', '2026-01-19', '2026-01-22', 3, 11, 'Star Health',   'SH-002345'),
(11, 'Deepak',   'Tiwari',   '1988-10-15', 'Male',   'AB-', '9911001011', 'deepak.t@email.com',  'Sector 18, Noida',     'Noida',        '9911001089', '2026-01-20', '2026-01-24', 1, 10, 'None',          NULL),
(12, 'Roshni',   'Malhotra', '1993-01-27', 'Female', 'A+',  '9911001012', 'roshni.m@email.com',  'Pitampura, Delhi',     'Delhi',        '9911001088', '2026-01-21', NULL,         8, 16, 'Bajaj Allianz', 'BA-008901'),
(13, 'Nikhil',   'Srivastava','1970-04-04','Male',   'B+',  '9911001013', 'nikhil.s@email.com',  'Crossing Republik, Gzb','Ghaziabad',   '9911001087', '2026-01-22', '2026-01-28', 6, 14, 'HDFC Ergo',     'HE-003456'),
(14, 'Pooja',    'Chauhan',  '2000-08-11', 'Female', 'O-',  '9911001014', 'pooja.c@email.com',   'Karol Bagh, Delhi',    'Delhi',        '9911001086', '2026-01-23', '2026-01-26', 5, 13, 'None',          NULL),
(15, 'Mohit',    'Agarwal',  '1965-03-29', 'Male',   'A-',  '9911001015', 'mohit.a@email.com',   'Vaishali, Ghaziabad',  'Ghaziabad',    '9911001085', '2026-01-24', '2026-02-03', 7, 17, 'Star Health',   'SH-005678'),
(16, 'Sonia',    'Bhatia',   '1983-11-17', 'Female', 'B+',  '9911001016', 'sonia.b@email.com',   'Sector 76, Noida',     'Noida',        '9911001084', '2026-01-25', '2026-01-28', 8, 6,  'Max Bupa',      'MB-006789'),
(17, 'Arjun',    'Nair',     '1958-06-05', 'Male',   'O+',  '9911001017', 'arjun.n@email.com',   'Saket, Delhi',         'Delhi',        '9911001083', '2026-01-26', NULL,         2, 9,  'HDFC Ergo',     'HE-007890'),
(18, 'Lata',     'Mishra',   '1971-09-13', 'Female', 'AB+', '9911001018', 'lata.m@email.com',    'Sector 12, Noida',     'Noida',        '9911001082', '2026-01-27', '2026-02-01', 3, 1,  'Bajaj Allianz', 'BA-001234'),
(19, 'Gaurav',   'Dubey',    '1991-12-08', 'Male',   'A+',  '9911001019', 'gaurav.d@email.com',  'Janakpuri, Delhi',     'Delhi',        '9911001081', '2026-01-28', '2026-01-31', 1, 5,  'None',          NULL),
(20, 'Preeti',   'Saxena',   '1987-02-22', 'Female', 'B-',  '9911001020', 'preeti.s@email.com',  'Sector 44, Noida',     'Noida',        '9911001080', '2026-01-29', '2026-02-04', 6, 4,  'Star Health',   'SH-003456'),
(21, 'Rahul',    'Chopra',   '1979-07-16', 'Male',   'O+',  '9911001021', 'rahul.c@email.com',   'Ashok Vihar, Delhi',   'Delhi',        '9911001079', '2026-02-01', '2026-02-08', 5, 3,  'Max Bupa',      'MB-002345'),
(22, 'Anjali',   'Kumar',    '1996-04-30', 'Female', 'A+',  '9911001022', 'anjali.k@email.com',  'Sector 34, Noida',     'Noida',        '9911001078', '2026-02-02', '2026-02-05', 4, 12, 'HDFC Ergo',     'HE-009012'),
(23, 'Naveen',   'Joshi',    '1963-01-25', 'Male',   'B+',  '9911001023', 'naveen.j@email.com',  'Paschim Vihar, Delhi', 'Delhi',        '9911001077', '2026-02-03', NULL,         7, 7,  'Bajaj Allianz', 'BA-005678'),
(24, 'Rekha',    'Rani',     '1945-10-10', 'Female', 'AB-', '9911001024', NULL,                  'Tilak Nagar, Delhi',   'Delhi',        '9911001076', '2026-02-04', '2026-02-14', 2, 9,  'Star Health',   'SH-008901'),
(25, 'Siddharth','Bajpai',   '2015-03-18', 'Male',   'O-',  '9911001025', NULL,                  'Sector 93, Noida',     'Noida',        '9911001075', '2026-02-05', '2026-02-07', 4, 2,  'None',          NULL),
(26, 'Divya',    'Kapoor',   '1989-08-02', 'Female', 'A-',  '9911001026', 'divya.k@email.com',   'Indirapuram, Gzb',     'Ghaziabad',    '9911001074', '2026-02-06', '2026-02-10', 8, 16, 'Max Bupa',      'MB-007890'),
(27, 'Manish',   'Tripathi', '1974-05-14', 'Male',   'B+',  '9911001027', 'manish.t@email.com',  'Sector 22, Noida',     'Noida',        '9911001073', '2026-02-07', '2026-02-15', 3, 11, 'HDFC Ergo',     'HE-004567'),
(28, 'Shweta',   'Sinha',    '1998-11-29', 'Female', 'O+',  '9911001028', 'shweta.s@email.com',  'Preet Vihar, Delhi',   'Delhi',        '9911001072', '2026-02-08', '2026-02-11', 1, 20, 'None',          NULL),
(29, 'Tushar',   'Mehta',    '1967-06-23', 'Male',   'A+',  '9911001029', 'tushar.m@email.com',  'Sector 29, Faridabad', 'Faridabad',    '9911001071', '2026-02-09', '2026-02-20', 6, 4,  'Bajaj Allianz', 'BA-002345'),
(30, 'Vandana',  'Shukla',   '1980-02-07', 'Female', 'AB+', '9911001030', 'vandana.s@email.com', 'Sector 5, Dwarka',     'Delhi',        '9911001070', '2026-02-10', '2026-02-13', 5, 13, 'Star Health',   'SH-006789'),
(31, 'Vivek',    'Pandey',   '1972-09-19', 'Male',   'B-',  '9911001031', 'vivek.p@email.com',   'Sector 56, Noida',     'Noida',        '9911001069', '2026-02-11', NULL,         2, 19, 'Max Bupa',      'MB-003456'),
(32, 'Nidhi',    'Rastogi',  '1994-12-05', 'Female', 'A+',  '9911001032', 'nidhi.r@email.com',   'Vasundhara Enclave',   'Delhi',        '9911001068', '2026-02-12', '2026-02-16', 8, 6,  'HDFC Ergo',     'HE-005678'),
(33, 'Harish',   'Goswami',  '1956-04-28', 'Male',   'O+',  '9911001033', 'harish.g@email.com',  'Sector 12, Faridabad', 'Faridabad',    '9911001067', '2026-02-13', '2026-02-25', 7, 17, 'None',          NULL),
(34, 'Mamta',    'Khatri',   '1985-07-12', 'Female', 'B+',  '9911001034', 'mamta.k@email.com',   'Sector 45, Noida',     'Noida',        '9911001066', '2026-02-14', '2026-02-17', 4, 2,  'Bajaj Allianz', 'BA-009012'),
(35, 'Prakash',  'Soni',     '1977-10-01', 'Male',   'A-',  '9911001035', 'prakash.s@email.com', 'Vasant Kunj, Delhi',   'Delhi',        '9911001065', '2026-02-15', '2026-02-22', 3, 1,  'Star Health',   'SH-004567'),
(36, 'Geeta',    'Bhatt',    '1962-01-14', 'Female', 'O-',  '9911001036', 'geeta.b@email.com',   'Sector 3, Gurgaon',    'Gurgaon',      '9911001064', '2026-02-16', NULL,         6, 14, 'Max Bupa',      'MB-008901'),
(37, 'Ashwin',   'Patil',    '1990-06-07', 'Male',   'AB+', '9911001037', 'ashwin.p@email.com',  'Sector 23, Dwarka',    'Delhi',        '9911001063', '2026-02-17', '2026-02-20', 1, 10, 'HDFC Ergo',     'HE-006789'),
(38, 'Rina',     'Das',      '1975-03-21', 'Female', 'B+',  '9911001038', 'rina.d@email.com',    'Sector 61, Noida',     'Noida',        '9911001062', '2026-02-18', '2026-02-26', 5, 3,  'None',          NULL),
(39, 'Kamal',    'Prasad',   '1968-11-09', 'Male',   'A+',  '9911001039', 'kamal.p@email.com',   'Meerut Road, Gzb',     'Ghaziabad',    '9911001061', '2026-02-19', '2026-03-01', 7, 7,  'Bajaj Allianz', 'BA-006789'),
(40, 'Shalini',  'Rathore',  '1992-08-26', 'Female', 'O+',  '9911001040', 'shalini.r@email.com', 'Sadar Bazar, Delhi',   'Delhi',        '9911001060', '2026-02-20', '2026-02-23', 8, 6,  'Star Health',   'SH-001234'),
(41, 'Dinesh',   'Khanna',   '1959-05-17', 'Male',   'AB-', '9911001041', 'dinesh.k@email.com',  'Sector 14, Noida',     'Noida',        '9911001059', '2026-02-21', NULL,         2, 9,  'Max Bupa',      'MB-004567'),
(42, 'Usha',     'Bansal',   '1948-02-03', 'Female', 'B+',  '9911001042', NULL,                  'Rajouri Garden, Delhi','Delhi',        '9911001058', '2026-02-22', '2026-03-04', 3, 11, 'HDFC Ergo',     'HE-007890'),
(43, 'Kuldeep',  'Sethi',    '1984-09-30', 'Male',   'A-',  '9911001043', 'kuldeep.s@email.com', 'Sector 55, Noida',     'Noida',        '9911001057', '2026-02-23', '2026-02-28', 5, 13, 'None',          NULL),
(44, 'Madhuri',  'Bhardwaj', '1997-12-15', 'Female', 'O+',  '9911001044', 'madhuri.b@email.com', 'Shalimar Bagh, Delhi', 'Delhi',        '9911001056', '2026-02-24', '2026-02-27', 4, 12, 'Bajaj Allianz', 'BA-003456'),
(45, 'Rajiv',    'Oberoi',   '1973-07-04', 'Male',   'B-',  '9911001045', 'rajiv.o@email.com',   'Sector 31, Faridabad', 'Faridabad',    '9911001055', '2026-02-25', '2026-03-07', 6, 4,  'Star Health',   'SH-007890'),
(46, 'Shipra',   'Tripathi', '1986-04-19', 'Female', 'A+',  '9911001046', 'shipra.t@email.com',  'Sector 82, Noida',     'Noida',        '9911001054', '2026-02-26', NULL,         8, 16, 'Max Bupa',      'MB-002345'),
(47, 'Naresh',   'Yadav',    '1951-01-28', 'Male',   'O-',  '9911001047', 'naresh.y@email.com',  'Tilak Nagar, Delhi',   'Delhi',        '9911001053', '2026-02-27', '2026-03-10', 7, 17, 'HDFC Ergo',     'HE-001122'),
(48, 'Renu',     'Sahu',     '1988-10-12', 'Female', 'AB+', '9911001048', 'renu.s@email.com',    'Vaishali, Ghaziabad',  'Ghaziabad',    '9911001052', '2026-02-28', '2026-03-04', 1, 5,  'None',          NULL),
(49, 'Umesh',    'Tomar',    '1966-07-25', 'Male',   'B+',  '9911001049', 'umesh.t@email.com',   'Sector 67, Noida',     'Noida',        '9911001051', '2026-03-01', NULL,         2, 19, 'Bajaj Allianz', 'BA-007890'),
(50, 'Savita',   'Pillai',   '1993-05-08', 'Female', 'A+',  '9911001050', 'savita.p@email.com',  'Sector 8, Dwarka',     'Delhi',        '9911001050', '2026-03-02', '2026-03-06', 5, 3,  'Star Health',   'SH-002345'),
(51, 'Harendra', 'Singh',    '1969-08-14', 'Male',   'O+',  '9911002001', 'harendra.s@email.com','Sector 77, Noida',     'Noida',        '9911002099', '2026-03-03', '2026-03-10', 3, 1,  'Max Bupa',      'MB-009012'),
(52, 'Poonam',   'Dixit',    '1981-02-27', 'Female', 'B-',  '9911002002', 'poonam.d@email.com',  'Kaushambi, Ghaziabad', 'Ghaziabad',    '9911002098', '2026-03-04', NULL,         6, 14, 'HDFC Ergo',     'HE-003456'),
(53, 'Sanjeev',  'Awasthi',  '1976-11-16', 'Male',   'A-',  '9911002003', 'sanjeev.a@email.com', 'Sector 18, Faridabad', 'Faridabad',    '9911002097', '2026-03-05', '2026-03-12', 7, 7,  'None',          NULL),
(54, 'Mona',     'Kashyap',  '1999-09-03', 'Female', 'AB+', '9911002004', 'mona.k@email.com',    'Uttam Nagar, Delhi',   'Delhi',        '9911002096', '2026-03-06', '2026-03-09', 8, 8,  'Bajaj Allianz', 'BA-001234'),
(55, 'Bharat',   'Lal',      '1954-06-22', 'Male',   'O+',  '9911002005', NULL,                  'Sector 10, Noida',     'Noida',        '9911002095', '2026-03-07', '2026-03-20', 2, 9,  'Star Health',   'SH-005678'),
(56, 'Sarita',   'Wadhwa',   '1987-03-11', 'Female', 'B+',  '9911002006', 'sarita.w@email.com',  'Rajinder Nagar, Delhi','Delhi',        '9911002094', '2026-03-08', '2026-03-13', 4, 2,  'Max Bupa',      'MB-006789'),
(57, 'Alok',     'Srivastav','1971-12-28', 'Male',   'A+',  '9911002007', 'alok.sr@email.com',   'Sector 72, Noida',     'Noida',        '9911002093', '2026-03-09', NULL,         5, 3,  'HDFC Ergo',     'HE-008901'),
(58, 'Ranjana',  'Vashist',  '1963-09-17', 'Female', 'O-',  '9911002008', 'ranjana.v@email.com', 'Rohini Sector 9',      'Delhi',        '9911002092', '2026-03-10', '2026-03-18', 7, 17, 'None',          NULL),
(59, 'Sunil',    'Bhatt',    '1989-06-04', 'Male',   'AB-', '9911002009', 'sunil.b@email.com',   'Sector 48, Noida',     'Noida',        '9911002091', '2026-03-11', '2026-03-15', 1, 10, 'Bajaj Allianz', 'BA-004567'),
(60, 'Kamla',    'Devi',     '1943-01-19', 'Female', 'B+',  '9911002010', NULL,                  'Chandni Chowk, Delhi', 'Delhi',        '9911002090', '2026-03-12', NULL,         2, 19, 'Star Health',   'SH-009012');


-- ============================================================
-- INSERT DATA: APPOINTMENTS (60 rows)
-- ============================================================
INSERT INTO appointments VALUES
(1,  1,  5,  '2026-01-10', '09:00', 'OPD',       'Completed', 'Hypertension',             'BP 150/95. Prescribed medication.',                 20),
(2,  1,  1,  '2026-01-11', '11:00', 'Follow-up', 'Completed', 'Hypertension with tachycardia','Referred to cardiology.',                       30),
(3,  2,  1,  '2026-01-11', '14:00', 'OPD',       'Completed', 'Angina Pectoris',           'ECG done. Scheduled for angiography.',              45),
(4,  3,  9,  '2026-01-12', '10:00', 'Emergency', 'Completed', 'Acute Respiratory Failure', 'ICU admission. Ventilator support.',                60),
(5,  4,  4,  '2026-01-13', '09:30', 'OPD',       'Completed', 'Migraine with Aura',        'MRI scheduled.',                                    30),
(6,  5,  2,  '2026-01-14', '11:00', 'OPD',       'Completed', 'Viral Fever',               'Child. Paracetamol and rest advised.',               20),
(7,  6,  7,  '2026-01-15', '10:00', 'OPD',       'Completed', 'Breast Cancer Stage II',    'Chemotherapy plan initiated.',                       45),
(8,  7,  3,  '2026-01-16', '09:00', 'Surgical',  'Completed', 'Right Knee Replacement',    'Surgery successful. Post-op care.',                  90),
(9,  8,  6,  '2026-01-17', '10:30', 'OPD',       'Completed', 'PCOS',                      'Hormonal profile done.',                             30),
(10, 9,  5,  '2026-01-18', '09:00', 'OPD',       'Completed', 'Diabetes Type 2',           'HbA1c 8.2%. Metformin increased.',                   20),
(11, 10, 11, '2026-01-19', '11:30', 'OPD',       'Completed', 'Coronary Artery Disease',   'Statin and aspirin started.',                        30),
(12, 11, 10, '2026-01-20', '09:00', 'OPD',       'Completed', 'Gastroenteritis',           'ORS and antibiotics.',                               20),
(13, 12, 16, '2026-01-21', '10:00', 'OPD',       'Completed', 'Endometriosis',             'Laparoscopy recommended.',                           45),
(14, 13, 14, '2026-01-22', '09:30', 'OPD',       'Completed', 'Epilepsy',                  'Sodium Valproate adjusted.',                         30),
(15, 14, 13, '2026-01-23', '11:00', 'Surgical',  'Completed', 'ACL Tear Left Knee',        'Arthroscopic repair done.',                          60),
(16, 15, 17, '2026-01-24', '10:00', 'OPD',       'Completed', 'Lymphoma',                  'RCHOP chemotherapy cycle 2.',                        45),
(17, 16, 6,  '2026-01-25', '09:00', 'OPD',       'Completed', 'Uterine Fibroids',          'USG abdomen done. Medication started.',              30),
(18, 17, 9,  '2026-01-26', '08:00', 'Emergency', 'Completed', 'Septic Shock',              'ICU. IV antibiotics and vasopressors.',              60),
(19, 18, 1,  '2026-01-27', '11:00', 'OPD',       'Completed', 'Hypertensive Heart Disease','Echo done. LVEF 45%.',                               40),
(20, 19, 5,  '2026-01-28', '09:00', 'OPD',       'Completed', 'Upper Respiratory Infection','Amoxicillin and antihistamine.',                    20),
(21, 20, 4,  '2026-01-29', '10:00', 'OPD',       'Completed', 'Cluster Headache',          'Sumatriptan prescribed.',                            30),
(22, 21, 3,  '2026-02-01', '09:00', 'Surgical',  'Completed', 'Hip Fracture',              'ORIF done. Physiotherapy started.',                  90),
(23, 22, 12, '2026-02-02', '11:00', 'OPD',       'Completed', 'Pediatric Asthma',          'Salbutamol inhaler. Spacer provided.',                30),
(24, 23, 7,  '2026-02-03', '10:00', 'OPD',       'Completed', 'Prostate Cancer Stage III', 'Radiation therapy planned.',                         45),
(25, 24, 9,  '2026-02-04', '08:00', 'Emergency', 'Completed', 'Cardiac Arrest',            'CPR. Defibrillated. ICU admission.',                 60),
(26, 25, 2,  '2026-02-05', '11:00', 'OPD',       'Completed', 'Acute Tonsillitis',         'Antibiotics. Rest.',                                 20),
(27, 26, 16, '2026-02-06', '10:00', 'OPD',       'Completed', 'Pregnancy 20 weeks',        'Anomaly scan normal.',                               30),
(28, 27, 11, '2026-02-07', '09:30', 'Follow-up', 'Completed', 'Post Angioplasty',          'Stent patent. Continue dual antiplatelet.',          30),
(29, 28, 20, '2026-02-08', '09:00', 'OPD',       'Completed', 'Urinary Tract Infection',   'Urine culture sent. Nitrofurantoin started.',         20),
(30, 29, 4,  '2026-02-09', '10:30', 'OPD',       'Completed', 'Parkinsons Disease',        'Levodopa adjusted. Physiotherapy referred.',         40),
(31, 30, 13, '2026-02-10', '09:00', 'OPD',       'Completed', 'Osteoarthritis Knee',       'Intra-articular injection given.',                   30),
(32, 31, 19, '2026-02-11', '08:00', 'Emergency', 'Completed', 'Pulmonary Embolism',        'ICU. Anticoagulation started.',                      60),
(33, 32, 6,  '2026-02-12', '10:00', 'Follow-up', 'Completed', 'PCOS Follow-up',            'Hormones improving. Continue Metformin.',            20),
(34, 33, 17, '2026-02-13', '09:30', 'Follow-up', 'Completed', 'Lymphoma Cycle 4',          'Good response to chemo.',                            45),
(35, 34, 2,  '2026-02-14', '11:00', 'OPD',       'Completed', 'Hand Foot Mouth Disease',   'Symptomatic. Hygiene counselling.',                  20),
(36, 35, 1,  '2026-02-15', '09:00', 'Surgical',  'Completed', 'Aortic Valve Replacement',  'Surgery successful. ICU post-op.',                   90),
(37, 36, 14, '2026-02-16', '10:00', 'OPD',       'Completed', 'Alzheimers Disease',        'Donepezil started. Family counselled.',              30),
(38, 37, 10, '2026-02-17', '09:00', 'OPD',       'Completed', 'Acute Gastritis',           'PPI and antacid. Diet advised.',                     20),
(39, 38, 3,  '2026-02-18', '11:00', 'Surgical',  'Completed', 'Lumbar Disc Herniation',    'Microdiscectomy done.',                              75),
(40, 39, 7,  '2026-02-19', '10:00', 'OPD',       'Completed', 'Colon Cancer Stage II',     'Adjuvant chemotherapy started.',                     45),
(41, 40, 6,  '2026-02-20', '09:30', 'OPD',       'Completed', 'Infertility Evaluation',    'Semen analysis and HSG ordered.',                    40),
(42, 41, 9,  '2026-02-21', '08:00', 'Emergency', 'Completed', 'Diabetic Ketoacidosis',     'ICU. IV insulin infusion.',                          60),
(43, 42, 11, '2026-02-22', '11:00', 'OPD',       'Completed', 'Heart Failure',             'Furosemide and ACE inhibitor.',                      30),
(44, 43, 13, '2026-02-23', '09:00', 'OPD',       'Completed', 'Sports Injury Ankle',       'RICE protocol. Physiotherapy.',                      25),
(45, 44, 12, '2026-02-24', '10:00', 'OPD',       'Completed', 'Anemia in Child',           'Iron and folic acid supplementation.',               20),
(46, 45, 4,  '2026-02-25', '09:30', 'OPD',       'Completed', 'Stroke Follow-up',          'Rehabilitation progress good.',                       35),
(47, 46, 16, '2026-02-26', '11:00', 'OPD',       'Completed', 'Pregnancy 32 weeks',        'BP monitoring. Iron tabs.',                          30),
(48, 47, 17, '2026-02-27', '10:00', 'OPD',       'Completed', 'Lung Cancer Stage IIIB',    'Targeted therapy with Erlotinib.',                   45),
(49, 48, 5,  '2026-02-28', '09:00', 'OPD',       'Completed', 'Thyroid Hypothyroidism',    'TSH high. Levothyroxine increased.',                 20),
(50, 49, 19, '2026-03-01', '08:00', 'Emergency', 'Completed', 'COPD Exacerbation',         'Nebulization. IV steroids. ICU.',                    60),
(51, 50, 3,  '2026-03-02', '11:00', 'OPD',       'Completed', 'Cervical Spondylosis',      'Traction and NSAIDs.',                               25),
(52, 51, 1,  '2026-03-03', '09:00', 'Follow-up', 'Completed', 'Post CABG 3 months',        'Doing well. Cardiac rehab started.',                 30),
(53, 52, 14, '2026-03-04', '10:00', 'OPD',       'Completed', 'Multiple Sclerosis',        'Interferon beta started.',                           45),
(54, 53, 7,  '2026-03-05', '09:30', 'OPD',       'Completed', 'Thyroid Cancer',            'Post thyroidectomy follow-up. RAI planned.',         40),
(55, 54, 8,  '2026-03-06', '11:00', 'OPD',       'Completed', 'Eczema',                    'Topical steroid and moisturizer.',                   20),
(56, 55, 9,  '2026-03-07', '08:00', 'Emergency', 'Completed', 'Acute MI',                  'Thrombolysis given. ICU monitoring.',                60),
(57, 56, 2,  '2026-03-08', '10:00', 'OPD',       'Completed', 'Neonatal Jaundice',         'Phototherapy for 2 days.',                           30),
(58, 57, 3,  '2026-03-09', '09:00', 'OPD',       'Completed', 'Plantar Fasciitis',         'Orthotics and stretching exercises.',                 25),
(59, 58, 17, '2026-03-10', '10:30', 'OPD',       'Completed', 'Ovarian Cancer Stage I',    'Post-op chemo. CA-125 monitoring.',                  45),
(60, 59, 10, '2026-03-11', '09:00', 'OPD',       'Completed', 'Peptic Ulcer Disease',      'H. pylori eradication therapy.',                     30);


-- ============================================================
-- INSERT DATA: MEDICATIONS (60 rows)
-- ============================================================
INSERT INTO medications VALUES
(1,  1,  1,  'Amlodipine',       '5mg',   'Once daily',   30, '2026-01-10', 1, 8.50,   30),
(2,  1,  1,  'Telmisartan',      '40mg',  'Once daily',   30, '2026-01-10', 1, 12.00,  30),
(3,  2,  1,  'Metoprolol',       '25mg',  'Twice daily',  30, '2026-01-11', 1, 6.00,   60),
(4,  3,  2,  'Isosorbide Mononitrate','10mg','Twice daily',30, '2026-01-11', 2, 5.50,   60),
(5,  3,  2,  'Aspirin',          '75mg',  'Once daily',   30, '2026-01-11', 2, 2.00,   30),
(6,  5,  4,  'Sumatriptan',      '50mg',  'As needed',    15, '2026-01-13', 1, 45.00,  10),
(7,  5,  4,  'Amitriptyline',    '10mg',  'Once at night',30, '2026-01-13', 1, 3.50,   30),
(8,  6,  5,  'Paracetamol',      '250mg', 'Thrice daily', 5,  '2026-01-14', 0, 1.50,   15),
(9,  6,  5,  'Cetirizine',       '5mg',   'Once daily',   5,  '2026-01-14', 0, 3.00,   5),
(10, 7,  6,  'Cyclophosphamide', '750mg/m2','IV once',    21, '2026-01-15', 5, 850.00, 1),
(11, 9,  8,  'Metformin',        '500mg', 'Twice daily',  90, '2026-01-18', 2, 4.00,   180),
(12, 9,  8,  'Glipizide',        '5mg',   'Once daily',   90, '2026-01-18', 2, 5.00,   90),
(13, 10, 10, 'Atorvastatin',     '40mg',  'Once at night',30, '2026-01-19', 2, 18.00,  30),
(14, 10, 10, 'Clopidogrel',      '75mg',  'Once daily',   30, '2026-01-19', 2, 22.00,  30),
(15, 12, 12, 'Pantoprazole',     '40mg',  'Twice daily',  7,  '2026-01-20', 0, 8.00,   14),
(16, 13, 12, 'Dienogest',        '2mg',   'Once daily',   90, '2026-01-21', 2, 35.00,  90),
(17, 14, 13, 'Sodium Valproate', '500mg', 'Twice daily',  90, '2026-01-22', 2, 12.00,  180),
(18, 16, 15, 'Rituximab',        '375mg/m2','IV once',    21, '2026-01-24', 5, 18000.00,1),
(19, 16, 15, 'Cyclophosphamide', '750mg/m2','IV once',    21, '2026-01-24', 5, 850.00, 1),
(20, 17, 16, 'Norethisterone',   '5mg',   'Twice daily',  90, '2026-01-25', 1, 8.00,   180),
(21, 19, 18, 'Ramipril',         '5mg',   'Once daily',   30, '2026-01-27', 2, 14.00,  30),
(22, 19, 18, 'Carvedilol',       '6.25mg','Twice daily',  30, '2026-01-27', 2, 16.00,  60),
(23, 20, 19, 'Amoxicillin',      '500mg', 'Thrice daily', 7,  '2026-01-28', 0, 6.00,   21),
(24, 20, 19, 'Cetirizine',       '10mg',  'Once daily',   7,  '2026-01-28', 0, 4.00,   7),
(25, 21, 20, 'Propranolol',      '10mg',  'Twice daily',  30, '2026-01-29', 1, 4.50,   60),
(26, 23, 22, 'Salbutamol inhaler','100mcg','As needed',   30, '2026-02-02', 2, 85.00,  1),
(27, 23, 22, 'Montelukast',      '5mg',   'Once daily',   30, '2026-02-02', 2, 25.00,  30),
(28, 24, 23, 'Leuprolide',       '7.5mg', 'Monthly IM',   90, '2026-02-03', 3, 2500.00,3),
(29, 25, 24, 'Enoxaparin',       '60mg',  'Twice daily',  7,  '2026-02-04', 0, 280.00, 14),
(30, 26, 25, 'Amoxicillin-Clav.','375mg', 'Thrice daily', 7,  '2026-02-05', 0, 18.00,  21),
(31, 27, 26, 'Folic Acid',       '5mg',   'Once daily',   30, '2026-02-06', 2, 1.00,   30),
(32, 27, 26, 'Iron Sucrose',     '200mg', 'IV alternate', 15, '2026-02-06', 0, 120.00, 5),
(33, 28, 27, 'Aspirin',          '75mg',  'Once daily',   30, '2026-02-07', 5, 2.00,   30),
(34, 28, 27, 'Ticagrelor',       '90mg',  'Twice daily',  30, '2026-02-07', 5, 85.00,  60),
(35, 29, 28, 'Nitrofurantoin',   '100mg', 'Twice daily',  5,  '2026-02-08', 0, 12.00,  10),
(36, 30, 29, 'Levodopa/Carbidopa','250/25mg','Thrice daily',90,'2026-02-09',2, 22.00,  270),
(37, 31, 30, 'Diclofenac',       '75mg',  'Twice daily',  10, '2026-02-10', 0, 6.00,   20),
(38, 33, 32, 'Metformin',        '500mg', 'Twice daily',  90, '2026-02-12', 2, 4.00,   180),
(39, 34, 33, 'Doxorubicin',      '50mg/m2','IV once',     21, '2026-02-13', 3, 1200.00,1),
(40, 37, 37, 'Omeprazole',       '20mg',  'Twice daily',  14, '2026-02-17', 0, 7.50,   28),
(41, 37, 37, 'Sucralfate',       '1g',    'Thrice daily', 14, '2026-02-17', 0, 15.00,  42),
(42, 40, 39, 'Oxaliplatin',      '85mg/m2','IV once',     21, '2026-02-19', 5, 3200.00,1),
(43, 42, 41, 'Regular Insulin',  '0.1u/kg','IV infusion', 3,  '2026-02-21', 0, 45.00,  1),
(44, 43, 42, 'Furosemide',       '40mg',  'Once daily',   30, '2026-02-22', 2, 5.00,   30),
(45, 43, 42, 'Ramipril',         '2.5mg', 'Once daily',   30, '2026-02-22', 2, 14.00,  30),
(46, 45, 44, 'Ferrous Sulphate', '200mg', 'Twice daily',  60, '2026-02-24', 1, 2.50,   120),
(47, 46, 45, 'Levodopa/Carbidopa','250/25mg','Thrice daily',30,'2026-02-25',2, 22.00,  90),
(48, 47, 46, 'Progesterone',     '200mg', 'Once daily',   30, '2026-02-26', 0, 28.00,  30),
(49, 48, 47, 'Erlotinib',        '150mg', 'Once daily',   30, '2026-02-27', 5, 4500.00,30),
(50, 49, 48, 'Levothyroxine',    '100mcg','Once daily',   90, '2026-02-28', 5, 8.00,   90),
(51, 51, 50, 'Diclofenac',       '50mg',  'Twice daily',  10, '2026-03-02', 0, 6.00,   20),
(52, 51, 50, 'Thiocolchicoside', '4mg',   'Twice daily',  10, '2026-03-02', 0, 18.00,  20),
(53, 52, 51, 'Carvedilol',       '12.5mg','Twice daily',  30, '2026-03-03', 2, 16.00,  60),
(54, 52, 51, 'Aspirin',          '75mg',  'Once daily',   30, '2026-03-03', 5, 2.00,   30),
(55, 53, 52, 'Interferon beta-1a','30mcg','Weekly IM',    90, '2026-03-04', 2, 8500.00,12),
(56, 55, 54, 'Betamethasone',    '0.05%', 'Twice daily',  14, '2026-03-06', 0, 42.00,  1),
(57, 55, 54, 'Tacrolimus',       '0.1%',  'Once daily',   14, '2026-03-06', 0, 185.00, 1),
(58, 56, 55, 'Tenecteplase',     '40mg',  'IV bolus once',1,  '2026-03-07', 0, 22000.00,1),
(59, 58, 57, 'Ibuprofen',        '400mg', 'Thrice daily', 7,  '2026-03-09', 0, 4.00,   21),
(60, 60, 59, 'Omeprazole',       '20mg',  'Twice daily',  14, '2026-03-11', 0, 7.50,   28);


-- ============================================================
-- INSERT DATA: BILLING (50 rows)
-- ============================================================
INSERT INTO billing VALUES
(1,  1,  1,  '2026-01-17', 500,   255,   6300,  0,     0,      7055,   2000,  5055,  'Paid',    'UPI'),
(2,  2,  3,  '2026-01-14', 1500,  930,   1800,  2500,  45000,  51730,  25000, 26730, 'Partial', 'Insurance'),
(3,  3,  4,  '2026-01-30', 2000,  0,     27000, 8000,  0,      37000,  0,     37000, 'Pending', NULL),
(4,  4,  5,  '2026-01-20', 1500,  45,    2400,  3500,  0,      7445,   3000,  4445,  'Paid',    'Card'),
(5,  5,  6,  '2026-01-16', 500,   22,    400,   500,   0,      1422,   1000,  422,   'Paid',    'Cash'),
(6,  6,  7,  '2026-01-25', 1500,  18850, 9000,  5000,  0,      34350,  15000, 19350, 'Partial', 'Insurance'),
(7,  7,  8,  '2026-01-19', 2000,  0,     2700,  3000,  85000,  92700,  40000, 52700, 'Partial', 'Insurance'),
(8,  8,  9,  '2026-01-21', 1000,  0,     3600,  2000,  0,      6600,   0,     6600,  'Paid',    'UPI'),
(9,  9,  10, '2026-01-30', 500,   1110,  10800, 1500,  0,      13910,  6000,  7910,  'Paid',    'Card'),
(10, 10, 11, '2026-01-22', 1000,  1200,  2700,  2000,  0,      6900,   3000,  3900,  'Paid',    'UPI'),
(11, 11, 12, '2026-01-24', 500,   168,   0,     0,     0,      668,    0,     668,   'Paid',    'Cash'),
(12, 12, 13, '2026-02-10', 1000,  3150,  9000,  3500,  35000,  51650,  20000, 31650, 'Partial', 'Insurance'),
(13, 13, 14, '2026-01-28', 1000,  2160,  5400,  2500,  0,      11060,  5000,  6060,  'Paid',    'Card'),
(14, 14, 15, '2026-01-26', 2000,  0,     2700,  2500,  55000,  62200,  0,     62200, 'Pending', NULL),
(15, 15, 16, '2026-02-03', 1500,  21700, 9000,  5000,  0,      37200,  15000, 22200, 'Partial', 'Insurance'),
(16, 16, 17, '2026-01-28', 1000,  0,     2700,  1500,  0,      5200,   2500,  2700,  'Paid',    'UPI'),
(17, 17, 18, '2026-02-10', 2000,  0,     40000, 12000, 0,      54000,  0,     54000, 'Pending', NULL),
(18, 18, 19, '2026-02-01', 1500,  1800,  4500,  5000,  0,      12800,  6000,  6800,  'Paid',    'Insurance'),
(19, 19, 20, '2026-01-31', 500,   390,   2700,  500,   0,      4090,   0,     4090,  'Paid',    'Cash'),
(20, 20, 21, '2026-02-04', 1000,  270,   2700,  2000,  0,      5970,   2500,  3470,  'Paid',    'UPI'),
(21, 21, 22, '2026-02-08', 2000,  0,     6300,  4000,  180000, 192300, 80000, 112300,'Partial', 'Insurance'),
(22, 22, 23, '2026-02-05', 500,   3275,  2700,  1500,  0,      7975,   3500,  4475,  'Paid',    'Card'),
(23, 23, 24, '2026-02-14', 1500,  7500,  9000,  4000,  0,      22000,  10000, 12000, 'Partial', 'Insurance'),
(24, 24, 25, '2026-02-14', 2000,  4060,  108000,20000, 0,      134060, 60000, 74060, 'Partial', 'Insurance'),
(25, 25, 26, '2026-02-07', 500,   378,   900,   500,   0,      2278,   0,     2278,  'Paid',    'Cash'),
(26, 26, 27, '2026-02-10', 1000,  3640,  3600,  2000,  0,      10240,  5000,  5240,  'Paid',    'UPI'),
(27, 27, 28, '2026-02-15', 1000,  7650,  7200,  3000,  0,      18850,  8000,  10850, 'Paid',    'Card'),
(28, 28, 29, '2026-02-11', 500,   120,   0,     800,   0,      1420,   0,     1420,  'Paid',    'Cash'),
(29, 29, 30, '2026-02-20', 1000,  5940,  10800, 3000,  0,      20740,  8000,  12740, 'Paid',    'Insurance'),
(30, 30, 31, '2026-02-13', 1000,  120,   2700,  1500,  0,      5320,   2000,  3320,  'Paid',    'UPI'),
(31, 31, 32, '2026-03-01', 2000,  0,     27000, 10000, 0,      39000,  0,     39000, 'Pending', NULL),
(32, 32, 33, '2026-02-16', 500,   720,   0,     0,     0,      1220,   0,     1220,  'Paid',    'Cash'),
(33, 33, 34, '2026-02-25', 1500,  1200,  10800, 4000,  0,      17500,  0,     17500, 'Pending', NULL),
(34, 34, 35, '2026-02-17', 500,   50,    1800,  500,   0,      2850,   1200,  1650,  'Paid',    'Insurance'),
(35, 35, 36, '2026-02-22', 2000,  0,     6300,  8000,  350000, 366300, 150000,216300,'Partial', 'Insurance'),
(36, 36, 37, '2026-02-20', 1000,  0,     9000,  2000,  0,      12000,  0,     12000, 'Pending', NULL),
(37, 37, 38, '2026-02-20', 500,   633,   0,     0,     0,      1133,   0,     1133,  'Paid',    'Cash'),
(38, 38, 39, '2026-02-26', 2000,  0,     7200,  4000,  95000,  108200, 50000, 58200, 'Partial', 'Insurance'),
(39, 39, 40, '2026-03-01', 1500,  3200,  11700, 5000,  0,      21400,  0,     21400, 'Pending', NULL),
(40, 40, 41, '2026-02-23', 1000,  0,     2700,  3000,  0,      6700,   3000,  3700,  'Paid',    'UPI'),
(41, 41, 42, '2026-03-05', 2000,  45,    45000, 15000, 0,      62045,  0,     62045, 'Pending', NULL),
(42, 42, 43, '2026-03-04', 1000,  6300,  10800, 3000,  0,      21100,  10000, 11100, 'Paid',    'Insurance'),
(43, 43, 44, '2026-02-28', 1000,  0,     0,     1000,  0,      2000,   0,     2000,  'Paid',    'Cash'),
(44, 44, 45, '2026-02-27', 500,   300,   900,   500,   0,      2200,   1000,  1200,  'Paid',    'UPI'),
(45, 45, 46, '2026-03-07', 1000,  1980,  5400,  2000,  0,      10380,  4000,  6380,  'Paid',    'Card'),
(46, 46, 47, '2026-03-10', 1000,  840,   8100,  2500,  0,      12440,  5000,  7440,  'Paid',    'Insurance'),
(47, 47, 48, '2026-03-10', 1500,  135000,7200,  5000,  0,      148700, 60000, 88700, 'Partial', 'Insurance'),
(48, 48, 49, '2026-03-04', 500,   720,   0,     800,   0,      2020,   1000,  1020,  'Paid',    'UPI'),
(49, 49, 50, '2026-03-20', 2000,  0,     54000, 12000, 0,      68000,  0,     68000, 'Pending', NULL),
(50, 50, 51, '2026-03-06', 1000,  240,   3600,  1500,  0,      6340,   3000,  3340,  'Paid',    'Card');


-- ============================================================
--   BUSINESS QUERIES — Read, Understand, Modify
--   15 queries covering key hospital analytics scenarios
-- ============================================================


-- ============================================================
-- QUERY 1: CURRENT INPATIENTS
-- Shows all patients currently admitted (no discharge date).
-- Modify: Change ward filter to see a specific ward, e.g. ICU
-- ============================================================
SELECT
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    p.gender,
    p.admission_date,
    julianday('now') - julianday(p.admission_date) AS days_admitted,
    w.ward_name,
    d.first_name || ' ' || d.last_name AS primary_doctor,
    p.insurance_provider
FROM patients p
JOIN wards w     ON p.ward_id = w.ward_id
JOIN doctors d   ON p.primary_doctor = d.doctor_id
WHERE p.discharge_date IS NULL
ORDER BY days_admitted DESC;


-- ============================================================
-- QUERY 2: DOCTOR WORKLOAD — Appointments per Doctor
-- Shows how busy each doctor is (volume of appointments).
-- Useful for scheduling and resource planning.
-- Modify: Add a WHERE clause for a specific month
-- ============================================================
SELECT
    d.doctor_id,
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialization,
    COUNT(a.appointment_id) AS total_appointments,
    SUM(CASE WHEN a.status = 'Completed'  THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN a.status = 'Cancelled'  THEN 1 ELSE 0 END) AS cancelled,
    SUM(CASE WHEN a.status = 'No-show'    THEN 1 ELSE 0 END) AS no_shows,
    ROUND(AVG(a.duration_mins), 1) AS avg_duration_mins
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
ORDER BY total_appointments DESC;


-- ============================================================
-- QUERY 3: REVENUE SUMMARY — Total Billing by Ward
-- Shows which ward generates most revenue and outstanding dues.
-- Modify: Replace ward grouping with doctor or month
-- ============================================================
SELECT
    w.ward_name,
    COUNT(DISTINCT b.patient_id)          AS patients_billed,
    ROUND(SUM(b.total_amount), 2)         AS gross_revenue,
    ROUND(SUM(b.insurance_covered), 2)    AS insurance_settled,
    ROUND(SUM(b.amount_paid), 2)          AS cash_collected,
    ROUND(SUM(b.total_amount) - SUM(b.amount_paid), 2) AS outstanding_dues,
    ROUND(AVG(b.total_amount), 2)         AS avg_bill_per_patient
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
JOIN wards w    ON p.ward_id = w.ward_id
GROUP BY w.ward_name
ORDER BY gross_revenue DESC;


-- ============================================================
-- QUERY 4: TOP 10 MOST PRESCRIBED MEDICATIONS
-- Ranks drugs by how frequently they appear across all prescriptions.
-- Modify: Add WHERE duration_days > 30 to see long-term drugs only
-- ============================================================
SELECT
    drug_name,
    COUNT(*)                           AS times_prescribed,
    SUM(units_prescribed)             AS total_units_dispensed,
    ROUND(AVG(cost_per_unit), 2)      AS avg_unit_cost,
    ROUND(SUM(units_prescribed * cost_per_unit), 2) AS total_medication_revenue
FROM medications
GROUP BY drug_name
ORDER BY times_prescribed DESC
LIMIT 10;


-- ============================================================
-- QUERY 5: PATIENT AGE DISTRIBUTION
-- Groups patients into age brackets for demographic analysis.
-- Useful for understanding the patient population composition.
-- ============================================================
SELECT
    CASE
        WHEN (strftime('%Y','now') - strftime('%Y', date_of_birth)) < 18  THEN '0-17 (Pediatric)'
        WHEN (strftime('%Y','now') - strftime('%Y', date_of_birth)) < 35  THEN '18-34 (Young Adult)'
        WHEN (strftime('%Y','now') - strftime('%Y', date_of_birth)) < 55  THEN '35-54 (Middle Age)'
        WHEN (strftime('%Y','now') - strftime('%Y', date_of_birth)) < 70  THEN '55-69 (Senior)'
        ELSE '70+ (Elderly)'
    END AS age_group,
    COUNT(*)        AS patient_count,
    SUM(CASE WHEN gender = 'Male'   THEN 1 ELSE 0 END) AS males,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS females
FROM patients
GROUP BY age_group
ORDER BY age_group;


-- ============================================================
-- QUERY 6: WARD BED OCCUPANCY RATE
-- Calculates how full each ward is (a key hospital efficiency KPI).
-- ICU occupancy > 85% = danger zone for patient safety.
-- ============================================================
SELECT
    ward_id,
    ward_name,
    ward_type,
    total_beds,
    occupied_beds,
    ROUND((occupied_beds * 100.0 / total_beds), 1) AS occupancy_pct,
    (total_beds - occupied_beds)                   AS available_beds,
    CASE
        WHEN (occupied_beds * 100.0 / total_beds) >= 90 THEN 'CRITICAL'
        WHEN (occupied_beds * 100.0 / total_beds) >= 75 THEN 'HIGH'
        WHEN (occupied_beds * 100.0 / total_beds) >= 50 THEN 'MODERATE'
        ELSE 'LOW'
    END AS capacity_status
FROM wards
ORDER BY occupancy_pct DESC;


-- ============================================================
-- QUERY 7: PAYMENT STATUS BREAKDOWN
-- Shows how many bills are Paid vs Pending vs Partial.
-- Useful for understanding the hospital's collections health.
-- ============================================================
SELECT
    payment_status,
    COUNT(*)                         AS bill_count,
    ROUND(SUM(total_amount), 2)      AS total_billed,
    ROUND(SUM(amount_paid), 2)       AS total_collected,
    ROUND(SUM(total_amount - amount_paid), 2) AS amount_outstanding,
    ROUND(AVG(total_amount), 2)      AS avg_bill_size
FROM billing
GROUP BY payment_status
ORDER BY total_billed DESC;


-- ============================================================
-- QUERY 8: MONTHLY ADMISSIONS TREND
-- Tracks patient admissions by month to detect seasonal patterns.
-- Modify: Group by week for finer granularity
-- ============================================================
SELECT
    strftime('%Y-%m', admission_date) AS admission_month,
    COUNT(*)                          AS admissions,
    SUM(CASE WHEN gender = 'Male'   THEN 1 ELSE 0 END) AS male_admissions,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_admissions,
    SUM(CASE WHEN discharge_date IS NULL THEN 1 ELSE 0 END) AS still_admitted
FROM patients
WHERE admission_date IS NOT NULL
GROUP BY admission_month
ORDER BY admission_month;


-- ============================================================
-- QUERY 9: EMERGENCY CASES WITH HIGH BILLING
-- Identifies high-cost emergency cases — useful for insurance
-- claim review and financial risk management.
-- ============================================================
SELECT
    p.first_name || ' ' || p.last_name AS patient_name,
    p.insurance_provider,
    a.diagnosis,
    a.appointment_date,
    b.total_amount,
    b.insurance_covered,
    b.amount_paid,
    (b.total_amount - b.insurance_covered - b.amount_paid) AS net_outstanding,
    b.payment_status
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN billing   b ON p.patient_id = b.patient_id
WHERE a.appointment_type = 'Emergency'
ORDER BY b.total_amount DESC;


-- ============================================================
-- QUERY 10: PATIENTS WITH MULTIPLE ADMISSIONS / DIAGNOSES
-- Finds patients who have had more than one appointment —
-- useful for chronic disease management tracking.
-- ============================================================
SELECT
    p.patient_id,
    p.first_name || ' ' || p.last_name AS patient_name,
    COUNT(a.appointment_id)            AS visit_count,
    MIN(a.appointment_date)            AS first_visit,
    MAX(a.appointment_date)            AS last_visit,
    GROUP_CONCAT(a.diagnosis, ' | ')   AS all_diagnoses
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id
HAVING COUNT(a.appointment_id) > 1
ORDER BY visit_count DESC;


-- ============================================================
-- QUERY 11: DOCTOR REVENUE CONTRIBUTION
-- Shows how much revenue each doctor's patients generate.
-- Ties financial performance to clinical performance.
-- ============================================================
SELECT
    d.first_name || ' ' || d.last_name AS doctor_name,
    d.specialization,
    COUNT(DISTINCT b.patient_id)        AS patients_treated,
    ROUND(SUM(b.total_amount), 2)       AS total_revenue_generated,
    ROUND(AVG(b.total_amount), 2)       AS avg_revenue_per_patient,
    ROUND(d.salary, 0)                  AS doctor_salary,
    ROUND(SUM(b.total_amount) / d.salary, 2) AS revenue_to_salary_ratio
FROM doctors d
JOIN patients p   ON d.doctor_id = p.primary_doctor
JOIN billing  b   ON p.patient_id = b.patient_id
GROUP BY d.doctor_id
ORDER BY total_revenue_generated DESC;


-- ============================================================
-- QUERY 12: BLOOD GROUP DISTRIBUTION AMONG PATIENTS
-- Useful for blood bank inventory planning and emergency prep.
-- ============================================================
SELECT
    blood_group,
    COUNT(*)                                AS patient_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 1) AS percentage
FROM patients
WHERE blood_group IS NOT NULL
GROUP BY blood_group
ORDER BY patient_count DESC;


-- ============================================================
-- QUERY 13: INSURANCE COVERAGE ANALYSIS BY PROVIDER
-- Shows which insurance companies are most common and their
-- average settlement coverage percentage.
-- ============================================================
SELECT
    p.insurance_provider,
    COUNT(DISTINCT p.patient_id)          AS insured_patients,
    ROUND(SUM(b.total_amount), 2)         AS total_billed,
    ROUND(SUM(b.insurance_covered), 2)    AS total_covered,
    ROUND(SUM(b.insurance_covered) * 100.0 / NULLIF(SUM(b.total_amount), 0), 1) AS coverage_pct
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
WHERE p.insurance_provider != 'None' AND p.insurance_provider IS NOT NULL
GROUP BY p.insurance_provider
ORDER BY insured_patients DESC;


-- ============================================================
-- QUERY 14: AVERAGE LENGTH OF STAY BY WARD
-- Calculates average number of days patients stay in each ward.
-- ICU and surgical wards expected to be highest.
-- ============================================================
SELECT
    w.ward_name,
    w.ward_type,
    COUNT(p.patient_id)  AS discharged_patients,
    ROUND(AVG(julianday(p.discharge_date) - julianday(p.admission_date)), 1) AS avg_stay_days,
    MIN(julianday(p.discharge_date) - julianday(p.admission_date))            AS min_stay,
    MAX(julianday(p.discharge_date) - julianday(p.admission_date))            AS max_stay
FROM patients p
JOIN wards w ON p.ward_id = w.ward_id
WHERE p.discharge_date IS NOT NULL
GROUP BY w.ward_id
ORDER BY avg_stay_days DESC;


-- ============================================================
-- QUERY 15: CITY-WISE PATIENT FOOTPRINT
-- Shows which cities/areas most patients come from.
-- Useful for marketing, outreach, and ambulance coverage.
-- ============================================================
SELECT
    city,
    COUNT(*)                          AS total_patients,
    SUM(CASE WHEN discharge_date IS NULL THEN 1 ELSE 0 END) AS currently_admitted,
    ROUND(AVG(julianday(COALESCE(discharge_date, date('now')))
              - julianday(admission_date)), 1) AS avg_stay_days,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM patients), 1) AS pct_of_total
FROM patients
GROUP BY city
ORDER BY total_patients DESC;

-- ============================================================
-- END OF PROJECT 1: HOSPITAL PATIENT MANAGEMENT DATABASE
-- Run each query block individually in DB Browser for SQLite
-- to understand what it does, then try the modifications!
-- ============================================================
