CREATE DOMAIN NAME_DOM AS VARCHAR(255);
CREATE DOMAIN LOCATION_DOM AS VARCHAR(255);
CREATE DOMAIN EMAIL_DOM AS VARCHAR(50);
CREATE DOMAIN PHONE_NB_DOM AS VARCHAR(15);


CREATE TABLE Building (
	Bldg_Name NAME_DOM NOT NULL PRIMARY KEY,
	Nb_Rooms INT NOT NULL,
	Bldg_Type VARCHAR(100) NOT NULL,
	Bldg_Maint_Repair_Status VARCHAR(100) NOT NULL,
	Bldg_Maint_Sched_Date DATE NOT NULL,
	Bldg_Last_Maintained DATE
);

CREATE TABLE Employee (
	Empl_ID INT NOT NULL PRIMARY KEY,
	Empl_Name NAME_DOM,
	Email_Address EMAIL_DOM NOT NULL UNIQUE,
	Empl_Phone_Nb PHONE_NB_DOM NOT NULL UNIQUE,
	Empl_Position VARCHAR(100) NOT NULL,
	Salary INT NOT NULL,
	Manager_ID INT NOT NULL
);

CREATE TYPE TIME_INTERVAL AS (
	Start_Time TIME,
	End_Time TIME
);

CREATE TABLE Amenities (
	Amenity_ID INT NOT NULL PRIMARY KEY,
	Amenity_Type VARCHAR(100),
	Amenity_Location LOCATION_DOM NOT NULL,
	Wkdy_Hrs TIME_INTERVAL,
	Wknd_Hrs TIME_INTERVAL
);

CREATE TABLE Stock (
	Stock_Type VARCHAR(50) NOT NULL PRIMARY KEY,
	Quantity INT NOT NULL,
	Last_Replenished DATE,
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
	Guest_Name NAME_DOM,
	Rating INT NOT NULL
);

ALTER TABLE Guest
ADD CONSTRAINT Guest_Contact_Info PRIMARY KEY(Guest_Phone, Guest_Email);