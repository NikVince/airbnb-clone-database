# Phase 2 Schema Refinement Documentation

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Design - Normalization and Constraints  
**Date:** 14/10/2025  
**Student:** Nikolas Daniel Vincenti

---

## 1. Introduction

This document provides a comprehensive analysis of the schema refinements made from Phase 1 to Phase 2 of the Airbnb database design project. The refinements address critical feedback received during Phase 1 evaluation and implement a robust role-based architecture that supports the complex multi-role nature of the Airbnb platform.

## 2. Phase 1 Feedback Analysis

### 2.1 Critical Issues Identified

#### Issue 1: Missing Role Specifications
**Problem:** The original Phase 1 design lacked explicit role definitions and role-based user management.  
**Impact:** Users could not be distinguished as guests, hosts, or administrators, making the system unsuitable for a real-world Airbnb platform.  
**Business Impact:** No support for multi-role users, unclear permission management, and inability to track role-specific metrics.

#### Issue 2: No Guest/Host Distinction
**Problem:** Single users table with no role distinction or role-specific attributes.  
**Impact:** All users treated identically regardless of their platform role, preventing proper business logic implementation.  
**Business Impact:** No way to track guest preferences, host performance metrics, or role-specific verification processes.

### 2.2 Feedback Response Strategy

The schema refinement implements a comprehensive role-based architecture that:
- Separates role-specific attributes into dedicated profile tables
- Maintains multi-role support for users
- Provides clear business logic separation
- Enables efficient role-based querying
- Supports future role expansion

## 3. Schema Refinement Changes

### 3.1 Enhanced Users Table

#### Original Structure (Phase 1)
```sql
Table users {
  user_id int [pk, increment]
  email varchar(255) [unique, not null]
  password_hash varchar(255) [not null]
  first_name varchar(100) [not null]
  last_name varchar(100) [not null]
  phone varchar(20) [unique, not null]
  date_of_birth date
  created_at datetime [not null]
  updated_at datetime [not null]
  is_active boolean [default: true]
}
```

#### Refined Structure (Phase 2)
```sql
Table users {
  user_id int [pk, increment]
  email varchar(255) [unique, not null]
  password_hash varchar(255) [not null]
  first_name varchar(100) [not null]
  last_name varchar(100) [not null]
  phone varchar(20) [unique, not null]
  date_of_birth date
  // ROLE TRACKING FLAGS (NEW)
  is_guest boolean [default: true]
  is_host boolean [default: false]
  is_admin boolean [default: false]
  created_at datetime [not null]
  updated_at datetime [not null]
  is_active boolean [default: true]
}
```

#### Justification for Changes
- **Role Tracking Flags:** Enable system to track which roles a user currently holds
- **Default Guest Role:** New users automatically become guests, supporting the platform's guest-first approach
- **Multi-Role Support:** Users can simultaneously hold multiple roles (guest + host)
- **Permission Management:** Role flags enable role-based access control

### 3.2 New Entity: guest_profiles

#### Purpose
Store guest-specific attributes and preferences that are not relevant to other user roles.

#### Structure
```sql
Table guest_profiles {
  guest_profile_id int [pk, increment]
  user_id int [not null, unique] // 1:1 relationship with users
  preferred_price_range varchar(50)
  preferred_property_types json
  travel_preferences json
  guest_verification_status varchar(20) [default: 'unverified']
  verification_date datetime
  created_at datetime [not null]
}
```

#### Business Logic
- **Automatic Creation:** Guest profiles created automatically on first booking attempt
- **Verification Tracking:** Separate verification status for guest-specific requirements
- **Preference Storage:** JSON fields for flexible preference storage
- **1:1 Relationship:** Each user can have at most one guest profile

#### Impact Analysis
- **Query Efficiency:** Guest-specific queries can target this table directly
- **Data Integrity:** Guest attributes isolated from host attributes
- **Scalability:** Easy to add new guest-specific attributes without affecting other roles

### 3.3 New Entity: host_profiles

#### Purpose
Store host-specific attributes, performance metrics, and business information.

#### Structure
```sql
Table host_profiles {
  host_profile_id int [pk, increment]
  user_id int [not null, unique] // 1:1 relationship with users
  host_verification_status varchar(20) [default: 'pending']
  verification_date datetime
  host_since datetime
  response_rate decimal(5,2) [default: 0.00]
  response_time_hours int
  acceptance_rate decimal(5,2) [default: 0.00]
  host_rating decimal(3,2)
  total_properties int [default: 0]
  superhost_status boolean [default: false]
  payout_method_id int // FK to payment_methods
  tax_id varchar(50) // ENCRYPTED
  business_name varchar(255)
  business_registration varchar(100)
  created_at datetime [not null]
}
```

#### Business Logic
- **Manual Creation:** Host profiles created when user applies to become host
- **Performance Tracking:** Response rates, acceptance rates, and ratings
- **Business Information:** Tax ID, business registration for commercial hosts
- **Superhost Status:** Platform recognition for high-performing hosts

#### Impact Analysis
- **Performance Metrics:** Centralized location for all host performance data
- **Business Compliance:** Tax and business information properly isolated
- **Host Management:** Easy to query and manage host-specific operations

### 3.4 Updated Relationship Mappings

#### Properties Entity
**Before (Phase 1):**
```sql
host_id int [not null] // References users.user_id
```

**After (Phase 2):**
```sql
host_id int [not null] // References host_profiles.host_profile_id
```

**Justification:** Properties should be owned by host profiles, not generic users. This ensures only verified hosts can list properties and provides clear business logic separation.

#### Bookings Entity
**Before (Phase 1):**
```sql
guest_id int [not null] // References users.user_id
```

**After (Phase 2):**
```sql
guest_profile_id int [not null] // References guest_profiles.guest_profile_id
user_id int [not null] // For audit trail and authentication
```

**Justification:** Bookings should reference guest profiles for role-specific attributes while maintaining user_id for audit trail and authentication purposes.

#### Payouts Entity
**Before (Phase 1):**
```sql
host_id int [not null] // References users.user_id
```

**After (Phase 2):**
```sql
host_profile_id int [not null] // References host_profiles.host_profile_id
```

**Justification:** Payouts should reference host profiles to ensure proper business logic and enable host-specific payout management.

## 4. Entity Count and Relationship Updates

### 4.1 Entity Count Changes
- **Phase 1:** 25 entities
- **Phase 2:** 27 entities (+2 new entities)
- **Triple Relationships:** 3 (maintained)
- **Recursive Relationships:** 1 (maintained)

### 4.2 New Entities Added
1. **guest_profiles** - Guest-specific attributes and preferences
2. **host_profiles** - Host-specific attributes and performance metrics

### 4.3 Relationship Updates
- **Properties → Hosts:** Now references host_profiles instead of users
- **Bookings → Guests:** Now references guest_profiles with user_id audit trail
- **Payouts → Hosts:** Now references host_profiles instead of users

## 5. Business Logic Improvements

### 5.1 Multi-Role Support Implementation

#### User Role Transitions
1. **New User Registration:** Default to guest role (is_guest = TRUE)
2. **First Booking:** Auto-create guest profile
3. **Host Application:** Create host profile, set is_host = TRUE
4. **Role Management:** Users can hold multiple roles simultaneously

#### Context Awareness
- **Property Operations:** Require host profile and is_host = TRUE
- **Booking Operations:** Require guest profile and is_guest = TRUE
- **Administrative Operations:** Require is_admin = TRUE

### 5.2 Data Integrity Enhancements

#### Profile Consistency Rules
- Guest profiles created automatically on first booking
- Host profiles created when user applies to become host
- Role flags must be consistent with profile existence
- Users cannot perform role-specific actions without appropriate profiles

#### Business Rule Enforcement
- Properties can only be created by users with host profiles
- Bookings can only be made by users with guest profiles
- Payouts only processed to users with host profiles
- Reviews require appropriate role context

## 6. Performance and Scalability Considerations

### 6.1 Query Optimization
- **Role-Specific Queries:** Can target appropriate profile tables
- **Index Strategy:** Indexes on role tables for efficient role-based queries
- **Join Optimization:** Clear foreign key relationships enable efficient joins

### 6.2 Scalability Benefits
- **Modular Architecture:** Easy to add new role-specific attributes
- **Role Expansion:** Simple to add new roles (e.g., property managers)
- **Attribute Isolation:** Role-specific changes don't affect other roles

### 6.3 Maintenance Benefits
- **Clear Separation:** Role logic isolated in dedicated tables
- **Business Logic Clarity:** Property ownership and booking actions clearly defined
- **Audit Trail:** User_id maintained for authentication and audit purposes

## 7. Implementation Strategy

### 7.1 Profile Creation Flow
1. **User Registration:** Create user with default guest role
2. **First Booking Attempt:** Auto-create guest profile
3. **Host Application:** Create host profile, update role flags
4. **Role Transitions:** Update role flags when profiles are created/deleted

### 7.2 Data Migration Considerations
- **Existing Users:** Need to create appropriate profiles based on current role
- **Role Flag Updates:** Ensure consistency between flags and profile existence
- **Foreign Key Updates:** Update all references to use new profile tables

### 7.3 Validation Rules
- **Profile Consistency:** Role flags must match profile existence
- **Business Logic:** Role-specific operations require appropriate profiles
- **Data Integrity:** All foreign keys must reference existing records

## 8. Impact Analysis

### 8.1 Positive Impacts
- **Clear Role Separation:** Guest and host logic properly isolated
- **Multi-Role Support:** Users can simultaneously act as guests and hosts
- **Business Logic Clarity:** Property ownership and booking actions explicitly defined
- **Scalability:** Easy to add new roles and role-specific attributes
- **Query Efficiency:** Role-specific queries can target appropriate tables

### 8.2 Considerations
- **Data Migration:** Existing data needs to be migrated to new structure
- **Application Updates:** Application code needs to be updated for new relationships
- **Training:** Users need to understand new role-based workflow

### 8.3 Future Enhancements
- **Property Manager Role:** Easy to add as new profile table
- **Role Permissions:** Can implement fine-grained permission system
- **Analytics:** Role-specific metrics and reporting capabilities

## 9. Conclusion

The schema refinements implemented in Phase 2 address all critical issues identified in Phase 1 feedback while maintaining the core functionality and relationships of the original design. The role-based architecture provides:

1. **Clear Business Logic Separation:** Guest and host operations are properly isolated
2. **Multi-Role Support:** Users can simultaneously act as guests and hosts
3. **Scalable Design:** Easy to add new roles and role-specific attributes
4. **Performance Optimization:** Role-specific queries can target appropriate tables
5. **Data Integrity:** Proper foreign key relationships and business rule enforcement

These refinements transform the database from a basic user-property-booking system into a sophisticated, role-aware platform that can support the complex business requirements of a real-world Airbnb-like service.

---

**Document Version:** 1.0  
**Last Updated:** 14/10/2025
