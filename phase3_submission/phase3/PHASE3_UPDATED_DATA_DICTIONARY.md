# Updated Data Dictionary for Airbnb Database System

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Phase 3 - Final Implementation  
**Date:** 24/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## Overview

This updated data dictionary reflects the actual implemented database schema from Phase 2. The database includes 27 entities with comprehensive relationships, role-based architecture, and enhanced business logic.

---

## 1. USER MANAGEMENT DOMAIN

### 1.1 users Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| user_id | INT | Primary key, unique identifier for each user | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key, system-generated |
| email | VARCHAR(255) | User's email address for login and communication | UNIQUE, NOT NULL | Must be valid email format, unique across platform |
| password_hash | VARCHAR(255) | Encrypted password for authentication | NOT NULL | Never store plain text, use secure hashing |
| first_name | VARCHAR(100) | User's first name | NOT NULL | Required for personalization |
| last_name | VARCHAR(100) | User's last name | NOT NULL | Required for personalization |
| phone | VARCHAR(20) | User's phone number | UNIQUE, NOT NULL | Must be unique, valid international format |
| date_of_birth | DATE | User's birth date | NULL allowed | Used for age verification, privacy compliance |
| is_guest | BOOLEAN | Guest role flag | DEFAULT TRUE | Controls guest functionality |
| is_host | BOOLEAN | Host role flag | DEFAULT FALSE | Controls host functionality |
| is_admin | BOOLEAN | Admin role flag | DEFAULT FALSE | Controls admin functionality |
| created_at | DATETIME | Account creation timestamp | NOT NULL | System-generated, immutable |
| updated_at | DATETIME | Last modification timestamp | NOT NULL | System-maintained, updated on changes |
| is_active | BOOLEAN | Account status flag | DEFAULT TRUE | Controls login access, soft delete |

### 1.2 guest_profiles Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| guest_profile_id | INT | Primary key for guest profile | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users table | FOREIGN KEY, UNIQUE, NOT NULL | One profile per user (1:1) |
| preferred_price_range | VARCHAR(50) | Guest's preferred price range | NULL allowed | Price preference for searches |
| preferred_property_types | JSON | Guest's preferred property types | NULL allowed | JSON array of property type preferences |
| travel_preferences | JSON | Guest's travel preferences | NULL allowed | JSON object with travel preferences |
| guest_verification_status | VARCHAR(20) | Guest verification status | DEFAULT 'unverified' | Verification level tracking |
| verification_date | DATETIME | When guest was verified | NULL allowed | Set when verification completed |
| created_at | DATETIME | Profile creation timestamp | NOT NULL | System-generated |

### 1.3 host_profiles Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| host_profile_id | INT | Primary key for host profile | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users table | FOREIGN KEY, UNIQUE, NOT NULL | One profile per user (1:1) |
| host_verification_status | VARCHAR(20) | Host verification status | DEFAULT 'pending' | Verification level tracking |
| verification_date | DATETIME | When host was verified | NULL allowed | Set when verification completed |
| host_since | DATETIME | When host joined platform | NULL allowed | Host tenure tracking |
| response_rate | DECIMAL(5,2) | Host response rate percentage | DEFAULT 0.00 | Must be 0-100 |
| response_time_hours | INT | Average response time in hours | NULL allowed | Performance metric |
| acceptance_rate | DECIMAL(5,2) | Host acceptance rate percentage | DEFAULT 0.00 | Must be 0-100 |
| host_rating | DECIMAL(3,2) | Overall host rating | NULL allowed | Must be 1-5 |
| total_properties | INT | Number of properties owned | DEFAULT 0 | Host property count |
| superhost_status | BOOLEAN | Superhost status flag | DEFAULT FALSE | Premium host status |
| payout_method_id | INT | Payout method reference | NULL allowed | Payment method for payouts |
| tax_id | VARCHAR(50) | Tax identification number | NULL allowed | Tax compliance |
| business_name | VARCHAR(255) | Business name if applicable | NULL allowed | Business entity name |
| business_registration | VARCHAR(100) | Business registration number | NULL allowed | Business registration |
| created_at | DATETIME | Profile creation timestamp | NOT NULL | System-generated |

### 1.4 user_profiles Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| profile_id | INT | Primary key for profile record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users table | FOREIGN KEY, NOT NULL | Multiple profiles per user allowed |
| bio | TEXT | User's biographical description | NULL allowed | Optional personal information |
| profile_picture | VARCHAR(500) | URL to user's profile image | NULL allowed | Must be valid image URL |
| language_preference | VARCHAR(10) | User's preferred language | DEFAULT 'en' | ISO language code |
| currency_preference | VARCHAR(3) | User's preferred currency | DEFAULT 'USD' | ISO currency code |
| timezone | VARCHAR(50) | User's timezone | NULL allowed | IANA timezone identifier |
| notification_settings | JSON | User's notification preferences | NULL allowed | Structured preference data |

### 1.5 user_verification Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| verification_id | INT | Primary key for verification record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users table | FOREIGN KEY, NOT NULL | Multiple verifications per user |
| verification_type | VARCHAR(50) | Type of verification performed | NOT NULL | 'identity', 'phone', 'email', 'government_id' |
| document_type | VARCHAR(50) | Type of document used | NOT NULL | 'passport', 'driver_license', 'national_id' |
| document_number | VARCHAR(100) | Document identifier | NOT NULL | Encrypted sensitive data |
| verification_status | VARCHAR(20) | Current verification status | NOT NULL | 'pending', 'approved', 'rejected', 'expired' |
| verified_at | DATETIME | When verification was completed | NULL allowed | Set when status becomes 'approved' |
| expires_at | DATETIME | When verification expires | NULL allowed | Required for time-limited verifications |

### 1.6 user_preferences Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| preference_id | INT | Primary key for preference record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users table | FOREIGN KEY, NOT NULL | Multiple preferences per user |
| preference_key | VARCHAR(100) | Preference identifier | NOT NULL | 'email_notifications', 'sms_alerts', etc. |
| preference_value | JSON | Preference value/settings | NOT NULL | Structured data for complex preferences |
| updated_at | DATETIME | Last preference update | NOT NULL | Track preference changes |

---

## 2. LOCATION DOMAIN

### 2.1 countries Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| country_id | INT | Primary key for country | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| country_name | VARCHAR(100) | Country name | NOT NULL, UNIQUE | Official country name |
| country_code | VARCHAR(3) | ISO country code | NOT NULL, UNIQUE | Standard ISO 3166-1 alpha-3 |
| currency_code | VARCHAR(3) | Currency code | NOT NULL | ISO 4217 currency code |
| phone_code | VARCHAR(5) | International dialing code | NULL allowed | Country calling code |

### 2.2 cities Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| city_id | INT | Primary key for city | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| city_name | VARCHAR(100) | City name | NOT NULL | Official city name |
| state_province | VARCHAR(100) | State or province | NULL allowed | Administrative division |
| country_id | INT | Foreign key to countries | FOREIGN KEY, NOT NULL | Country containing city |
| timezone | VARCHAR(50) | City timezone | NULL allowed | IANA timezone identifier |
| population | INT | City population | NULL allowed | Demographic data |

### 2.3 addresses Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| address_id | INT | Primary key for address | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| street_address | VARCHAR(200) | Street address line | NOT NULL | Building number and street |
| city_id | INT | Foreign key to cities | FOREIGN KEY, NOT NULL | City location |
| postal_code | VARCHAR(20) | Postal/ZIP code | NULL allowed | Location identifier |
| latitude | DECIMAL(10,8) | GPS latitude coordinate | NOT NULL | Must be valid GPS coordinate |
| longitude | DECIMAL(11,8) | GPS longitude coordinate | NOT NULL | Must be valid GPS coordinate |

---

## 3. PROPERTY MANAGEMENT DOMAIN

### 3.1 property_types Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| property_type_id | INT | Primary key for property type | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| type_name | VARCHAR(50) | Property type name | NOT NULL, UNIQUE | 'apartment', 'house', 'villa', etc. |
| description | TEXT | Type description | NULL allowed | Marketing copy |
| icon_url | VARCHAR(500) | Icon image URL | NULL allowed | Visual representation |

### 3.2 property_amenities Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| amenity_id | INT | Primary key for amenity | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| amenity_name | VARCHAR(100) | Amenity name | NOT NULL, UNIQUE | 'WiFi', 'Pool', 'Parking', etc. |
| amenity_category | VARCHAR(50) | Amenity category | NOT NULL | 'internet', 'kitchen', 'safety', etc. |
| icon_url | VARCHAR(500) | Amenity icon URL | NULL allowed | Visual representation |
| description | TEXT | Amenity description | NULL allowed | Detailed explanation |

### 3.3 properties Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| property_id | INT | Primary key for property | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| host_id | INT | Foreign key to host_profiles | FOREIGN KEY, NOT NULL | Property owner (host) |
| property_type_id | INT | Foreign key to property_types | FOREIGN KEY, NOT NULL | Property category |
| title | VARCHAR(200) | Property listing title | NOT NULL | Marketing headline |
| description | TEXT | Detailed property description | NULL allowed | Rich text content |
| address_id | INT | Foreign key to addresses | FOREIGN KEY, NOT NULL | Physical location |
| max_guests | INT | Maximum guest capacity | NOT NULL | Must be positive integer |
| bedrooms | INT | Number of bedrooms | NOT NULL | Must be non-negative |
| bathrooms | DECIMAL(3,1) | Number of bathrooms | NOT NULL | Allows half-baths (1.5, 2.5) |
| size_sqm | DECIMAL(8,2) | Property size in square meters | NULL allowed | For property comparison |
| created_at | DATETIME | Property listing creation | NOT NULL | System-generated |
| updated_at | DATETIME | Last property update | NOT NULL | System-maintained |
| is_active | BOOLEAN | Property availability status | DEFAULT TRUE | Controls booking availability |

### 3.4 property_amenity_links Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| link_id | INT | Primary key for link | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INT | Foreign key to properties | FOREIGN KEY, NOT NULL | Property with amenity |
| amenity_id | INT | Foreign key to property_amenities | FOREIGN KEY, NOT NULL | Available amenity |
| is_available | BOOLEAN | Amenity availability status | DEFAULT TRUE | Can be temporarily unavailable |
| additional_info | TEXT | Extra amenity details | NULL allowed | Special conditions, notes |

### 3.5 property_photos Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| photo_id | INT | Primary key for photo | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INT | Foreign key to properties | FOREIGN KEY, NOT NULL | Property in photo |
| photo_url | VARCHAR(500) | Photo file URL | NOT NULL | Must be valid image URL |
| caption | VARCHAR(200) | Photo description | NULL allowed | Optional photo caption |
| is_primary | BOOLEAN | Primary photo flag | DEFAULT FALSE | Only one primary per property |
| display_order | INT | Photo display sequence | DEFAULT 0 | Controls photo gallery order |
| uploaded_at | DATETIME | Upload timestamp | NOT NULL | System-generated |

### 3.6 property_pricing Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| pricing_id | INT | Primary key for pricing rule | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INT | Foreign key to properties | FOREIGN KEY, NOT NULL | Property with pricing |
| start_date | DATE | Pricing period start | NOT NULL | Must be valid date |
| end_date | DATE | Pricing period end | NOT NULL | Must be after start_date |
| base_price_per_night | DECIMAL(10,2) | Standard nightly rate | NOT NULL | Must be positive |
| weekend_price_per_night | DECIMAL(10,2) | Weekend rate | NULL allowed | Optional weekend pricing |
| weekly_discount_percentage | DECIMAL(5,2) | Weekly stay discount | DEFAULT 0 | Percentage discount |
| monthly_discount_percentage | DECIMAL(5,2) | Monthly stay discount | DEFAULT 0 | Percentage discount |
| minimum_stay_nights | INT | Minimum booking length | DEFAULT 1 | Must be at least 1 |
| maximum_stay_nights | INT | Maximum booking length | NULL allowed | Optional stay limit |
| is_available | BOOLEAN | Availability status | DEFAULT TRUE | Controls booking availability |
| created_at | DATETIME | Rule creation timestamp | NOT NULL | System-generated |
| updated_at | DATETIME | Last rule update | NOT NULL | System-maintained |

---

## 4. BOOKING SYSTEM DOMAIN

### 4.1 booking_status Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| status_id | INT | Primary key for status | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| status_name | VARCHAR(50) | Status name | NOT NULL, UNIQUE | 'pending', 'confirmed', 'cancelled' |
| description | TEXT | Status description | NULL allowed | Business explanation |
| is_active | BOOLEAN | Status availability | DEFAULT TRUE | Controls status usage |

### 4.2 bookings Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| booking_id | INT | Primary key for booking | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| guest_profile_id | INT | Foreign key to guest_profiles | FOREIGN KEY, NOT NULL | Booking guest |
| user_id | INT | Foreign key to users (audit trail) | FOREIGN KEY, NOT NULL | Guest user for audit |
| property_id | INT | Foreign key to properties | FOREIGN KEY, NOT NULL | Booked property |
| booking_status_id | INT | Foreign key to booking_status | FOREIGN KEY, NOT NULL | Current booking status |
| check_in_date | DATE | Check-in date | NOT NULL | Must be future date when created |
| check_out_date | DATE | Check-out date | NOT NULL | Must be after check-in_date |
| number_of_guests | INT | Number of guests | NOT NULL | Must match property capacity |
| total_amount | DECIMAL(10,2) | Total booking cost | NOT NULL | Must be positive |
| created_at | DATETIME | Booking creation timestamp | NOT NULL | System-generated |
| confirmed_at | DATETIME | Booking confirmation timestamp | NULL allowed | Set when booking confirmed |

### 4.3 booking_modifications Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| modification_id | INT | Primary key for modification | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Modified booking |
| modification_type | VARCHAR(50) | Type of modification | NOT NULL | 'date_change', 'guest_count', 'cancellation' |
| old_value | TEXT | Previous value | NULL allowed | Original booking data |
| new_value | TEXT | New value | NULL allowed | Modified booking data |
| reason | TEXT | Modification reason | NULL allowed | Business justification |
| created_at | DATETIME | Modification timestamp | NOT NULL | System-generated |
| approved_by | INT | Foreign key to users (approver) | FOREIGN KEY, NULL allowed | Staff member who approved |

---

## 5. FINANCIAL DOMAIN

### 5.1 payment_methods Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| payment_method_id | INT | Primary key for payment method | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users | FOREIGN KEY, NOT NULL | Payment method owner |
| method_type | VARCHAR(50) | Payment method type | NOT NULL | 'credit_card', 'debit_card', 'paypal' |
| card_last_four | VARCHAR(4) | Last four digits of card | NULL allowed | Masked card information |
| expiry_date | VARCHAR(7) | Card expiry date | NULL allowed | MM/YYYY format |
| is_default | BOOLEAN | Default payment method | DEFAULT FALSE | User's preferred method |
| is_active | BOOLEAN | Method availability | DEFAULT TRUE | Controls method usage |

### 5.2 payments Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| payment_id | INT | Primary key for payment | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Payment for booking |
| payment_method_id | INT | Foreign key to payment_methods | FOREIGN KEY, NOT NULL | Payment method used |
| amount | DECIMAL(10,2) | Payment amount | NOT NULL | Must be positive |
| currency | VARCHAR(3) | Payment currency | NOT NULL | ISO 4217 currency code |
| payment_status | VARCHAR(20) | Payment status | NOT NULL | 'pending', 'completed', 'failed', 'refunded' |
| transaction_id | VARCHAR(100) | External transaction ID | UNIQUE, NULL allowed | Payment processor reference |
| processed_at | DATETIME | Payment processing timestamp | NULL allowed | Set when payment processed |
| refunded_at | DATETIME | Refund timestamp | NULL allowed | Set when payment refunded |

### 5.3 payouts Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| payout_id | INT | Primary key for payout | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| host_profile_id | INT | Foreign key to host_profiles | FOREIGN KEY, NOT NULL | Payout recipient |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Source booking |
| amount | DECIMAL(10,2) | Payout amount | NOT NULL | Must be positive |
| currency | VARCHAR(3) | Payout currency | NOT NULL | ISO 4217 currency code |
| payout_status | VARCHAR(20) | Payout status | NOT NULL | 'pending', 'processing', 'completed', 'failed' |
| scheduled_date | DATETIME | Scheduled payout date | NULL allowed | Planned payout date |
| processed_date | DATETIME | Actual payout date | NULL allowed | When payout was completed |

---

## 6. REVIEW SYSTEM DOMAIN

### 6.1 review_categories Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| category_id | INT | Primary key for category | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| category_name | VARCHAR(50) | Category name | NOT NULL, UNIQUE | 'cleanliness', 'communication', 'location' |
| description | TEXT | Category description | NULL allowed | Category explanation |
| weight | DECIMAL(3,2) | Category importance weight | DEFAULT 1.00 | Used in overall rating calculation |

### 6.2 reviews Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| review_id | INT | Primary key for review | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| reviewer_id | INT | Foreign key to users (reviewer) | FOREIGN KEY, NOT NULL | Review author |
| reviewee_id | INT | Foreign key to users (reviewee) | FOREIGN KEY, NOT NULL | Review subject |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Source booking |
| rating | INT | Overall rating | NOT NULL | Must be 1-5 |
| review_text | TEXT | Review content | NULL allowed | Detailed review text |
| is_public | BOOLEAN | Review visibility | DEFAULT TRUE | Controls public display |
| created_at | DATETIME | Review creation timestamp | NOT NULL | System-generated |
| updated_at | DATETIME | Last review update | NOT NULL | System-maintained |

### 6.3 review_ratings Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| rating_id | INT | Primary key for rating | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| review_id | INT | Foreign key to reviews | FOREIGN KEY, NOT NULL | Parent review |
| category_id | INT | Foreign key to review_categories | FOREIGN KEY, NOT NULL | Rating category |
| rating_value | INT | Category rating | NOT NULL | Must be 1-5 |

---

## 7. COMMUNICATION DOMAIN

### 7.1 conversations Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| conversation_id | INT | Primary key for conversation | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| participant1_id | INT | Foreign key to users (participant 1) | FOREIGN KEY, NOT NULL | First conversation participant |
| participant2_id | INT | Foreign key to users (participant 2) | FOREIGN KEY, NOT NULL | Second conversation participant |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Related booking |
| created_at | DATETIME | Conversation creation timestamp | NOT NULL | System-generated |
| last_message_at | DATETIME | Last message timestamp | NULL allowed | Updated on new messages |

### 7.2 messages Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| message_id | INT | Primary key for message | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| conversation_id | INT | Foreign key to conversations | FOREIGN KEY, NOT NULL | Parent conversation |
| sender_id | INT | Foreign key to users (sender) | FOREIGN KEY, NOT NULL | Message author |
| message_text | TEXT | Message content | NOT NULL | Message body |
| message_type | VARCHAR(20) | Message type | DEFAULT 'text' | 'text', 'image', 'file', 'system' |
| sent_at | DATETIME | Message timestamp | NOT NULL | System-generated |
| read_at | DATETIME | Read timestamp | NULL allowed | When message was read |

---

## 8. SYSTEM DOMAIN

### 8.1 notifications Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| notification_id | INT | Primary key for notification | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users | FOREIGN KEY, NOT NULL | Notification recipient |
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
| pbp_id | INT | Primary key for junction record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| property_id | INT | Foreign key to properties | FOREIGN KEY, NOT NULL | Property in relationship |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Booking in relationship |
| pricing_id | INT | Foreign key to property_pricing | FOREIGN KEY, NOT NULL | Pricing rule applied |
| applied_price | DECIMAL(10,2) | Final price applied | NOT NULL | Actual price charged |
| pricing_rule_applied | VARCHAR(100) | Rule description | NULL allowed | Which pricing rule was used |
| created_at | DATETIME | Junction creation timestamp | NOT NULL | System-generated |

### 9.2 user_booking_review Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| ubr_id | INT | Primary key for junction record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| user_id | INT | Foreign key to users | FOREIGN KEY, NOT NULL | User in relationship |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Booking in relationship |
| review_id | INT | Foreign key to reviews | FOREIGN KEY, NOT NULL | Review in relationship |
| review_role | VARCHAR(20) | User's role in review | NOT NULL | 'reviewer' or 'reviewee' |
| interaction_type | VARCHAR(50) | Type of interaction | NULL allowed | 'written', 'received', 'responded' |
| created_at | DATETIME | Junction creation timestamp | NOT NULL | System-generated |

### 9.3 booking_payment_payout Table

| Attribute | Data Type | Description | Constraints | Business Rules |
|-----------|-----------|-------------|-------------|----------------|
| bpp_id | INT | Primary key for junction record | PRIMARY KEY, AUTO_INCREMENT, NOT NULL | Surrogate key |
| booking_id | INT | Foreign key to bookings | FOREIGN KEY, NOT NULL | Booking in relationship |
| payment_id | INT | Foreign key to payments | FOREIGN KEY, NOT NULL | Payment in relationship |
| payout_id | INT | Foreign key to payouts | FOREIGN KEY, NULL allowed | Payout in relationship |
| transaction_chain_status | VARCHAR(20) | Chain status | NOT NULL | 'pending', 'completed', 'failed' |
| processing_notes | TEXT | Processing notes | NULL allowed | Additional processing information |
| created_at | DATETIME | Junction creation timestamp | NOT NULL | System-generated |

---

## 10. KEY DIFFERENCES FROM PHASE 1 DATA DICTIONARY

### 10.1 Role-Based Architecture
- **Enhanced users table** with role tracking flags (is_guest, is_host, is_admin)
- **Separate guest_profiles and host_profiles** tables for role-specific attributes
- **Multi-role support** allowing users to be both guests and hosts

### 10.2 Updated Relationships
- **Properties → host_profiles**: Clear ownership chain through host_profiles
- **Bookings → guest_profiles**: Explicit guest context with user_id for audit trail
- **Enhanced foreign key relationships** with proper cascade rules

### 10.3 Business Logic Improvements
- **Comprehensive verification systems** for both guests and hosts
- **Enhanced pricing rules** with flexible date ranges and discounts
- **Improved communication system** with conversation tracking
- **Financial transaction chain** with booking-payment-payout relationships

### 10.4 Data Integrity Enhancements
- **Role consistency constraints** ensuring valid role combinations
- **Enhanced validation rules** for ratings, amounts, and dates
- **Comprehensive foreign key relationships** with proper cascade rules
- **Business rule enforcement** at the database level

---

**Document Version:** 2.0  
**Last Updated:** 24/10/2025  
**Status:** Updated to reflect Phase 2 implementation
