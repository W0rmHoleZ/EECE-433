-- NOT NULL PRIMARY KEY redundant, no need for NOT NULL --

CREATE DOMAIN NAME_DOM AS VARCHAR(255);
CREATE DOMAIN LOCATION_DOM AS VARCHAR(255);
CREATE DOMAIN EMAIL_DOM AS VARCHAR(50);
CREATE DOMAIN PHONE_NB_DOM AS VARCHAR(15);

-- Entities

CREATE TABLE Building (
	Bldg_Name NAME_DOM NOT NULL PRIMARY KEY,
	Nb_Rooms INT NOT NULL,
	Bldg_Type VARCHAR(100) NOT NULL,
	Bldg_Maint_Repair_Status VARCHAR(100) NOT NULL,
	Bldg_Maint_Sched_Date TIMESTAMP, -- Null if the building has just been maintained --
	Bldg_Last_Maintained TIMESTAMP -- Null if the building has never been maintained --
);

CREATE TABLE Employee (
	Empl_ID INT NOT NULL PRIMARY KEY,
	Empl_Name NAME_DOM NOT NULL,
	Email_Address EMAIL_DOM NOT NULL UNIQUE,
	Empl_Phone_Nb PHONE_NB_DOM NOT NULL UNIQUE,
	Empl_Position VARCHAR(100) NOT NULL,
	Salary INT NOT NULL,
	Manager_ID INT -- Null if the Employee is the Manager --
);

CREATE TYPE TIME_INTERVAL AS (
	Start_Time TIME,
	End_Time TIME
);

CREATE TABLE Amenities (
	Amenity_ID INT NOT NULL PRIMARY KEY,
	Amenity_Type VARCHAR(100) NOT NULL,
	Amenity_Location LOCATION_DOM NOT NULL,
	Wkdy_Hrs TIME_INTERVAL NOT NULL,
	Wknd_Hrs TIME_INTERVAL NOT NULL,
	Amenity_Maint_Repair_Status VARCHAR(100) NOT NULL,
	Amenity_Maint_Sched_Date TIMESTAMP, -- Null if the amenity has just been maintained --
	Amenity_Last_Maintained TIMESTAMP -- Null if the amenity has never been maintained --
);

CREATE TABLE Restaurant (
	Rest_Name NAME_DOM PRIMARY KEY,
	Rest_Location LOCATION_DOM NOT NULL,
	Capacity INT NOT NULL,
	Wkdy_Hrs TIME_INTERVAL NOT NULL,
	Wknd_Hrs TIME_INTERVAL NOT NULL,
);

CREATE TABLE Wellness_Center (
	WCenter_ID INT PRIMARY KEY,
	WCenter_Location LOCATION_DOM NOT NULL,
	Capacity INT NOT NULL,
	Wkdy_Hrs TIME_INTERVAL NOT NULL,
	Wknd_Hrs TIME_INTERVAL NOT NULL,
	Price FLOAT NOT NULL
);

CREATE TABLE Stock (
	Stock_Type VARCHAR(50) NOT NULL PRIMARY KEY,
	Quantity INT NOT NULL,
	Last_Replenished DATE, -- Null if the stock has never been replenished --
	Bldg_Name FOREIGN KEY REFERENCES Building(Bldg_Name),
	Amenity_ID FOREIGN KEY REFERENCES Amenities(Amenity_ID),
	Restaurant_Name FOREIGN KEY REFERENCES Restaurant(Restaurant_Name),
	WCenter_ID FOREIGN KEY REFERENCES Wellness_Center(WCenter_ID)
);

CREATE TABLE Supplier (
	Supplier_Name NAME_DOM NOT NULL PRIMARY KEY
);

CREATE TABLE Guest (
	Guest_Phone PHONE_NB_DOM,
	Guest_Email EMAIL_DOM,
	Guest_Name NAME_DOM NOT NULL,
	Rating FLOAT, -- Null if the Guest doesn't give feedback --
	CONSTRAINT Guest_Contact_Info PRIMARY KEY(Guest_Phone, Guest_Email)
	-- Null if the guest doesn't reserve at a restaurant --
	Reserved_Rest_Name NAME_DOM FOREIGN KEY REFERENCES Restaurant(Restaurant_Name),
	Rest_Booking_Time TIMESTAMP,
	Booking_Meal_Plan VARCHAR(100), -- What the guest orders --
	Booking_Table_Nb INT,
	-- Null if the guest doesn't reserve at wellness center --
	Reserved_WCenter_ID INT FOREIGN KEY REFERENCES Wellness_Center(WCenter_ID),
	WCenter_Booking_Time TIMESTAMP,
	WCenter_Book_Service VARCHAR(100)
);

CREATE TYPE DATE_INTERVAL AS (
	Start_Date DATE,
	End_Date DATE
);

CREATE TABLE Room (
	Room_Nb INT,
	Bldg_Name NAME_DOM FOREIGN KEY REFERENCES Building(Bldg_Name),
	Last_Cleaned TIMESTAMP, -- Null if the room has never been cleaned --
	Price_per_Night FLOAT NOT NULL,
	Room_Type VARCHAR(100) NOT NULL,
	CONSTRAINT Room_Pk PRIMARY KEY(Room_Nb, Bldg_Name),
	-- Null if guest doesn't reserve room --
	Guest_Phone PHONE_NB_DOM FOREIGN KEY REFERENCES Guest(Guest_Phone),
	Guest_Email EMAIL_DOM FOREIGN KEY REFERENCES Guest(Guest_Email),
	Guest_Reservation DATE_INTERVAL,
	-- Null if no discount --
	Discount_Percent FLOAT,
	Discount_Interval DATE_INTERVAL,
	Discount_Description VARCHAR(150)
);

CREATE TABLE Billing_Record (
	Invoice_ID INT,
	Guest_Phone PHONE_NB_DOM FOREIGN KEY REFERENCES Guest(Guest_Phone),
	Guest_Email EMAIL_DOM FOREIGN KEY REFERENCES Guest(Guest_Email),
	Amount_Due FLOAT NOT NULL, 
	Amount_Paid FLOAT NOT NULL,
	CONSTRAINT BR_PK PRIMARY KEY(Invoice_ID, Guest_Phone, Guest_Email)
);

-- Relationships --

CREATE TABLE Has_Assigned (
	Bldg_Name NAME_DOM,
	Empl_ID INT,
	Shift TIME_INTERVAL,
	CONSTRAINT Has_Assigned_PK PRIMARY KEY(Bldg_Name, Empl_ID)
);