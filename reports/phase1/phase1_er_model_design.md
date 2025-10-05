# Entity Relationship Model Design for Airbnb Database System

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Conception Phase  
**Date:** 05/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## 1. ER Model Overview

This Entity Relationship Model (ERM) represents a comprehensive database design for an Airbnb-like platform. The model contains **25 entities** with **3 triple relationships** and **1 recursive relationship**, meeting all assignment requirements.

### 1.1 Model Statistics
- **Total Entities:** 25
- **Triple Relationships:** 3
- **Recursive Relationships:** 1
- **Notation:** Chen Notation
- **Cardinality:** Min-Max notation

### 1.2 Complete Entity List

| # | Entity Name | Category | Primary Purpose |
|---|-------------|----------|-----------------|
| 1 | users | User Management | Core user authentication and identification |
| 2 | user_profiles | User Management | Extended user biographical information |
| 3 | user_verification | User Management | Identity verification and trust system |
| 4 | user_preferences | User Management | User settings and customization |
| 5 | properties | Property Management | Property listings and details |
| 6 | property_types | Property Management | Property categorization (apartment, house, etc.) |
| 7 | property_amenities | Property Management | Available amenities catalog |
| 8 | property_amenity_links | Property Management | Property-to-amenity junction table |
| 9 | property_photos | Property Management | Property image gallery |
| 10 | property_pricing | Property Management | Dynamic pricing and availability rules |
| 11 | addresses | Location | Physical address information |
| 12 | cities | Location | City-level geographic data |
| 13 | countries | Location | Country-level geographic data |
| 14 | bookings | Booking System | Reservation records |
| 15 | booking_status | Booking System | Booking state management |
| 16 | booking_modifications | Booking System | Booking change audit trail |
| 17 | payments | Financial | Guest payment transactions |
| 18 | payment_methods | Financial | User payment method storage |
| 19 | payouts | Financial | Host payout records |
| 20 | reviews | Review System | User-to-user reviews |
| 21 | review_categories | Review System | Review aspect categories |
| 22 | review_ratings | Review System | Category-specific rating values |
| 23 | conversations | Communication | Message thread management |
| 24 | messages | Communication | Individual message records |
| 25 | notifications | System | User notification queue |

## 2. Entity Descriptions

### 2.1 Core User Entities

#### **users**
- **Purpose:** Central user entity for all platform users
- **Key Attributes:** user_id (PK), email, password_hash, first_name, last_name, phone, date_of_birth, created_at, updated_at, is_active
- **Business Rules:** Unique email, required phone verification

#### **user_profiles**
- **Purpose:** Extended user information and preferences
- **Key Attributes:** profile_id (PK), user_id (FK), bio, profile_picture, language_preference, currency_preference, timezone, notification_settings
- **Business Rules:** One profile per user

#### **user_verification**
- **Purpose:** Identity verification for hosts and guests
- **Key Attributes:** verification_id (PK), user_id (FK), verification_type, document_type, document_number, verification_status, verified_at, expires_at
- **Business Rules:** Multiple verification types per user

### 2.2 Property Entities

#### **properties**
- **Purpose:** Property listings on the platform
- **Key Attributes:** property_id (PK), host_id (FK), property_type_id (FK), title, description, address_id (FK), max_guests, bedrooms, bathrooms, size_sqm, created_at, updated_at, is_active
- **Business Rules:** At least one photo required, valid location required

#### **property_types**
- **Purpose:** Categories of properties (apartment, house, villa, etc.)
- **Key Attributes:** property_type_id (PK), type_name, description, icon_url
- **Business Rules:** Predefined types only

#### **property_amenities**
- **Purpose:** Available amenities for properties
- **Key Attributes:** amenity_id (PK), amenity_name, amenity_category, icon_url, description
- **Business Rules:** Predefined amenities only

#### **property_amenity_links**
- **Purpose:** Many-to-many relationship between properties and amenities
- **Key Attributes:** link_id (PK), property_id (FK), amenity_id (FK), is_available, additional_info
- **Business Rules:** Unique property-amenity combinations

#### **property_photos**
- **Purpose:** Photo gallery for properties
- **Key Attributes:** photo_id (PK), property_id (FK), photo_url, caption, is_primary, display_order, uploaded_at
- **Business Rules:** At least one primary photo per property

### 2.3 Location Entities

#### **addresses**
- **Purpose:** Physical addresses for properties and users
- **Key Attributes:** address_id (PK), street_address, city_id (FK), postal_code, latitude, longitude, country_id (FK)
- **Business Rules:** Valid coordinates required

#### **cities**
- **Purpose:** City information for location-based searches
- **Key Attributes:** city_id (PK), city_name, state_province, country_id (FK), timezone, population
- **Business Rules:** Unique city within country

#### **countries**
- **Purpose:** Country information for international operations
- **Key Attributes:** country_id (PK), country_name, country_code, currency_code, phone_code
- **Business Rules:** Standard ISO country codes

### 2.4 Booking Entities

#### **bookings**
- **Purpose:** Reservation records between guests and properties
- **Key Attributes:** booking_id (PK), guest_id (FK), property_id (FK), check_in_date, check_out_date, number_of_guests, total_amount, booking_status, created_at, confirmed_at
- **Business Rules:** No overlapping bookings, valid date ranges

#### **booking_status**
- **Purpose:** Status tracking for bookings
- **Key Attributes:** status_id (PK), status_name, description, is_active
- **Business Rules:** Predefined statuses only

#### **booking_modifications**
- **Purpose:** Changes to existing bookings
- **Key Attributes:** modification_id (PK), booking_id (FK), modification_type, old_value, new_value, reason, created_at, approved_by
- **Business Rules:** Track all booking changes

#### **property_pricing**
- **Purpose:** Dynamic pricing and availability management for properties
- **Key Attributes:** 
  - pricing_id (PK) - INTEGER, AUTO_INCREMENT
  - property_id (FK) - INTEGER, references properties.property_id
  - start_date - DATE, NOT NULL
  - end_date - DATE, NOT NULL
  - base_price_per_night - DECIMAL(10,2), NOT NULL, CHECK (base_price_per_night > 0)
  - weekend_price_per_night - DECIMAL(10,2), NULL
  - weekly_discount_percentage - DECIMAL(5,2), DEFAULT 0
  - monthly_discount_percentage - DECIMAL(5,2), DEFAULT 0
  - minimum_stay_nights - INTEGER, DEFAULT 1
  - maximum_stay_nights - INTEGER, NULL
  - is_available - BOOLEAN, DEFAULT TRUE
  - created_at - DATETIME, NOT NULL
  - updated_at - DATETIME, NOT NULL
- **Business Rules:** 
  - No overlapping date ranges for same property
  - end_date must be after start_date
  - Minimum stay must be at least 1 night
  - Supports seasonal and dynamic pricing strategies

### 2.5 Financial Entities

#### **payments**
- **Purpose:** Payment transactions for bookings
- **Key Attributes:** payment_id (PK), booking_id (FK), payment_method_id (FK), amount, currency, payment_status, transaction_id, processed_at, refunded_at
- **Business Rules:** One payment per booking, valid amounts only

#### **payment_methods**
- **Purpose:** User payment methods (credit cards, PayPal, etc.)
- **Key Attributes:** payment_method_id (PK), user_id (FK), method_type, card_last_four, expiry_date, is_default, is_active
- **Business Rules:** Encrypted sensitive data

#### **payouts**
- **Purpose:** Payments to hosts
- **Key Attributes:** payout_id (PK), host_id (FK), booking_id (FK), amount, currency, payout_status, scheduled_date, processed_date
- **Business Rules:** 24-hour delay after guest check-in

### 2.6 Review Entities

#### **reviews**
- **Purpose:** Reviews and ratings between users
- **Key Attributes:** review_id (PK), reviewer_id (FK), reviewee_id (FK), booking_id (FK), rating, review_text, is_public, created_at, updated_at
- **Business Rules:** Post-stay reviews only, cannot be edited

#### **review_categories**
- **Purpose:** Different aspects of reviews (cleanliness, communication, etc.)
- **Key Attributes:** category_id (PK), category_name, description, weight
- **Business Rules:** Predefined categories only

#### **review_ratings**
- **Purpose:** Detailed ratings for different categories
- **Key Attributes:** rating_id (PK), review_id (FK), category_id (FK), rating_value
- **Business Rules:** Rating values 1-5 only

### 2.7 Communication Entities

#### **conversations**
- **Purpose:** Message threads between users
- **Key Attributes:** conversation_id (PK), participant1_id (FK), participant2_id (FK), booking_id (FK), created_at, last_message_at
- **Business Rules:** Unique participant pairs per booking

#### **messages**
- **Purpose:** Individual messages in conversations
- **Key Attributes:** message_id (PK), conversation_id (FK), sender_id (FK), message_text, message_type, sent_at, read_at
- **Business Rules:** Messages cannot be deleted

### 2.8 System Entities

#### **notifications**
- **Purpose:** System notifications for users
- **Key Attributes:** notification_id (PK), user_id (FK), notification_type, title, message, is_read, created_at, sent_at
- **Business Rules:** Automatic cleanup of old notifications

#### **user_preferences**
- **Purpose:** User settings and preferences
- **Key Attributes:** preference_id (PK), user_id (FK), preference_key, preference_value, updated_at
- **Business Rules:** JSON values for complex preferences

## 3. Relationship Specifications

### 3.1 Triple Relationships (3 Required)

#### **Triple Relationship 1: Booking-Payment-Property**
- **Entities:** bookings, payments, properties
- **Purpose:** Links booking transactions to specific properties
- **Cardinality:** (1,1) - (1,1) - (1,N)
- **Business Rule:** Each booking has one payment for one property

#### **Triple Relationship 2: Review-Booking-User**
- **Entities:** reviews, bookings, users
- **Purpose:** Links reviews to specific booking participants
- **Cardinality:** (1,1) - (1,1) - (1,2)
- **Business Rule:** Reviews are tied to specific bookings and users

#### **Triple Relationship 3: Booking-Payment-Payout**
- **Entities:** bookings, payments, payouts
- **Purpose:** Links booking transactions through payment processing to host payouts
- **Cardinality:** 
  - bookings to payments: (1,1)
  - payments to payouts: (1,0..1)
  - bookings to payouts: (1,0..1)
- **Business Rule:** Each booking generates exactly one payment from the guest. After the guest checks in and the 24-hour security period passes, the payment generates one payout to the host. Cancelled or disputed bookings may not result in payouts.
- **Implementation Note:** This creates a transaction chain: Booking → Payment (immediate) → Payout (delayed)

### 3.2 Recursive Relationship (1 Required)

#### **User Self-Referencing: Host-Guest Dual Role**
- **Entity:** users (self-referencing through transaction tables)
- **Type:** Implicit many-to-many recursive relationship
- **Implementation:** Users reference other users through their dual roles:
  - As **hosts**: via properties.host_id → users.user_id
  - As **guests**: via bookings.guest_id → users.user_id
  - **Connection**: When a guest books a property, they create a relationship with the host user
- **Cardinality:** (0,N) ↔ (0,N)
  - A user can host for N other users (through property bookings)
  - A user can be a guest of N other users (by booking their properties)
  - The same user account can simultaneously act as both host AND guest
- **Business Rule:** 
  - Users can list multiple properties as hosts
  - Users can make multiple bookings as guests
  - A user can book other users' properties while also hosting their own
- **Example Scenario:** 
  - User A owns Property X (acts as host)
  - User A books User B's Property Y (acts as guest)
  - User C books User A's Property X (User A is host, User C is guest)
  - This demonstrates the recursive nature: users interact with other users through the booking ecosystem

### 3.3 Standard Relationships

#### **One-to-Many Relationships**
- users → user_profiles (1:1)
- users → properties (1:N)
- properties → property_photos (1:N)
- properties → property_pricing (1:N) - "Has_pricing_rules"
- bookings → booking_modifications (1:N)
- conversations → messages (1:N)

**Description:** Each property can have multiple pricing rules for different date ranges (e.g., summer rates, winter rates, holiday pricing). Cardinality: (1,1) on property side, (0,N) on pricing side.

#### **Many-to-Many Relationships**
- properties ↔ property_amenities (through property_amenity_links)
- users ↔ users (through bookings, reviews)

## 4. Data Dictionary

### 4.1 Attribute Types and Constraints

#### **Primary Keys**
- All entities have surrogate primary keys (ID fields)
- Format: entity_name_id
- Data Type: INTEGER, AUTO_INCREMENT

#### **Foreign Keys**
- All foreign keys reference primary keys
- Format: referenced_entity_id
- Data Type: INTEGER
- Constraints: ON DELETE CASCADE, ON UPDATE CASCADE

#### **Common Attributes**
- **Email:** VARCHAR(255), UNIQUE, NOT NULL
- **Phone:** VARCHAR(20), UNIQUE, NOT NULL
- **Dates:** DATETIME, NOT NULL
- **Amounts:** DECIMAL(10,2), NOT NULL, CHECK (amount >= 0)
- **Ratings:** INTEGER, CHECK (rating >= 1 AND rating <= 5)
- **Status Fields:** ENUM with predefined values

#### **Text Fields**
- **Short Text:** VARCHAR(255)
- **Long Text:** TEXT
- **Descriptions:** TEXT, NULL allowed

#### **Boolean Fields**
- **Flags:** BOOLEAN, DEFAULT FALSE
- **Status Indicators:** BOOLEAN, DEFAULT TRUE

### 4.2 Data Types Summary

| Attribute Type | Data Type | Constraints | Example |
|----------------|-----------|-------------|---------|
| Primary Keys | INTEGER | AUTO_INCREMENT, NOT NULL | user_id |
| Foreign Keys | INTEGER | NOT NULL, REFERENCES | property_id |
| Email | VARCHAR(255) | UNIQUE, NOT NULL | user@example.com |
| Phone | VARCHAR(20) | UNIQUE, NOT NULL | +1234567890 |
| Dates | DATETIME | NOT NULL | 2025-01-15 10:30:00 |
| Amounts | DECIMAL(10,2) | NOT NULL, >= 0 | 150.00 |
| Ratings | INTEGER | 1-5 range | 4 |
| Status | ENUM | Predefined values | 'active', 'inactive' |
| Text | TEXT | NULL allowed | Property description |
| Boolean | BOOLEAN | DEFAULT FALSE | is_verified |

## 5. Business Rules Implementation

### 5.1 Data Integrity Rules
- All foreign keys must reference existing records
- Email addresses must be unique across all users
- Phone numbers must be unique and valid format
- Booking dates must be valid and non-overlapping
- Payment amounts must be positive

### 5.2 Business Logic Rules
- Users must verify identity before listing properties
- Bookings cannot be made for past dates
- Reviews can only be written after stay completion
- Payments must be processed before check-in
- Hosts receive payouts 24 hours after guest check-in

### 5.3 Security Rules
- Passwords must be hashed and never stored in plain text
- Payment information must be encrypted
- Personal data must be protected according to privacy laws
- Access control based on user roles and permissions

## 6. ER Model Diagram Requirements

### 6.1 Diagram Specifications
- **Tool:** Draw.io or similar professional diagramming tool
- **Notation:** Chen notation with entity boxes and relationship diamonds
- **Cardinality:** Min-max notation (e.g., (1,1), (0,N), (1,N))
- **Legend:** Complete notation explanation
- **Resolution:** Minimum 300 DPI for submission

### 6.2 Diagram Elements
- **Entities:** Rectangular boxes with entity names
- **Attributes:** Listed within entity boxes
- **Primary Keys:** Underlined or marked with (PK)
- **Foreign Keys:** Marked with (FK)
- **Relationships:** Diamond shapes with relationship names
- **Cardinality:** Numbers on relationship lines

## 7. Implementation Considerations

### 7.1 Database Design Principles
- **Normalization:** Target 3NF (Third Normal Form)
- **Performance:** Appropriate indexing strategy
- **Scalability:** Design for growth and expansion
- **Maintainability:** Clear naming conventions and documentation

### 7.2 Technical Requirements
- **Database System:** MySQL, PostgreSQL, or SQL Server
- **SQL Standard:** ANSI SQL compliance
- **Character Set:** UTF-8 for international support
- **Storage Engine:** InnoDB for transaction support

### 7.3 Future Considerations
- **Audit Trail:** Track all data changes
- **Data Archival:** Long-term data retention strategy
- **Performance Monitoring:** Query optimization and indexing
- **Backup Strategy:** Regular backups and recovery procedures

---

**Document Version:** 1.0  
**Last Updated:** 05/10/2025
