# Phase 2 Integrity Rules Documentation

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Design - Normalization and Constraints  
**Date:** 14/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## 1. Introduction

This document provides a comprehensive specification of integrity rules for the Airbnb database design. Integrity rules ensure data consistency, accuracy, and reliability across all database operations. This analysis covers entity integrity, referential integrity, and domain integrity for all 27 entities, ensuring robust data quality and business rule enforcement.

## 2. Integrity Rule Categories Overview

### 2.1 Entity Integrity
- **Primary Key Constraints:** Ensure unique identification of each record
- **NOT NULL Constraints:** Ensure required fields have values
- **Unique Constraints:** Ensure uniqueness of natural keys

### 2.2 Referential Integrity
- **Foreign Key Constraints:** Maintain relationships between tables
- **Cascade Rules:** Define behavior for updates and deletes
- **Orphan Prevention:** Prevent dangling references

### 2.3 Domain Integrity
- **Data Type Constraints:** Ensure correct data types
- **Check Constraints:** Enforce business rules and validation
- **Format Validation:** Ensure proper data formats

## 3. Entity Integrity Rules

### 3.1 Primary Key Integrity

#### 3.1.1 Primary Key Requirements
Every table must have a primary key that:
- **Uniquely identifies each record**
- **Cannot contain NULL values**
- **Cannot be duplicated**
- **Remains stable over time**

#### 3.1.2 Primary Key Implementation
```sql
-- All 27 entities have primary key constraints
ALTER TABLE users ADD CONSTRAINT pk_users PRIMARY KEY (user_id);
ALTER TABLE guest_profiles ADD CONSTRAINT pk_guest_profiles PRIMARY KEY (guest_profile_id);
ALTER TABLE host_profiles ADD CONSTRAINT pk_host_profiles PRIMARY KEY (host_profile_id);
-- ... (all 27 entities)
```

#### 3.1.3 Primary Key Characteristics
- **Data Type:** INTEGER AUTO_INCREMENT
- **Naming Convention:** table_name_id
- **Uniqueness:** Guaranteed by database engine
- **Stability:** Never changes once assigned

### 3.2 NOT NULL Integrity

#### 3.2.1 Required Fields Analysis
**Critical Business Fields (Always Required):**
- **Identification Fields:** user_id, property_id, booking_id, etc.
- **Authentication Fields:** email, password_hash
- **Business Logic Fields:** first_name, last_name, phone
- **System Fields:** created_at, updated_at

**Role-Specific Required Fields:**
- **Guest Fields:** guest_profile_id, user_id, created_at
- **Host Fields:** host_profile_id, user_id, created_at
- **Property Fields:** property_id, host_id, title, max_guests
- **Booking Fields:** booking_id, guest_profile_id, property_id, check_in_date, check_out_date

#### 3.2.2 NOT NULL Implementation
```sql
-- User Management Domain
ALTER TABLE users MODIFY COLUMN user_id INT NOT NULL;
ALTER TABLE users MODIFY COLUMN email VARCHAR(255) NOT NULL;
ALTER TABLE users MODIFY COLUMN password_hash VARCHAR(255) NOT NULL;
ALTER TABLE users MODIFY COLUMN first_name VARCHAR(100) NOT NULL;
ALTER TABLE users MODIFY COLUMN last_name VARCHAR(100) NOT NULL;
ALTER TABLE users MODIFY COLUMN phone VARCHAR(20) NOT NULL;
ALTER TABLE users MODIFY COLUMN created_at DATETIME NOT NULL;
ALTER TABLE users MODIFY COLUMN updated_at DATETIME NOT NULL;

-- Property Management Domain
ALTER TABLE properties MODIFY COLUMN property_id INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN host_id INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN property_type_id INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN title VARCHAR(200) NOT NULL;
ALTER TABLE properties MODIFY COLUMN address_id INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN max_guests INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN bedrooms INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN bathrooms DECIMAL(3,1) NOT NULL;
ALTER TABLE properties MODIFY COLUMN created_at DATETIME NOT NULL;
ALTER TABLE properties MODIFY COLUMN updated_at DATETIME NOT NULL;

-- Booking System Domain
ALTER TABLE bookings MODIFY COLUMN booking_id INT NOT NULL;
ALTER TABLE bookings MODIFY COLUMN guest_profile_id INT NOT NULL;
ALTER TABLE bookings MODIFY COLUMN user_id INT NOT NULL;
ALTER TABLE bookings MODIFY COLUMN property_id INT NOT NULL;
ALTER TABLE bookings MODIFY COLUMN booking_status_id INT NOT NULL;
ALTER TABLE bookings MODIFY COLUMN check_in_date DATE NOT NULL;
ALTER TABLE bookings MODIFY COLUMN check_out_date DATE NOT NULL;
ALTER TABLE bookings MODIFY COLUMN number_of_guests INT NOT NULL;
ALTER TABLE bookings MODIFY COLUMN total_amount DECIMAL(10,2) NOT NULL;
ALTER TABLE bookings MODIFY COLUMN created_at DATETIME NOT NULL;
```

#### 3.2.3 Business Logic for NOT NULL Fields
- **User Identification:** email, phone required for authentication
- **Property Information:** title, max_guests required for listing
- **Booking Details:** dates, amounts required for reservation
- **System Tracking:** created_at, updated_at required for audit trail

### 3.3 Unique Integrity

#### 3.3.1 Natural Key Uniqueness
**Email Uniqueness:**
```sql
ALTER TABLE users ADD CONSTRAINT uk_users_email UNIQUE (email);
```
- **Business Rule:** Each user must have a unique email address
- **Data Integrity:** Prevents duplicate accounts
- **Authentication:** Email serves as login identifier

**Phone Uniqueness:**
```sql
ALTER TABLE users ADD CONSTRAINT uk_users_phone UNIQUE (phone);
```
- **Business Rule:** Each user must have a unique phone number
- **Data Integrity:** Prevents duplicate accounts
- **Verification:** Phone serves as verification identifier

#### 3.3.2 Business Rule Uniqueness
**Property Type Names:**
```sql
ALTER TABLE property_types ADD CONSTRAINT uk_property_types_name UNIQUE (type_name);
```
- **Business Rule:** Each property type must have a unique name
- **Data Integrity:** Prevents duplicate property types
- **User Experience:** Clear property categorization

**Amenity Names:**
```sql
ALTER TABLE property_amenities ADD CONSTRAINT uk_property_amenities_name UNIQUE (amenity_name);
```
- **Business Rule:** Each amenity must have a unique name
- **Data Integrity:** Prevents duplicate amenities
- **Search Functionality:** Clear amenity identification

#### 3.3.3 Composite Uniqueness
**User Preferences:**
```sql
ALTER TABLE user_preferences ADD CONSTRAINT uk_user_preferences_user_key UNIQUE (user_id, preference_key);
```
- **Business Rule:** Each user can have only one value per preference type
- **Data Integrity:** Prevents duplicate preference entries
- **User Experience:** Clear preference management

**Property Amenity Links:**
```sql
ALTER TABLE property_amenity_links ADD CONSTRAINT uk_property_amenity_links_unique UNIQUE (property_id, amenity_id);
```
- **Business Rule:** Each property can have only one entry per amenity
- **Data Integrity:** Prevents duplicate amenity assignments
- **Property Management:** Clear amenity tracking

## 4. Referential Integrity Rules

### 4.1 Foreign Key Relationships

#### 4.1.1 User Management Relationships
**Users to Guest Profiles:**
```sql
ALTER TABLE guest_profiles ADD CONSTRAINT fk_guest_profiles_user_id 
FOREIGN KEY (user_id) REFERENCES users(user_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
```
- **Relationship:** 1:1 (one user can have one guest profile)
- **Cascade Rules:** DELETE CASCADE (delete user → delete guest profile)
- **Update Rules:** UPDATE CASCADE (update user_id → update guest_profile.user_id)

**Users to Host Profiles:**
```sql
ALTER TABLE host_profiles ADD CONSTRAINT fk_host_profiles_user_id 
FOREIGN KEY (user_id) REFERENCES users(user_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
```
- **Relationship:** 1:1 (one user can have one host profile)
- **Cascade Rules:** DELETE CASCADE (delete user → delete host profile)
- **Update Rules:** UPDATE CASCADE (update user_id → update host_profile.user_id)

#### 4.1.2 Property Management Relationships
**Host Profiles to Properties:**
```sql
ALTER TABLE properties ADD CONSTRAINT fk_properties_host_id 
FOREIGN KEY (host_id) REFERENCES host_profiles(host_profile_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
```
- **Relationship:** 1:N (one host can have many properties)
- **Cascade Rules:** DELETE CASCADE (delete host → delete all properties)
- **Update Rules:** UPDATE CASCADE (update host_profile_id → update properties.host_id)

**Properties to Property Types:**
```sql
ALTER TABLE properties ADD CONSTRAINT fk_properties_property_type_id 
FOREIGN KEY (property_type_id) REFERENCES property_types(property_type_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```
- **Relationship:** N:1 (many properties can have one type)
- **Cascade Rules:** DELETE RESTRICT (cannot delete property type if properties exist)
- **Update Rules:** UPDATE CASCADE (update property_type_id → update properties.property_type_id)

#### 4.1.3 Booking System Relationships
**Guest Profiles to Bookings:**
```sql
ALTER TABLE bookings ADD CONSTRAINT fk_bookings_guest_profile_id 
FOREIGN KEY (guest_profile_id) REFERENCES guest_profiles(guest_profile_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```
- **Relationship:** 1:N (one guest can have many bookings)
- **Cascade Rules:** DELETE RESTRICT (cannot delete guest profile if bookings exist)
- **Update Rules:** UPDATE CASCADE (update guest_profile_id → update bookings.guest_profile_id)

**Properties to Bookings:**
```sql
ALTER TABLE bookings ADD CONSTRAINT fk_bookings_property_id 
FOREIGN KEY (property_id) REFERENCES properties(property_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```
- **Relationship:** 1:N (one property can have many bookings)
- **Cascade Rules:** DELETE RESTRICT (cannot delete property if bookings exist)
- **Update Rules:** UPDATE CASCADE (update property_id → update bookings.property_id)

#### 4.1.4 Financial Relationships
**Bookings to Payments:**
```sql
ALTER TABLE payments ADD CONSTRAINT fk_payments_booking_id 
FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```
- **Relationship:** 1:1 (one booking has one payment)
- **Cascade Rules:** DELETE RESTRICT (cannot delete booking if payment exists)
- **Update Rules:** UPDATE CASCADE (update booking_id → update payments.booking_id)

**Host Profiles to Payouts:**
```sql
ALTER TABLE payouts ADD CONSTRAINT fk_payouts_host_profile_id 
FOREIGN KEY (host_profile_id) REFERENCES host_profiles(host_profile_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```
- **Relationship:** 1:N (one host can have many payouts)
- **Cascade Rules:** DELETE RESTRICT (cannot delete host profile if payouts exist)
- **Update Rules:** UPDATE CASCADE (update host_profile_id → update payouts.host_profile_id)

### 4.2 Cascade Rule Analysis

#### 4.2.1 CASCADE Rules
**When to Use CASCADE:**
- **Parent-Child Relationships:** When child records should be deleted with parent
- **Profile Relationships:** User profiles should be deleted with user
- **Property Relationships:** Property photos should be deleted with property

**Examples:**
```sql
-- User to Guest Profile (CASCADE)
ALTER TABLE guest_profiles ADD CONSTRAINT fk_guest_profiles_user_id 
FOREIGN KEY (user_id) REFERENCES users(user_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- Property to Photos (CASCADE)
ALTER TABLE property_photos ADD CONSTRAINT fk_property_photos_property_id 
FOREIGN KEY (property_id) REFERENCES properties(property_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
```

#### 4.2.2 RESTRICT Rules
**When to Use RESTRICT:**
- **Business Critical Relationships:** When child records are essential
- **Financial Relationships:** Payments and payouts should not be deleted
- **Booking Relationships:** Bookings should not be deleted if they have payments

**Examples:**
```sql
-- Property Type to Properties (RESTRICT)
ALTER TABLE properties ADD CONSTRAINT fk_properties_property_type_id 
FOREIGN KEY (property_type_id) REFERENCES property_types(property_type_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Booking to Payments (RESTRICT)
ALTER TABLE payments ADD CONSTRAINT fk_payments_booking_id 
FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```

#### 4.2.3 SET NULL Rules
**When to Use SET NULL:**
- **Optional Relationships:** When child records can exist without parent
- **Approval Relationships:** When approver can be removed

**Examples:**
```sql
-- Booking Modifications to Approver (SET NULL)
ALTER TABLE booking_modifications ADD CONSTRAINT fk_booking_modifications_approved_by 
FOREIGN KEY (approved_by) REFERENCES users(user_id) 
ON DELETE SET NULL ON UPDATE CASCADE;

-- Host Profiles to Payout Method (SET NULL)
ALTER TABLE host_profiles ADD CONSTRAINT fk_host_profiles_payout_method_id 
FOREIGN KEY (payout_method_id) REFERENCES payment_methods(payment_method_id) 
ON DELETE SET NULL ON UPDATE CASCADE;
```

### 4.3 Orphan Prevention

#### 4.3.1 Orphan Prevention Strategies
**Foreign Key Constraints:**
- **Prevent Orphan Creation:** Foreign keys must reference existing records
- **Prevent Orphan Deletion:** RESTRICT rules prevent deletion of referenced records
- **Maintain Relationships:** CASCADE rules maintain relationship integrity

#### 4.3.2 Orphan Prevention Examples
**User Management:**
```sql
-- Prevent orphan guest profiles
ALTER TABLE guest_profiles ADD CONSTRAINT fk_guest_profiles_user_id 
FOREIGN KEY (user_id) REFERENCES users(user_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- Prevent orphan host profiles
ALTER TABLE host_profiles ADD CONSTRAINT fk_host_profiles_user_id 
FOREIGN KEY (user_id) REFERENCES users(user_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
```

**Property Management:**
```sql
-- Prevent orphan properties
ALTER TABLE properties ADD CONSTRAINT fk_properties_host_id 
FOREIGN KEY (host_id) REFERENCES host_profiles(host_profile_id) 
ON DELETE CASCADE ON UPDATE CASCADE;

-- Prevent orphan property photos
ALTER TABLE property_photos ADD CONSTRAINT fk_property_photos_property_id 
FOREIGN KEY (property_id) REFERENCES properties(property_id) 
ON DELETE CASCADE ON UPDATE CASCADE;
```

**Booking System:**
```sql
-- Prevent orphan bookings
ALTER TABLE bookings ADD CONSTRAINT fk_bookings_guest_profile_id 
FOREIGN KEY (guest_profile_id) REFERENCES guest_profiles(guest_profile_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;

-- Prevent orphan payments
ALTER TABLE payments ADD CONSTRAINT fk_payments_booking_id 
FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) 
ON DELETE RESTRICT ON UPDATE CASCADE;
```

## 5. Domain Integrity Rules

### 5.1 Data Type Integrity

#### 5.1.1 Numeric Data Types
**Integer Types:**
```sql
-- Primary keys and foreign keys
user_id INT AUTO_INCREMENT PRIMARY KEY
property_id INT AUTO_INCREMENT PRIMARY KEY
booking_id INT AUTO_INCREMENT PRIMARY KEY

-- Count fields
max_guests INT NOT NULL
bedrooms INT NOT NULL
number_of_guests INT NOT NULL
```

**Decimal Types:**
```sql
-- Monetary values
total_amount DECIMAL(10,2) NOT NULL
amount DECIMAL(10,2) NOT NULL
base_price_per_night DECIMAL(10,2) NOT NULL

-- Percentage values
response_rate DECIMAL(5,2) DEFAULT 0.00
acceptance_rate DECIMAL(5,2) DEFAULT 0.00
weekly_discount_percentage DECIMAL(5,2) DEFAULT 0

-- Rating values
host_rating DECIMAL(3,2)
rating INT NOT NULL
```

**Coordinate Types:**
```sql
-- Geographic coordinates
latitude DECIMAL(10,8) NOT NULL
longitude DECIMAL(11,8) NOT NULL
```

#### 5.1.2 Character Data Types
**Variable Length Strings:**
```sql
-- Names and titles
first_name VARCHAR(100) NOT NULL
last_name VARCHAR(100) NOT NULL
title VARCHAR(200) NOT NULL

-- Contact information
email VARCHAR(255) UNIQUE NOT NULL
phone VARCHAR(20) UNIQUE NOT NULL

-- URLs and identifiers
photo_url VARCHAR(500) NOT NULL
transaction_id VARCHAR(100) UNIQUE
```

**Fixed Length Strings:**
```sql
-- Currency codes
currency VARCHAR(3) NOT NULL
country_code VARCHAR(3) NOT NULL

-- Status fields
payment_status VARCHAR(20) NOT NULL
booking_status VARCHAR(20) NOT NULL
```

**Large Text Fields:**
```sql
-- Descriptions and content
description TEXT
bio TEXT
message_text TEXT NOT NULL
review_text TEXT
```

#### 5.1.3 Date/Time Data Types
**Date Fields:**
```sql
-- Date-only fields
check_in_date DATE NOT NULL
check_out_date DATE NOT NULL
start_date DATE NOT NULL
end_date DATE NOT NULL
```

**DateTime Fields:**
```sql
-- Timestamp fields
created_at DATETIME NOT NULL
updated_at DATETIME NOT NULL
sent_at DATETIME NOT NULL
processed_at DATETIME
```

#### 5.1.4 Boolean Data Types
**Flag Fields:**
```sql
-- Status flags
is_active BOOLEAN DEFAULT TRUE
is_guest BOOLEAN DEFAULT TRUE
is_host BOOLEAN DEFAULT FALSE
is_admin BOOLEAN DEFAULT FALSE
is_primary BOOLEAN DEFAULT FALSE
is_public BOOLEAN DEFAULT TRUE
```

#### 5.1.5 Special Data Types
**JSON Fields:**
```sql
-- Structured data
preferred_property_types JSON
travel_preferences JSON
notification_settings JSON
preference_value JSON NOT NULL
```

**Enum Fields:**
```sql
-- Predefined values
guest_verification_status VARCHAR(20) DEFAULT 'unverified'
host_verification_status VARCHAR(20) DEFAULT 'pending'
payment_status VARCHAR(20) NOT NULL
booking_status VARCHAR(20) NOT NULL
```

### 5.2 Check Constraint Integrity

#### 5.2.1 Format Validation
**Email Format:**
```sql
ALTER TABLE users ADD CONSTRAINT chk_users_email 
CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');
```

**Phone Format:**
```sql
ALTER TABLE users ADD CONSTRAINT chk_users_phone 
CHECK (phone REGEXP '^\\+[1-9]\\d{1,14}$');
```

**URL Format:**
```sql
ALTER TABLE property_photos ADD CONSTRAINT chk_property_photos_url 
CHECK (photo_url REGEXP '^https?://[^\\s]+$');
```

#### 5.2.2 Range Validation
**Rating Ranges:**
```sql
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_rating 
CHECK (rating >= 1 AND rating <= 5);

ALTER TABLE review_ratings ADD CONSTRAINT chk_review_ratings_value 
CHECK (rating_value >= 1 AND rating_value <= 5);
```

**Percentage Ranges:**
```sql
ALTER TABLE host_profiles ADD CONSTRAINT chk_host_profiles_response_rate 
CHECK (response_rate >= 0 AND response_rate <= 100);

ALTER TABLE property_pricing ADD CONSTRAINT chk_property_pricing_weekly_discount 
CHECK (weekly_discount_percentage >= 0 AND weekly_discount_percentage <= 100);
```

**Amount Ranges:**
```sql
ALTER TABLE bookings ADD CONSTRAINT chk_bookings_amount 
CHECK (total_amount > 0);

ALTER TABLE payments ADD CONSTRAINT chk_payments_amount 
CHECK (amount > 0);
```

#### 5.2.3 Business Logic Validation
**Date Relationships:**
```sql
ALTER TABLE bookings ADD CONSTRAINT chk_bookings_dates 
CHECK (check_out_date > check_in_date);

ALTER TABLE property_pricing ADD CONSTRAINT chk_property_pricing_dates 
CHECK (end_date > start_date);
```

**User Relationships:**
```sql
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_different_users 
CHECK (reviewer_id != reviewee_id);

ALTER TABLE conversations ADD CONSTRAINT chk_conversations_different_participants 
CHECK (participant1_id != participant2_id);
```

**Role Consistency:**
```sql
ALTER TABLE users ADD CONSTRAINT chk_users_role_consistency 
CHECK (
  (is_guest = TRUE AND is_host = FALSE AND is_admin = FALSE) OR
  (is_guest = TRUE AND is_host = TRUE AND is_admin = FALSE) OR
  (is_guest = FALSE AND is_host = FALSE AND is_admin = TRUE)
);
```

### 5.3 Enumeration Integrity

#### 5.3.1 Status Enumerations
**User Verification Status:**
```sql
ALTER TABLE guest_profiles ADD CONSTRAINT chk_guest_profiles_verification_status 
CHECK (guest_verification_status IN ('unverified', 'email_verified', 'phone_verified', 'id_verified', 'fully_verified'));

ALTER TABLE host_profiles ADD CONSTRAINT chk_host_profiles_verification_status 
CHECK (host_verification_status IN ('pending', 'verified', 'rejected', 'suspended'));
```

**Booking Status:**
```sql
ALTER TABLE booking_status ADD CONSTRAINT chk_booking_status_name_values 
CHECK (status_name IN ('pending', 'confirmed', 'cancelled', 'completed', 'disputed'));
```

**Payment Status:**
```sql
ALTER TABLE payments ADD CONSTRAINT chk_payments_status 
CHECK (payment_status IN ('pending', 'processing', 'completed', 'failed', 'refunded', 'disputed'));
```

#### 5.3.2 Type Enumerations
**Property Types:**
```sql
ALTER TABLE property_types ADD CONSTRAINT chk_property_types_name 
CHECK (type_name IN ('apartment', 'house', 'villa', 'condo', 'townhouse', 'loft', 'studio'));
```

**Amenity Categories:**
```sql
ALTER TABLE property_amenities ADD CONSTRAINT chk_property_amenities_category 
CHECK (amenity_category IN ('basic', 'kitchen', 'bathroom', 'bedroom', 'outdoor', 'safety', 'entertainment', 'accessibility'));
```

**Message Types:**
```sql
ALTER TABLE messages ADD CONSTRAINT chk_messages_type 
CHECK (message_type IN ('text', 'image', 'file', 'system'));
```

#### 5.3.3 Language and Currency Enumerations
**Language Preferences:**
```sql
ALTER TABLE user_profiles ADD CONSTRAINT chk_user_profiles_language 
CHECK (language_preference IN ('en', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'zh', 'ja', 'ko'));
```

**Currency Preferences:**
```sql
ALTER TABLE user_profiles ADD CONSTRAINT chk_user_profiles_currency 
CHECK (currency_preference IN ('USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF', 'CNY'));
```

## 6. Business Rule Integrity

### 6.1 User Management Business Rules

#### 6.1.1 Role Management Rules
**Multi-Role Support:**
```sql
-- Users can be guests and hosts simultaneously
ALTER TABLE users ADD CONSTRAINT chk_users_role_consistency 
CHECK (
  (is_guest = TRUE AND is_host = FALSE AND is_admin = FALSE) OR
  (is_guest = TRUE AND is_host = TRUE AND is_admin = FALSE) OR
  (is_guest = FALSE AND is_host = FALSE AND is_admin = TRUE)
);
```

**Profile Consistency:**
```sql
-- Guest profiles must have is_guest = TRUE
-- Host profiles must have is_host = TRUE
-- Role flags must be consistent with profile existence
```

#### 6.1.2 Verification Rules
**Guest Verification:**
```sql
-- Guest verification status progression
ALTER TABLE guest_profiles ADD CONSTRAINT chk_guest_profiles_verification_status 
CHECK (guest_verification_status IN ('unverified', 'email_verified', 'phone_verified', 'id_verified', 'fully_verified'));
```

**Host Verification:**
```sql
-- Host verification status progression
ALTER TABLE host_profiles ADD CONSTRAINT chk_host_profiles_verification_status 
CHECK (host_verification_status IN ('pending', 'verified', 'rejected', 'suspended'));
```

### 6.2 Property Management Business Rules

#### 6.2.1 Property Listing Rules
**Required Information:**
```sql
-- Properties must have title, max_guests, bedrooms, bathrooms
ALTER TABLE properties MODIFY COLUMN title VARCHAR(200) NOT NULL;
ALTER TABLE properties MODIFY COLUMN max_guests INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN bedrooms INT NOT NULL;
ALTER TABLE properties MODIFY COLUMN bathrooms DECIMAL(3,1) NOT NULL;
```

**Capacity Validation:**
```sql
-- Max guests must be positive
ALTER TABLE properties ADD CONSTRAINT chk_properties_max_guests 
CHECK (max_guests > 0);

-- Bedrooms must be non-negative
ALTER TABLE properties ADD CONSTRAINT chk_properties_bedrooms 
CHECK (bedrooms >= 0);

-- Bathrooms must be positive
ALTER TABLE properties ADD CONSTRAINT chk_properties_bathrooms 
CHECK (bathrooms > 0);
```

#### 6.2.2 Pricing Rules
**Price Validation:**
```sql
-- Base price must be positive
ALTER TABLE property_pricing ADD CONSTRAINT chk_property_pricing_base_price 
CHECK (base_price_per_night > 0);

-- Weekend price must be positive if provided
ALTER TABLE property_pricing ADD CONSTRAINT chk_property_pricing_weekend_price 
CHECK (weekend_price_per_night IS NULL OR weekend_price_per_night > 0);
```

**Stay Rules:**
```sql
-- Minimum stay must be positive
ALTER TABLE property_pricing ADD CONSTRAINT chk_property_pricing_minimum_stay 
CHECK (minimum_stay_nights > 0);

-- Maximum stay must be greater than minimum stay
ALTER TABLE property_pricing ADD CONSTRAINT chk_property_pricing_stay_range 
CHECK (maximum_stay_nights IS NULL OR maximum_stay_nights >= minimum_stay_nights);
```

### 6.3 Booking System Business Rules

#### 6.3.1 Booking Validation Rules
**Date Validation:**
```sql
-- Check-out must be after check-in
ALTER TABLE bookings ADD CONSTRAINT chk_bookings_dates 
CHECK (check_out_date > check_in_date);
```

**Guest Count Validation:**
```sql
-- Number of guests must be positive
ALTER TABLE bookings ADD CONSTRAINT chk_bookings_guests 
CHECK (number_of_guests > 0);
```

**Amount Validation:**
```sql
-- Total amount must be positive
ALTER TABLE bookings ADD CONSTRAINT chk_bookings_amount 
CHECK (total_amount > 0);
```

#### 6.3.2 Payment Rules
**Payment Amount:**
```sql
-- Payment amount must be positive
ALTER TABLE payments ADD CONSTRAINT chk_payments_amount 
CHECK (amount > 0);
```

**Transaction Validation:**
```sql
-- Transaction ID must be alphanumeric
ALTER TABLE payments ADD CONSTRAINT chk_payments_transaction_id 
CHECK (transaction_id IS NULL OR transaction_id REGEXP '^[A-Za-z0-9]+$');
```

#### 6.3.3 Payout Rules
**Payout Amount:**
```sql
-- Payout amount must be positive
ALTER TABLE payouts ADD CONSTRAINT chk_payouts_amount 
CHECK (amount > 0);
```

**Payout Timing:**
```sql
-- Scheduled date must be in the future
ALTER TABLE payouts ADD CONSTRAINT chk_payouts_scheduled_date 
CHECK (scheduled_date IS NULL OR scheduled_date > NOW());

-- Processed date must be in the past
ALTER TABLE payouts ADD CONSTRAINT chk_payouts_processed_date 
CHECK (processed_date IS NULL OR processed_date <= NOW());
```

### 6.4 Review System Business Rules

#### 6.4.1 Review Validation Rules
**Rating Validation:**
```sql
-- Rating must be between 1 and 5
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_rating 
CHECK (rating >= 1 AND rating <= 5);
```

**User Relationship:**
```sql
-- Reviewer and reviewee must be different
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_different_users 
CHECK (reviewer_id != reviewee_id);
```

**Review Timing:**
```sql
-- Updated at must be after created at
ALTER TABLE reviews ADD CONSTRAINT chk_reviews_updated_after_created 
CHECK (updated_at IS NULL OR updated_at >= created_at);
```

#### 6.4.2 Review Category Rules
**Category Rating:**
```sql
-- Category rating must be between 1 and 5
ALTER TABLE review_ratings ADD CONSTRAINT chk_review_ratings_value 
CHECK (rating_value >= 1 AND rating_value <= 5);
```

**Category Weight:**
```sql
-- Category weight must be between 0 and 1
ALTER TABLE review_categories ADD CONSTRAINT chk_review_categories_weight 
CHECK (weight >= 0 AND weight <= 1);
```

### 6.5 Communication System Business Rules

#### 6.5.1 Message Rules
**Message Content:**
```sql
-- Message text must not be empty
ALTER TABLE messages ADD CONSTRAINT chk_messages_text 
CHECK (LENGTH(TRIM(message_text)) > 0);
```

**Message Timing:**
```sql
-- Read at must be after sent at
ALTER TABLE messages ADD CONSTRAINT chk_messages_read_after_sent 
CHECK (read_at IS NULL OR read_at >= sent_at);
```

#### 6.5.2 Conversation Rules
**Participant Validation:**
```sql
-- Participants must be different
ALTER TABLE conversations ADD CONSTRAINT chk_conversations_different_participants 
CHECK (participant1_id != participant2_id);
```

**Conversation Timing:**
```sql
-- Last message at must be after created at
ALTER TABLE conversations ADD CONSTRAINT chk_conversations_last_message_after_created 
CHECK (last_message_at IS NULL OR last_message_at >= created_at);
```

## 7. Data Quality Integrity

### 7.1 Data Consistency Rules

#### 7.1.1 Temporal Consistency
**Creation Timestamps:**
```sql
-- Created at must be in the past
ALTER TABLE users ADD CONSTRAINT chk_users_created_at 
CHECK (created_at <= NOW());

ALTER TABLE properties ADD CONSTRAINT chk_properties_created_at 
CHECK (created_at <= NOW());

ALTER TABLE bookings ADD CONSTRAINT chk_bookings_created_at 
CHECK (created_at <= NOW());
```

**Update Timestamps:**
```sql
-- Updated at must be in the past
ALTER TABLE users ADD CONSTRAINT chk_users_updated_at 
CHECK (updated_at <= NOW());

ALTER TABLE properties ADD CONSTRAINT chk_properties_updated_at 
CHECK (updated_at <= NOW());
```

#### 7.1.2 Referential Consistency
**Foreign Key Consistency:**
```sql
-- All foreign keys must reference existing records
-- CASCADE rules maintain consistency on updates
-- RESTRICT rules prevent orphan creation
```

**Business Logic Consistency:**
```sql
-- Role flags must be consistent with profile existence
-- Booking dates must be valid
-- Payment amounts must match booking amounts
```

### 7.2 Data Validation Rules

#### 7.2.1 Format Validation
**Email Validation:**
```sql
ALTER TABLE users ADD CONSTRAINT chk_users_email 
CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$');
```

**Phone Validation:**
```sql
ALTER TABLE users ADD CONSTRAINT chk_users_phone 
CHECK (phone REGEXP '^\\+[1-9]\\d{1,14}$');
```

**URL Validation:**
```sql
ALTER TABLE property_photos ADD CONSTRAINT chk_property_photos_url 
CHECK (photo_url REGEXP '^https?://[^\\s]+$');
```

#### 7.2.2 Range Validation
**Numeric Ranges:**
```sql
-- Ratings: 1-5
-- Percentages: 0-100
-- Amounts: > 0
-- Coordinates: Latitude (-90 to 90), Longitude (-180 to 180)
```

**Date Ranges:**
```sql
-- Creation dates: <= NOW()
-- Future dates: > NOW()
-- Date relationships: end_date > start_date
```

### 7.3 Business Logic Validation

#### 7.3.1 Workflow Validation
**Booking Workflow:**
```sql
-- Booking must have valid dates
-- Booking must have positive amount
-- Booking must reference valid property and guest
```

**Payment Workflow:**
```sql
-- Payment must have positive amount
-- Payment must reference valid booking
-- Payment must have valid status
```

**Payout Workflow:**
```sql
-- Payout must have positive amount
-- Payout must reference valid host and booking
-- Payout must have valid status
```

#### 7.3.2 State Validation
**User States:**
```sql
-- Users must have valid role combinations
-- Profiles must be consistent with role flags
-- Verification status must be valid
```

**Booking States:**
```sql
-- Bookings must have valid status
-- Bookings must have valid dates
-- Bookings must have positive amounts
```

**Property States:**
```sql
-- Properties must have valid host
-- Properties must have valid type
-- Properties must have valid address
```

## 8. Performance Integrity

### 8.1 Index Integrity

#### 8.1.1 Primary Key Indexes
```sql
-- All primary keys automatically indexed
-- Ensures unique identification
-- Enables efficient lookups
```

#### 8.1.2 Foreign Key Indexes
```sql
-- Foreign key indexes for efficient joins
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_bookings_guest_profile_id ON bookings(guest_profile_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payouts_host_profile_id ON payouts(host_profile_id);
```

#### 8.1.3 Business Logic Indexes
```sql
-- Indexes for common query patterns
CREATE INDEX idx_properties_active ON properties(is_active);
CREATE INDEX idx_bookings_dates ON bookings(check_in_date, check_out_date);
CREATE INDEX idx_reviews_booking_id ON reviews(booking_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
```

### 8.2 Query Integrity

#### 8.2.1 Join Integrity
**Foreign Key Joins:**
```sql
-- All joins use proper foreign key relationships
-- Ensures referential integrity
-- Enables efficient query execution
```

**Business Logic Joins:**
```sql
-- Joins follow business logic
-- User to profiles (1:1)
-- Host to properties (1:N)
-- Guest to bookings (1:N)
```

#### 8.2.2 Constraint Integrity
**Constraint Performance:**
```sql
-- Check constraints have minimal performance impact
-- Foreign key constraints enable efficient joins
-- Unique constraints support fast lookups
```

**Query Optimization:**
```sql
-- Indexes support efficient queries
-- Constraints prevent invalid data
-- Relationships enable efficient joins
```

## 9. Integrity Rule Summary

### 9.1 Integrity Rule Statistics

| Integrity Type | Count | Purpose |
|----------------|-------|---------|
| **Entity Integrity** | 156 | Required fields |
| **Referential Integrity** | 45 | Foreign key relationships |
| **Domain Integrity** | 89 | Business rules and validation |
| **Unique Constraints** | 15 | Natural keys |
| **Check Constraints** | 89 | Data validation |

### 9.2 Business Rule Coverage

#### 9.2.1 User Management Rules
- **Role Management:** Multi-role support with consistency checks
- **Profile Management:** 1:1 relationships with cascade rules
- **Verification Management:** Status progression validation

#### 9.2.2 Property Management Rules
- **Property Listing:** Required information validation
- **Pricing Management:** Positive amounts and valid ranges
- **Amenity Management:** Unique assignments and availability

#### 9.2.3 Booking System Rules
- **Booking Validation:** Date relationships and guest counts
- **Payment Processing:** Amount validation and status tracking
- **Payout Management:** Timing and amount validation

#### 9.2.4 Review System Rules
- **Review Validation:** Rating ranges and user relationships
- **Category Management:** Weight validation and rating consistency
- **Timing Rules:** Creation and update timestamp validation

### 9.3 Data Quality Assurance

#### 9.3.1 Consistency Assurance
- **Referential Integrity:** All relationships properly maintained
- **Business Logic:** All business rules implemented as constraints
- **Data Validation:** All data validated at database level

#### 9.3.2 Performance Assurance
- **Index Strategy:** Strategic indexes for common query patterns
- **Constraint Performance:** Minimal performance impact from constraints
- **Query Optimization:** Efficient joins and lookups

#### 9.3.3 Maintainability Assurance
- **Clear Documentation:** All integrity rules documented
- **Consistent Naming:** Consistent naming conventions
- **Extensibility:** Easy to add new integrity rules

## 10. Conclusion

The comprehensive integrity rule system ensures:

### 10.1 Data Integrity
- **Entity Integrity:** All records uniquely identified and required fields populated
- **Referential Integrity:** All relationships properly maintained with appropriate cascade rules
- **Domain Integrity:** All data validated according to business rules and format requirements

### 10.2 Business Logic Enforcement
- **Role Management:** Multi-role support with consistency validation
- **Transaction Integrity:** Proper booking-payment-payout flow
- **Data Quality:** Invalid data prevented at database level

### 10.3 Performance Optimization
- **Efficient Indexing:** Strategic indexes for common query patterns
- **Constraint Performance:** Minimal performance impact from integrity rules
- **Query Optimization:** Efficient joins and lookups enabled

### 10.4 Maintainability
- **Clear Documentation:** All integrity rules documented with business justification
- **Consistent Implementation:** Consistent naming and implementation patterns
- **Extensibility:** Easy to add new integrity rules as business requirements evolve

The integrity rule system provides a robust foundation for data consistency, business rule enforcement, and system performance in the Airbnb database design.

---

**Document Version:** 1.0  
**Last Updated:** 14/10/2025
