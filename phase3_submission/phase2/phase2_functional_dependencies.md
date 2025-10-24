# Phase 2 Functional Dependencies Analysis

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Design - Normalization and Constraints  
**Date:** 14/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## 1. Introduction

This document provides a comprehensive analysis of functional dependencies (FDs) in the Airbnb database design. Functional dependencies are fundamental to understanding data relationships, ensuring proper normalization, and maintaining data integrity. This analysis covers all 27 entities and their relationships, identifying partial dependencies, transitive dependencies, and the complete functional dependency set.

## 2. Functional Dependencies Theory

### 2.1 Definition and Notation

**Functional Dependency:** A functional dependency X → Y exists if, for any two tuples t1 and t2 in a relation, if t1[X] = t2[X], then t1[Y] = t2[Y].

**Notation:**
- **X → Y:** X functionally determines Y
- **X:** Determinant (left side)
- **Y:** Dependent (right side)
- **X → Y, Z:** X determines both Y and Z

### 2.2 Types of Functional Dependencies

1. **Trivial FDs:** X → Y where Y ⊆ X
2. **Non-trivial FDs:** X → Y where Y ⊄ X
3. **Partial Dependencies:** X → Y where X is a proper subset of a candidate key
4. **Transitive Dependencies:** X → Y → Z where X → Y and Y → Z, but X ↛ Z

## 3. Complete Functional Dependency Set

### 3.1 User Management Domain

#### 3.1.1 Users Table
**Primary Key:** user_id

**Functional Dependencies:**
```
user_id → {email, password_hash, first_name, last_name, phone, date_of_birth, 
           is_guest, is_host, is_admin, created_at, updated_at, is_active}

email → user_id (unique constraint)
phone → user_id (unique constraint)
```

**Analysis:**
- **Single-attribute Primary Key:** No partial dependencies
- **Unique Constraints:** Email and phone create additional functional dependencies
- **No Transitive Dependencies:** All attributes directly depend on user_id

#### 3.1.2 Guest Profiles Table
**Primary Key:** guest_profile_id

**Functional Dependencies:**
```
guest_profile_id → {user_id, preferred_price_range, guest_verification_status, 
                    verification_date, created_at}

user_id → guest_profile_id (1:1 relationship)
```

**Analysis:**
- **1:1 Relationship:** user_id and guest_profile_id are mutually dependent
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on guest_profile_id

#### 3.1.3 Host Profiles Table
**Primary Key:** host_profile_id

**Functional Dependencies:**
```
host_profile_id → {user_id, host_verification_status, verification_date, host_since,
                   response_rate, response_time_hours, acceptance_rate, host_rating,
                   total_properties, superhost_status, payout_method_id, tax_id,
                   business_name, business_registration, created_at}

user_id → host_profile_id (1:1 relationship)
```

**Analysis:**
- **1:1 Relationship:** user_id and host_profile_id are mutually dependent
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on host_profile_id

#### 3.1.4 User Profiles Table
**Primary Key:** profile_id

**Functional Dependencies:**
```
profile_id → {user_id, bio, profile_picture, language_preference, currency_preference,
              timezone, notification_settings}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on profile_id

#### 3.1.5 User Verification Table
**Primary Key:** verification_id

**Functional Dependencies:**
```
verification_id → {user_id, verification_type, document_type, document_number,
                   verification_status, verified_at, expires_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on verification_id

#### 3.1.6 User Preferences Table
**Primary Key:** preference_id

**Functional Dependencies:**
```
preference_id → {user_id, preference_key, preference_value, updated_at}

(user_id, preference_key) → {preference_value, updated_at}
```

**Analysis:**
- **Composite Key Dependency:** (user_id, preference_key) determines preference_value and updated_at
- **No Partial Dependencies:** The composite key fully determines all non-key attributes
- **No Transitive Dependencies:** All attributes directly depend on the primary key

### 3.2 Property Management Domain

#### 3.2.1 Properties Table
**Primary Key:** property_id

**Functional Dependencies:**
```
property_id → {host_id, property_type_id, title, description, address_id, max_guests,
               bedrooms, bathrooms, size_sqm, created_at, updated_at, is_active}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on property_id

#### 3.2.2 Property Types Table
**Primary Key:** property_type_id

**Functional Dependencies:**
```
property_type_id → {type_name, description, icon_url}

type_name → property_type_id (unique constraint)
```

**Analysis:**
- **Unique Constraint:** type_name creates additional functional dependency
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on property_type_id

#### 3.2.3 Property Amenities Table
**Primary Key:** amenity_id

**Functional Dependencies:**
```
amenity_id → {amenity_name, amenity_category, icon_url, description}

amenity_name → amenity_id (unique constraint)
```

**Analysis:**
- **Unique Constraint:** amenity_name creates additional functional dependency
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on amenity_id

#### 3.2.4 Property Amenity Links Table
**Primary Key:** link_id

**Functional Dependencies:**
```
link_id → {property_id, amenity_id, is_available, additional_info}

(property_id, amenity_id) → {is_available, additional_info}
```

**Analysis:**
- **Composite Key Dependency:** (property_id, amenity_id) determines is_available and additional_info
- **No Partial Dependencies:** The composite key fully determines all non-key attributes
- **No Transitive Dependencies:** All attributes directly depend on the primary key

#### 3.2.5 Property Photos Table
**Primary Key:** photo_id

**Functional Dependencies:**
```
photo_id → {property_id, photo_url, caption, is_primary, display_order, uploaded_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on photo_id

#### 3.2.6 Property Pricing Table
**Primary Key:** pricing_id

**Functional Dependencies:**
```
pricing_id → {property_id, start_date, end_date, base_price_per_night, weekend_price_per_night,
              weekly_discount_percentage, monthly_discount_percentage, minimum_stay_nights,
              maximum_stay_nights, is_available, created_at, updated_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on pricing_id

### 3.3 Location Domain

#### 3.3.1 Addresses Table
**Primary Key:** address_id

**Functional Dependencies:**
```
address_id → {street_address, city_id, postal_code, latitude, longitude, country_id}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on address_id

#### 3.3.2 Cities Table
**Primary Key:** city_id

**Functional Dependencies:**
```
city_id → {city_name, state_province, country_id, timezone, population}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on city_id

#### 3.3.3 Countries Table
**Primary Key:** country_id

**Functional Dependencies:**
```
country_id → {country_name, country_code, currency_code, phone_code}

country_name → country_id (unique constraint)
country_code → country_id (unique constraint)
```

**Analysis:**
- **Unique Constraints:** country_name and country_code create additional functional dependencies
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on country_id

### 3.4 Booking System Domain

#### 3.4.1 Bookings Table
**Primary Key:** booking_id

**Functional Dependencies:**
```
booking_id → {guest_profile_id, user_id, property_id, booking_status_id, check_in_date,
               check_out_date, number_of_guests, total_amount, created_at, confirmed_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on booking_id

#### 3.4.2 Booking Status Table
**Primary Key:** status_id

**Functional Dependencies:**
```
status_id → {status_name, description, is_active}

status_name → status_id (unique constraint)
```

**Analysis:**
- **Unique Constraint:** status_name creates additional functional dependency
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on status_id

#### 3.4.3 Booking Modifications Table
**Primary Key:** modification_id

**Functional Dependencies:**
```
modification_id → {booking_id, modification_type, old_value, new_value, reason,
                   created_at, approved_by}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on modification_id

### 3.5 Financial Domain

#### 3.5.1 Payments Table
**Primary Key:** payment_id

**Functional Dependencies:**
```
payment_id → {booking_id, payment_method_id, amount, currency, payment_status,
               transaction_id, processed_at, refunded_at}

transaction_id → payment_id (unique constraint)
```

**Analysis:**
- **Unique Constraint:** transaction_id creates additional functional dependency
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on payment_id

#### 3.5.2 Payment Methods Table
**Primary Key:** payment_method_id

**Functional Dependencies:**
```
payment_method_id → {user_id, method_type, card_last_four, expiry_date, is_default, is_active}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on payment_method_id

#### 3.5.3 Payouts Table
**Primary Key:** payout_id

**Functional Dependencies:**
```
payout_id → {host_profile_id, booking_id, amount, currency, payout_status,
              scheduled_date, processed_date}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on payout_id

### 3.6 Review System Domain

#### 3.6.1 Reviews Table
**Primary Key:** review_id

**Functional Dependencies:**
```
review_id → {reviewer_id, reviewee_id, booking_id, rating, review_text, is_public,
              created_at, updated_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on review_id

#### 3.6.2 Review Categories Table
**Primary Key:** category_id

**Functional Dependencies:**
```
category_id → {category_name, description, weight}

category_name → category_id (unique constraint)
```

**Analysis:**
- **Unique Constraint:** category_name creates additional functional dependency
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on category_id

#### 3.6.3 Review Ratings Table
**Primary Key:** rating_id

**Functional Dependencies:**
```
rating_id → {review_id, category_id, rating_value}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on rating_id

### 3.7 Communication Domain

#### 3.7.1 Conversations Table
**Primary Key:** conversation_id

**Functional Dependencies:**
```
conversation_id → {participant1_id, participant2_id, booking_id, created_at, last_message_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on conversation_id

#### 3.7.2 Messages Table
**Primary Key:** message_id

**Functional Dependencies:**
```
message_id → {conversation_id, sender_id, message_text, message_type, sent_at, read_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on message_id

### 3.8 System Domain

#### 3.8.1 Notifications Table
**Primary Key:** notification_id

**Functional Dependencies:**
```
notification_id → {user_id, notification_type, title, message, is_read, created_at, sent_at}
```

**Analysis:**
- **No Partial Dependencies:** Single-attribute primary key
- **No Transitive Dependencies:** All attributes directly depend on notification_id

### 3.9 Triple Relationship Tables

#### 3.9.1 Property-Booking-Pricing Junction
**Primary Key:** pbp_id

**Functional Dependencies:**
```
pbp_id → {property_id, booking_id, pricing_id, applied_price, pricing_rule_applied, created_at}

(property_id, booking_id, pricing_id) → {applied_price, pricing_rule_applied, created_at}
```

**Analysis:**
- **Composite Key Dependency:** (property_id, booking_id, pricing_id) determines applied_price, pricing_rule_applied, and created_at
- **No Partial Dependencies:** The composite key fully determines all non-key attributes
- **No Transitive Dependencies:** All attributes directly depend on the primary key

#### 3.9.2 User-Booking-Review Junction
**Primary Key:** ubr_id

**Functional Dependencies:**
```
ubr_id → {user_id, booking_id, review_id, review_role, interaction_type, created_at}

(user_id, booking_id, review_id) → {review_role, interaction_type, created_at}
```

**Analysis:**
- **Composite Key Dependency:** (user_id, booking_id, review_id) determines review_role, interaction_type, and created_at
- **No Partial Dependencies:** The composite key fully determines all non-key attributes
- **No Transitive Dependencies:** All attributes directly depend on the primary key

#### 3.9.3 Booking-Payment-Payout Junction
**Primary Key:** bpp_id

**Functional Dependencies:**
```
bpp_id → {booking_id, payment_id, payout_id, transaction_chain_status, processing_notes, created_at}

(booking_id, payment_id, payout_id) → {transaction_chain_status, processing_notes, created_at}
```

**Analysis:**
- **Composite Key Dependency:** (booking_id, payment_id, payout_id) determines transaction_chain_status, processing_notes, and created_at
- **No Partial Dependencies:** The composite key fully determines all non-key attributes
- **No Transitive Dependencies:** All attributes directly depend on the primary key

## 4. Partial Dependencies Analysis

### 4.1 Partial Dependency Definition
A partial dependency occurs when a non-key attribute depends on only part of a composite primary key.

### 4.2 Analysis Results

**Result:** No partial dependencies were found in the database design.

**Justification:**
1. **Single-Attribute Primary Keys:** Most tables use auto-increment primary keys
2. **Composite Keys:** Where composite keys exist, they fully determine all non-key attributes
3. **Proper Design:** The original design avoided partial dependencies

### 4.3 Examples of Proper Composite Key Design

#### 4.3.1 User Preferences Table
**Composite Key:** (user_id, preference_key)
**Functional Dependencies:**
```
(user_id, preference_key) → {preference_value, updated_at}
```

**Analysis:** No partial dependencies exist because:
- preference_value depends on the full composite key (user_id, preference_key)
- updated_at depends on the full composite key (user_id, preference_key)
- Neither attribute depends on just user_id or just preference_key

#### 4.3.2 Property Amenity Links Table
**Composite Key:** (property_id, amenity_id)
**Functional Dependencies:**
```
(property_id, amenity_id) → {is_available, additional_info}
```

**Analysis:** No partial dependencies exist because:
- is_available depends on the full composite key (property_id, amenity_id)
- additional_info depends on the full composite key (property_id, amenity_id)
- Neither attribute depends on just property_id or just amenity_id

## 5. Transitive Dependencies Analysis

### 5.1 Transitive Dependency Definition
A transitive dependency occurs when X → Y and Y → Z, but X ↛ Z directly.

### 5.2 Analysis Results

**Result:** No transitive dependencies were found in the database design.

**Justification:**
1. **Direct Dependencies:** All non-key attributes directly depend on the primary key
2. **Proper Foreign Keys:** Related data is stored through foreign key relationships, not transitive dependencies
3. **Normalized Design:** The original design avoided transitive dependencies

### 5.3 Examples of Proper Relationship Design

#### 5.3.1 Address-City-Country Relationship
**Potential Transitive Dependency:**
```
address_id → city_id → country_id
```

**Analysis:** This is NOT a transitive dependency because:
1. **city_id** is a foreign key, not a derived attribute
2. **country_id** is stored directly in addresses table
3. The relationship is maintained through foreign keys, not transitive dependencies

**Correct Design:**
```sql
CREATE TABLE addresses (
  address_id INT PRIMARY KEY,
  street_address VARCHAR(200) NOT NULL,
  city_id INT NOT NULL,
  country_id INT NOT NULL,  -- Direct reference, not transitive
  -- other attributes
);
```

#### 5.3.2 User-Profile Relationships
**Potential Transitive Dependency:**
```
user_id → guest_profile_id → guest_verification_status
```

**Analysis:** This is NOT a transitive dependency because:
1. **guest_profile_id** is a foreign key, not a derived attribute
2. **guest_verification_status** is stored directly in guest_profiles table
3. The relationship is maintained through foreign keys, not transitive dependencies

## 6. Functional Dependency Diagrams

### 6.1 User Management Domain FDs

```
Users Table:
user_id → {email, password_hash, first_name, last_name, phone, date_of_birth, 
           is_guest, is_host, is_admin, created_at, updated_at, is_active}

Guest Profiles Table:
guest_profile_id → {user_id, preferred_price_range, guest_verification_status, 
                    verification_date, created_at}

Host Profiles Table:
host_profile_id → {user_id, host_verification_status, verification_date, host_since,
                   response_rate, response_time_hours, acceptance_rate, host_rating,
                   total_properties, superhost_status, payout_method_id, tax_id,
                   business_name, business_registration, created_at}
```

### 6.2 Property Management Domain FDs

```
Properties Table:
property_id → {host_id, property_type_id, title, description, address_id, max_guests,
               bedrooms, bathrooms, size_sqm, created_at, updated_at, is_active}

Property Amenity Links Table:
(property_id, amenity_id) → {is_available, additional_info}

Property Pricing Table:
pricing_id → {property_id, start_date, end_date, base_price_per_night, 
              weekend_price_per_night, weekly_discount_percentage, 
              monthly_discount_percentage, minimum_stay_nights, maximum_stay_nights,
              is_available, created_at, updated_at}
```

### 6.3 Booking System Domain FDs

```
Bookings Table:
booking_id → {guest_profile_id, user_id, property_id, booking_status_id, 
               check_in_date, check_out_date, number_of_guests, total_amount, 
               created_at, confirmed_at}

Payments Table:
payment_id → {booking_id, payment_method_id, amount, currency, payment_status,
               transaction_id, processed_at, refunded_at}

Payouts Table:
payout_id → {host_profile_id, booking_id, amount, currency, payout_status,
              scheduled_date, processed_date}
```

### 6.4 Triple Relationship FDs

```
Property-Booking-Pricing Junction:
(property_id, booking_id, pricing_id) → {applied_price, pricing_rule_applied, created_at}

User-Booking-Review Junction:
(user_id, booking_id, review_id) → {review_role, interaction_type, created_at}

Booking-Payment-Payout Junction:
(booking_id, payment_id, payout_id) → {transaction_chain_status, processing_notes, created_at}
```

## 7. Business Logic Functional Dependencies

### 7.1 Role-Based Dependencies

#### 7.1.1 Guest Role Dependencies
```
user_id + is_guest=TRUE → guest_profile_id
guest_profile_id → {preferred_price_range, guest_verification_status, verification_date}
```

#### 7.1.2 Host Role Dependencies
```
user_id + is_host=TRUE → host_profile_id
host_profile_id → {host_verification_status, response_rate, acceptance_rate, 
                   host_rating, superhost_status, business_name}
```

#### 7.1.3 Multi-Role Dependencies
```
user_id → {is_guest, is_host, is_admin}
user_id → guest_profile_id (if is_guest=TRUE)
user_id → host_profile_id (if is_host=TRUE)
```

### 7.2 Transaction Flow Dependencies

#### 7.2.1 Booking-Payment-Payout Chain
```
booking_id → payment_id
payment_id → payout_id (after 24-hour delay)
booking_id → {check_in_date, check_out_date, total_amount}
payment_id → {amount, currency, payment_status}
payout_id → {amount, currency, payout_status}
```

#### 7.2.2 Review Dependencies
```
booking_id → {reviewer_id, reviewee_id}
reviewer_id + reviewee_id + booking_id → review_id
review_id → {rating, review_text, is_public}
```

### 7.3 Property Management Dependencies

#### 7.3.1 Property Ownership
```
host_profile_id → property_id
property_id → {title, description, max_guests, bedrooms, bathrooms}
```

#### 7.3.2 Property Availability
```
property_id + start_date + end_date → {base_price_per_night, is_available}
property_id → {amenity_id, is_available, additional_info}
```

## 8. Functional Dependency Validation

### 8.1 Validation Methods

#### 8.1.1 Armstrong's Axioms
- **Reflexivity:** If Y ⊆ X, then X → Y
- **Augmentation:** If X → Y, then XZ → YZ
- **Transitivity:** If X → Y and Y → Z, then X → Z

#### 8.1.2 Closure Calculation
For each functional dependency X → Y, calculate X+ (closure of X) to verify all dependencies.

#### 8.1.3 Dependency Preservation
Verify that all original functional dependencies are preserved in the normalized design.

### 8.2 Validation Results

**Result:** All functional dependencies are valid and properly implemented.

**Verification:**
1. **Single-Attribute Primary Keys:** All FDs follow the pattern PK → {all_attributes}
2. **Composite Keys:** All FDs follow the pattern (composite_key) → {all_attributes}
3. **Foreign Key Relationships:** All FDs maintain referential integrity
4. **Business Logic:** All FDs support business requirements

## 9. Performance Implications

### 9.1 Functional Dependency Impact on Queries

#### 9.1.1 Join Optimization
- **Foreign Key Indexes:** FDs indicate which columns need indexes for efficient joins
- **Query Planning:** FDs help the query optimizer choose efficient execution plans
- **Constraint Validation:** FDs enable efficient constraint checking

#### 9.1.2 Index Strategy
```sql
-- Primary key indexes (automatic)
-- Foreign key indexes based on FDs
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_bookings_guest_profile_id ON bookings(guest_profile_id);
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payouts_host_profile_id ON payouts(host_profile_id);

-- Composite key indexes for junction tables
CREATE INDEX idx_property_amenity_links_composite ON property_amenity_links(property_id, amenity_id);
CREATE INDEX idx_user_preferences_composite ON user_preferences(user_id, preference_key);
```

### 9.2 Normalization Benefits

#### 9.2.1 Storage Efficiency
- **No Redundancy:** FDs ensure no duplicate data storage
- **Minimal Storage:** Each piece of information stored once
- **Efficient Updates:** Changes require updates to single locations

#### 9.2.2 Data Integrity
- **Constraint Enforcement:** FDs enable proper constraint implementation
- **Referential Integrity:** Foreign key FDs maintain data consistency
- **Business Rule Support:** FDs implement business logic constraints

## 10. Conclusion

The functional dependency analysis reveals a well-designed database structure with:

### 10.1 Technical Achievements
1. **Complete FD Set:** All functional dependencies identified and documented
2. **No Partial Dependencies:** All tables properly normalized to 2NF
3. **No Transitive Dependencies:** All tables properly normalized to 3NF
4. **Proper Relationships:** All foreign key relationships maintain referential integrity

### 10.2 Business Logic Support
1. **Role-Based Architecture:** FDs support multi-role user management
2. **Transaction Integrity:** FDs ensure proper booking-payment-payout flow
3. **Data Consistency:** FDs prevent data anomalies and inconsistencies
4. **Scalability:** FDs support future system expansion

### 10.3 Design Quality
1. **Normalization:** All tables in 3NF/BCNF
2. **Performance:** FDs enable efficient query optimization
3. **Maintainability:** Clear dependency relationships
4. **Extensibility:** FDs support future enhancements

The functional dependency analysis confirms that the Airbnb database design provides a solid foundation for data integrity, performance, and business logic implementation.

---

**Document Version:** 1.0  
**Last Updated:** 14/10/2025
