-- Step 1: Drop the existing database if it exists
DROP DATABASE IF EXISTS HospitalManagementSystem;

-- Step 2: Create the new database
CREATE DATABASE HospitalManagementSystem;

-- Step 3: Use the newly created database
USE HospitalManagementSystem;

-- 1️⃣ Department Table
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);

-- 2️⃣ Role Table
CREATE TABLE Role (
    RoleID INT PRIMARY KEY AUTO_INCREMENT,
    RoleDesc VARCHAR(100) NOT NULL UNIQUE
);

-- 3️⃣ Employee Table with enhanced data
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeNumber VARCHAR(45) NOT NULL UNIQUE,
    EmailID VARCHAR(100) NOT NULL UNIQUE,
    Password VARBINARY(255) NOT NULL,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    DateOfBirth DATE,
    DateOfJoining DATE,
    Status ENUM('Active', 'Inactive') DEFAULT 'Active',
    CreatedBy INT NULL,
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    ModifiedON DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID) ON DELETE SET NULL
);

-- 4️⃣ EmployeeDetails Table
CREATE TABLE EmployeeDetails (
    EmployeeDetailsID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT NOT NULL,
    FirstName VARCHAR(45) NOT NULL,
    LastName VARCHAR(45) NOT NULL,
    DateOfBirth DATE,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    PhoneNumber VARCHAR(20),
    RoleID INT NOT NULL,
    Address VARCHAR(255),
    NationalID VARCHAR(20),
    DateOfJoining DATE,
    Salary DECIMAL(10,2),
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    ModifiedON DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (RoleID) REFERENCES Role(RoleID)
);

-- 5️⃣ EmployeeDepartment Table
CREATE TABLE EmployeeDepartment (
    EmployeeID INT,
    DepartmentID INT,
    IsActive BIT(1) DEFAULT 1,
    PRIMARY KEY (EmployeeID, DepartmentID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE,
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);

-- 6️⃣ Patient Table with enhanced data
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    PatientRegNo VARCHAR(45) NOT NULL UNIQUE,
    FirstName VARCHAR(45) NOT NULL,
    LastName VARCHAR(45) NOT NULL,
    DateOfBirth DATE,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    PhoneNumber VARCHAR(20),
    EmailID VARCHAR(100),
    Height DECIMAL(6,2),
    Weight DECIMAL(6,2),
    BloodGroup ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'),
    EmergencyContact VARCHAR(20),
    Address VARCHAR(255),
    Allergies VARCHAR(100),
    MaritalStatus ENUM('Single', 'Married', 'Divorced'),
    Occupation VARCHAR(100),
    InsuranceStatus ENUM('Active', 'Inactive') DEFAULT 'Active',
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    ModifiedON DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 7️⃣ Disease Table with enhanced data
CREATE TABLE Disease (
    DiseaseID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT,
    Severity ENUM('Mild', 'Moderate', 'Severe'),
    Symptoms TEXT,
    Complications TEXT,
    Treatment VARCHAR(255)
);

-- 8️⃣ PatientInsurance Table
CREATE TABLE PatientInsurance (
    PatientInsuranceID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    ProviderName VARCHAR(100),
    GroupNumber VARCHAR(45),
    InsuranceNumber VARCHAR(45),
    InNetworkCoPay DECIMAL(10,2),
    OutNetworkCoPay DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE,
    IsCurrent BIT(1) DEFAULT 1,
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    ModifiedON DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE
);

-- 9️⃣ PatientRegister Table
CREATE TABLE PatientRegister (
    PatientRegisterID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT NOT NULL,
    AdmittedON DATETIME,
    DischargeON DATETIME,
    PatientInsuranceID INT,
    RoomNumber VARCHAR(45),
    CopayType VARCHAR(45),
    CreatedBy INT,
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (PatientInsuranceID) REFERENCES PatientInsurance(PatientInsuranceID),
    FOREIGN KEY (CreatedBy) REFERENCES Employee(EmployeeID)
);

-- 1️⃣0️⃣ PatientDisease Table
CREATE TABLE PatientDisease (
    PatientRegisterID INT,
    DiseaseID INT,
    PRIMARY KEY (PatientRegisterID, DiseaseID),
    FOREIGN KEY (PatientRegisterID) REFERENCES PatientRegister(PatientRegisterID) ON DELETE CASCADE,
    FOREIGN KEY (DiseaseID) REFERENCES Disease(DiseaseID)
);

-- 1️⃣1️⃣ LabTest Table
CREATE TABLE LabTest (
    LabTestID INT PRIMARY KEY AUTO_INCREMENT,
    TestName VARCHAR(100) NOT NULL,
    `MinValue` DECIMAL(5,2) NOT NULL,
    `MaxValue` DECIMAL(5,2) NOT NULL,
    CalcUnit VARCHAR(30) DEFAULT 'N/A'
);

-- 1️⃣2️⃣ PatientLabReport Table
CREATE TABLE PatientLabReport (
    PatientLabReportID INT PRIMARY KEY AUTO_INCREMENT,
    PatientRegisterID INT NOT NULL,
    LabTestID INT NOT NULL,
    TestValue VARCHAR(100),
    Comment VARCHAR(255),
    DateOfTest DATETIME,
    FOREIGN KEY (PatientRegisterID) REFERENCES PatientRegister(PatientRegisterID),
    FOREIGN KEY (LabTestID) REFERENCES LabTest(LabTestID)
);

-- 1️⃣3️⃣ Feedback Table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY AUTO_INCREMENT,
    FromPatientID INT NOT NULL,
    ToEmployeeID INT NOT NULL,
    Comment VARCHAR(255),
    Rating VARCHAR(45),
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (FromPatientID) REFERENCES Patient(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (ToEmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- 1️⃣4️⃣ Create Address Table (needed for EmployeeAddressMapping)
CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    Address1 VARCHAR(100),
    Address2 VARCHAR(100),
    City VARCHAR(50),
    Zipcode VARCHAR(10),
    State VARCHAR(50),
    Country VARCHAR(50),
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    ModifiedON DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 1️⃣5️⃣ Create EmployeeAddressMapping Table
CREATE TABLE EmployeeAddressMapping (
    EmployeeDetailsID INT,
    AddressID INT,
    IsActive BIT(1) DEFAULT 1,
    CreatedON DATETIME DEFAULT CURRENT_TIMESTAMP,
    ModifiedON DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (EmployeeDetailsID, AddressID),
    FOREIGN KEY (EmployeeDetailsID) REFERENCES EmployeeDetails(EmployeeDetailsID) ON DELETE CASCADE,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- 1️⃣6️⃣ PatientAttendant Table (Missing Table)
CREATE TABLE PatientAttendant (
    PatientRegisterID INT,
    EmployeeID INT,
    PRIMARY KEY (PatientRegisterID, EmployeeID),
    FOREIGN KEY (PatientRegisterID) REFERENCES PatientRegister(PatientRegisterID) ON DELETE CASCADE,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID) ON DELETE CASCADE
);

-- Step 4: Insert Roles into Role Table
INSERT INTO Role (RoleDesc) VALUES
('Manager'), 
('Nurse'), 
('Doctor');

-- Step 5: Insert Employees into Employee Table
INSERT INTO Employee (EmployeeNumber, EmailID, Password, FirstName, LastName, Gender, DateOfBirth, DateOfJoining, Status, CreatedBy) VALUES
('001', 'mohammed.aly@example.com', 'password123', 'Mohammed', 'Aly', 'Male', '1985-06-15', '2010-02-20', 'Active', NULL),
('002', 'mona.ahmed@example.com', 'password123', 'Mona', 'Ahmed', 'Female', '1990-03-22', '2015-06-25', 'Active', NULL),
('003', 'farah.ibrahim@example.com', 'password123', 'Farah', 'Ibrahim', 'Female', '1988-08-13', '2017-09-10', 'Active', NULL),
('004', 'dana.said@example.com', 'password123', 'Dana', 'Said', 'Female', '1992-11-03', '2018-01-15', 'Active', NULL),
('005', 'lana.mohamed@example.com', 'password123', 'Lana', 'Mohamed', 'Female', '1995-02-20', '2020-05-11', 'Active', NULL),
('006', 'ahmed.khaled@example.com', 'password123', 'Ahmed', 'Khaled', 'Male', '1984-07-10', '2011-03-12', 'Active', NULL),
('007', 'sara.fouad@example.com', 'password123', 'Sara', 'Fouad', 'Female', '1989-04-18', '2014-09-20', 'Active', NULL),
('008', 'omar.hassan@example.com', 'password123', 'Omar', 'Hassan', 'Male', '1987-01-25', '2013-07-05', 'Active', NULL),
('009', 'yasmine.gamal@example.com', 'password123', 'Yasmine', 'Gamal', 'Female', '1993-09-30', '2019-02-11', 'Active', NULL),
('010', 'nour.hani@example.com', 'password123', 'Nour', 'Hani', 'Female', '1996-12-12', '2021-06-15', 'Active', NULL),
('011', 'karim.samir@example.com', 'password123', 'Karim', 'Samir', 'Male', '1986-03-15', '2012-04-10', 'Active', NULL),
('012', 'leila.mostafa@example.com', 'password123', 'Leila', 'Mostafa', 'Female', '1991-05-05', '2016-08-20', 'Active', NULL),
('013', 'hassan.ali@example.com', 'password123', 'Hassan', 'Ali', 'Male', '1983-11-02', '2009-01-25', 'Active', NULL),
('014', 'fatma.helmy@example.com', 'password123', 'Fatma', 'Helmy', 'Female', '1990-06-09', '2015-03-30', 'Active', NULL),
('015', 'tarek.ismail@example.com', 'password123', 'Tarek', 'Ismail', 'Male', '1985-08-21', '2010-10-05', 'Active', NULL),
('016', 'dalia.kamal@example.com', 'password123', 'Dalia', 'Kamal', 'Female', '1992-10-17', '2018-07-12', 'Active', NULL),
('017', 'mohamed.fathi@example.com', 'password123', 'Mohamed', 'Fathi', 'Male', '1988-12-05', '2014-02-18', 'Active', NULL),
('018', 'salma.rashid@example.com', 'password123', 'Salma', 'Rashid', 'Female', '1994-04-22', '2020-11-09', 'Active', NULL),
('019', 'ramy.nabil@example.com', 'password123', 'Ramy', 'Nabil', 'Male', '1987-09-11', '2013-06-14', 'Active', NULL),
('020', 'amira.samir@example.com', 'password123', 'Amira', 'Samir', 'Female', '1995-01-19', '2021-03-03', 'Active', NULL),
('021', 'khaled.hosny@example.com', 'password123', 'Khaled', 'Hosny', 'Male', '1984-02-25', '2011-05-29', 'Active', NULL),
('022', 'nada.khalifa@example.com', 'password123', 'Nada', 'Khalifa', 'Female', '1990-07-07', '2015-09-16', 'Active', NULL),
('023', 'mahmoud.atef@example.com', 'password123', 'Mahmoud', 'Atef', 'Male', '1986-10-30', '2012-12-01', 'Active', NULL),
('024', 'ghada.hafez@example.com', 'password123', 'Ghada', 'Hafez', 'Female', '1991-03-13', '2016-04-27', 'Active', NULL),
('025', 'fady.mounir@example.com', 'password123', 'Fady', 'Mounir', 'Male', '1988-05-18', '2014-08-05', 'Active', NULL),
('026', 'noha.ali@example.com', 'password123', 'Noha', 'Ali', 'Female', '1993-08-24', '2019-12-19', 'Active', NULL),
('027', 'shady.hassan@example.com', 'password123', 'Shady', 'Hassan', 'Male', '1987-11-09', '2013-07-14', 'Active', NULL),
('028', 'mayar.samy@example.com', 'password123', 'Mayar', 'Samy', 'Female', '1995-12-15', '2021-05-20', 'Active', NULL),
('029', 'walid.fahmy@example.com', 'password123', 'Walid', 'Fahmy', 'Male', '1985-01-07', '2010-09-02', 'Active', NULL),
('030', 'ranya.mahmoud@example.com', 'password123', 'Ranya', 'Mahmoud', 'Female', '1992-06-28', '2018-02-10', 'Active', NULL),
('031', 'ammar.youssef@example.com', 'password123', 'Ammar', 'Youssef', 'Male', '1986-04-10', '2012-11-15', 'Active', NULL),
('032', 'merna.farouk@example.com', 'password123', 'Merna', 'Farouk', 'Female', '1990-11-22', '2015-07-18', 'Active', NULL),
('033', 'adham.saleh@example.com', 'password123', 'Adham', 'Saleh', 'Male', '1984-08-19', '2011-06-09', 'Active', NULL),
('034', 'hend.nabil@example.com', 'password123', 'Hend', 'Nabil', 'Female', '1993-01-05', '2019-03-25', 'Active', NULL),
('035', 'zeyad.omar@example.com', 'password123', 'Zeyad', 'Omar', 'Male', '1988-03-12', '2014-04-30', 'Active', NULL),
('036', 'asmaa.saber@example.com', 'password123', 'Asmaa', 'Saber', 'Female', '1994-09-08', '2020-01-22', 'Active', NULL),
('037', 'basel.nasir@example.com', 'password123', 'Basel', 'Nasir', 'Male', '1987-12-20', '2013-05-07', 'Active', NULL),
('038', 'eman.hosam@example.com', 'password123', 'Eman', 'Hosam', 'Female', '1991-06-02', '2016-10-19', 'Active', NULL),
('039', 'maged.ibrahim@example.com', 'password123', 'Maged', 'Ibrahim', 'Male', '1985-02-16', '2010-08-03', 'Active', NULL),
('040', 'salwa.kareem@example.com', 'password123', 'Salwa', 'Kareem', 'Female', '1992-05-30', '2018-09-14', 'Active', NULL),
('041', 'tamer.fathy@example.com', 'password123', 'Tamer', 'Fathy', 'Male', '1986-09-11', '2012-01-17', 'Active', NULL),
('042', 'rania.saad@example.com', 'password123', 'Rania', 'Saad', 'Female', '1990-12-25', '2015-05-05', 'Active', NULL),
('043', 'essam.adel@example.com', 'password123', 'Essam', 'Adel', 'Male', '1987-03-07', '2013-10-21', 'Active', NULL),
('044', 'manar.hosny@example.com', 'password123', 'Manar', 'Hosny', 'Female', '1993-07-14', '2019-11-28', 'Active', NULL),
('045', 'youssef.samy@example.com', 'password123', 'Youssef', 'Samy', 'Male', '1989-10-02', '2014-07-09', 'Active', NULL),
('046', 'doaa.mostafa@example.com', 'password123', 'Doaa', 'Mostafa', 'Female', '1995-03-20', '2021-04-01', 'Active', NULL),
('047', 'mohsen.rami@example.com', 'password123', 'Mohsen', 'Rami', 'Male', '1984-06-13', '2011-02-08', 'Active', NULL),
('048', 'aya.ahmed@example.com', 'password123', 'Aya', 'Ahmed', 'Female', '1991-09-26', '2016-06-18', 'Active', NULL),
('049', 'hatem.fouad@example.com', 'password123', 'Hatem', 'Fouad', 'Male', '1988-11-15', '2014-12-04', 'Active', NULL),
('050', 'rabab.khaled@example.com', 'password123', 'Rabab', 'Khaled', 'Female', '1994-02-07', '2020-07-23', 'Active', NULL),
('051', 'ibrahim.helmy@example.com', 'password123', 'Ibrahim', 'Helmy', 'Male', '1985-04-29', '2010-11-12', 'Active', NULL),
('052', 'sahar.mahmoud@example.com', 'password123', 'Sahar', 'Mahmoud', 'Female', '1992-08-03', '2018-03-30', 'Active', NULL),
('053', 'fouad.kareem@example.com', 'password123', 'Fouad', 'Kareem', 'Male', '1986-11-20', '2012-05-24', 'Active', NULL),
('054', 'sanaa.samir@example.com', 'password123', 'Sanaa', 'Samir', 'Female', '1990-01-29', '2015-08-16', 'Active', NULL),
('055', 'ramadan.atef@example.com', 'password123', 'Ramadan', 'Atef', 'Male', '1987-05-18', '2013-02-11', 'Active', NULL),
('056', 'mariam.ali@example.com', 'password123', 'Mariam', 'Ali', 'Female', '1995-10-08', '2021-09-06', 'Active', NULL),
('057', 'kareem.fathi@example.com', 'password123', 'Kareem', 'Fathi', 'Male', '1984-12-22', '2011-04-29', 'Active', NULL),
('058', 'nahed.khalifa@example.com', 'password123', 'Nahed', 'Khalifa', 'Female', '1993-06-15', '2019-01-17', 'Active', NULL),
('059', 'adel.samy@example.com', 'password123', 'Adel', 'Samy', 'Male', '1988-02-04', '2014-03-22', 'Active', NULL),
('060', 'laila.omar@example.com', 'password123', 'Laila', 'Omar', 'Female', '1991-11-11', '2016-09-27', 'Active', NULL),
('061', 'ahmad.khaled@example.com', 'password123', 'Ahmad', 'Khaled', 'Male', '1986-03-09', '2012-12-13', 'Active', NULL),
('062', 'hoda.rashid@example.com', 'password123', 'Hoda', 'Rashid', 'Female', '1990-07-05', '2015-11-02', 'Active', NULL),
('063', 'fady.samir@example.com', 'password123', 'Fady', 'Samir', 'Male', '1989-09-14', '2014-06-07', 'Active', NULL),
('064', 'nermin.hassan@example.com', 'password123', 'Nermin', 'Hassan', 'Female', '1994-12-01', '2020-02-20', 'Active', NULL),
('065', 'saif.nabil@example.com', 'password123', 'Saif', 'Nabil', 'Male', '1985-08-29', '2011-07-16', 'Active', NULL),
('066', 'yara.fouad@example.com', 'password123', 'Yara', 'Fouad', 'Female', '1992-03-27', '2018-08-03', 'Active', NULL),
('067', 'magdy.ismail@example.com', 'password123', 'Magdy', 'Ismail', 'Male', '1987-05-31', '2013-11-14', 'Active', NULL),
('068', 'lobna.helmy@example.com', 'password123', 'Lobna', 'Helmy', 'Female', '1995-01-22', '2021-03-19', 'Active', NULL),
('069', 'naser.adel@example.com', 'password123', 'Naser', 'Adel', 'Male', '1984-10-13', '2011-01-04', 'Active', NULL),
('070', 'marwa.khaled@example.com', 'password123', 'Marwa', 'Khaled', 'Female', '1993-08-17', '2019-06-21', 'Active', NULL);

-- Step 6: Insert EmployeeDetails into EmployeeDetails Table
INSERT INTO EmployeeDetails (EmployeeID, FirstName, LastName, Gender, PhoneNumber, RoleID, DateOfBirth, Address, NationalID, DateOfJoining, Salary) VALUES
(1, 'Mohammed', 'Aly', 'Male', '1234567801', 1, '1985-06-15', '1234 Elm Street, Cairo, Egypt', 'NID100001', '2010-02-20', 3000.00),
(2, 'Mona', 'Ahmed', 'Female', '1234567802', 2, '1990-03-22', '5678 Maple Avenue, Cairo, Egypt', 'NID100002', '2015-06-25', 2500.00),
(3, 'Farah', 'Ibrahim', 'Female', '1234567803', 3, '1988-08-13', '2345 Oak Lane, Cairo, Egypt', 'NID100003', '2017-09-10', 3200.00),
(4, 'Dana', 'Said', 'Female', '1234567804', 2, '1992-11-03', '3456 Pine Drive, Cairo, Egypt', 'NID100004', '2018-01-15', 2700.00),
(5, 'Lana', 'Mohamed', 'Female', '1234567805', 1, '1995-02-20', '4567 Cedar Road, Cairo, Egypt', 'NID100005', '2020-05-11', 2800.00),
(6, 'Ahmed', 'Khaled', 'Male', '1234567806', 1, '1984-07-10', '6789 Palm Street, Cairo, Egypt', 'NID100006', '2011-03-12', 3100.00),
(7, 'Sara', 'Fouad', 'Female', '1234567807', 2, '1989-04-18', '7890 Birch Lane, Cairo, Egypt', 'NID100007', '2014-09-20', 2600.00),
(8, 'Omar', 'Hassan', 'Male', '1234567808', 3, '1987-01-25', '8901 Ash Drive, Cairo, Egypt', 'NID100008', '2013-07-05', 3300.00),
(9, 'Yasmine', 'Gamal', 'Female', '1234567809', 2, '1993-09-30', '9012 Willow Way, Cairo, Egypt', 'NID100009', '2019-02-11', 2800.00),
(10, 'Nour', 'Hani', 'Female', '1234567810', 1, '1996-12-12', '1023 Fir Road, Cairo, Egypt', 'NID100010', '2021-06-15', 2900.00),
(11, 'Karim', 'Samir', 'Male', '1234567811', 1, '1986-03-15', '1235 Elm Street, Cairo, Egypt', 'NID100011', '2012-04-10', 3050.00),
(12, 'Leila', 'Mostafa', 'Female', '1234567812', 2, '1991-05-05', '5679 Maple Avenue, Cairo, Egypt', 'NID100012', '2016-08-20', 2550.00),
(13, 'Hassan', 'Ali', 'Male', '1234567813', 3, '1983-11-02', '2346 Oak Lane, Cairo, Egypt', 'NID100013', '2009-01-25', 3250.00),
(14, 'Fatma', 'Helmy', 'Female', '1234567814', 2, '1990-06-09', '3457 Pine Drive, Cairo, Egypt', 'NID100014', '2015-03-30', 2650.00),
(15, 'Tarek', 'Ismail', 'Male', '1234567815', 1, '1985-08-21', '4568 Cedar Road, Cairo, Egypt', 'NID100015', '2010-10-05', 3150.00),
(16, 'Dalia', 'Kamal', 'Female', '1234567816', 2, '1992-10-17', '6780 Palm Street, Cairo, Egypt', 'NID100016', '2018-07-12', 2700.00),
(17, 'Mohamed', 'Fathi', 'Male', '1234567817', 1, '1988-12-05', '7891 Birch Lane, Cairo, Egypt', 'NID100017', '2014-02-18', 3200.00),
(18, 'Salma', 'Rashid', 'Female', '1234567818', 2, '1994-04-22', '8902 Ash Drive, Cairo, Egypt', 'NID100018', '2020-11-09', 2750.00),
(19, 'Ramy', 'Nabil', 'Male', '1234567819', 3, '1987-09-11', '9013 Willow Way, Cairo, Egypt', 'NID100019', '2013-06-14', 3300.00),
(20, 'Amira', 'Samir', 'Female', '1234567820', 2, '1995-01-19', '1024 Fir Road, Cairo, Egypt', 'NID100020', '2021-03-03', 2850.00),
(21, 'Khaled', 'Hosny', 'Male', '1234567821', 1, '1984-02-25', '1236 Elm Street, Cairo, Egypt', 'NID100021', '2011-05-29', 3000.00),
(22, 'Nada', 'Khalifa', 'Female', '1234567822', 2, '1990-07-07', '5680 Maple Avenue, Cairo, Egypt', 'NID100022', '2015-09-16', 2500.00),
(23, 'Mahmoud', 'Atef', 'Male', '1234567823', 3, '1986-10-30', '2347 Oak Lane, Cairo, Egypt', 'NID100023', '2012-12-01', 3200.00),
(24, 'Ghada', 'Hafez', 'Female', '1234567824', 2, '1991-03-13', '3458 Pine Drive, Cairo, Egypt', 'NID100024', '2016-04-27', 2700.00),
(25, 'Fady', 'Mounir', 'Male', '1234567825', 1, '1988-05-18', '4569 Cedar Road, Cairo, Egypt', 'NID100025', '2014-08-05', 2800.00),
(26, 'Noha', 'Ali', 'Female', '1234567826', 2, '1993-08-24', '6781 Palm Street, Cairo, Egypt', 'NID100026', '2019-12-19', 2900.00),
(27, 'Shady', 'Hassan', 'Male', '1234567827', 3, '1987-11-09', '7892 Birch Lane, Cairo, Egypt', 'NID100027', '2013-07-14', 3350.00),
(28, 'Mayar', 'Samy', 'Female', '1234567828', 2, '1995-12-15', '8903 Ash Drive, Cairo, Egypt', 'NID100028', '2021-05-20', 2950.00),
(29, 'Walid', 'Fahmy', 'Male', '1234567829', 1, '1985-01-07', '9014 Willow Way, Cairo, Egypt', 'NID100029', '2010-09-02', 3050.00),
(30, 'Ranya', 'Mahmoud', 'Female', '1234567830', 2, '1992-06-28', '1025 Fir Road, Cairo, Egypt', 'NID100030', '2018-02-10', 2700.00),
(31, 'Ammar', 'Youssef', 'Male', '1234567831', 1, '1986-04-10', '1237 Elm Street, Cairo, Egypt', 'NID100031', '2012-11-15', 3100.00),
(32, 'Merna', 'Farouk', 'Female', '1234567832', 2, '1990-11-22', '5681 Maple Avenue, Cairo, Egypt', 'NID100032', '2015-07-18', 2600.00),
(33, 'Adham', 'Saleh', 'Male', '1234567833', 3, '1984-08-19', '2348 Oak Lane, Cairo, Egypt', 'NID100033', '2011-06-09', 3200.00),
(34, 'Hend', 'Nabil', 'Female', '1234567834', 2, '1993-01-05', '3459 Pine Drive, Cairo, Egypt', 'NID100034', '2019-03-25', 2750.00),
(35, 'Zeyad', 'Omar', 'Male', '1234567835', 1, '1988-03-12', '4570 Cedar Road, Cairo, Egypt', 'NID100035', '2014-04-30', 3150.00),
(36, 'Asmaa', 'Saber', 'Female', '1234567836', 2, '1994-09-08', '6782 Palm Street, Cairo, Egypt', 'NID100036', '2020-01-22', 2800.00),
(37, 'Basel', 'Nasir', 'Male', '1234567837', 3, '1987-12-20', '7893 Birch Lane, Cairo, Egypt', 'NID100037', '2013-05-07', 3300.00),
(38, 'Eman', 'Hosam', 'Female', '1234567838', 2, '1991-06-02', '8904 Ash Drive, Cairo, Egypt', 'NID100038', '2016-10-19', 2700.00),
(39, 'Maged', 'Ibrahim', 'Male', '1234567839', 1, '1985-02-16', '9015 Willow Way, Cairo, Egypt', 'NID100039', '2010-08-03', 3000.00),
(40, 'Salwa', 'Kareem', 'Female', '1234567840', 2, '1992-05-30', '1026 Fir Road, Cairo, Egypt', 'NID100040', '2018-09-14', 2650.00),
(41, 'Tamer', 'Fathy', 'Male', '1234567841', 1, '1986-09-11', '1238 Elm Street, Cairo, Egypt', 'NID100041', '2012-01-17', 3100.00),
(42, 'Rania', 'Saad', 'Female', '1234567842', 2, '1990-12-25', '5682 Maple Avenue, Cairo, Egypt', 'NID100042', '2015-05-05', 2600.00),
(43, 'Essam', 'Adel', 'Male', '1234567843', 3, '1987-03-07', '2349 Oak Lane, Cairo, Egypt', 'NID100043', '2013-10-21', 3200.00),
(44, 'Manar', 'Hosny', 'Female', '1234567844', 2, '1993-07-14', '3460 Pine Drive, Cairo, Egypt', 'NID100044', '2019-11-28', 2750.00),
(45, 'Youssef', 'Samy', 'Male', '1234567845', 1, '1989-10-02', '4571 Cedar Road, Cairo, Egypt', 'NID100045', '2014-07-09', 3150.00),
(46, 'Doaa', 'Mostafa', 'Female', '1234567846', 2, '1995-03-20', '6783 Palm Street, Cairo, Egypt', 'NID100046', '2021-04-01', 2800.00),
(47, 'Mohsen', 'Rami', 'Male', '1234567847', 3, '1984-06-13', '7894 Birch Lane, Cairo, Egypt', 'NID100047', '2011-02-08', 3300.00),
(48, 'Aya', 'Ahmed', 'Female', '1234567848', 2, '1991-09-26', '8905 Ash Drive, Cairo, Egypt', 'NID100048', '2016-06-18', 2700.00),
(49, 'Hatem', 'Fouad', 'Male', '1234567849', 1, '1988-11-15', '9016 Willow Way, Cairo, Egypt', 'NID100049', '2014-12-04', 3000.00),
(50, 'Rabab', 'Khaled', 'Female', '1234567850', 2, '1994-02-07', '1027 Fir Road, Cairo, Egypt', 'NID100050', '2020-07-23', 2650.00),
(51, 'Ibrahim', 'Helmy', 'Male', '1234567851', 1, '1985-04-29', '1239 Elm Street, Cairo, Egypt', 'NID100051', '2010-11-12', 3100.00),
(52, 'Sahar', 'Mahmoud', 'Female', '1234567852', 2, '1992-08-03', '5683 Maple Avenue, Cairo, Egypt', 'NID100052', '2018-03-30', 2600.00),
(53, 'Fouad', 'Kareem', 'Male', '1234567853', 3, '1986-11-20', '2350 Oak Lane, Cairo, Egypt', 'NID100053', '2012-05-24', 3200.00),
(54, 'Sanaa', 'Samir', 'Female', '1234567854', 2, '1990-01-29', '3461 Pine Drive, Cairo, Egypt', 'NID100054', '2015-08-16', 2750.00),
(55, 'Ramadan', 'Atef', 'Male', '1234567855', 1, '1987-05-18', '4572 Cedar Road, Cairo, Egypt', 'NID100055', '2013-02-11', 3150.00),
(56, 'Mariam', 'Ali', 'Female', '1234567856', 2, '1995-10-08', '6784 Palm Street, Cairo, Egypt', 'NID100056', '2021-09-06', 2800.00),
(57, 'Kareem', 'Fathi', 'Male', '1234567857', 3, '1984-12-22', '7895 Birch Lane, Cairo, Egypt', 'NID100057', '2011-04-29', 3300.00),
(58, 'Nahed', 'Khalifa', 'Female', '1234567858', 2, '1993-06-15', '8906 Ash Drive, Cairo, Egypt', 'NID100058', '2019-01-17', 2700.00),
(59, 'Adel', 'Samy', 'Male', '1234567859', 1, '1988-02-04', '9017 Willow Way, Cairo, Egypt', 'NID100059', '2014-03-22', 3000.00),
(60, 'Laila', 'Omar', 'Female', '1234567860', 2, '1991-11-11', '1028 Fir Road, Cairo, Egypt', 'NID100060', '2016-09-27', 2650.00),
(61, 'Ahmad', 'Khaled', 'Male', '1234567861', 1, '1986-03-09', '1240 Elm Street, Cairo, Egypt', 'NID100061', '2012-12-13', 3100.00),
(62, 'Hoda', 'Rashid', 'Female', '1234567862', 2, '1990-07-05', '5684 Maple Avenue, Cairo, Egypt', 'NID100062', '2015-11-02', 2600.00),
(63, 'Fady', 'Samir', 'Male', '1234567863', 3, '1989-09-14', '2351 Oak Lane, Cairo, Egypt', 'NID100063', '2014-06-07', 3200.00),
(64, 'Nermin', 'Hassan', 'Female', '1234567864', 2, '1994-12-01', '3462 Pine Drive, Cairo, Egypt', 'NID100064', '2020-02-20', 2750.00),
(65, 'Saif', 'Nabil', 'Male', '1234567865', 1, '1985-08-29', '4573 Cedar Road, Cairo, Egypt', 'NID100065', '2011-07-16', 3150.00),
(66, 'Yara', 'Fouad', 'Female', '1234567866', 2, '1992-03-27', '6785 Palm Street, Cairo, Egypt', 'NID100066', '2018-08-03', 2800.00),
(67, 'Magdy', 'Ismail', 'Male', '1234567867', 3, '1987-05-31', '7896 Birch Lane, Cairo, Egypt', 'NID100067', '2013-11-14', 3300.00),
(68, 'Lobna', 'Helmy', 'Female', '1234567868', 2, '1995-01-22', '8907 Ash Drive, Cairo, Egypt', 'NID100068', '2021-03-19', 2700.00),
(69, 'Naser', 'Adel', 'Male', '1234567869', 1, '1984-10-13', '9018 Willow Way, Cairo, Egypt', 'NID100069', '2011-01-04', 3000.00),
(70, 'Marwa', 'Khaled', 'Female', '1234567870', 2, '1993-08-17', '1029 Fir Road, Cairo, Egypt', 'NID100070', '2019-06-21', 2650.00);



-- Step 7: Insert Patients into Patient Table
INSERT INTO Patient (PatientRegNo, FirstName, LastName, Gender, PhoneNumber, EmailID, Height, Weight, BloodGroup, EmergencyContact, Address, Allergies, MaritalStatus, Occupation, InsuranceStatus) 
VALUES
('P001', 'Mohammed', 'Aly', 'Male', '1234567801', 'mohammed.aly@example.com', 175, 70, 'O+', '123-456-7801', '1234 Elm Street, Cairo, Egypt', 'None', 'Single', 'Engineer', 'Active'),
('P002', 'Mona', 'Ahmed', 'Female', '1234567802', 'mona.ahmed@example.com', 160, 55, 'A+', '123-456-7802', '5678 Maple Avenue, Cairo, Egypt', 'Peanuts', 'Married', 'Teacher', 'Active'),
('P003', 'Farah', 'Ibrahim', 'Female', '1234567803', 'farah.ibrahim@example.com', 165, 60, 'B+', '123-456-7803', '2345 Oak Lane, Cairo, Egypt', 'Penicillin', 'Single', 'Artist', 'Active'),
('P004', 'Dana', 'Said', 'Female', '1234567804', 'dana.said@example.com', 170, 65, 'AB+', '123-456-7804', '3456 Pine Drive, Cairo, Egypt', 'None', 'Married', 'Doctor', 'Active'),
('P005', 'Lana', 'Mohamed', 'Female', '1234567805', 'lana.mohamed@example.com', 160, 50, 'O-', '123-456-7805', '4567 Cedar Road, Cairo, Egypt', 'Shellfish', 'Single', 'Nurse', 'Active'),
('P006', 'Ahmed', 'Khaled', 'Male', '1234567806', 'ahmed.khaled@example.com', 180, 75, 'A-', '123-456-7806', '6789 Palm Street, Cairo, Egypt', 'None', 'Married', 'Engineer', 'Active'),
('P007', 'Sara', 'Fouad', 'Female', '1234567807', 'sara.fouad@example.com', 158, 53, 'B-', '123-456-7807', '7890 Birch Lane, Cairo, Egypt', 'Gluten', 'Single', 'Accountant', 'Active'),
('P008', 'Omar', 'Hassan', 'Male', '1234567808', 'omar.hassan@example.com', 172, 68, 'O+', '123-456-7808', '8901 Ash Drive, Cairo, Egypt', 'None', 'Married', 'Pilot', 'Active'),
('P009', 'Yasmine', 'Gamal', 'Female', '1234567809', 'yasmine.gamal@example.com', 164, 58, 'A+', '123-456-7809', '9012 Willow Way, Cairo, Egypt', 'None', 'Single', 'Designer', 'Active'),
('P010', 'Nour', 'Hani', 'Female', '1234567810', 'nour.hani@example.com', 162, 54, 'B+', '123-456-7810', '1023 Fir Road, Cairo, Egypt', 'Dust', 'Single', 'Nurse', 'Active'),
('P011', 'Karim', 'Samir', 'Male', '1234567811', 'karim.samir@example.com', 178, 72, 'O-', '123-456-7811', '1235 Elm Street, Cairo, Egypt', 'None', 'Married', 'Teacher', 'Active'),
('P012', 'Leila', 'Mostafa', 'Female', '1234567812', 'leila.mostafa@example.com', 159, 55, 'AB-', '123-456-7812', '5679 Maple Avenue, Cairo, Egypt', 'None', 'Single', 'Doctor', 'Active'),
('P013', 'Hassan', 'Ali', 'Male', '1234567813', 'hassan.ali@example.com', 170, 69, 'A+', '123-456-7813', '2346 Oak Lane, Cairo, Egypt', 'Pollen', 'Married', 'Engineer', 'Active'),
('P014', 'Fatma', 'Helmy', 'Female', '1234567814', 'fatma.helmy@example.com', 161, 56, 'B+', '123-456-7814', '3457 Pine Drive, Cairo, Egypt', 'None', 'Married', 'Pharmacist', 'Active'),
('P015', 'Tarek', 'Ismail', 'Male', '1234567815', 'tarek.ismail@example.com', 177, 74, 'O+', '123-456-7815', '4568 Cedar Road, Cairo, Egypt', 'None', 'Single', 'Pilot', 'Active'),
('P016', 'Dalia', 'Kamal', 'Female', '1234567816', 'dalia.kamal@example.com', 163, 57, 'A-', '123-456-7816', '6780 Palm Street, Cairo, Egypt', 'Nuts', 'Single', 'Artist', 'Active'),
('P017', 'Mohamed', 'Fathi', 'Male', '1234567817', 'mohamed.fathi@example.com', 174, 71, 'B-', '123-456-7817', '7891 Birch Lane, Cairo, Egypt', 'None', 'Married', 'Doctor', 'Active'),
('P018', 'Salma', 'Rashid', 'Female', '1234567818', 'salma.rashid@example.com', 160, 52, 'O+', '123-456-7818', '8902 Ash Drive, Cairo, Egypt', 'Penicillin', 'Single', 'Nurse', 'Active'),
('P019', 'Ramy', 'Nabil', 'Male', '1234567819', 'ramy.nabil@example.com', 176, 73, 'A+', '123-456-7819', '9013 Willow Way, Cairo, Egypt', 'None', 'Married', 'Engineer', 'Active'),
('P020', 'Amira', 'Samir', 'Female', '1234567820', 'amira.samir@example.com', 158, 51, 'B+', '123-456-7820', '1024 Fir Road, Cairo, Egypt', 'Gluten', 'Married', 'Teacher', 'Active'),
('P021', 'Khaled', 'Hosny', 'Male', '1234567821', 'khaled.hosny@example.com', 175, 70, 'O-', '123-456-7821', '1236 Elm Street, Cairo, Egypt', 'None', 'Single', 'Pharmacist', 'Active'),
('P022', 'Nada', 'Khalifa', 'Female', '1234567822', 'nada.khalifa@example.com', 160, 55, 'AB+', '123-456-7822', '5680 Maple Avenue, Cairo, Egypt', 'None', 'Single', 'Doctor', 'Active'),
('P023', 'Mahmoud', 'Atef', 'Male', '1234567823', 'mahmoud.atef@example.com', 172, 68, 'B-', '123-456-7823', '2347 Oak Lane, Cairo, Egypt', 'Peanuts', 'Married', 'Engineer', 'Active'),
('P024', 'Ghada', 'Hafez', 'Female', '1234567824', 'ghada.hafez@example.com', 165, 60, 'O+', '123-456-7824', '3458 Pine Drive, Cairo, Egypt', 'None', 'Married', 'Nurse', 'Active'),
('P025', 'Fady', 'Mounir', 'Male', '1234567825', 'fady.mounir@example.com', 173, 69, 'A+', '123-456-7825', '4569 Cedar Road, Cairo, Egypt', 'Dust', 'Single', 'Artist', 'Active'),
('P026', 'Noha', 'Ali', 'Female', '1234567826', 'noha.ali@example.com', 162, 54, 'B+', '123-456-7826', '6781 Palm Street, Cairo, Egypt', 'None', 'Single', 'Teacher', 'Active'),
('P027', 'Shady', 'Hassan', 'Male', '1234567827', 'shady.hassan@example.com', 176, 74, 'O-', '123-456-7827', '7892 Birch Lane, Cairo, Egypt', 'Pollen', 'Married', 'Engineer', 'Active'),
('P028', 'Mayar', 'Samy', 'Female', '1234567828', 'mayar.samy@example.com', 159, 52, 'A-', '123-456-7828', '8903 Ash Drive, Cairo, Egypt', 'None', 'Single', 'Nurse', 'Active'),
('P029', 'Walid', 'Fahmy', 'Male', '1234567829', 'walid.fahmy@example.com', 174, 72, 'B+', '123-456-7829', '9014 Willow Way, Cairo, Egypt', 'None', 'Single', 'Doctor', 'Active'),
('P030', 'Ranya', 'Mahmoud', 'Female', '1234567830', 'ranya.mahmoud@example.com', 164, 58, 'O+', '123-456-7830', '1025 Fir Road, Cairo, Egypt', 'Shellfish', 'Married', 'Pharmacist', 'Active'),
('P031', 'Ammar', 'Youssef', 'Male', '1234567831', 'ammar.youssef@example.com', 177, 75, 'A+', '123-456-7831', '1237 Elm Street, Cairo, Egypt', 'Gluten', 'Single', 'Engineer', 'Active'),
('P032', 'Merna', 'Farouk', 'Female', '1234567832', 'merna.farouk@example.com', 161, 56, 'B-', '123-456-7832', '5681 Maple Avenue, Cairo, Egypt', 'None', 'Married', 'Teacher', 'Active'),
('P033', 'Adham', 'Saleh', 'Male', '1234567833', 'adham.saleh@example.com', 173, 70, 'O+', '123-456-7833', '2348 Oak Lane, Cairo, Egypt', 'Dust', 'Single', 'Artist', 'Active'),
('P034', 'Hend', 'Nabil', 'Female', '1234567834', 'hend.nabil@example.com', 158, 51, 'A-', '123-456-7834', '3459 Pine Drive, Cairo, Egypt', 'None', 'Married', 'Nurse', 'Active'),
('P035', 'Zeyad', 'Omar', 'Male', '1234567835', 'zeyad.omar@example.com', 170, 68, 'B+', '123-456-7835', '4570 Cedar Road, Cairo, Egypt', 'Peanuts', 'Single', 'Engineer', 'Active'),
('P036', 'Asmaa', 'Saber', 'Female', '1234567836', 'asmaa.saber@example.com', 160, 54, 'O-', '123-456-7836', '6782 Palm Street, Cairo, Egypt', 'None', 'Married', 'Doctor', 'Active'),
('P037', 'Basel', 'Nasir', 'Male', '1234567837', 'basel.nasir@example.com', 175, 71, 'A+', '123-456-7837', '7893 Birch Lane, Cairo, Egypt', 'None', 'Single', 'Pilot', 'Active'),
('P038', 'Eman', 'Hosam', 'Female', '1234567838', 'eman.hosam@example.com', 162, 55, 'B+', '123-456-7838', '8904 Ash Drive, Cairo, Egypt', 'Penicillin', 'Single', 'Teacher', 'Active'),
('P039', 'Maged', 'Ibrahim', 'Male', '1234567839', 'maged.ibrahim@example.com', 178, 74, 'O-', '123-456-7839', '9015 Willow Way, Cairo, Egypt', 'None', 'Married', 'Doctor', 'Active'),
('P040', 'Salwa', 'Kareem', 'Female', '1234567840', 'salwa.kareem@example.com', 159, 52, 'AB+', '123-456-7840', '1026 Fir Road, Cairo, Egypt', 'Shellfish', 'Single', 'Nurse', 'Active'),
('P041', 'Tamer', 'Fathy', 'Male', '1234567841', 'tamer.fathy@example.com', 174, 70, 'A-', '123-456-7841', '1238 Elm Street, Cairo, Egypt', 'None', 'Single', 'Artist', 'Active'),
('P042', 'Rania', 'Saad', 'Female', '1234567842', 'rania.saad@example.com', 163, 57, 'B-', '123-456-7842', '5682 Maple Avenue, Cairo, Egypt', 'Peanuts', 'Married', 'Pharmacist', 'Active'),
('P043', 'Essam', 'Adel', 'Male', '1234567843', 'essam.adel@example.com', 176, 72, 'O+', '123-456-7843', '2349 Oak Lane, Cairo, Egypt', 'None', 'Single', 'Doctor', 'Active'),
('P044', 'Manar', 'Hosny', 'Female', '1234567844', 'manar.hosny@example.com', 161, 56, 'A+', '123-456-7844', '3460 Pine Drive, Cairo, Egypt', 'Pollen', 'Single', 'Teacher', 'Active'),
('P045', 'Youssef', 'Samy', 'Male', '1234567845', 'youssef.samy@example.com', 173, 70, 'B+', '123-456-7845', '4571 Cedar Road, Cairo, Egypt', 'None', 'Married', 'Pilot', 'Active'),
('P046', 'Doaa', 'Mostafa', 'Female', '1234567846', 'doaa.mostafa@example.com', 160, 54, 'O-', '123-456-7846', '6783 Palm Street, Cairo, Egypt', 'None', 'Married', 'Engineer', 'Active'),
('P047', 'Mohsen', 'Rami', 'Male', '1234567847', 'mohsen.rami@example.com', 177, 75, 'A-', '123-456-7847', '7894 Birch Lane, Cairo, Egypt', 'Gluten', 'Single', 'Artist', 'Active'),
('P048', 'Aya', 'Ahmed', 'Female', '1234567848', 'aya.ahmed@example.com', 158, 52, 'B+', '123-456-7848', '8905 Ash Drive, Cairo, Egypt', 'None', 'Single', 'Nurse', 'Active'),
('P049', 'Hatem', 'Fouad', 'Male', '1234567849', 'hatem.fouad@example.com', 175, 71, 'O+', '123-456-7849', '9016 Willow Way, Cairo, Egypt', 'None', 'Married', 'Doctor', 'Active'),
('P050', 'Rabab', 'Khaled', 'Female', '1234567850', 'rabab.khaled@example.com', 161, 56, 'A+', '123-456-7850', '1027 Fir Road, Cairo, Egypt', 'Shellfish', 'Married', 'Pharmacist', 'Active'),
('P051', 'Ibrahim', 'Helmy', 'Male', '1234567851', 'ibrahim.helmy@example.com', 172, 69, 'B-', '123-456-7851', '1239 Elm Street, Cairo, Egypt', 'None', 'Single', 'Engineer', 'Active'),
('P052', 'Sahar', 'Mahmoud', 'Female', '1234567852', 'sahar.mahmoud@example.com', 160, 54, 'O+', '123-456-7852', '5683 Maple Avenue, Cairo, Egypt', 'Penicillin', 'Single', 'Doctor', 'Active'),
('P053', 'Fouad', 'Kareem', 'Male', '1234567853', 'fouad.kareem@example.com', 175, 70, 'A+', '123-456-7853', '2350 Oak Lane, Cairo, Egypt', 'None', 'Married', 'Pilot', 'Active'),
('P054', 'Sanaa', 'Samir', 'Female', '1234567854', 'sanaa.samir@example.com', 159, 53, 'B+', '123-456-7854', '3461 Pine Drive, Cairo, Egypt', 'Peanuts', 'Single', 'Nurse', 'Active'),
('P055', 'Ramadan', 'Atef', 'Male', '1234567855', 'ramadan.atef@example.com', 177, 74, 'O-', '123-456-7855', '4572 Cedar Road, Cairo, Egypt', 'None', 'Married', 'Engineer', 'Active'),
('P056', 'Mariam', 'Ali', 'Female', '1234567856', 'mariam.ali@example.com', 160, 55, 'A-', '123-456-7856', '6784 Palm Street, Cairo, Egypt', 'None', 'Married', 'Teacher', 'Active'),
('P057', 'Kareem', 'Fathi', 'Male', '1234567857', 'kareem.fathi@example.com', 174, 70, 'B-', '123-456-7857', '7895 Birch Lane, Cairo, Egypt', 'None', 'Single', 'Doctor', 'Active'),
('P058', 'Nahed', 'Khalifa', 'Female', '1234567858', 'nahed.khalifa@example.com', 163, 57, 'O+', '123-456-7858', '8906 Ash Drive, Cairo, Egypt', 'Gluten', 'Single', 'Nurse', 'Active'),
('P059', 'Adel', 'Samy', 'Male', '1234567859', 'adel.samy@example.com', 175, 72, 'A+', '123-456-7859', '9017 Willow Way, Cairo, Egypt', 'None', 'Married', 'Pilot', 'Active'),
('P060', 'Laila', 'Omar', 'Female', '1234567860', 'laila.omar@example.com', 161, 55, 'B+', '123-456-7860', '1028 Fir Road, Cairo, Egypt', 'Nuts', 'Married', 'Pharmacist', 'Active');



-- Step 8: Insert PatientInsurance into PatientInsurance Table 
INSERT INTO PatientInsurance  (PatientID, ProviderName, GroupNumber, InsuranceNumber, InNetworkCoPay, OutNetworkCoPay, StartDate, EndDate, IsCurrent) 
VALUES
(1, 'Misr Insurance', 'M001', 'INS10001', 20, 50, '2023-01-01', '2024-01-01', 1),
(2, 'Al-Ahly Insurance', 'A001', 'INS10002', 25, 55, '2023-02-01', '2024-02-01', 1),
(3, 'GIG Egypt', 'G001', 'INS10003', 30, 60, '2023-03-01', '2024-03-01', 1),
(4, 'Cairo Health', 'C001', 'INS10004', 40, 70, '2023-04-01', '2024-04-01', 1),
(5, 'Global Health', 'G002', 'INS10005', 35, 65, '2023-05-01', '2024-05-01', 1),
(6, 'Misr Insurance', 'M001', 'INS10006', 20, 50, '2023-06-01', '2024-06-01', 1),
(7, 'Al-Ahly Insurance', 'A001', 'INS10007', 25, 55, '2023-07-01', '2024-07-01', 1),
(8, 'GIG Egypt', 'G001', 'INS10008', 30, 60, '2023-08-01', '2024-08-01', 1),
(9, 'Cairo Health', 'C001', 'INS10009', 40, 70, '2023-09-01', '2024-09-01', 1),
(10, 'Global Health', 'G002', 'INS10010', 35, 65, '2023-10-01', '2024-10-01', 1),
(11, 'Misr Insurance', 'M001', 'INS10011', 20, 50, '2023-11-01', '2024-11-01', 1),
(12, 'Al-Ahly Insurance', 'A001', 'INS10012', 25, 55, '2023-12-01', '2024-12-01', 1),
(13, 'GIG Egypt', 'G001', 'INS10013', 30, 60, '2023-01-01', '2024-01-01', 1),
(14, 'Cairo Health', 'C001', 'INS10014', 40, 70, '2023-02-01', '2024-02-01', 1),
(15, 'Global Health', 'G002', 'INS10015', 35, 65, '2023-03-01', '2024-03-01', 1),
(16, 'Misr Insurance', 'M001', 'INS10016', 20, 50, '2023-04-01', '2024-04-01', 1),
(17, 'Al-Ahly Insurance', 'A001', 'INS10017', 25, 55, '2023-05-01', '2024-05-01', 1),
(18, 'GIG Egypt', 'G001', 'INS10018', 30, 60, '2023-06-01', '2024-06-01', 1),
(19, 'Cairo Health', 'C001', 'INS10019', 40, 70, '2023-07-01', '2024-07-01', 1),
(20, 'Global Health', 'G002', 'INS10020', 35, 65, '2023-08-01', '2024-08-01', 1),
(21, 'Misr Insurance', 'M001', 'INS10021', 20, 50, '2023-09-01', '2024-09-01', 1),
(22, 'Al-Ahly Insurance', 'A001', 'INS10022', 25, 55, '2023-10-01', '2024-10-01', 1),
(23, 'GIG Egypt', 'G001', 'INS10023', 30, 60, '2023-11-01', '2024-11-01', 1),
(24, 'Cairo Health', 'C001', 'INS10024', 40, 70, '2023-12-01', '2024-12-01', 1),
(25, 'Global Health', 'G002', 'INS10025', 35, 65, '2024-01-01', '2025-01-01', 1),
(26, 'Misr Insurance', 'M001', 'INS10026', 20, 50, '2024-02-01', '2025-02-01', 1),
(27, 'Al-Ahly Insurance', 'A001', 'INS10027', 25, 55, '2024-03-01', '2025-03-01', 1),
(28, 'GIG Egypt', 'G001', 'INS10028', 30, 60, '2024-04-01', '2025-04-01', 1),
(29, 'Cairo Health', 'C001', 'INS10029', 40, 70, '2024-05-01', '2025-05-01', 1),
(30, 'Global Health', 'G002', 'INS10030', 35, 65, '2024-06-01', '2025-06-01', 1),
(31, 'Misr Insurance', 'M001', 'INS10031', 20, 50, '2024-07-01', '2025-07-01', 1),
(32, 'Al-Ahly Insurance', 'A001', 'INS10032', 25, 55, '2024-08-01', '2025-08-01', 1),
(33, 'GIG Egypt', 'G001', 'INS10033', 30, 60, '2024-09-01', '2025-09-01', 1),
(34, 'Cairo Health', 'C001', 'INS10034', 40, 70, '2024-10-01', '2025-10-01', 1),
(35, 'Global Health', 'G002', 'INS10035', 35, 65, '2024-11-01', '2025-11-01', 1),
(36, 'Misr Insurance', 'M001', 'INS10036', 20, 50, '2024-12-01', '2025-12-01', 1),
(37, 'Al-Ahly Insurance', 'A001', 'INS10037', 25, 55, '2025-01-01', '2026-01-01', 1),
(38, 'GIG Egypt', 'G001', 'INS10038', 30, 60, '2025-02-01', '2026-02-01', 1),
(39, 'Cairo Health', 'C001', 'INS10039', 40, 70, '2025-03-01', '2026-03-01', 1),
(40, 'Global Health', 'G002', 'INS10040', 35, 65, '2025-04-01', '2026-04-01', 1),
(41, 'Misr Insurance', 'M001', 'INS10041', 20, 50, '2025-05-01', '2026-05-01', 1),
(42, 'Al-Ahly Insurance', 'A001', 'INS10042', 25, 55, '2025-06-01', '2026-06-01', 1),
(43, 'GIG Egypt', 'G001', 'INS10043', 30, 60, '2025-07-01', '2026-07-01', 1),
(44, 'Cairo Health', 'C001', 'INS10044', 40, 70, '2025-08-01', '2026-08-01', 1),
(45, 'Global Health', 'G002', 'INS10045', 35, 65, '2025-09-01', '2026-09-01', 1),
(46, 'Misr Insurance', 'M001', 'INS10046', 20, 50, '2025-10-01', '2026-10-01', 1),
(47, 'Al-Ahly Insurance', 'A001', 'INS10047', 25, 55, '2025-11-01', '2026-11-01', 1),
(48, 'GIG Egypt', 'G001', 'INS10048', 30, 60, '2025-12-01', '2026-12-01', 1),
(49, 'Cairo Health', 'C001', 'INS10049', 40, 70, '2026-01-01', '2027-01-01', 1),
(50, 'Global Health', 'G002', 'INS10050', 35, 65, '2026-02-01', '2027-02-01', 1),
(51, 'Misr Insurance', 'M001', 'INS10051', 20, 50, '2026-03-01', '2027-03-01', 1),
(52, 'Al-Ahly Insurance', 'A001', 'INS10052', 25, 55, '2026-04-01', '2027-04-01', 1),
(53, 'GIG Egypt', 'G001', 'INS10053', 30, 60, '2026-05-01', '2027-05-01', 1),
(54, 'Cairo Health', 'C001', 'INS10054', 40, 70, '2026-06-01', '2027-06-01', 1),
(55, 'Global Health', 'G002', 'INS10055', 35, 65, '2026-07-01', '2027-07-01', 1),
(56, 'Misr Insurance', 'M001', 'INS10056', 20, 50, '2026-08-01', '2027-08-01', 1),
(57, 'Al-Ahly Insurance', 'A001', 'INS10057', 25, 55, '2026-09-01', '2027-09-01', 1),
(58, 'GIG Egypt', 'G001', 'INS10058', 30, 60, '2026-10-01', '2027-10-01', 1),
(59, 'Cairo Health', 'C001', 'INS10059', 40, 70, '2026-11-01', '2027-11-01', 1),
(60, 'Global Health', 'G002', 'INS10060', 35, 65, '2026-12-01', '2027-12-01', 1);

-- Step 9: Insert Diseases into Disease Table 
INSERT INTO Disease (Name, Description, Severity, Symptoms, Complications, Treatment)
VALUES
('Anemia', 'A condition where you lack enough healthy red blood cells', 'Mild', 'Fatigue, Weakness', 'Heart problems', 'Iron supplements, Diet changes'),
('Arthritis', 'Inflammation of one or more joints', 'Moderate', 'Joint pain, Stiffness', 'Joint damage', 'Painkillers, Physical therapy'),
('Bronchitis', 'Inflammation of the bronchial tubes', 'Mild', 'Cough, Mucus production', 'Chronic bronchitis', 'Rest, Cough medicine'),
('COVID-19', 'Infectious disease caused by coronavirus', 'Severe', 'Fever, Cough, Loss of taste', 'Respiratory failure', 'Supportive care, Antivirals'),
('Dengue', 'Mosquito-borne viral infection', 'Moderate', 'High fever, Rash', 'Bleeding, Shock', 'Fluids, Pain relief'),
('Epilepsy', 'Neurological disorder causing seizures', 'Moderate', 'Seizures, Confusion', 'Injury, Status epilepticus', 'Antiepileptic drugs'),
('Gallstones', 'Solid particles that form in the gallbladder', 'Mild', 'Abdominal pain, Nausea', 'Gallbladder infection', 'Surgery, Medication'),
('Gastritis', 'Inflammation of the stomach lining', 'Mild', 'Stomach pain, Nausea', 'Ulcers, Bleeding', 'Antacids, Diet change'),
('Glaucoma', 'Eye condition damaging the optic nerve', 'Moderate', 'Vision loss, Eye pain', 'Blindness', 'Eye drops, Surgery'),
('Hepatitis B', 'Liver infection caused by the hepatitis B virus', 'Moderate', 'Jaundice, Fatigue', 'Liver failure, Cancer', 'Antiviral drugs'),
('Hernia', 'Organ pushing through an opening in muscle or tissue', 'Mild', 'Bulge, Pain', 'Obstruction, Strangulation', 'Surgery'),
('Influenza', 'Common viral infection', 'Mild', 'Fever, Body aches', 'Pneumonia', 'Rest, Antivirals'),
('Kidney Stones', 'Hard deposits in the kidneys', 'Moderate', 'Severe pain, Blood in urine', 'Urinary infection', 'Pain relievers, Surgery'),
('Leukemia', 'Cancer of blood-forming tissues', 'Severe', 'Fatigue, Easy bruising', 'Infections, Bleeding', 'Chemotherapy'),
('Malaria', 'Mosquito-borne infectious disease', 'Moderate', 'Fever, Chills', 'Organ failure', 'Antimalarial drugs'),
('Meningitis', 'Inflammation of brain and spinal cord membranes', 'Severe', 'Headache, Stiff neck', 'Brain damage', 'Antibiotics, Antivirals'),
('Migraine', 'Intense headache often with nausea', 'Mild', 'Throbbing pain, Sensitivity to light', 'Chronic migraines', 'Pain relievers, Preventive drugs'),
('Osteoporosis', 'Weak and brittle bones', 'Mild', 'Back pain, Bone fractures', 'Disability', 'Calcium, Bisphosphonates'),
('Psoriasis', 'Chronic skin condition', 'Mild', 'Red patches, Itching', 'Skin infections', 'Topical treatments'),
('Rheumatic Fever', 'Inflammatory disease from strep throat', 'Moderate', 'Joint pain, Rash', 'Heart damage', 'Antibiotics, Anti-inflammatories'),
('Sinusitis', 'Inflammation of the sinuses', 'Mild', 'Facial pain, Nasal congestion', 'Chronic sinusitis', 'Decongestants, Antibiotics'),
('Tuberculosis', 'Bacterial infection of the lungs', 'Severe', 'Cough, Weight loss', 'Lung damage', 'Antibiotics (long-term)'),
('Typhoid', 'Bacterial infection from contaminated food or water', 'Moderate', 'Fever, Abdominal pain', 'Intestinal rupture', 'Antibiotics'),
('Ulcerative Colitis', 'Chronic inflammation of the colon', 'Moderate', 'Diarrhea, Abdominal pain', 'Colon cancer', 'Anti-inflammatories'),
('Varicose Veins', 'Enlarged, twisted veins', 'Mild', 'Aching legs, Swelling', 'Ulcers, Bleeding', 'Compression, Surgery');

-- Step 10: Insert PatientRegister into PatientRegister Table 
INSERT INTO PatientRegister (PatientID, AdmittedON, DischargeON, PatientInsuranceID, RoomNumber, CopayType, CreatedBy) 
VALUES
(1, '2024-05-01 10:00:00', '2024-05-07 10:00:00', 1, 'Room101', 'Standard', 1),
(2, '2024-05-02 11:00:00', '2024-05-08 11:00:00', 2, 'Room102', 'VIP', 2),
(3, '2024-05-03 12:00:00', '2024-05-09 12:00:00', 3, 'Room103', 'Standard', 3),
(4, '2024-05-04 13:00:00', '2024-05-10 13:00:00', 4, 'Room104', 'VIP', 4),
(5, '2024-05-05 14:00:00', '2024-05-11 14:00:00', 5, 'Room105', 'Standard', 5),
(6, '2024-05-06 10:00:00', '2024-05-12 10:00:00', 6, 'Room106', 'Standard', 1),
(7, '2024-05-07 11:00:00', '2024-05-13 11:00:00', 7, 'Room107', 'VIP', 2),
(8, '2024-05-08 12:00:00', '2024-05-14 12:00:00', 8, 'Room108', 'Standard', 3),
(9, '2024-05-09 13:00:00', '2024-05-15 13:00:00', 9, 'Room109', 'VIP', 4),
(10, '2024-05-10 14:00:00', '2024-05-16 14:00:00', 10, 'Room110', 'Standard', 5),
(11, '2024-05-11 10:00:00', '2024-05-17 10:00:00', 11, 'Room111', 'Standard', 1),
(12, '2024-05-12 11:00:00', '2024-05-18 11:00:00', 12, 'Room112', 'VIP', 2),
(13, '2024-05-13 12:00:00', '2024-05-19 12:00:00', 13, 'Room113', 'Standard', 3),
(14, '2024-05-14 13:00:00', '2024-05-20 13:00:00', 14, 'Room114', 'VIP', 4),
(15, '2024-05-15 14:00:00', '2024-05-21 14:00:00', 15, 'Room115', 'Standard', 5),
(16, '2024-05-16 10:00:00', '2024-05-22 10:00:00', 16, 'Room116', 'Standard', 1),
(17, '2024-05-17 11:00:00', '2024-05-23 11:00:00', 17, 'Room117', 'VIP', 2),
(18, '2024-05-18 12:00:00', '2024-05-24 12:00:00', 18, 'Room118', 'Standard', 3),
(19, '2024-05-19 13:00:00', '2024-05-25 13:00:00', 19, 'Room119', 'VIP', 4),
(20, '2024-05-20 14:00:00', '2024-05-26 14:00:00', 20, 'Room120', 'Standard', 5),
(21, '2024-05-21 10:00:00', '2024-05-27 10:00:00', 21, 'Room121', 'Standard', 1),
(22, '2024-05-22 11:00:00', '2024-05-28 11:00:00', 22, 'Room122', 'VIP', 2),
(23, '2024-05-23 12:00:00', '2024-05-29 12:00:00', 23, 'Room123', 'Standard', 3),
(24, '2024-05-24 13:00:00', '2024-05-30 13:00:00', 24, 'Room124', 'VIP', 4),
(25, '2024-05-25 14:00:00', '2024-05-31 14:00:00', 25, 'Room125', 'Standard', 5),
(26, '2024-05-26 10:00:00', '2024-06-01 10:00:00', 26, 'Room126', 'Standard', 1),
(27, '2024-05-27 11:00:00', '2024-06-02 11:00:00', 27, 'Room127', 'VIP', 2),
(28, '2024-05-28 12:00:00', '2024-06-03 12:00:00', 28, 'Room128', 'Standard', 3),
(29, '2024-05-29 13:00:00', '2024-06-04 13:00:00', 29, 'Room129', 'VIP', 4),
(30, '2024-05-30 14:00:00', '2024-06-05 14:00:00', 30, 'Room130', 'Standard', 5),
(31, '2024-05-31 10:00:00', '2024-06-06 10:00:00', 31, 'Room131', 'Standard', 1),
(32, '2024-06-01 11:00:00', '2024-06-07 11:00:00', 32, 'Room132', 'VIP', 2),
(33, '2024-06-02 12:00:00', '2024-06-08 12:00:00', 33, 'Room133', 'Standard', 3),
(34, '2024-06-03 13:00:00', '2024-06-09 13:00:00', 34, 'Room134', 'VIP', 4),
(35, '2024-06-04 14:00:00', '2024-06-10 14:00:00', 35, 'Room135', 'Standard', 5),
(36, '2024-06-05 10:00:00', '2024-06-11 10:00:00', 36, 'Room136', 'Standard', 1),
(37, '2024-06-06 11:00:00', '2024-06-12 11:00:00', 37, 'Room137', 'VIP', 2),
(38, '2024-06-07 12:00:00', '2024-06-13 12:00:00', 38, 'Room138', 'Standard', 3),
(39, '2024-06-08 13:00:00', '2024-06-14 13:00:00', 39, 'Room139', 'VIP', 4),
(40, '2024-06-09 14:00:00', '2024-06-15 14:00:00', 40, 'Room140', 'Standard', 5),
(41, '2024-06-10 10:00:00', '2024-06-16 10:00:00', 41, 'Room141', 'Standard', 1),
(42, '2024-06-11 11:00:00', '2024-06-17 11:00:00', 42, 'Room142', 'VIP', 2),
(43, '2024-06-12 12:00:00', '2024-06-18 12:00:00', 43, 'Room143', 'Standard', 3),
(44, '2024-06-13 13:00:00', '2024-06-19 13:00:00', 44, 'Room144', 'VIP', 4),
(45, '2024-06-14 14:00:00', '2024-06-20 14:00:00', 45, 'Room145', 'Standard', 5),
(46, '2024-06-15 10:00:00', '2024-06-21 10:00:00', 46, 'Room146', 'Standard', 1),
(47, '2024-06-16 11:00:00', '2024-06-22 11:00:00', 47, 'Room147', 'VIP', 2),
(48, '2024-06-17 12:00:00', '2024-06-23 12:00:00', 48, 'Room148', 'Standard', 3),
(49, '2024-06-18 13:00:00', '2024-06-24 13:00:00', 49, 'Room149', 'VIP', 4),
(50, '2024-06-19 14:00:00', '2024-06-25 14:00:00', 50, 'Room150', 'Standard', 5),
(51, '2024-06-20 10:00:00', '2024-06-26 10:00:00', 51, 'Room151', 'Standard', 1),
(52, '2024-06-21 11:00:00', '2024-06-27 11:00:00', 52, 'Room152', 'VIP', 2),
(53, '2024-06-22 12:00:00', '2024-06-28 12:00:00', 53, 'Room153', 'Standard', 3),
(54, '2024-06-23 13:00:00', '2024-06-29 13:00:00', 54, 'Room154', 'VIP', 4),
(55, '2024-06-24 14:00:00', '2024-06-30 14:00:00', 55, 'Room155', 'Standard', 5);

-- Insert PatientDisease records for each patientt
INSERT INTO PatientDisease (PatientRegisterID, DiseaseID) 
VALUES 
(1, 1), -- Hypertension for Patient 1
(2, 2), -- Asthma for Patient 2
(3, 3), -- Diabetes for Patient 3
(4, 4), -- Cancer for Patient 4
(5, 5), -- Pneumonia for Patient 5
(6, 6), -- Anemia for Patient 6
(7, 7), -- Arthritis for Patient 7
(8, 8), -- Bronchitis for Patient 8
(9, 9), -- COVID-19 for Patient 9
(10, 10), -- Dengue for Patient 10
(11, 11), -- Epilepsy for Patient 11
(12, 12), -- Gallstones for Patient 12
(13, 13), -- Gastritis for Patient 13
(14, 14), -- Glaucoma for Patient 14
(15, 15), -- Hepatitis B for Patient 15
(16, 16), -- Hernia for Patient 16
(17, 17), -- Influenza for Patient 17
(18, 18), -- Kidney Stones for Patient 18
(19, 19), -- Leukemia for Patient 19
(20, 20), -- Malaria for Patient 20
(21, 21), -- Meningitis for Patient 21
(22, 22), -- Migraine for Patient 22
(23, 23), -- Osteoporosis for Patient 23
(24, 24), -- Psoriasis for Patient 24
(25, 25), -- Rheumatic Fever for Patient 25
(26, 1), -- Hypertension for Patient 26
(27, 2), -- Asthma for Patient 27
(28, 3), -- Diabetes for Patient 28
(29, 4), -- Cancer for Patient 29
(30, 5), -- Pneumonia for Patient 30
(31, 6), -- Anemia for Patient 31
(32, 7), -- Arthritis for Patient 32
(33, 8), -- Bronchitis for Patient 33
(34, 9), -- COVID-19 for Patient 34
(35, 10), -- Dengue for Patient 35
(36, 11), -- Epilepsy for Patient 36
(37, 12), -- Gallstones for Patient 37
(38, 13), -- Gastritis for Patient 38
(39, 14), -- Glaucoma for Patient 39
(40, 15), -- Hepatitis B for Patient 40
(41, 16), -- Hernia for Patient 41
(42, 17), -- Influenza for Patient 42
(43, 18), -- Kidney Stones for Patient 43
(44, 19), -- Leukemia for Patient 44
(45, 20), -- Malaria for Patient 45
(46, 21), -- Meningitis for Patient 46
(47, 22), -- Migraine for Patient 47
(48, 23), -- Osteoporosis for Patient 48
(49, 24), -- Psoriasis for Patient 49
(50, 25), -- Rheumatic Fever for Patient 50
(51, 1), -- Hypertension for Patient 51
(52, 2), -- Asthma for Patient 52
(53, 3), -- Diabetes for Patient 53
(54, 4), -- Cancer for Patient 54
(55, 5); -- Pneumonia for Patient 55


-- Step 11: Show all data with detailed output
SELECT 
    PR.PatientRegisterID,
    P.PatientRegNo,
    P.FirstName AS PatientFirstName,
    P.LastName AS PatientLastName,
    P.EmailID AS PatientEmail,
    P.PhoneNumber AS PatientPhoneNumber,
    P.BloodGroup AS PatientBloodGroup,
    P.Height AS PatientHeight,
    P.Weight AS PatientWeight,
    P.Address AS PatientAddress,
    P.Allergies AS PatientAllergies,
    P.MaritalStatus AS PatientMaritalStatus,
    P.Occupation AS PatientOccupation,
    P.EmergencyContact AS PatientEmergencyContact,
    P.InsuranceStatus AS PatientInsuranceStatus,
    
    D.Name AS DiseaseName,
    D.Description AS DiseaseDescription,
    D.Severity AS DiseaseSeverity,
    D.Symptoms AS DiseaseSymptoms,
    D.Complications AS DiseaseComplications,
    
    PI.ProviderName AS InsuranceProviderName,
    PI.InsuranceNumber AS InsuranceNumber,
    PI.StartDate AS InsuranceStartDate,
    PI.EndDate AS InsuranceEndDate,
    PI.InNetworkCoPay AS InsuranceInNetworkCoPay,
    PI.OutNetworkCoPay AS InsuranceOutNetworkCoPay,

    ED.FirstName AS EmployeeFirstName,
    ED.LastName AS EmployeeLastName,
    ED.PhoneNumber AS EmployeePhoneNumber,
    ED.RoleID AS EmployeeRoleID,
    ED.Salary AS EmployeeSalary,
    ED.DateOfJoining AS EmployeeDateOfJoining,
    
    LR.TestValue AS LabTestResult,
    LR.Comment AS LabTestComment,
    LR.DateOfTest AS LabTestDate
FROM 
    PatientDisease PD
JOIN 
    PatientRegister PR ON PD.PatientRegisterID = PR.PatientRegisterID
JOIN 
    Patient P ON PR.PatientID = P.PatientID
JOIN 
    Disease D ON PD.DiseaseID = D.DiseaseID
JOIN 
    PatientInsurance PI ON P.PatientID = PI.PatientID
JOIN 
    EmployeeDetails ED ON PR.CreatedBy = ED.EmployeeID
LEFT JOIN 
    PatientLabReport LR ON PR.PatientRegisterID = LR.PatientRegisterID;