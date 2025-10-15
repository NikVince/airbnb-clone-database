# Phase 1 Feedback Response Summary

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Student:** Nikolas Daniel Vincenti  
**Date:** October 14, 2025

---

## Issues Addressed

### Issue 1: Missing Role Specifications in Conception Phase
**Problem:** The conception phase documentation did not explicitly define and describe the different user roles in the system.

**Solution Implemented:**
- Added comprehensive "USER ROLES AND RESPONSIBILITIES" section to `phase1_requirements_specification.md`
- Defined four distinct roles: Guest, Host, Administrator, and Property Manager
- Specified key responsibilities, required permissions, and relationships for each role
- Emphasized multi-role support where users can hold multiple roles simultaneously

### Issue 2: No Distinction Between Guest and Host Users
**Problem:** The database design featured a single `users` table with no mechanism to distinguish between guests and hosts.

**Solution Implemented:**
- **Enhanced users table** with role tracking flags (is_guest, is_host, is_admin)
- **Added guest_profiles entity** for guest-specific attributes and preferences
- **Added host_profiles entity** for host-specific attributes and performance metrics
- **Updated relationships:**
  - Properties now reference host_profiles.host_profile_id
  - Bookings now reference guest_profiles.guest_profile_id
  - Maintained user_id in bookings for audit trail

## Design Changes Summary

### Entity Count Update
- **Before:** 25 entities
- **After:** 27 entities (added guest_profiles and host_profiles)

### New Entities Added

#### guest_profiles
- Stores guest-specific attributes (travel preferences, verification level)
- 1:1 relationship with users table
- Created automatically when user makes first booking

#### host_profiles  
- Stores host-specific attributes (verification, performance metrics, payout info)
- 1:1 relationship with users table
- Created when user applies to become host

### Updated Relationships
- **Properties → host_profiles:** Clear ownership chain
- **Bookings → guest_profiles:** Explicit guest context
- **Multi-role support:** Users can be both guests and hosts

## Files Modified

1. **`phase1_requirements_specification.md`**
   - Added Section 2: "USER ROLES AND RESPONSIBILITIES"
   - Defined all roles with responsibilities and permissions

2. **`phase1_er_model_design.md`**
   - Updated entity count from 25 to 27
   - Added guest_profiles and host_profiles entities
   - Updated users entity with role tracking flags
   - Modified properties and bookings relationships
   - Added design rationale section

3. **`phase1_summary.md`**
   - Updated entity count references
   - Added role-based architecture description
   - Added paragraph about feedback-driven improvements

## Business Logic Improvements

### Multi-Role Support
- Users can simultaneously act as guests (booking properties) and hosts (listing properties)
- Role-specific attributes stored in separate profile tables
- Context awareness for role-based operations
- Clear separation of guest and host business logic

### Query Efficiency
- Role-specific queries can target appropriate profile tables
- Clear foreign key relationships make queries explicit
- Indexes on role tables optimize role-specific queries

## Phase 2 Preparation

The updated design provides a solid foundation for Phase 2 implementation with:
- Clear role-based data model
- Explicit guest/host distinction
- Multi-role support architecture
- Scalable profile management system

---

**Status:** Ready for Phase 2 Implementation  
**All feedback issues addressed and documented**
