CREATE TABLE TypeOfDrug (
    type_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
CREATE UNIQUE INDEX idx_TypeOfDrug_name ON TypeOfDrug(name);


CREATE TABLE FormType (
    form_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
CREATE UNIQUE INDEX idx_FormType_name ON FormType(name);


CREATE TABLE PackageType (
    package_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
CREATE UNIQUE INDEX idx_PackageType_name ON PackageType(name);


CREATE TABLE Country (
    country_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
CREATE UNIQUE INDEX idx_Country_name ON Country(name);


CREATE TABLE Drug (
    drug_id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL UNIQUE,
    type_id INT NOT NULL,
    form_id INT NOT NULL,
    status VARCHAR(50) NOT NULL
        CHECK (status IN ('в свободной продаже', 'рецепт')),
    FOREIGN KEY (type_id) REFERENCES TypeOfDrug(type_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (form_id) REFERENCES FormType(form_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);
CREATE UNIQUE INDEX idx_Drug_name ON Drug(name);


CREATE TABLE Doctor (
    doctor_id INT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    medical_institution VARCHAR(150) NOT NULL
);


CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL
);


CREATE TABLE Batch (
    batch_number INT PRIMARY KEY,
    drug_id INT NOT NULL,
    arrival_date DATE NOT NULL DEFAULT GETDATE(),
    country_id INT NULL,
    manufacture_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    package_id INT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    dosage INT NULL,
    certificate_number INT NULL UNIQUE,
    FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (country_id) REFERENCES Country(country_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (package_id) REFERENCES PackageType(package_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);
CREATE UNIQUE INDEX idx_Batch_certificate_number ON Batch(certificate_number);


CREATE TABLE Sale (
    sale_id INT IDENTITY(1,1) PRIMARY KEY,
    sale_date DATE NOT NULL DEFAULT GETDATE(),
    employee_id INT NULL,
    drug_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0),
    FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
);


CREATE TABLE Prescription (
    prescription_id INT IDENTITY(1,1) PRIMARY KEY,
    prescription_date DATE NOT NULL DEFAULT GETDATE(),
    doctor_id INT NULL,
    patient_name VARCHAR(150) NOT NULL,
    drug_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    package_id INT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    FOREIGN KEY (drug_id) REFERENCES Drug(drug_id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    FOREIGN KEY (package_id) REFERENCES PackageType(package_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
);
