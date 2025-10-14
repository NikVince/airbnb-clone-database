# Phase 2 Schema Update Summary

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Student:** Nikolas Daniel Vincenti  
**Date:** October 14, 2025  
**Purpose:** Updated schema incorporating Phase 1 feedback

---

## Overview

This document summarizes the changes made to the database schema based on Phase 1 feedback. The original schema (`phase1_dbdiagram_schema.dbml`) is preserved as a backup, while the updated schema (`phase2_dbdiagram_schema.dbml`) incorporates all feedback-driven improvements.

## Issues Addressed

### Issue 1: Missing Role Specifications
**Problem:** No explicit role definitions in the conception phase  
**Solution:** Added comprehensive role tracking and profile separation

### Issue 2: No Guest/Host Distinction  
**Problem:** Single users table with no role distinction  
**Solution:** Implemented role-based architecture with separate profile tables

## Key Changes Implemented

### 1. Enhanced Users Table
**Added Role Tracking Flags:**
```sql
is_guest BOOLEAN DEFAULT TRUE
is_host BOOLEAN DEFAULT FALSE  
is_admin BOOLEAN DEFAULT FALSE
```

### 2. New Entity: guest_profiles
**Purpose:** Guest-specific attributes and preferences
**Key Features:**
- 1:1 relationship with users table
- Guest verification status tracking
- Travel preferences and property type preferences
- Created automatically on first booking

### 3. New Entity: host_profiles  
**Purpose:** Host-specific attributes and performance metrics
**Key Features:**
- 1:1 relationship with users table
- Host verification and performance tracking
- Superhost status and business information
- Payout method and tax information
- Created when user applies to become host

### 4. Updated Relationships

#### Properties Entity
- **Before:** `host_id` → `users.user_id`
- **After:** `host_id` → `host_profiles.host_profile_id`

#### Bookings Entity  
- **Before:** `guest_id` → `users.user_id`
- **After:** `guest_profile_id` → `guest_profiles.guest_profile_id`
- **Added:** `user_id` for audit trail

#### Payouts Entity
- **Before:** `host_id` → `users.user_id`  
- **After:** `host_profile_id` → `host_profiles.host_profile_id`

## Entity Count Update

- **Phase 1:** 25 entities
- **Phase 2:** 27 entities (+2 new entities)
- **Triple Relationships:** 3 (maintained)
- **Recursive Relationships:** 1 (maintained)

## Business Logic Improvements

### Multi-Role Support
- Users can simultaneously act as guests and hosts
- Role-specific attributes stored in separate profile tables
- Context awareness for role-based operations
- Clear separation of business logic

### Query Efficiency
- Role-specific queries can target appropriate profile tables
- Clear foreign key relationships make queries explicit
- Indexes on role tables optimize role-specific queries

### Scalability
- Easy to add new role-specific attributes
- Modular architecture supports future role additions
- Clear separation of concerns

## Design Benefits

1. **Clear Role Separation:** Guest and host logic isolated in separate tables
2. **Multi-Role Support:** Users can transition between roles or hold multiple roles
3. **Efficient Querying:** Role-specific queries target appropriate profile tables
4. **Business Logic Clarity:** Property ownership tied to host_profiles, booking actions tied to guest_profiles
5. **Audit Trail:** User_id maintained in bookings for authentication and audit purposes

## Implementation Strategy

### Profile Creation Flow
1. **New User Registration:** Default to guest role
2. **First Booking:** Auto-create guest profile
3. **Host Application:** Create host profile when user applies
4. **Role Transitions:** Update role flags when profiles are created

### Data Integrity
- Guest profiles created automatically on first booking
- Host profiles created when user applies to become host
- Role flags must be consistent with profile existence
- All foreign keys reference existing records

## Files Created

1. **`phase2_dbdiagram_schema.dbml`** - Updated DBML schema with all changes
2. **`SCHEMA_UPDATE_SUMMARY.md`** - This summary document

## Next Steps

The updated schema is ready for Phase 2 implementation:
- SQL DDL script generation
- Data population with test data
- Query development and testing
- Performance optimization

---

**Status:** Ready for Phase 2 Implementation  
**All Phase 1 feedback issues resolved and documented**
