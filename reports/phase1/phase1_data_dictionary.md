# Data Dictionary for Airbnb Database System

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Conception Phase  
**Date:** 02/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## Overview

This data dictionary provides comprehensive documentation for all attributes in the Airbnb database schema. Each attribute is documented with its data type, description, constraints, and business rules.

---

## 1. USER MANAGEMENT DOMAIN

### 1.1 users Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| user_id | INTEGER | Primary key, unique identifier for each user | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key, system-generated |
| email | VARCHAR(255) | User's email address for login and communication | UNIQUE, NOT NULL | Must be valid email format, unique across platform |
| password_hash | VARCHAR(255) | Encrypted password for authentication | NOT NULL | Never store plain text, use secure hashing |
| first_name | VARCHAR(100) | User's first name | NOT NULL | Required for personalization |
| last_name | VARCHAR(100) | User's last name | NOT NULL | Required for personalization |
| phone | VARCHAR(20) | User's phone number | UNIQUE, NOT NULL | Must be unique, valid international format |
| date_of_birth | DATE | User's birth date | NULL allowed | Used for age verification, privacy compliance |
| created_at | DATETIME | Account creation timestamp | NOT NULL | System-generated, immutable |
| updated_at | DATETIME | Last modification timestamp | NOT NULL | System-maintained, updated on changes |
| is_active | BOOLEAN | Account status flag | DEFAULT TRUE | Controls login access, soft delete |

### 1.2 user_profiles Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| profile_id | INTEGER | Primary key for profile record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INTEGER | Foreign key to users table | FOREIGN KEY, NOT NULL | One profile per user (1:1) |
| bio | TEXT | User's biographical description | NULL allowed | Optional personal information |
| profile_picture | VARCHAR(500) | URL to user's profile image | NULL allowed | Must be valid image URL |
| language_preference | VARCHAR(10) | User's preferred language | DEFAULT 'en' | ISO language code |
| currency_preference | VARCHAR(3) | User's preferred currency | DEFAULT 'USD' | ISO currency code |
| timezone | VARCHAR(50) | User's timezone | NULL allowed | IANA timezone identifier |
| notification_settings | JSON | User's notification preferences | NULL allowed | Structured preference data |

### 1.3 user_verification Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| verification_id | INTEGER | Primary key for verification record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INTEGER | Foreign key to users table | FOREIGN KEY, NOT NULL | Multiple verifications per user |
| verification_type | VARCHAR(50) | Type of verification performed | NOT NULL | 'identity', 'phone', 'email', 'government_id' |
| document_type | VARCHAR(50) | Type of document used | NOT NULL | 'passport', 'driver_license', 'national_id' |
| document_number | VARCHAR(100) | Document identifier | NOT NULL | Encrypted sensitive data |
| verification_status | VARCHAR(20) | Current verification status | NOT NULL | 'pending', 'approved', 'rejected', 'expired' |
| verified_at | DATETIME | When verification was completed | NULL allowed | Set when status becomes 'approved' |
| expires_at | DATETIME | When verification expires | NULL allowed | Required for time-limited verifications |

### 1.4 user_preferences Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| preference_id | INTEGER | Primary key for preference record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INTEGER | Foreign key to users table | FOREIGN KEY, NOT NULL | Multiple preferences per user |
| preference_key | VARCHAR(100) | Preference identifier | NOT NULL | 'email_notifications', 'sms_alerts', etc. |
| preference_value | JSON | Preference value/settings | NOT NULL | Structured data for complex preferences |
| updated_at | DATETIME | Last preference update | NOT NULL | Track preference changes |

---

## 2. PROPERTY MANAGEMENT DOMAIN

### 2.1 properties Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| property_id | INTEGER | Primary key for property | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| host_id | INTEGER | Foreign key to users (host) | FOREIGN KEY, NOT NULL | Property owner |
| property_type_id | INTEGER | Foreign key to property_types | FOREIGN KEY, NOT NULL | Property category |
| title | VARCHAR(200) | Property listing title | NOT NULL | Marketing headline |
| description | TEXT | Detailed property description | NULL allowed | Rich text content |
| address_id | INTEGER | Foreign key to addresses | FOREIGN KEY, NOT NULL | Physical location |
| max_guests | INTEGER | Maximum guest capacity | NOT NULL | Must be positive integer |
| bedrooms | INTEGER | Number of bedrooms | NOT NULL | Must be non-negative |
| bathrooms | DECIMAL(3,1) | Number of bathrooms | NOT NULL | Allows half-baths (1.5, 2.5) |
| size_sqm | DECIMAL(8,2) | Property size in square meters | NULL allowed | For property comparison |
| created_at | DATETIME | Property listing creation | NOT NULL | System-generated |
| updated_at | DATETIME | Last property update | NOT NULL | System-maintained |
| is_active | BOOLEAN | Property availability status | DEFAULT TRUE | Controls booking availability |

### 2.2 property_types Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| property_type_id | INTEGER | Primary key for property type | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| type_name | VARCHAR(50) | Property type name | NOT NULL, UNIQUE | 'apartment', 'house', 'villa', etc. |
| description | TEXT | Type description | NULL allowed | Marketing copy |
| icon_url | VARCHAR(500) | Icon image URL | NULL allowed | Visual representation |

### 2.3 property_amenities Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| amenity_id | INTEGER | Primary key for amenity | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| amenity_name | VARCHAR(100) | Amenity name | NOT NULL, UNIQUE | 'WiFi', 'Pool', 'Parking', etc. |
| amenity_category | VARCHAR(50) | Amenity category | NOT NULL | 'internet', 'kitchen', 'safety', etc. |
| icon_url | VARCHAR(500) | Amenity icon URL | NULL allowed | Visual representation |
| description | TEXT | Amenity description | NULL allowed | Detailed explanation |

### 2.4 property_amenity_links Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| link_id | INTEGER | Primary key for link | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INTEGER | Foreign key to properties | FOREIGN KEY, NOT NULL | Property with amenity |
| amenity_id | INTEGER | Foreign key to property_amenities | FOREIGN KEY, NOT NULL | Available amenity |
| is_available | BOOLEAN | Amenity availability status | DEFAULT TRUE | Can be temporarily unavailable |
| additional_info | TEXT | Extra amenity details | NULL allowed | Special conditions, notes |

### 2.5 property_photos Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| photo_id | INTEGER | Primary key for photo | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INTEGER | Foreign key to properties | FOREIGN KEY, NOT NULL | Property in photo |
| photo_url | VARCHAR(500) | Photo file URL | NOT NULL | Must be valid image URL |
| caption | VARCHAR(200) | Photo description | NULL allowed | Optional photo caption |
| is_primary | BOOLEAN | Primary photo flag | DEFAULT FALSE | Only one primary per property |
| display_order | INTEGER | Photo display sequence | DEFAULT 0 | Controls photo gallery order |
| uploaded_at | DATETIME | Upload timestamp | NOT NULL | System-generated |

### 2.6 property_pricing Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| pricing_id | INTEGER | Primary key for pricing rule | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INTEGER | Foreign key to properties | FOREIGN KEY, NOT NULL | Property with pricing |
| start_date | DATE | Pricing period start | NOT NULL | Must be valid date |
| end_date | DATE | Pricing period end | NOT NULL | Must be after start_date |
| base_price_per_night | DECIMAL(10,2) | Standard nightly rate | NOT NULL | Must be positive |
| weekend_price_per_night | DECIMAL(10,2) | Weekend rate | NULL allowed | Optional weekend pricing |
| weekly_discount_percentage | DECIMAL(5,2) | Weekly stay discount | DEFAULT 0 | Percentage discount |
| monthly_discount_percentage | DECIMAL(5,2) | Monthly stay discount | DEFAULT 0 | Percentage discount |
| minimum_stay_nights | INTEGER | Minimum booking length | DEFAULT 1 | Must be at least 1 |
| maximum_stay_nights | INTEGER | Maximum booking length | NULL allowed | Optional stay limit |
| is_available | BOOLEAN | Availability status | DEFAULT TRUE | Controls booking availability |
| created_at | DATETIME | Rule creation timestamp | NOT NULL | System-generated |
| updated_at | DATETIME | Last rule update | NOT NULL | System-maintained |

---

## 3. LOCATION DOMAIN

### 3.1 addresses Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| address_id | INTEGER | Primary key for address | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| street_address | VARCHAR(200) | Street address line | NOT NULL | Building number and street |
| city_id | INTEGER | Foreign key to cities | FOREIGN KEY, NOT NULL | City location |
| postal_code | VARCHAR(20) | Postal/ZIP code | NULL allowed | Location identifier |
| latitude | DECIMAL(10,8) | GPS latitude coordinate | NOT NULL | Must be valid GPS coordinate |
| longitude | DECIMAL(11,8) | GPS longitude coordinate | NOT NULL | Must be valid GPS coordinate |
| country_id | INTEGER | Foreign key to countries | FOREIGN KEY, NOT NULL | Country location |

### 3.2 cities Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| city_id | INTEGER | Primary key for city | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| city_name | VARCHAR(100) | City name | NOT NULL | Official city name |
| state_province | VARCHAR(100) | State or province | NULL allowed | Administrative division |
| country_id | INTEGER | Foreign key to countries | FOREIGN KEY, NOT NULL | Country containing city |
| timezone | VARCHAR(50) | City timezone | NULL allowed | IANA timezone identifier |
| population | INTEGER | City population | NULL allowed | Demographic data |

### 3.3 countries Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| country_id | INTEGER | Primary key for country | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| country_name | VARCHAR(100) | Country name | NOT NULL, UNIQUE | Official country name |
| country_code | VARCHAR(3) | ISO country code | NOT NULL, UNIQUE | Standard ISO 3166-1 alpha-3 |
| currency_code | VARCHAR(3) | Currency code | NOT NULL | ISO 4217 currency code |
| phone_code | VARCHAR(5) | International dialing code | NULL allowed | Country calling code |

---

## 4. BOOKING SYSTEM DOMAIN

### 4.1 bookings Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| booking_id | INTEGER | Primary key for booking | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| guest_id | INTEGER | Foreign key to users (guest) | FOREIGN KEY, NOT NULL | Booking guest |
| property_id | INTEGER | Foreign key to properties | FOREIGN KEY, NOT NULL | Booked property |
| booking_status_id | INTEGER | Foreign key to booking_status | FOREIGN KEY, NOT NULL | Current booking status |
| check_in_date | DATE | Check-in date | NOT NULL | Must be future date when created |
| check_out_date | DATE | Check-out date | NOT NULL | Must be after check-in_date |
| number_of_guests | INTEGER | Number of guests | NOT NULL | Must match property capacity |
| total_amount | DECIMAL(10,2) | Total booking cost | NOT NULL | Must be positive |
| created_at | DATETIME | Booking creation timestamp | NOT NULL | System-generated |
| confirmed_at | DATETIME | Booking confirmation timestamp | NULL allowed | Set when booking confirmed |

### 4.2 booking_status Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| status_id | INTEGER | Primary key for status | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| status_name | VARCHAR(50) | Status name | NOT NULL, UNIQUE | 'pending', 'confirmed', 'cancelled' |
| description | TEXT | Status description | NULL allowed | Business explanation |
| is_active | BOOLEAN | Status availability | DEFAULT TRUE | Controls status usage |

### 4.3 booking_modifications Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| modification_id | INTEGER | Primary key for modification | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Modified booking |
| modification_type | VARCHAR(50) | Type of modification | NOT NULL | 'date_change', 'guest_count', 'cancellation' |
| old_value | TEXT | Previous value | NULL allowed | Original booking data |
| new_value | TEXT | New value | NULL allowed | Modified booking data |
| reason | TEXT | Modification reason | NULL allowed | Business justification |
| created_at | DATETIME | Modification timestamp | NOT NULL | System-generated |
| approved_by | INTEGER | Foreign key to users (approver) | FOREIGN KEY, NULL allowed | Staff member who approved |

---

## 5. FINANCIAL DOMAIN

### 5.1 payments Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| payment_id | INTEGER | Primary key for payment | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Payment for booking |
| payment_method_id | INTEGER | Foreign key to payment_methods | FOREIGN KEY, NOT NULL | Payment method used |
| amount | DECIMAL(10,2) | Payment amount | NOT NULL | Must be positive |
| currency | VARCHAR(3) | Payment currency | NOT NULL | ISO 4217 currency code |
| payment_status | VARCHAR(20) | Payment status | NOT NULL | 'pending', 'completed', 'failed', 'refunded' |
| transaction_id | VARCHAR(100) | External transaction ID | UNIQUE, NULL allowed | Payment processor reference |
| processed_at | DATETIME | Payment processing timestamp | NULL allowed | Set when payment processed |
| refunded_at | DATETIME | Refund timestamp | NULL allowed | Set when payment refunded |

### 5.2 payment_methods Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| payment_method_id | INTEGER | Primary key for payment method | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INTEGER | Foreign key to users | FOREIGN KEY, NOT NULL | Payment method owner |
| method_type | VARCHAR(50) | Payment method type | NOT NULL | 'credit_card', 'debit_card', 'paypal' |
| card_last_four | VARCHAR(4) | Last four digits of card | NULL allowed | Masked card information |
| expiry_date | VARCHAR(7) | Card expiry date | NULL allowed | MM/YYYY format |
| is_default | BOOLEAN | Default payment method | DEFAULT FALSE | User's preferred method |
| is_active | BOOLEAN | Method availability | DEFAULT TRUE | Controls method usage |

### 5.3 payouts Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| payout_id | INTEGER | Primary key for payout | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| host_id | INTEGER | Foreign key to users (host) | FOREIGN KEY, NOT NULL | Payout recipient |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Source booking |
| amount | DECIMAL(10,2) | Payout amount | NOT NULL | Must be positive |
| currency | VARCHAR(3) | Payout currency | NOT NULL | ISO 4217 currency code |
| payout_status | VARCHAR(20) | Payout status | NOT NULL | 'pending', 'processing', 'completed', 'failed' |
| scheduled_date | DATETIME | Scheduled payout date | NULL allowed | Planned payout date |
| processed_date | DATETIME | Actual payout date | NULL allowed | When payout was completed |

---

## 6. REVIEW SYSTEM DOMAIN

### 6.1 reviews Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| review_id | INTEGER | Primary key for review | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| reviewer_id | INTEGER | Foreign key to users (reviewer) | FOREIGN KEY, NOT NULL | Review author |
| reviewee_id | INTEGER | Foreign key to users (reviewee) | FOREIGN KEY, NOT NULL | Review subject |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Source booking |
| rating | INTEGER | Overall rating | NOT NULL | Must be 1-5 |
| review_text | TEXT | Review content | NULL allowed | Detailed review text |
| is_public | BOOLEAN | Review visibility | DEFAULT TRUE | Controls public display |
| created_at | DATETIME | Review creation timestamp | NOT NULL | System-generated |
| updated_at | DATETIME | Last review update | NOT NULL | System-maintained |

### 6.2 review_categories Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| category_id | INTEGER | Primary key for category | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| category_name | VARCHAR(50) | Category name | NOT NULL, UNIQUE | 'cleanliness', 'communication', 'location' |
| description | TEXT | Category description | NULL allowed | Category explanation |
| weight | DECIMAL(3,2) | Category importance weight | DEFAULT 1.00 | Used in overall rating calculation |

### 6.3 review_ratings Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| rating_id | INTEGER | Primary key for rating | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| review_id | INTEGER | Foreign key to reviews | FOREIGN KEY, NOT NULL | Parent review |
| category_id | INTEGER | Foreign key to review_categories | FOREIGN KEY, NOT NULL | Rating category |
| rating_value | INTEGER | Category rating | NOT NULL | Must be 1-5 |

---

## 7. COMMUNICATION DOMAIN

### 7.1 conversations Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| conversation_id | INTEGER | Primary key for conversation | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| participant1_id | INTEGER | Foreign key to users (participant 1) | FOREIGN KEY, NOT NULL | First conversation participant |
| participant2_id | INTEGER | Foreign key to users (participant 2) | FOREIGN KEY, NOT NULL | Second conversation participant |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Related booking |
| created_at | DATETIME | Conversation creation timestamp | NOT NULL | System-generated |
| last_message_at | DATETIME | Last message timestamp | NULL allowed | Updated on new messages |

### 7.2 messages Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| message_id | INTEGER | Primary key for message | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| conversation_id | INTEGER | Foreign key to conversations | FOREIGN KEY, NOT NULL | Parent conversation |
| sender_id | INTEGER | Foreign key to users (sender) | FOREIGN KEY, NOT NULL | Message author |
| message_text | TEXT | Message content | NOT NULL | Message body |
| message_type | VARCHAR(20) | Message type | DEFAULT 'text' | 'text', 'image', 'file', 'system' |
| sent_at | DATETIME | Message timestamp | NOT NULL | System-generated |
| read_at | DATETIME | Read timestamp | NULL allowed | When message was read |

---

## 8. SYSTEM DOMAIN

### 8.1 notifications Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| notification_id | INTEGER | Primary key for notification | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INTEGER | Foreign key to users | FOREIGN KEY, NOT NULL | Notification recipient |
| notification_type | VARCHAR(50) | Notification type | NOT NULL | 'booking_confirmed', 'payment_received', 'review_posted' |
| title | VARCHAR(200) | Notification title | NOT NULL | Brief notification headline |
| message | TEXT | Notification content | NOT NULL | Detailed notification message |
| is_read | BOOLEAN | Read status | DEFAULT FALSE | Controls notification display |
| created_at | DATETIME | Notification creation | NOT NULL | System-generated |
| sent_at | DATETIME | Notification send timestamp | NULL allowed | When notification was sent |

---

## 9. TRIPLE RELATIONSHIP JUNCTION TABLES

### 9.1 property_booking_pricing Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| pbp_id | INTEGER | Primary key for junction record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INTEGER | Foreign key to properties | FOREIGN KEY, NOT NULL | Property in relationship |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Booking in relationship |
| pricing_id | INTEGER | Foreign key to property_pricing | FOREIGN KEY, NOT NULL | Pricing rule applied |
| applied_price | DECIMAL(10,2) | Final price applied | NOT NULL | Actual price charged |
| pricing_rule_applied | VARCHAR(100) | Rule description | NULL allowed | Which pricing rule was used |
| created_at | DATETIME | Junction creation timestamp | NOT NULL | System-generated |

### 9.2 user_booking_review Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| ubr_id | INTEGER | Primary key for junction record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INTEGER | Foreign key to users | FOREIGN KEY, NOT NULL | User in relationship |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Booking in relationship |
| review_id | INTEGER | Foreign key to reviews | FOREIGN KEY, NOT NULL | Review in relationship |
| review_role | VARCHAR(20) | User's role in review | NOT NULL | 'reviewer' or 'reviewee' |
| interaction_type | VARCHAR(50) | Type of interaction | NULL allowed | 'written', 'received', 'responded' |
| created_at | DATETIME | Junction creation timestamp | NOT NULL | System-generated |

### 9.3 booking_payment_payout Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| bpp_id | INTEGER | Primary key for junction record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| booking_id | INTEGER | Foreign key to bookings | FOREIGN KEY, NOT NULL | Booking in relationship |
| payment_id | INTEGER | Foreign key to payments | FOREIGN KEY, NOT NULL | Payment in relationship |
| payout_id | INTEGER | Foreign key to payouts | FOREIGN KEY, NULL allowed | Payout in relationship |
| transaction_chain_status | VARCHAR(20) | Chain status | NOT NULL | 'pending', 'completed', 'failed' |
| processing_notes | TEXT | Processing notes | NULL allowed | Additional processing information |
| created_at | DATETIME | Junction creation timestamp | NOT NULL | System-generated |

---

## 10. DATA INTEGRITY CONSTRAINTS

### 10.1 Primary Key Constraints
- All tables have surrogate primary keys (INTEGER, AUTO_INCREMENT)
- Primary keys are immutable and system-generated
- No business logic should depend on primary key values

### 10.2 Foreign Key Constraints
- All foreign keys must reference existing records
- Foreign key relationships enforce referential integrity
- Cascade rules: ON DELETE CASCADE, ON UPDATE CASCADE

### 10.3 Unique Constraints
- Email addresses must be unique across all users
- Phone numbers must be unique across all users
- Property type names must be unique
- Amenity names must be unique
- Country codes must be unique
- Transaction IDs must be unique

### 10.4 Check Constraints
- Rating values must be between 1 and 5
- Amounts must be positive (>= 0)
- Dates must be valid and logical
- Email addresses must be valid format
- Phone numbers must be valid format

### 10.5 Business Rule Constraints
- Booking check-out date must be after check-in date
- Property capacity must accommodate number of guests
- Reviews can only be written after stay completion
- Payments must be processed before check-in
- Payouts are processed 24 hours after guest check-in

---

**Document Version:** 1.0  
**Last Updated:** 02/10/2025
