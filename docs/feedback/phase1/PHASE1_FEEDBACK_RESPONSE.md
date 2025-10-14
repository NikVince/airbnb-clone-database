# Phase 1 Feedback Response

**Course:** DLBDSPBDM01 - Build a Data Mart in SQL  
**Student:** Nikolas Daniel Vincenti  
**Submission:** Phase 1 - Conception Phase  
**Date Received:** October 14, 2025  
**Date Addressed:** October 14, 2025

---

## Tutor Feedback Summary

**Overall Assessment:** Good submission with two critical issues requiring correction.

**Feedback Received:**
> "Hi Niklas, Overall good submission. However, there are a couple of issues to fix:
> 1. You are required to specify the different roles in the conception phase and you did not.
> 2. Your design shows no distinction between the users who are guests and/or hosts, which is fundamental to the business logic.
> Please fix these two issues in the next phase."

---

## Issue 1: Missing Role Specifications in Conception Phase

### Problem Identified
The conception phase documentation did not explicitly define and describe the different user roles in the system, despite the roles being fundamental to understanding the platform's functionality.

### Root Cause Analysis
While the requirements specification file (`phase1_requirements_specification.md`) contained information about different user actions, it failed to:
- Explicitly define each role with clear descriptions
- Outline role-specific responsibilities and permissions
- Explain the relationships between roles
- Emphasize that users can hold multiple roles simultaneously

### Solution Implemented
Added a comprehensive "User Roles and Responsibilities" section to `phase1_requirements_specification.md` that includes:

#### **1. Guest Role**
- **Description:** Users who search for, book, and stay at properties
- **Key Responsibilities:**
  - Search and filter available properties
  - Make bookings and payments
  - Communicate with hosts
  - Leave reviews after stays
  - Manage personal profile and preferences
- **Business Logic:** Any registered user with email verification can act as a guest

#### **2. Host Role**
- **Description:** Users who list and manage rental properties on the platform
- **Key Responsibilities:**
  - Create and manage property listings
  - Set pricing and availability
  - Respond to booking requests
  - Communicate with guests
  - Manage payouts and financial information
  - Maintain property standards
- **Business Logic:** Requires enhanced verification including identity and property ownership validation

#### **3. Administrator Role**
- **Description:** Platform staff with system-wide management capabilities
- **Key Responsibilities:**
  - User account management and dispute resolution
  - Content moderation and policy enforcement
  - System configuration and monitoring
  - Financial oversight and reporting
  - Security and compliance management
- **Access Level:** Full system access with audit trail

#### **4. Property Manager Role**
- **Description:** Professional managers who operate properties on behalf of hosts
- **Key Responsibilities:**
  - Manage multiple properties under delegated authority
  - Handle guest communications and check-ins
  - Coordinate maintenance and cleaning
  - Report to property owners
- **Business Logic:** Linked to host accounts with delegated permissions

### Multi-Role Support
**Critical Design Decision:** Users can hold multiple roles simultaneously. For example:
- A user can list properties as a **Host** while also booking other properties as a **Guest**
- This is common behavior in the Airbnb platform and must be supported by the database design

### Files Modified
- ✅ `phase1_requirements_specification.md` - Added Section 2: "User Roles and Responsibilities"
- ✅ `phase1_summary.md` - Added reference to role-based design approach

---

## Issue 2: No Distinction Between Guest and Host Users

### Problem Identified
The database design featured a single `users` table with no mechanism to distinguish between guests and hosts, which is problematic because:
1. Guests and hosts have fundamentally different attributes and business requirements
2. The same user can act as both guest and host
3. Business logic needs to know which role a user is performing in any given transaction
4. Queries and relationships were ambiguous about role context

### Original Design (Problematic)

```
users
├── user_id (PK)
├── email
├── password_hash
├── full_name
├── phone_number
└── ... (common attributes)

properties
├── property_id (PK)
├── host_id (FK → users.user_id)  ❌ Ambiguous: Which users are hosts?
└── ...

bookings
├── booking_id (PK)
├── guest_id (FK → users.user_id)  ❌ Ambiguous: Which users are guests?
├── property_id (FK)
└── ...
```

**Problems:**
- ❌ No way to identify if a user is a guest, host, or both
- ❌ Host-specific attributes (verification status, payout info, response time) mixed with general user data
- ❌ Guest-specific attributes (travel preferences, verification) not captured
- ❌ Impossible to query "all hosts" or "all guests" efficiently
- ❌ No clear business logic separation

### Solution Implemented: Hybrid Role-Based Design

#### **Architecture Overview**
Implemented a three-table structure that:
1. Maintains a base `users` table for common authentication and profile data
2. Creates role-specific profile tables for guests and hosts
3. Uses boolean flags for role tracking while maintaining separate profiles

#### **1. Enhanced Users Table**

```sql
users (
  -- Primary identification
  user_id INT PK AUTO_INCREMENT
  email VARCHAR(255) UNIQUE NOT NULL
  password_hash VARCHAR(255) NOT NULL
  
  -- Profile information
  full_name VARCHAR(255) NOT NULL
  phone_number VARCHAR(20) UNIQUE
  date_of_birth DATE
  
  -- Role tracking (NEW)
  is_guest BOOLEAN DEFAULT TRUE
  is_host BOOLEAN DEFAULT FALSE
  is_admin BOOLEAN DEFAULT FALSE
  
  -- Status and metadata
  account_status ENUM('active', 'suspended', 'deleted')
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  last_login DATETIME
)
```

**Key Changes:**
- ✅ Added `is_guest`, `is_host`, `is_admin` boolean flags for role tracking
- ✅ Allows users to have multiple roles (both flags can be TRUE)
- ✅ Default new users to guest role
- ✅ Maintains all common attributes in base table

#### **2. New Entity: Guest Profiles**

```sql
guest_profiles (
  -- Primary key
  guest_profile_id INT PK AUTO_INCREMENT
  
  -- Relationship to users (1:1)
  user_id INT FK → users.user_id UNIQUE NOT NULL
  
  -- Guest-specific preferences
  preferred_price_range VARCHAR(50)
  preferred_property_types JSON
  travel_preferences JSON
  
  -- Guest verification
  guest_verification_status ENUM(
    'unverified',
    'email_verified', 
    'phone_verified',
    'id_verified',
    'fully_verified'
  ) DEFAULT 'unverified'
  verification_date DATETIME
  
  -- Metadata
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  
  -- Indexes
  INDEX idx_user_id (user_id)
  INDEX idx_verification_status (guest_verification_status)
)
```

**Purpose:**
- Stores guest-specific attributes (travel preferences, verification level)
- Created automatically when user makes first booking
- One-to-one relationship with users table
- Allows efficient querying of all active guests

#### **3. New Entity: Host Profiles**

```sql
host_profiles (
  -- Primary key
  host_profile_id INT PK AUTO_INCREMENT
  
  -- Relationship to users (1:1)
  user_id INT FK → users.user_id UNIQUE NOT NULL
  
  -- Host verification
  host_verification_status ENUM(
    'pending',
    'verified', 
    'rejected',
    'suspended'
  ) DEFAULT 'pending'
  verification_date DATETIME
  host_since DATETIME
  
  -- Host performance metrics
  response_rate DECIMAL(5,2) DEFAULT 0.00
  response_time_hours INT
  acceptance_rate DECIMAL(5,2) DEFAULT 0.00
  host_rating DECIMAL(3,2)
  total_properties INT DEFAULT 0
  superhost_status BOOLEAN DEFAULT FALSE
  
  -- Host financial information
  payout_method_id INT FK → payment_methods.payment_method_id
  tax_id VARCHAR(50) ENCRYPTED
  business_name VARCHAR(255)
  business_registration VARCHAR(100)
  
  -- Metadata
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  
  -- Indexes
  INDEX idx_user_id (user_id)
  INDEX idx_verification_status (host_verification_status)
  INDEX idx_superhost (superhost_status)
)
```

**Purpose:**
- Stores host-specific attributes (verification, performance metrics, payout info)
- Created when user applies to become a host
- One-to-one relationship with users table
- Enables host dashboard queries and analytics

#### **4. Updated Relationships**

**Properties Entity:**
```sql
properties (
  property_id INT PK
  host_id INT FK → host_profiles.host_profile_id  ✅ Now explicitly links to host profile
  ...
)
```
**Cardinality:** One host profile can own many properties (1:N)

**Bookings Entity:**
```sql
bookings (
  booking_id INT PK
  guest_profile_id INT FK → guest_profiles.guest_profile_id  ✅ Explicitly links to guest profile
  user_id INT FK → users.user_id  ✅ Kept for audit trail and authentication
  property_id INT FK → properties.property_id
  ...
)
```
**Cardinality:** 
- One guest profile can make many bookings (1:N)
- One user can make many bookings (1:N) - for audit purposes

### Revised Entity Relationship Model

#### **Before (27 entities):**
```
users (generic, no role distinction)
├── properties
├── bookings
└── reviews
```

#### **After (29 entities):**
```
users (base authentication & profile)
├── guest_profiles (1:1) ─┬─ bookings (1:N)
│                          └─ reviews (1:N) 
└── host_profiles (1:1) ───── properties (1:N) ─── bookings (1:N)
```

**Entity Count Update:** 27 → 29 entities (added guest_profiles and host_profiles)

### Design Rationale

**Why This Approach?**

1. **Clear Separation of Concerns**
   - Guest logic isolated to guest-specific tables
   - Host logic isolated to host-specific tables
   - Common authentication remains in base users table

2. **Multi-Role Support**
   - Users can be both guests AND hosts
   - Each role has its own profile with relevant attributes
   - No data duplication or conflicts

3. **Efficient Querying**
   ```sql
   -- Find all active hosts
   SELECT * FROM host_profiles 
   WHERE host_verification_status = 'verified';
   
   -- Find all superhosts
   SELECT u.*, h.* FROM users u
   JOIN host_profiles h ON u.user_id = h.user_id
   WHERE h.superhost_status = TRUE;
   
   -- Find guests who haven't verified email
   SELECT u.*, g.* FROM users u
   JOIN guest_profiles g ON u.user_id = g.user_id
   WHERE g.guest_verification_status = 'unverified';
   ```

4. **Scalability**
   - Easy to add new role-specific attributes without polluting users table
   - Clear foreign key relationships make queries explicit
   - Indexes on role tables optimize role-specific queries

5. **Business Logic Clarity**
   - Property ownership explicitly tied to host_profiles
   - Booking actions explicitly tied to guest_profiles
   - Audit trail maintained through users table

### Technical Implementation Details

**Profile Creation Flow:**

1. **New User Registration**
   ```sql
   INSERT INTO users (email, password_hash, is_guest) 
   VALUES ('user@example.com', 'hash', TRUE);
   ```

2. **First Booking (Auto-creates guest profile)**
   ```sql
   INSERT INTO guest_profiles (user_id) 
   VALUES (NEW.user_id);
   ```

3. **Becoming a Host (Manual application)**
   ```sql
   -- User applies to be host
   INSERT INTO host_profiles (user_id, host_verification_status)
   VALUES (user_id, 'pending');
   
   -- After verification
   UPDATE users SET is_host = TRUE WHERE user_id = user_id;
   UPDATE host_profiles SET host_verification_status = 'verified' 
   WHERE user_id = user_id;
   ```

**Query Examples:**

```sql
-- Find user acting as both guest and host
SELECT u.*, g.guest_verification_status, h.host_verification_status
FROM users u
LEFT JOIN guest_profiles g ON u.user_id = g.user_id
LEFT JOIN host_profiles h ON u.user_id = h.user_id
WHERE u.is_guest = TRUE AND u.is_host = TRUE;

-- Get all properties owned by a specific user (as host)
SELECT p.*
FROM properties p
JOIN host_profiles h ON p.host_id = h.host_profile_id
WHERE h.user_id = ?;

-- Get all bookings made by a specific user (as guest)
SELECT b.*
FROM bookings b
JOIN guest_profiles g ON b.guest_profile_id = g.guest_profile_id
WHERE g.user_id = ?;
```

### Files Modified

- ✅ `phase1_er_model_design.md` - Added guest_profiles and host_profiles entities
- ✅ `phase1_er_model_design.md` - Updated users entity with role flags
- ✅ `phase1_er_model_design.md` - Updated properties and bookings relationships
- ✅ `phase1_er_model_design.md` - Added design rationale section
- ✅ `phase1_summary.md` - Added paragraph on role distinction

---

## Impact on Other Entities

### Reviews Entity
The reviews entity now benefits from clearer role context:

```sql
reviews (
  review_id INT PK
  reviewer_id INT FK → users.user_id
  reviewee_id INT FK → users.user_id
  booking_id INT FK → bookings.booking_id
  reviewer_role ENUM('guest', 'host')  -- NEW: Explicit role tracking
  ...
)
```

This clarifies whether a review is from a guest reviewing a host/property or a host reviewing a guest.

### Triple Relationships
The three required triple relationships remain intact but are now clearer:

1. **Property-Booking-Payment**
   - property → host_profile → user (clear ownership chain)
   
2. **User-Booking-Review**
   - Explicitly tracks which role (guest/host) is performing the action
   
3. **Booking-Payment-Payout**
   - Payment from guest_profile
   - Payout to host_profile via host's payment method

---

## Validation and Testing Considerations

### Data Integrity Checks
1. ✅ A user cannot create a host_profile without email verification
2. ✅ A user cannot list a property without a verified host_profile
3. ✅ A user cannot make a booking without at least email verification
4. ✅ guest_profiles.user_id must reference an active user
5. ✅ host_profiles.user_id must reference an active user
6. ✅ No orphaned profiles (cascading deletes configured)

### Business Logic Validation
1. ✅ Users can transition from guest-only to guest+host
2. ✅ Host verification is independent of guest verification
3. ✅ Hosts can also book properties (as guests)
4. ✅ Performance metrics calculated only for host_profiles
5. ✅ Payout methods linked only to host_profiles

---

## Phase 2 Implementation Plan

### Database Schema Changes
1. Execute DDL statements to create guest_profiles table
2. Execute DDL statements to create host_profiles table
3. Migrate existing users data to appropriate profile tables
4. Update foreign keys in properties and bookings tables
5. Add indexes for performance optimization

### Documentation Updates
1. Update all ER diagrams to reflect new entities
2. Update data dictionary with new table definitions
3. Create migration scripts for existing data
4. Document the profile creation workflow

### SQL Implementation
Will be demonstrated in Phase 2 with:
- Complete CREATE TABLE statements
- Sample INSERT statements for all roles
- Example queries demonstrating role-based operations
- Performance benchmarks for role-specific queries

---

## Lessons Learned

### What Worked Well
- ✅ Comprehensive initial entity design (27 entities)
- ✅ Clear documentation structure
- ✅ Thorough requirement analysis

### Areas for Improvement
- ⚠️ Should have made role distinctions explicit in conception phase
- ⚠️ Role-based design patterns should have been documented earlier
- ⚠️ User stories could have better highlighted multi-role scenarios

### Process Improvements
Going forward, for Phase 2 and Phase 3:
1. Make all business logic assumptions explicit in documentation
2. Include role-based access control (RBAC) considerations from the start
3. Document multi-role scenarios with concrete examples
4. Create visual diagrams showing role relationships

---

## References

### Modified Documentation Files
1. `phase1_requirements_specification.md` - Added role definitions
2. `phase1_er_model_design.md` - Added profile entities and updated relationships
3. `phase1_summary.md` - Added role-based design notes

### Supporting Documentation
1. Assignment requirements: `Assignments Portfolio_DLBDSPBDM01.pdf`
2. Chen notation reference: Used throughout ER diagrams
3. Database normalization: All tables in 3NF or higher

---

## Conclusion

Both issues identified in the Phase 1 feedback have been comprehensively addressed:

**Issue 1 Resolution:** Added explicit role definitions with clear responsibilities, permissions, and relationships in the conception phase documentation.

**Issue 2 Resolution:** Implemented a robust hybrid role-based design with separate profile tables for guests and hosts, allowing users to hold multiple roles while maintaining clear business logic separation.

These changes strengthen the database design, improve query performance, and provide a solid foundation for implementing the Airbnb platform's core functionality in Phase 2.

The revised design now clearly distinguishes between guests and hosts while supporting the real-world scenario of users who act as both, which is fundamental to the Airbnb business model.

---

**Document Version:** 1.0  
**Last Updated:** October 14, 2025  
**Status:** Ready for Phase 2 Implementation
