/**
  * MangoWealth Database Schema
  */

/* ################### CREATING DATABASE  ########################## */

USE innodb;

/* ################### CREATING TABLES  ########################### */

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS Users;
CREATE TABLE Users(
    id INT AUTO_INCREMENT NOT NULL,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age TINYINT(100) NOT NULL,
    gender ENUM('MALE', 'FEMALE') DEFAULT NULL,
    employment_status ENUM('FULL-TIME', 'PART-TIME', 'UNEMPLOYED', 'STUDENT', 'PART-TIME-STUDENT', 'VOLUNTEER') DEFAULT NULL,
    salary_period ENUM('WEEKLY', 'BI-WEEKLY', 'SEMI-MONTHLY', 'MONTHLY') DEFAULT NULL,
    risk_profile TINYINT(5) NOT NULL,
    email VARCHAR(256) NOT NULL,
    password_hash VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS UserFinancialsRecords;
CREATE TABLE UserFinancialsRecords(
    id INT NOT NULL AUTO_INCREMENT,
    income DOUBLE NOT NULL,
    expenses DOUBLE NOT NULL,
    recordDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    userId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS FinancialInstitutions;
CREATE TABLE FinancialInstitutions(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS UserFinancialInstitutions;
CREATE TABLE UserFinancialInstitutions(
    userId INT NOT NULL,
    institutionId INT NOT NULL,
    PRIMARY KEY(userId, institutionId),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY(institutionId) REFERENCES FinancialInstitutions(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS ProductTypes;
CREATE TABLE ProductTypes(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS FinancialProducts;
CREATE TABLE FinancialProducts(
    id INT NOT NULL AUTO_INCREMENT,
    product_name VARCHAR(256) NOT NULL,
    description TEXT NOT NULL,
    minimum_deposit INT NOT NULL DEFAULT 0,
    risk_profile TINYINT(100) NOT NULL,
    interest_rate DOUBLE NOT NULL,
    product_link TEXT NOT NULL,
    productTypeId INT NOT NULL,
    institutionId INT NOT NULL,
    PRIMARY KEY(id),
    FOREIGN KEY(productTypeId) REFERENCES ProductTypes(id) ON UPDATE CASCADE,
    FOREIGN KEY(institutionId) REFERENCES FinancialInstitutions(id) ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Fees;
CREATE TABLE Fees(
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256) NOT NULL,
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS FinancialProductsFees;
CREATE TABLE FinancialProductsFees(
    financialProductId INT NOT NULL,
    feesId INT NOT NULL,
    PRIMARY KEY(financialProductId, feesId),
    FOREIGN KEY(financialProductId) REFERENCES FinancialProducts(id) ON DELETE CASCADE,
    FOREIGN KEY(feesId) REFERENCES Fees(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Recommendations;
CREATE TABLE Recommendations(
    userId INT NOT NULL,
    financialProductId INT NOT NULL,
    recommendationDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(userId, financialProductId),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY(financialProductId) REFERENCES FinancialProducts(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS UserProductPreferences;
CREATE TABLE UserProductPreferences(
    userId INT NOT NULL,
    productTypeId INT NOT NULL,
    minimum_deposit TINYINT(5) NOT NULL DEFAULT 1,
    additional_fees TINYINT(5) NOT NULL DEFAULT 1,
    interest_rate TINYINT(5) NOT NULL DEFAULT 1,
    time_period TINYINT(5) NOT NULL DEFAULT 1,
    risk TINYINT(5) NOT NULL DEFAULT 1,
    preference_number TINYINT(3) NOT NULL DEFAULT 1,
    PRIMARY KEY(userId, productTypeId),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY(productTypeId) REFERENCES ProductTypes(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Goals;
CREATE TABLE Goals(
    id INT NOT NULL,
    userId INT NOT NULL,
    financialProductId INT NOT NULL,
    amount DOUBLE NOT NULL,
    time_period INT NOT NULL,
    record_date DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id),
    FOREIGN KEY(userId) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY(financialProductId) REFERENCES FinancialProducts(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS Progress;
CREATE TABLE Progress(
    progressId INT NOT NULL,
    goalId INT NOT NULL,
    gains DOUBLE NOT NULL,
    record_date DATETIME NOT NULL DEFAULT NOW(),
    PRIMARY KEY(progressId),
    FOREIGN KEY(goalId) REFERENCES Goals(id) ON DELETE CASCADE
);

/* ################ INSERTING DEFAULT VALUE INTO TABLES  ################### */

-- Inserting basic Financial Product Types
INSERT INTO ProductTypes(name) VALUES("SAVINGS");
INSERT INTO ProductTypes(name) VALUES("INVESTMENTS");
INSERT INTO ProductTypes(name) VALUES("LOANS");

/* ######### STORED PROCEDURE FOR CREATING VECTOR OBJECTS  ################# */


SET FOREIGN_KEY_CHECKS = 1;