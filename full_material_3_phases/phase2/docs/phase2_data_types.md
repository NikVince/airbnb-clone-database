# Phase 2 Data Types and Domains Documentation

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Design - Normalization and Constraints  
**Date:** 14/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## 1. Introduction

This document provides a comprehensive specification of data types and domains for all attributes in the Airbnb database design. Data types ensure proper storage, validation, and performance optimization, while domains define valid values and business rules for each attribute. This analysis covers all 27 entities with their complete data type specifications and domain constraints.

## 2. Data Type Categories Overview

### 2.1 Numeric Types
- **INTEGER:** Whole numbers for IDs and counts
- **DECIMAL:** Precise decimal numbers for monetary values
- **FLOAT:** Approximate decimal numbers for coordinates

### 2.2 Character Types
- **VARCHAR:** Variable-length character strings
- **CHAR:** Fixed-length character strings
- **TEXT:** Large text fields for descriptions

### 2.3 Date/Time Types
- **DATE:** Date values without time
- **DATETIME:** Date and time values
- **TIMESTAMP:** Automatic timestamp values

### 2.4 Boolean Types
- **BOOLEAN:** True/false values

### 2.5 Special Types
- **JSON:** Structured data storage
- **ENUM:** Predefined value sets
- **UUID:** Universally unique identifiers

## 3. User Management Domain Data Types

### 3.1 Users Table Data Types

#### 3.1.1 Primary Key
```sql
user_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 3.1.2 Authentication Fields
```sql
email VARCHAR(255) UNIQUE NOT NULL
```
- **Domain:** Valid email addresses
- **Format:** user@domain.com
- **Business Rule:** Unique across all users, required for login

```sql
password_hash VARCHAR(255) NOT NULL
```
- **Domain:** Hashed password strings
- **Format:** bcrypt hash (60 characters)
- **Business Rule:** Never store plain text passwords

#### 3.1.3 Personal Information
```sql
first_name VARCHAR(100) NOT NULL
```
- **Domain:** Alphabetic characters, spaces, hyphens, apostrophes
- **Format:** ^[A-Za-z\s\-'\.]+$
- **Business Rule:** Required for user identification

```sql
last_name VARCHAR(100) NOT NULL
```
- **Domain:** Alphabetic characters, spaces, hyphens, apostrophes
- **Format:** ^[A-Za-z\s\-'\.]+$
- **Business Rule:** Required for user identification

```sql
phone VARCHAR(20) UNIQUE NOT NULL
```
- **Domain:** International phone numbers
- **Format:** ^\+[1-9]\d{1,14}$
- **Business Rule:** Unique across all users, required for verification

```sql
date_of_birth DATE
```
- **Domain:** Valid dates in the past
- **Format:** YYYY-MM-DD
- **Business Rule:** Must be before current date, optional for privacy

#### 3.1.4 Role Management
```sql
is_guest BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Default role for new users

```sql
is_host BOOLEAN DEFAULT FALSE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Set to TRUE when user applies to become host

```sql
is_admin BOOLEAN DEFAULT FALSE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** System administrators only

#### 3.1.5 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when record is created

```sql
updated_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Updated on every record modification

```sql
is_active BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Soft delete mechanism

### 3.2 Guest Profiles Table Data Types

#### 3.2.1 Primary Key
```sql
guest_profile_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 3.2.2 Foreign Key
```sql
user_id INT UNIQUE NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id, 1:1 relationship

#### 3.2.3 Guest Preferences
```sql
preferred_price_range VARCHAR(50)
```
- **Domain:** {'budget', 'moderate', 'luxury', 'any'}
- **Business Rule:** Optional preference for search filtering

```sql
preferred_property_types JSON
```
- **Domain:** Array of property type IDs
- **Format:** [1, 2, 3, 4]
- **Business Rule:** JSON array for flexible storage

```sql
travel_preferences JSON
```
- **Domain:** Object with travel preferences
- **Format:** {"amenities": ["wifi", "parking"], "location": "city_center"}
- **Business Rule:** Flexible preference storage

#### 3.2.4 Verification
```sql
guest_verification_status VARCHAR(20) DEFAULT 'unverified'
```
- **Domain:** {'unverified', 'email_verified', 'phone_verified', 'id_verified', 'fully_verified'}
- **Business Rule:** Tracks verification progress

```sql
verification_date DATETIME
```
- **Domain:** Valid datetime values in the past
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when verification is completed

#### 3.2.5 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when profile is created

### 3.3 Host Profiles Table Data Types

#### 3.3.1 Primary Key
```sql
host_profile_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 3.3.2 Foreign Key
```sql
user_id INT UNIQUE NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id, 1:1 relationship

#### 3.3.3 Verification
```sql
host_verification_status VARCHAR(20) DEFAULT 'pending'
```
- **Domain:** {'pending', 'verified', 'rejected', 'suspended'}
- **Business Rule:** Tracks host verification status

```sql
verification_date DATETIME
```
- **Domain:** Valid datetime values in the past
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when verification is completed

```sql
host_since DATETIME
```
- **Domain:** Valid datetime values in the past
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Date when user became a host

#### 3.3.4 Performance Metrics
```sql
response_rate DECIMAL(5,2) DEFAULT 0.00
```
- **Domain:** 0.00 to 100.00
- **Precision:** 2 decimal places
- **Business Rule:** Percentage of messages responded to

```sql
response_time_hours INT
```
- **Domain:** Positive integers
- **Range:** 1 to 24
- **Business Rule:** Average response time in hours

```sql
acceptance_rate DECIMAL(5,2) DEFAULT 0.00
```
- **Domain:** 0.00 to 100.00
- **Precision:** 2 decimal places
- **Business Rule:** Percentage of booking requests accepted

```sql
host_rating DECIMAL(3,2)
```
- **Domain:** 1.00 to 5.00
- **Precision:** 2 decimal places
- **Business Rule:** Average rating from guests

```sql
total_properties INT DEFAULT 0
```
- **Domain:** Non-negative integers
- **Range:** 0 to 2,147,483,647
- **Business Rule:** Count of active properties

```sql
superhost_status BOOLEAN DEFAULT FALSE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Platform recognition for high-performing hosts

#### 3.3.5 Business Information
```sql
payout_method_id INT
```
- **Domain:** Valid payment_method_id values
- **Business Rule:** References payment_methods.payment_method_id

```sql
tax_id VARCHAR(50)
```
- **Domain:** Encrypted tax identification numbers
- **Format:** Encrypted string
- **Business Rule:** Encrypted for security, required for commercial hosts

```sql
business_name VARCHAR(255)
```
- **Domain:** Business entity names
- **Business Rule:** Required for commercial hosts

```sql
business_registration VARCHAR(100)
```
- **Domain:** Business registration numbers
- **Business Rule:** Required for commercial hosts

#### 3.3.6 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when profile is created

### 3.4 User Profiles Table Data Types

#### 3.4.1 Primary Key
```sql
profile_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 3.4.2 Foreign Key
```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

#### 3.4.3 Profile Information
```sql
bio TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional user biography

```sql
profile_picture VARCHAR(500)
```
- **Domain:** Valid URL strings
- **Format:** ^https?://[^\s]+$
- **Business Rule:** URL to profile image

#### 3.4.4 Preferences
```sql
language_preference VARCHAR(10) DEFAULT 'en'
```
- **Domain:** ISO 639-1 language codes
- **Values:** {'en', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'zh', 'ja', 'ko'}
- **Business Rule:** User interface language

```sql
currency_preference VARCHAR(3) DEFAULT 'USD'
```
- **Domain:** ISO 4217 currency codes
- **Values:** {'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY'}
- **Business Rule:** Display currency for prices

```sql
timezone VARCHAR(50)
```
- **Domain:** Valid timezone identifiers
- **Format:** IANA timezone format
- **Business Rule:** User's local timezone

```sql
notification_settings JSON
```
- **Domain:** Object with notification preferences
- **Format:** {"email": true, "sms": false, "push": true}
- **Business Rule:** Flexible notification configuration

### 3.5 User Verification Table Data Types

#### 3.5.1 Primary Key
```sql
verification_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 3.5.2 Foreign Key
```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

#### 3.5.3 Verification Details
```sql
verification_type VARCHAR(50) NOT NULL
```
- **Domain:** {'email', 'phone', 'identity', 'address', 'payment'}
- **Business Rule:** Type of verification being performed

```sql
document_type VARCHAR(50) NOT NULL
```
- **Domain:** {'passport', 'drivers_license', 'national_id', 'utility_bill', 'bank_statement'}
- **Business Rule:** Type of document submitted

```sql
document_number VARCHAR(100) NOT NULL
```
- **Domain:** Document identification numbers
- **Business Rule:** Encrypted document reference

```sql
verification_status VARCHAR(20) NOT NULL
```
- **Domain:** {'pending', 'verified', 'rejected', 'expired'}
- **Business Rule:** Current status of verification

#### 3.5.4 Timestamps
```sql
verified_at DATETIME
```
- **Domain:** Valid datetime values in the past
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when verification is completed

```sql
expires_at DATETIME
```
- **Domain:** Valid datetime values in the future
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Verification expiration date

### 3.6 User Preferences Table Data Types

#### 3.6.1 Primary Key
```sql
preference_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 3.6.2 Foreign Key
```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

#### 3.6.3 Preference Details
```sql
preference_key VARCHAR(100) NOT NULL
```
- **Domain:** {'notifications', 'privacy', 'language', 'currency', 'timezone', 'theme'}
- **Business Rule:** Type of preference being stored

```sql
preference_value JSON NOT NULL
```
- **Domain:** Valid JSON objects
- **Format:** {"enabled": true, "frequency": "daily"}
- **Business Rule:** Flexible preference value storage

#### 3.6.4 System Fields
```sql
updated_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when preference is updated

## 4. Property Management Domain Data Types

### 4.1 Properties Table Data Types

#### 4.1.1 Primary Key
```sql
property_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 4.1.2 Foreign Keys
```sql
host_id INT NOT NULL
```
- **Domain:** Valid host_profile_id values
- **Business Rule:** References host_profiles.host_profile_id

```sql
property_type_id INT NOT NULL
```
- **Domain:** Valid property_type_id values
- **Business Rule:** References property_types.property_type_id

```sql
address_id INT NOT NULL
```
- **Domain:** Valid address_id values
- **Business Rule:** References addresses.address_id

#### 4.1.3 Property Information
```sql
title VARCHAR(200) NOT NULL
```
- **Domain:** Non-empty character strings
- **Business Rule:** Required property title

```sql
description TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional property description

#### 4.1.4 Capacity Information
```sql
max_guests INT NOT NULL
```
- **Domain:** Positive integers
- **Range:** 1 to 50
- **Business Rule:** Maximum number of guests allowed

```sql
bedrooms INT NOT NULL
```
- **Domain:** Non-negative integers
- **Range:** 0 to 20
- **Business Rule:** Number of bedrooms

```sql
bathrooms DECIMAL(3,1) NOT NULL
```
- **Domain:** Positive decimal numbers
- **Range:** 0.5 to 20.0
- **Precision:** 1 decimal place
- **Business Rule:** Number of bathrooms (supports half bathrooms)

```sql
size_sqm DECIMAL(8,2)
```
- **Domain:** Positive decimal numbers
- **Range:** 1.00 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Property size in square meters

#### 4.1.5 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when property is created

```sql
updated_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Updated on every property modification

```sql
is_active BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Soft delete mechanism

### 4.2 Property Types Table Data Types

#### 4.2.1 Primary Key
```sql
property_type_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 4.2.2 Type Information
```sql
type_name VARCHAR(50) NOT NULL UNIQUE
```
- **Domain:** Unique property type names
- **Business Rule:** Predefined property types only

```sql
description TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional type description

```sql
icon_url VARCHAR(500)
```
- **Domain:** Valid URL strings
- **Format:** ^https?://[^\s]+$
- **Business Rule:** URL to type icon image

### 4.3 Property Amenities Table Data Types

#### 4.3.1 Primary Key
```sql
amenity_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 4.3.2 Amenity Information
```sql
amenity_name VARCHAR(100) NOT NULL UNIQUE
```
- **Domain:** Unique amenity names
- **Business Rule:** Predefined amenities only

```sql
amenity_category VARCHAR(50) NOT NULL
```
- **Domain:** {'basic', 'kitchen', 'bathroom', 'bedroom', 'outdoor', 'safety', 'entertainment', 'accessibility'}
- **Business Rule:** Categorization for filtering

```sql
icon_url VARCHAR(500)
```
- **Domain:** Valid URL strings
- **Format:** ^https?://[^\s]+$
- **Business Rule:** URL to amenity icon image

```sql
description TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional amenity description

### 4.4 Property Amenity Links Table Data Types

#### 4.4.1 Primary Key
```sql
link_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 4.4.2 Foreign Keys
```sql
property_id INT NOT NULL
```
- **Domain:** Valid property_id values
- **Business Rule:** References properties.property_id

```sql
amenity_id INT NOT NULL
```
- **Domain:** Valid amenity_id values
- **Business Rule:** References property_amenities.amenity_id

#### 4.4.3 Link Information
```sql
is_available BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether amenity is currently available

```sql
additional_info TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Additional details about amenity availability

### 4.5 Property Photos Table Data Types

#### 4.5.1 Primary Key
```sql
photo_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 4.5.2 Foreign Key
```sql
property_id INT NOT NULL
```
- **Domain:** Valid property_id values
- **Business Rule:** References properties.property_id

#### 4.5.3 Photo Information
```sql
photo_url VARCHAR(500) NOT NULL
```
- **Domain:** Valid URL strings
- **Format:** ^https?://[^\s]+$
- **Business Rule:** URL to photo image

```sql
caption VARCHAR(200)
```
- **Domain:** Character strings up to 200 characters
- **Business Rule:** Optional photo caption

```sql
is_primary BOOLEAN DEFAULT FALSE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Primary photo for property listing

```sql
display_order INT DEFAULT 0
```
- **Domain:** Non-negative integers
- **Range:** 0 to 999
- **Business Rule:** Order of photos in gallery

#### 4.5.4 System Fields
```sql
uploaded_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when photo is uploaded

### 4.6 Property Pricing Table Data Types

#### 4.6.1 Primary Key
```sql
pricing_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 4.6.2 Foreign Key
```sql
property_id INT NOT NULL
```
- **Domain:** Valid property_id values
- **Business Rule:** References properties.property_id

#### 4.6.3 Date Range
```sql
start_date DATE NOT NULL
```
- **Domain:** Valid date values
- **Format:** YYYY-MM-DD
- **Business Rule:** Start of pricing period

```sql
end_date DATE NOT NULL
```
- **Domain:** Valid date values
- **Format:** YYYY-MM-DD
- **Business Rule:** End of pricing period, must be after start_date

#### 4.6.4 Pricing Information
```sql
base_price_per_night DECIMAL(10,2) NOT NULL
```
- **Domain:** Positive decimal numbers
- **Range:** 0.01 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Base price per night

```sql
weekend_price_per_night DECIMAL(10,2)
```
- **Domain:** Positive decimal numbers
- **Range:** 0.01 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Optional weekend pricing

```sql
weekly_discount_percentage DECIMAL(5,2) DEFAULT 0
```
- **Domain:** 0.00 to 100.00
- **Precision:** 2 decimal places
- **Business Rule:** Weekly stay discount percentage

```sql
monthly_discount_percentage DECIMAL(5,2) DEFAULT 0
```
- **Domain:** 0.00 to 100.00
- **Precision:** 2 decimal places
- **Business Rule:** Monthly stay discount percentage

#### 4.6.5 Stay Rules
```sql
minimum_stay_nights INT DEFAULT 1
```
- **Domain:** Positive integers
- **Range:** 1 to 365
- **Business Rule:** Minimum number of nights required

```sql
maximum_stay_nights INT
```
- **Domain:** Positive integers
- **Range:** 1 to 365
- **Business Rule:** Maximum number of nights allowed

```sql
is_available BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether property is available for booking

#### 4.6.6 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when pricing rule is created

```sql
updated_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Updated on every pricing modification

## 5. Location Domain Data Types

### 5.1 Addresses Table Data Types

#### 5.1.1 Primary Key
```sql
address_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 5.1.2 Foreign Keys
```sql
city_id INT NOT NULL
```
- **Domain:** Valid city_id values
- **Business Rule:** References cities.city_id

```sql
country_id INT NOT NULL
```
- **Domain:** Valid country_id values
- **Business Rule:** References countries.country_id

#### 5.1.3 Address Information
```sql
street_address VARCHAR(200) NOT NULL
```
- **Domain:** Non-empty character strings
- **Business Rule:** Required street address

```sql
postal_code VARCHAR(20)
```
- **Domain:** Alphanumeric postal codes
- **Format:** ^[A-Za-z0-9\s\-]+$
- **Business Rule:** Optional postal code

#### 5.1.4 Geographic Coordinates
```sql
latitude DECIMAL(10,8) NOT NULL
```
- **Domain:** -90.00000000 to 90.00000000
- **Precision:** 8 decimal places
- **Business Rule:** Required for location services

```sql
longitude DECIMAL(11,8) NOT NULL
```
- **Domain:** -180.00000000 to 180.00000000
- **Precision:** 8 decimal places
- **Business Rule:** Required for location services

### 5.2 Cities Table Data Types

#### 5.2.1 Primary Key
```sql
city_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 5.2.2 Foreign Key
```sql
country_id INT NOT NULL
```
- **Domain:** Valid country_id values
- **Business Rule:** References countries.country_id

#### 5.2.3 City Information
```sql
city_name VARCHAR(100) NOT NULL
```
- **Domain:** Non-empty character strings
- **Business Rule:** Required city name

```sql
state_province VARCHAR(100)
```
- **Domain:** Character strings
- **Business Rule:** Optional state or province

```sql
timezone VARCHAR(50)
```
- **Domain:** Valid timezone identifiers
- **Format:** IANA timezone format
- **Business Rule:** City timezone

```sql
population INT
```
- **Domain:** Non-negative integers
- **Range:** 0 to 2,147,483,647
- **Business Rule:** Optional population count

### 5.3 Countries Table Data Types

#### 5.3.1 Primary Key
```sql
country_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 5.3.2 Country Information
```sql
country_name VARCHAR(100) NOT NULL UNIQUE
```
- **Domain:** Unique country names
- **Business Rule:** Required country name

```sql
country_code VARCHAR(3) NOT NULL UNIQUE
```
- **Domain:** 3-letter ISO country codes
- **Format:** ^[A-Z]{3}$
- **Business Rule:** ISO 3166-1 alpha-3 codes

```sql
currency_code VARCHAR(3) NOT NULL
```
- **Domain:** 3-letter ISO currency codes
- **Format:** ^[A-Z]{3}$
- **Business Rule:** ISO 4217 currency codes

```sql
phone_code VARCHAR(5)
```
- **Domain:** International phone codes
- **Format:** ^\+?[0-9]+$
- **Business Rule:** Optional phone country code

## 6. Booking System Domain Data Types

### 6.1 Bookings Table Data Types

#### 6.1.1 Primary Key
```sql
booking_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 6.1.2 Foreign Keys
```sql
guest_profile_id INT NOT NULL
```
- **Domain:** Valid guest_profile_id values
- **Business Rule:** References guest_profiles.guest_profile_id

```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id for audit trail

```sql
property_id INT NOT NULL
```
- **Domain:** Valid property_id values
- **Business Rule:** References properties.property_id

```sql
booking_status_id INT NOT NULL
```
- **Domain:** Valid status_id values
- **Business Rule:** References booking_status.status_id

#### 6.1.3 Booking Details
```sql
check_in_date DATE NOT NULL
```
- **Domain:** Valid date values
- **Format:** YYYY-MM-DD
- **Business Rule:** Required check-in date

```sql
check_out_date DATE NOT NULL
```
- **Domain:** Valid date values
- **Format:** YYYY-MM-DD
- **Business Rule:** Required check-out date, must be after check_in_date

```sql
number_of_guests INT NOT NULL
```
- **Domain:** Positive integers
- **Range:** 1 to 50
- **Business Rule:** Number of guests for booking

```sql
total_amount DECIMAL(10,2) NOT NULL
```
- **Domain:** Positive decimal numbers
- **Range:** 0.01 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Total booking amount

#### 6.1.4 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when booking is created

```sql
confirmed_at DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when booking is confirmed

### 6.2 Booking Status Table Data Types

#### 6.2.1 Primary Key
```sql
status_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 6.2.2 Status Information
```sql
status_name VARCHAR(50) NOT NULL UNIQUE
```
- **Domain:** {'pending', 'confirmed', 'cancelled', 'completed', 'disputed'}
- **Business Rule:** Predefined status values only

```sql
description TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional status description

```sql
is_active BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether status is currently active

### 6.3 Booking Modifications Table Data Types

#### 6.3.1 Primary Key
```sql
modification_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 6.3.2 Foreign Keys
```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

```sql
approved_by INT
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

#### 6.3.3 Modification Details
```sql
modification_type VARCHAR(50) NOT NULL
```
- **Domain:** {'date_change', 'guest_count_change', 'cancellation', 'refund'}
- **Business Rule:** Type of modification being made

```sql
old_value TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Previous value before modification

```sql
new_value TEXT
```
- **Domain:** Free-form text
- **Business Rule:** New value after modification

```sql
reason TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Reason for modification

#### 6.3.4 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when modification is created

## 7. Financial Domain Data Types

### 7.1 Payments Table Data Types

#### 7.1.1 Primary Key
```sql
payment_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 7.1.2 Foreign Keys
```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

```sql
payment_method_id INT NOT NULL
```
- **Domain:** Valid payment_method_id values
- **Business Rule:** References payment_methods.payment_method_id

#### 7.1.3 Payment Information
```sql
amount DECIMAL(10,2) NOT NULL
```
- **Domain:** Positive decimal numbers
- **Range:** 0.01 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Payment amount

```sql
currency VARCHAR(3) NOT NULL
```
- **Domain:** 3-letter ISO currency codes
- **Format:** ^[A-Z]{3}$
- **Business Rule:** ISO 4217 currency codes

```sql
payment_status VARCHAR(20) NOT NULL
```
- **Domain:** {'pending', 'processing', 'completed', 'failed', 'refunded', 'disputed'}
- **Business Rule:** Current payment status

```sql
transaction_id VARCHAR(100) UNIQUE
```
- **Domain:** Unique transaction identifiers
- **Format:** ^[A-Za-z0-9]+$
- **Business Rule:** External payment processor transaction ID

#### 7.1.4 Timestamps
```sql
processed_at DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when payment is processed

```sql
refunded_at DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when payment is refunded

### 7.2 Payment Methods Table Data Types

#### 7.2.1 Primary Key
```sql
payment_method_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 7.2.2 Foreign Key
```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

#### 7.2.3 Payment Method Information
```sql
method_type VARCHAR(50) NOT NULL
```
- **Domain:** {'credit_card', 'debit_card', 'paypal', 'bank_transfer', 'crypto'}
- **Business Rule:** Type of payment method

```sql
card_last_four VARCHAR(4)
```
- **Domain:** 4-digit card numbers
- **Format:** ^[0-9]{4}$
- **Business Rule:** Last four digits of card number

```sql
expiry_date VARCHAR(7)
```
- **Domain:** Card expiry dates
- **Format:** ^(0[1-9]|1[0-2])/[0-9]{4}$
- **Business Rule:** MM/YYYY format

```sql
is_default BOOLEAN DEFAULT FALSE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether this is the default payment method

```sql
is_active BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether payment method is active

### 7.3 Payouts Table Data Types

#### 7.3.1 Primary Key
```sql
payout_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 7.3.2 Foreign Keys
```sql
host_profile_id INT NOT NULL
```
- **Domain:** Valid host_profile_id values
- **Business Rule:** References host_profiles.host_profile_id

```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

#### 7.3.3 Payout Information
```sql
amount DECIMAL(10,2) NOT NULL
```
- **Domain:** Positive decimal numbers
- **Range:** 0.01 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Payout amount

```sql
currency VARCHAR(3) NOT NULL
```
- **Domain:** 3-letter ISO currency codes
- **Format:** ^[A-Z]{3}$
- **Business Rule:** ISO 4217 currency codes

```sql
payout_status VARCHAR(20) NOT NULL
```
- **Domain:** {'pending', 'processing', 'completed', 'failed', 'cancelled'}
- **Business Rule:** Current payout status

#### 7.3.4 Timestamps
```sql
scheduled_date DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Scheduled payout date

```sql
processed_date DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when payout is processed

## 8. Review System Domain Data Types

### 8.1 Reviews Table Data Types

#### 8.1.1 Primary Key
```sql
review_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 8.1.2 Foreign Keys
```sql
reviewer_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id (reviewer)

```sql
reviewee_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id (reviewee)

```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

#### 8.1.3 Review Information
```sql
rating INT NOT NULL
```
- **Domain:** 1 to 5
- **Range:** 1, 2, 3, 4, 5
- **Business Rule:** Overall rating scale

```sql
review_text TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional review text

```sql
is_public BOOLEAN DEFAULT TRUE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether review is publicly visible

#### 8.1.4 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when review is created

```sql
updated_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Updated on every review modification

### 8.2 Review Categories Table Data Types

#### 8.2.1 Primary Key
```sql
category_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 8.2.2 Category Information
```sql
category_name VARCHAR(50) NOT NULL UNIQUE
```
- **Domain:** Unique category names
- **Business Rule:** Predefined review categories only

```sql
description TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional category description

```sql
weight DECIMAL(3,2) DEFAULT 1.00
```
- **Domain:** 0.00 to 1.00
- **Precision:** 2 decimal places
- **Business Rule:** Weight for category in overall rating

### 8.3 Review Ratings Table Data Types

#### 8.3.1 Primary Key
```sql
rating_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 8.3.2 Foreign Keys
```sql
review_id INT NOT NULL
```
- **Domain:** Valid review_id values
- **Business Rule:** References reviews.review_id

```sql
category_id INT NOT NULL
```
- **Domain:** Valid category_id values
- **Business Rule:** References review_categories.category_id

#### 8.3.3 Rating Information
```sql
rating_value INT NOT NULL
```
- **Domain:** 1 to 5
- **Range:** 1, 2, 3, 4, 5
- **Business Rule:** Category-specific rating

## 9. Communication Domain Data Types

### 9.1 Conversations Table Data Types

#### 9.1.1 Primary Key
```sql
conversation_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 9.1.2 Foreign Keys
```sql
participant1_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id (first participant)

```sql
participant2_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id (second participant)

```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

#### 9.1.3 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when conversation is created

```sql
last_message_at DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when last message is sent

### 9.2 Messages Table Data Types

#### 9.2.1 Primary Key
```sql
message_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 9.2.2 Foreign Keys
```sql
conversation_id INT NOT NULL
```
- **Domain:** Valid conversation_id values
- **Business Rule:** References conversations.conversation_id

```sql
sender_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id (message sender)

#### 9.2.3 Message Information
```sql
message_text TEXT NOT NULL
```
- **Domain:** Non-empty text
- **Business Rule:** Required message content

```sql
message_type VARCHAR(20) DEFAULT 'text'
```
- **Domain:** {'text', 'image', 'file', 'system'}
- **Business Rule:** Type of message content

#### 9.2.4 Timestamps
```sql
sent_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when message is sent

```sql
read_at DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when message is read

## 10. System Domain Data Types

### 10.1 Notifications Table Data Types

#### 10.1.1 Primary Key
```sql
notification_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 10.1.2 Foreign Key
```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

#### 10.1.3 Notification Information
```sql
notification_type VARCHAR(50) NOT NULL
```
- **Domain:** {'booking', 'payment', 'review', 'message', 'system', 'promotion'}
- **Business Rule:** Type of notification

```sql
title VARCHAR(200) NOT NULL
```
- **Domain:** Non-empty character strings
- **Business Rule:** Required notification title

```sql
message TEXT NOT NULL
```
- **Domain:** Non-empty text
- **Business Rule:** Required notification message

```sql
is_read BOOLEAN DEFAULT FALSE
```
- **Domain:** TRUE or FALSE
- **Business Rule:** Whether notification has been read

#### 10.1.4 Timestamps
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when notification is created

```sql
sent_at DATETIME
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when notification is sent

## 11. Triple Relationship Tables Data Types

### 11.1 Property-Booking-Pricing Junction Data Types

#### 11.1.1 Primary Key
```sql
pbp_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 11.1.2 Foreign Keys
```sql
property_id INT NOT NULL
```
- **Domain:** Valid property_id values
- **Business Rule:** References properties.property_id

```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

```sql
pricing_id INT NOT NULL
```
- **Domain:** Valid pricing_id values
- **Business Rule:** References property_pricing.pricing_id

#### 11.1.3 Junction Information
```sql
applied_price DECIMAL(10,2) NOT NULL
```
- **Domain:** Positive decimal numbers
- **Range:** 0.01 to 999999.99
- **Precision:** 2 decimal places
- **Business Rule:** Price applied to booking

```sql
pricing_rule_applied VARCHAR(100)
```
- **Domain:** Character strings
- **Business Rule:** Description of pricing rule applied

#### 11.1.4 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when junction record is created

### 11.2 User-Booking-Review Junction Data Types

#### 11.2.1 Primary Key
```sql
ubr_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 11.2.2 Foreign Keys
```sql
user_id INT NOT NULL
```
- **Domain:** Valid user_id values
- **Business Rule:** References users.user_id

```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

```sql
review_id INT NOT NULL
```
- **Domain:** Valid review_id values
- **Business Rule:** References reviews.review_id

#### 11.2.3 Junction Information
```sql
review_role VARCHAR(20) NOT NULL
```
- **Domain:** {'reviewer', 'reviewee'}
- **Business Rule:** Role of user in review

```sql
interaction_type VARCHAR(50)
```
- **Domain:** {'written', 'received', 'responded'}
- **Business Rule:** Type of review interaction

#### 11.2.4 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when junction record is created

### 11.3 Booking-Payment-Payout Junction Data Types

#### 11.3.1 Primary Key
```sql
bpp_id INT AUTO_INCREMENT PRIMARY KEY
```
- **Domain:** Positive integers starting from 1
- **Range:** 1 to 2,147,483,647
- **Business Rule:** System-generated, unique identifier

#### 11.3.2 Foreign Keys
```sql
booking_id INT NOT NULL
```
- **Domain:** Valid booking_id values
- **Business Rule:** References bookings.booking_id

```sql
payment_id INT NOT NULL
```
- **Domain:** Valid payment_id values
- **Business Rule:** References payments.payment_id

```sql
payout_id INT
```
- **Domain:** Valid payout_id values
- **Business Rule:** References payouts.payout_id

#### 11.3.3 Junction Information
```sql
transaction_chain_status VARCHAR(20) NOT NULL
```
- **Domain:** {'pending', 'completed', 'failed'}
- **Business Rule:** Status of transaction chain

```sql
processing_notes TEXT
```
- **Domain:** Free-form text
- **Business Rule:** Optional processing notes

#### 11.3.4 System Fields
```sql
created_at DATETIME NOT NULL
```
- **Domain:** Valid datetime values
- **Format:** YYYY-MM-DD HH:MM:SS
- **Business Rule:** Set when junction record is created

## 12. Data Type Summary

### 12.1 Data Type Statistics

| Data Type | Count | Purpose |
|-----------|-------|---------|
| **INT** | 45 | Primary keys, foreign keys, counts |
| **VARCHAR** | 67 | Variable-length text fields |
| **DECIMAL** | 23 | Monetary values, coordinates, percentages |
| **DATETIME** | 31 | Timestamps and date/time values |
| **DATE** | 8 | Date-only values |
| **TEXT** | 15 | Large text fields |
| **BOOLEAN** | 12 | True/false values |
| **JSON** | 4 | Structured data storage |

### 12.2 Domain Validation Summary

#### 12.2.1 Format Validation
- **Email:** ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$
- **Phone:** ^\+[1-9]\d{1,14}$
- **URL:** ^https?://[^\s]+$
- **Currency:** ^[A-Z]{3}$
- **Postal Code:** ^[A-Za-z0-9\s\-]+$

#### 12.2.2 Range Validation
- **Ratings:** 1 to 5
- **Percentages:** 0.00 to 100.00
- **Coordinates:** Latitude (-90 to 90), Longitude (-180 to 180)
- **Amounts:** 0.01 to 999999.99
- **Guests:** 1 to 50

#### 12.2.3 Enumeration Validation
- **Status Fields:** Predefined status values
- **Type Fields:** Predefined type values
- **Role Fields:** Predefined role values
- **Category Fields:** Predefined category values

### 12.3 Performance Considerations

#### 12.3.1 Storage Optimization
- **VARCHAR Lengths:** Optimized for expected content length
- **DECIMAL Precision:** Appropriate precision for business requirements
- **Index Strategy:** Strategic indexing on frequently queried fields

#### 12.3.2 Query Optimization
- **Data Type Consistency:** Consistent data types across related tables
- **Foreign Key Types:** Matching data types for efficient joins
- **Index-Friendly Types:** Data types that support efficient indexing

## 13. Conclusion

The comprehensive data type and domain specification ensures:

### 13.1 Data Integrity
- **Type Safety:** Appropriate data types for all attributes
- **Domain Validation:** Valid values enforced at database level
- **Format Consistency:** Consistent data formats across the system
- **Business Rule Support:** Data types support all business requirements

### 13.2 Performance Optimization
- **Storage Efficiency:** Optimized data types for storage requirements
- **Query Performance:** Data types that support efficient querying
- **Index Support:** Data types that work well with database indexes

### 13.3 Maintainability
- **Clear Documentation:** All data types and domains documented
- **Consistent Naming:** Consistent naming conventions
- **Extensibility:** Data types that support future enhancements

The data type and domain specification provides a robust foundation for data storage, validation, and performance in the Airbnb database design.

---

**Document Version:** 1.0  
**Last Updated:** 14/10/2025
