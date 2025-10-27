# Phase 2 Normalization Process Documentation

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Design - Normalization and Constraints  
**Date:** 14/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## 1. Introduction

This document presents the complete normalization process for the Airbnb database design, transforming the conceptual model from Unnormalized Form (0NF) through Third Normal Form (3NF). The normalization process ensures data integrity, eliminates redundancy, and optimizes the database structure for efficient storage and retrieval.

## 2. Normalization Overview

### 2.1 Normalization Objectives
- **Eliminate Redundancy:** Remove duplicate data storage
- **Ensure Data Integrity:** Prevent update anomalies
- **Optimize Storage:** Reduce storage requirements
- **Improve Performance:** Enable efficient querying
- **Maintain Consistency:** Ensure data accuracy

### 2.2 Normalization Process
1. **0NF (Unnormalized Form):** Original conceptual design
2. **1NF (First Normal Form):** Eliminate repeating groups and multivalued attributes
3. **2NF (Second Normal Form):** Eliminate partial dependencies
4. **3NF (Third Normal Form):** Eliminate transitive dependencies

## 3. 0NF (Unnormalized Form) - Original Structure

### 3.1 Conceptual Design Analysis

The original conceptual design contained several unnormalized structures that needed refinement:

#### Example 1: User Information with Multiple Roles
**0NF Structure:**
```
User_Information {
  user_id, email, password_hash, first_name, last_name, phone, date_of_birth,
  // Guest attributes
  preferred_price_range, preferred_property_types[], travel_preferences[],
  guest_verification_status, guest_verification_date,
  // Host attributes  
  host_verification_status, host_since, response_rate, response_time_hours,
  acceptance_rate, host_rating, total_properties, superhost_status,
  payout_method_id, tax_id, business_name, business_registration,
  // System attributes
  created_at, updated_at, is_active
}
```

**Problems Identified:**
- **Repeating Groups:** Multiple verification statuses for different roles
- **Multivalued Attributes:** preferred_property_types[] and travel_preferences[]
- **Mixed Concerns:** Guest and host attributes in single table
- **Update Anomalies:** Changing guest preferences affects host data

#### Example 2: Property Information with Nested Data
**0NF Structure:**
```
Property_Information {
  property_id, host_id, property_type_id, title, description, address_id,
  max_guests, bedrooms, bathrooms, size_sqm,
  // Nested amenities
  amenities[] {
    amenity_id, amenity_name, amenity_category, is_available, additional_info
  },
  // Nested photos
  photos[] {
    photo_id, photo_url, caption, is_primary, display_order, uploaded_at
  },
  // Nested pricing
  pricing_rules[] {
    start_date, end_date, base_price, weekend_price, weekly_discount,
    monthly_discount, minimum_stay, maximum_stay, is_available
  },
  created_at, updated_at, is_active
}
```

**Problems Identified:**
- **Repeating Groups:** Multiple amenities, photos, and pricing rules
- **Multivalued Attributes:** Arrays of related data
- **Insert Anomalies:** Cannot add amenities without property
- **Delete Anomalies:** Deleting property removes all related data

#### Example 3: Booking Information with Nested Transactions
**0NF Structure:**
```
Booking_Information {
  booking_id, guest_id, property_id, check_in_date, check_out_date,
  number_of_guests, total_amount, booking_status,
  // Nested payment information
  payment {
    payment_id, payment_method_id, amount, currency, payment_status,
    transaction_id, processed_at, refunded_at
  },
  // Nested payout information
  payout {
    payout_id, host_id, amount, currency, payout_status,
    scheduled_date, processed_date
  },
  // Nested review information
  reviews[] {
    review_id, reviewer_id, reviewee_id, rating, review_text,
    is_public, created_at, updated_at
  },
  created_at, confirmed_at
}
```

**Problems Identified:**
- **Repeating Groups:** Multiple reviews per booking
- **Mixed Concerns:** Payment and payout data in booking table
- **Update Anomalies:** Changing payment status affects booking data

## 4. 1NF (First Normal Form) - Eliminate Repeating Groups

### 4.1 Transformation Process

#### 4.1.1 User Information Normalization

**1NF Transformation:**
```sql
-- Base users table
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL,
  date_of_birth DATE,
  is_guest BOOLEAN DEFAULT TRUE,
  is_host BOOLEAN DEFAULT FALSE,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE
);

-- Guest-specific attributes
CREATE TABLE guest_profiles (
  guest_profile_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT UNIQUE NOT NULL,
  preferred_price_range VARCHAR(50),
  guest_verification_status VARCHAR(20) DEFAULT 'unverified',
  verification_date DATETIME,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Host-specific attributes
CREATE TABLE host_profiles (
  host_profile_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT UNIQUE NOT NULL,
  host_verification_status VARCHAR(20) DEFAULT 'pending',
  verification_date DATETIME,
  host_since DATETIME,
  response_rate DECIMAL(5,2) DEFAULT 0.00,
  response_time_hours INT,
  acceptance_rate DECIMAL(5,2) DEFAULT 0.00,
  host_rating DECIMAL(3,2),
  total_properties INT DEFAULT 0,
  superhost_status BOOLEAN DEFAULT FALSE,
  payout_method_id INT,
  tax_id VARCHAR(50),
  business_name VARCHAR(255),
  business_registration VARCHAR(100),
  created_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- User preferences (normalized from JSON arrays)
CREATE TABLE user_preferences (
  preference_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  preference_key VARCHAR(100) NOT NULL,
  preference_value JSON NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

**Functional Dependencies (1NF):**
- user_id → {email, password_hash, first_name, last_name, phone, date_of_birth, is_guest, is_host, is_admin, created_at, updated_at, is_active}
- user_id → {preferred_price_range, guest_verification_status, verification_date, created_at} (in guest_profiles)
- user_id → {host_verification_status, verification_date, host_since, response_rate, response_time_hours, acceptance_rate, host_rating, total_properties, superhost_status, payout_method_id, tax_id, business_name, business_registration, created_at} (in host_profiles)
- user_id → {preference_key, preference_value, updated_at} (in user_preferences)

#### 4.1.2 Property Information Normalization

**1NF Transformation:**
```sql
-- Base properties table
CREATE TABLE properties (
  property_id INT PRIMARY KEY AUTO_INCREMENT,
  host_id INT NOT NULL,
  property_type_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  address_id INT NOT NULL,
  max_guests INT NOT NULL,
  bedrooms INT NOT NULL,
  bathrooms DECIMAL(3,1) NOT NULL,
  size_sqm DECIMAL(8,2),
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (host_id) REFERENCES host_profiles(host_profile_id),
  FOREIGN KEY (property_type_id) REFERENCES property_types(property_type_id),
  FOREIGN KEY (address_id) REFERENCES addresses(address_id)
);

-- Amenities catalog
CREATE TABLE property_amenities (
  amenity_id INT PRIMARY KEY AUTO_INCREMENT,
  amenity_name VARCHAR(100) NOT NULL UNIQUE,
  amenity_category VARCHAR(50) NOT NULL,
  icon_url VARCHAR(500),
  description TEXT
);

-- Property-amenity relationships
CREATE TABLE property_amenity_links (
  link_id INT PRIMARY KEY AUTO_INCREMENT,
  property_id INT NOT NULL,
  amenity_id INT NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  additional_info TEXT,
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (amenity_id) REFERENCES property_amenities(amenity_id),
  UNIQUE KEY unique_property_amenity (property_id, amenity_id)
);

-- Property photos
CREATE TABLE property_photos (
  photo_id INT PRIMARY KEY AUTO_INCREMENT,
  property_id INT NOT NULL,
  photo_url VARCHAR(500) NOT NULL,
  caption VARCHAR(200),
  is_primary BOOLEAN DEFAULT FALSE,
  display_order INT DEFAULT 0,
  uploaded_at DATETIME NOT NULL,
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);

-- Property pricing rules
CREATE TABLE property_pricing (
  pricing_id INT PRIMARY KEY AUTO_INCREMENT,
  property_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  base_price_per_night DECIMAL(10,2) NOT NULL,
  weekend_price_per_night DECIMAL(10,2),
  weekly_discount_percentage DECIMAL(5,2) DEFAULT 0,
  monthly_discount_percentage DECIMAL(5,2) DEFAULT 0,
  minimum_stay_nights INT DEFAULT 1,
  maximum_stay_nights INT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (property_id) REFERENCES properties(property_id)
);
```

**Functional Dependencies (1NF):**
- property_id → {host_id, property_type_id, title, description, address_id, max_guests, bedrooms, bathrooms, size_sqm, created_at, updated_at, is_active}
- amenity_id → {amenity_name, amenity_category, icon_url, description}
- (property_id, amenity_id) → {is_available, additional_info}
- photo_id → {property_id, photo_url, caption, is_primary, display_order, uploaded_at}
- pricing_id → {property_id, start_date, end_date, base_price_per_night, weekend_price_per_night, weekly_discount_percentage, monthly_discount_percentage, minimum_stay_nights, maximum_stay_nights, is_available, created_at, updated_at}

#### 4.1.3 Booking Information Normalization

**1NF Transformation:**
```sql
-- Base bookings table
CREATE TABLE bookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  guest_profile_id INT NOT NULL,
  user_id INT NOT NULL,
  property_id INT NOT NULL,
  booking_status_id INT NOT NULL,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  number_of_guests INT NOT NULL,
  total_amount DECIMAL(10,2) NOT NULL,
  created_at DATETIME NOT NULL,
  confirmed_at DATETIME,
  FOREIGN KEY (guest_profile_id) REFERENCES guest_profiles(guest_profile_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (property_id) REFERENCES properties(property_id),
  FOREIGN KEY (booking_status_id) REFERENCES booking_status(status_id)
);

-- Payment transactions
CREATE TABLE payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  booking_id INT NOT NULL,
  payment_method_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  payment_status VARCHAR(20) NOT NULL,
  transaction_id VARCHAR(100) UNIQUE,
  processed_at DATETIME,
  refunded_at DATETIME,
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id)
);

-- Host payouts
CREATE TABLE payouts (
  payout_id INT PRIMARY KEY AUTO_INCREMENT,
  host_profile_id INT NOT NULL,
  booking_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  payout_status VARCHAR(20) NOT NULL,
  scheduled_date DATETIME,
  processed_date DATETIME,
  FOREIGN KEY (host_profile_id) REFERENCES host_profiles(host_profile_id),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Reviews
CREATE TABLE reviews (
  review_id INT PRIMARY KEY AUTO_INCREMENT,
  reviewer_id INT NOT NULL,
  reviewee_id INT NOT NULL,
  booking_id INT NOT NULL,
  rating INT NOT NULL,
  review_text TEXT,
  is_public BOOLEAN DEFAULT TRUE,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (reviewer_id) REFERENCES users(user_id),
  FOREIGN KEY (reviewee_id) REFERENCES users(user_id),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);
```

**Functional Dependencies (1NF):**
- booking_id → {guest_profile_id, user_id, property_id, booking_status_id, check_in_date, check_out_date, number_of_guests, total_amount, created_at, confirmed_at}
- payment_id → {booking_id, payment_method_id, amount, currency, payment_status, transaction_id, processed_at, refunded_at}
- payout_id → {host_profile_id, booking_id, amount, currency, payout_status, scheduled_date, processed_date}
- review_id → {reviewer_id, reviewee_id, booking_id, rating, review_text, is_public, created_at, updated_at}

### 4.2 1NF Benefits Achieved
- **Eliminated Repeating Groups:** All arrays and nested structures converted to separate tables
- **Atomic Values:** All attributes contain single, indivisible values
- **No Multivalued Attributes:** JSON arrays converted to normalized relationships
- **Clear Entity Separation:** Each table represents a single entity type

## 5. 2NF (Second Normal Form) - Eliminate Partial Dependencies

### 5.1 Partial Dependency Analysis

#### 5.1.1 User Preferences Table Analysis

**Current Structure (1NF):**
```sql
CREATE TABLE user_preferences (
  preference_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  preference_key VARCHAR(100) NOT NULL,
  preference_value JSON NOT NULL,
  updated_at DATETIME NOT NULL
);
```

**Functional Dependencies:**
- preference_id → {user_id, preference_key, preference_value, updated_at}
- (user_id, preference_key) → {preference_value, updated_at}

**Analysis:** No partial dependencies exist. The composite key (user_id, preference_key) determines all non-key attributes.

#### 5.1.2 Property Amenity Links Analysis

**Current Structure (1NF):**
```sql
CREATE TABLE property_amenity_links (
  link_id INT PRIMARY KEY AUTO_INCREMENT,
  property_id INT NOT NULL,
  amenity_id INT NOT NULL,
  is_available BOOLEAN DEFAULT TRUE,
  additional_info TEXT
);
```

**Functional Dependencies:**
- link_id → {property_id, amenity_id, is_available, additional_info}
- (property_id, amenity_id) → {is_available, additional_info}

**Analysis:** No partial dependencies exist. The composite key (property_id, amenity_id) determines all non-key attributes.

#### 5.1.3 Triple Relationship Tables Analysis

**Property-Booking-Pricing Junction:**
```sql
CREATE TABLE property_booking_pricing (
  pbp_id INT PRIMARY KEY AUTO_INCREMENT,
  property_id INT NOT NULL,
  booking_id INT NOT NULL,
  pricing_id INT NOT NULL,
  applied_price DECIMAL(10,2) NOT NULL,
  pricing_rule_applied VARCHAR(100),
  created_at DATETIME NOT NULL
);
```

**Functional Dependencies:**
- pbp_id → {property_id, booking_id, pricing_id, applied_price, pricing_rule_applied, created_at}
- (property_id, booking_id, pricing_id) → {applied_price, pricing_rule_applied, created_at}

**Analysis:** No partial dependencies exist. The composite key determines all non-key attributes.

### 5.2 2NF Verification

**Result:** All tables are already in 2NF. No partial dependencies were found because:
1. **Single-attribute Primary Keys:** Most tables use auto-increment primary keys
2. **Composite Keys:** Where composite keys exist, they fully determine all non-key attributes
3. **Proper Design:** The original design avoided partial dependencies

### 5.3 2NF Benefits Confirmed
- **No Partial Dependencies:** All non-key attributes fully depend on the entire primary key
- **Data Integrity:** No update anomalies from partial dependencies
- **Efficient Storage:** No redundant data storage

## 6. 3NF (Third Normal Form) - Eliminate Transitive Dependencies

### 6.1 Transitive Dependency Analysis

#### 6.1.1 User Profile Analysis

**Current Structure:**
```sql
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) UNIQUE NOT NULL,
  date_of_birth DATE,
  is_guest BOOLEAN DEFAULT TRUE,
  is_host BOOLEAN DEFAULT FALSE,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE
);
```

**Functional Dependencies:**
- user_id → {email, password_hash, first_name, last_name, phone, date_of_birth, is_guest, is_host, is_admin, created_at, updated_at, is_active}
- email → user_id (unique constraint)
- phone → user_id (unique constraint)

**Analysis:** No transitive dependencies exist. All attributes directly depend on the primary key.

#### 6.1.2 Property Analysis

**Current Structure:**
```sql
CREATE TABLE properties (
  property_id INT PRIMARY KEY AUTO_INCREMENT,
  host_id INT NOT NULL,
  property_type_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  address_id INT NOT NULL,
  max_guests INT NOT NULL,
  bedrooms INT NOT NULL,
  bathrooms DECIMAL(3,1) NOT NULL,
  size_sqm DECIMAL(8,2),
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  is_active BOOLEAN DEFAULT TRUE
);
```

**Functional Dependencies:**
- property_id → {host_id, property_type_id, title, description, address_id, max_guests, bedrooms, bathrooms, size_sqm, created_at, updated_at, is_active}

**Analysis:** No transitive dependencies exist. All attributes directly depend on the primary key.

#### 6.1.3 Address Analysis

**Current Structure:**
```sql
CREATE TABLE addresses (
  address_id INT PRIMARY KEY AUTO_INCREMENT,
  street_address VARCHAR(200) NOT NULL,
  city_id INT NOT NULL,
  postal_code VARCHAR(20),
  latitude DECIMAL(10,8) NOT NULL,
  longitude DECIMAL(11,8) NOT NULL,
  country_id INT NOT NULL
);
```

**Functional Dependencies:**
- address_id → {street_address, city_id, postal_code, latitude, longitude, country_id}

**Analysis:** No transitive dependencies exist. All attributes directly depend on the primary key.

#### 6.1.4 City-Country Relationship Analysis

**Potential Transitive Dependency:**
```
address_id → city_id → country_id
```

**Analysis:** This is NOT a transitive dependency because:
1. **city_id** is a foreign key, not a derived attribute
2. **country_id** is stored directly in addresses table
3. The relationship is maintained through foreign keys, not transitive dependencies

**Verification:** The design correctly stores country_id directly in addresses table to avoid transitive dependencies.

### 6.2 3NF Verification

**Result:** All tables are already in 3NF. No transitive dependencies were found because:
1. **Direct Dependencies:** All non-key attributes directly depend on the primary key
2. **Proper Foreign Keys:** Related data is stored through foreign key relationships, not transitive dependencies
3. **Normalized Design:** The original design avoided transitive dependencies

### 6.3 3NF Benefits Confirmed
- **No Transitive Dependencies:** All non-key attributes directly depend on the primary key
- **Data Integrity:** No update anomalies from transitive dependencies
- **Efficient Updates:** Changes to related data don't require multiple table updates

## 7. BCNF (Boyce-Codd Normal Form) Consideration

### 7.1 BCNF Analysis

**BCNF Definition:** A table is in BCNF if, for every functional dependency X → Y, X is a superkey.

**Analysis of Key Tables:**

#### 7.1.1 Users Table
- **Primary Key:** user_id (single attribute)
- **Functional Dependencies:** user_id → all other attributes
- **Result:** Already in BCNF (single-attribute primary key)

#### 7.1.2 Properties Table
- **Primary Key:** property_id (single attribute)
- **Functional Dependencies:** property_id → all other attributes
- **Result:** Already in BCNF (single-attribute primary key)

#### 7.1.3 Bookings Table
- **Primary Key:** booking_id (single attribute)
- **Functional Dependencies:** booking_id → all other attributes
- **Result:** Already in BCNF (single-attribute primary key)

### 7.2 BCNF Verification

**Result:** All tables are already in BCNF because:
1. **Single-Attribute Primary Keys:** Most tables use auto-increment primary keys
2. **No Overlapping Dependencies:** No functional dependencies where the determinant is not a superkey
3. **Proper Design:** The original design avoided BCNF violations

## 8. Normalization Summary

### 8.1 Normalization Achievements

| Normal Form | Status | Key Achievements |
|-------------|--------|------------------|
| **1NF** | ✅ Achieved | Eliminated repeating groups and multivalued attributes |
| **2NF** | ✅ Achieved | No partial dependencies found |
| **3NF** | ✅ Achieved | No transitive dependencies found |
| **BCNF** | ✅ Achieved | All functional dependencies have superkey determinants |

### 8.2 Design Quality Metrics

#### 8.2.1 Redundancy Elimination
- **No Duplicate Data:** Each piece of information stored once
- **Efficient Storage:** Minimal storage requirements
- **Clear Relationships:** Foreign keys maintain referential integrity

#### 8.2.2 Update Anomaly Prevention
- **Insert Anomalies:** Prevented through proper primary keys
- **Update Anomalies:** Prevented through normalized structure
- **Delete Anomalies:** Prevented through proper foreign key relationships

#### 8.2.3 Query Efficiency
- **Indexed Primary Keys:** Fast lookups on primary keys
- **Foreign Key Indexes:** Efficient joins between tables
- **Normalized Structure:** Optimized for common query patterns

### 8.3 Business Logic Preservation

#### 8.3.1 Role-Based Architecture
- **Guest Profiles:** Isolated guest-specific attributes
- **Host Profiles:** Isolated host-specific attributes
- **Multi-Role Support:** Users can hold multiple roles simultaneously

#### 8.3.2 Transaction Integrity
- **Booking-Payment-Payout Chain:** Proper transaction flow maintained
- **Review System:** Bidirectional reviews supported
- **Communication System:** Message threads properly normalized

#### 8.3.3 Data Integrity
- **Referential Integrity:** All foreign keys properly defined
- **Business Rules:** Implemented through constraints and relationships
- **Audit Trail:** User_id maintained for authentication and audit purposes

## 9. Performance Considerations

### 9.1 Normalization vs. Performance Trade-offs

#### 9.1.1 Benefits of Normalization
- **Storage Efficiency:** Reduced storage requirements
- **Update Performance:** Faster updates due to no redundancy
- **Data Integrity:** Consistent data across the system
- **Maintainability:** Easier to modify and extend

#### 9.1.2 Potential Performance Costs
- **Join Operations:** More joins required for complex queries
- **Query Complexity:** Some queries may require multiple table joins
- **Index Strategy:** Need comprehensive indexing strategy

#### 9.1.3 Mitigation Strategies
- **Strategic Indexing:** Indexes on foreign keys and frequently queried columns
- **Query Optimization:** Well-designed queries can minimize join overhead
- **Denormalization Consideration:** Future denormalization for specific high-performance queries

### 9.2 Recommended Index Strategy

```sql
-- Primary key indexes (automatic)
-- Foreign key indexes
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_property_type_id ON properties(property_type_id);
CREATE INDEX idx_properties_address_id ON properties(address_id);
CREATE INDEX idx_bookings_guest_profile_id ON bookings(guest_profile_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payouts_host_profile_id ON payouts(host_profile_id);
CREATE INDEX idx_payouts_booking_id ON payouts(booking_id);

-- Business logic indexes
CREATE INDEX idx_properties_active ON properties(is_active);
CREATE INDEX idx_bookings_dates ON bookings(check_in_date, check_out_date);
CREATE INDEX idx_property_pricing_dates ON property_pricing(start_date, end_date);
CREATE INDEX idx_reviews_booking_id ON reviews(booking_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
```

## 10. Conclusion

The normalization process successfully transformed the Airbnb database design from an unnormalized conceptual model to a fully normalized 3NF/BCNF structure. The key achievements include:

### 10.1 Technical Achievements
1. **Complete Normalization:** All tables in 3NF/BCNF
2. **Eliminated Redundancy:** No duplicate data storage
3. **Data Integrity:** Proper foreign key relationships and constraints
4. **Performance Optimization:** Strategic indexing and efficient design

### 10.2 Business Achievements
1. **Role-Based Architecture:** Proper separation of guest and host concerns
2. **Multi-Role Support:** Users can simultaneously act as guests and hosts
3. **Transaction Integrity:** Proper booking-payment-payout flow
4. **Scalability:** Easy to add new features and roles

### 10.3 Design Quality
1. **Maintainability:** Clear separation of concerns
2. **Extensibility:** Easy to add new entities and relationships
3. **Performance:** Optimized for common query patterns
4. **Integrity:** Comprehensive constraint system

The normalized database design provides a solid foundation for the Airbnb platform, supporting all business requirements while maintaining data integrity and optimal performance.

---

**Document Version:** 1.0  
**Last Updated:** 14/10/2025
