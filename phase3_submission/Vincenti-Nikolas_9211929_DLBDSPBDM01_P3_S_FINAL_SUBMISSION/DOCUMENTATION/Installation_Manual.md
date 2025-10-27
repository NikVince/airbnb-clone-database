# Installation Manual - Airbnb Clone Database

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Student:** Nikolas Daniel Vincenti (9211929)  
**Date:** 27/10/2025

## Overview

This installation manual provides step-by-step instructions for setting up and testing the Airbnb Clone Database system. The database has been developed across three phases, with each phase building upon the previous one.

## Prerequisites

### Database Management System
- **MySQL 8.0+**
- **phpMyAdmin** (optional, for GUI management)
- **MySQL Workbench** (recommended for advanced users)

### System Requirements
- Minimum 4GB RAM
- 2GB free disk space
- Internet connection for initial setup

## Installation Process

### Phase 1: Database Conception
**Files:** `01_PHASE1_DELIVERABLES/`

1. **Review ER Model Design**
   - Open `docs/phase1_er_model_design.md`
   - Review `diagrams/phase1_ER_Diagram.pdf`
   - Understand entity relationships and business rules

2. **Data Dictionary Review**
   - Examine `docs/phase1_data_dictionary.md`
   - Understand entity attributes and constraints

### Phase 2: Database Design and Normalization
**Files:** `02_PHASE2_DELIVERABLES/`

1. **Install Initial Database Schema**
   ```sql
   -- Run the Phase 2 installation script
   SOURCE SQL_FILES/phase2/P2_Installation.sql;
   ```

2. **Test Basic Queries**
   ```sql
   -- Run presentation queries
   SOURCE SQL_FILES/phase2/P2_PresentationQueries.sql;
   ```

3. **Review Design Documentation**
   - Check normalization process in `docs/phase2_normalization.md`
   - Review constraints in `docs/phase2_constraints.md`
   - Examine functional dependencies in `docs/phase2_functional_dependencies.md`

### Phase 3: Enhanced Implementation and Testing
**Files:** `03_PHASE3_DELIVERABLES/`

1. **Install Enhanced Database Schema**
   ```sql
   -- Run the enhanced Phase 3 installation script
   SOURCE SQL_FILES/phase3/P3_EnhancedInstallation.sql;
   ```

2. **Collect Database Metadata**
   ```sql
   -- Run metadata collection script
   SOURCE SQL_FILES/phase3/P3_MetadataCollection.sql;
   ```

3. **Execute Test Queries**
   ```sql
   -- Run comprehensive test queries
   SOURCE SQL_FILES/phase3/P3_TestQueries.sql;
   ```

4. **Review Results**
   - Review metadata CSV files in `metadata/` directory
   - Examine updated data dictionary in `docs/PHASE3_UPDATED_DATA_DICTIONARY.md`

## Database Schema Overview

### Core Entities (20+ entities)
- **User Management:** users, user_profiles, user_addresses, user_verification
- **Property Management:** properties, property_types, property_amenities, property_photos, property_rules
- **Booking System:** bookings, booking_status, cancellation_policies, cancellation_requests
- **Financial:** payments, payment_methods, payouts, refunds, service_fees, taxes
- **Communication:** messages, conversations, notifications
- **Location:** addresses, cities, countries, neighborhoods
- **Reviews:** reviews, review_responses

### Key Features
- **Normalized Design:** 3NF compliance with proper functional dependencies
- **Data Integrity:** Comprehensive foreign key constraints and check constraints
- **Business Rules:** Enforced through database constraints
- **Scalability:** Designed for high-volume Airbnb-like operations

## Testing Procedures

### 1. Schema Validation
```sql
-- Verify all tables exist
SHOW TABLES;

-- Check foreign key relationships
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE REFERENCED_TABLE_SCHEMA = 'airbnb_clone_db';
```

### 2. Data Integrity Testing
```sql
-- Test constraint violations
INSERT INTO bookings (booking_id, property_id, guest_id, check_in_date, check_out_date)
VALUES (999999, 1, 1, '2025-12-31', '2025-12-30'); -- Should fail: check_out before check_in

-- Test foreign key constraints
INSERT INTO bookings (booking_id, property_id, guest_id, check_in_date, check_out_date)
VALUES (999998, 999999, 1, '2025-12-01', '2025-12-02'); -- Should fail: invalid property_id
```

### 3. Performance Testing
```sql
-- Test complex queries with JOINs
SELECT 
    p.property_name,
    COUNT(b.booking_id) as total_bookings,
    AVG(r.rating) as avg_rating
FROM properties p
LEFT JOIN bookings b ON p.property_id = b.property_id
LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY p.property_id, p.property_name
ORDER BY total_bookings DESC;
```

## Troubleshooting

### Common Issues

1. **Foreign Key Constraint Errors**
   - Ensure parent records exist before inserting child records
   - Check data types match between foreign and primary keys

2. **Check Constraint Violations**
   - Verify date ranges (check_out > check_in)
   - Ensure rating values are within valid ranges (1-5)
   - Check email format compliance

3. **Performance Issues**
   - Ensure indexes are created on frequently queried columns
   - Use EXPLAIN to analyze query execution plans

### Error Codes
- **1452:** Foreign key constraint fails
- **1062:** Duplicate entry for unique key
- **3819:** Check constraint violation

## Verification Checklist

- [ ] All 20+ entities created successfully
- [ ] Foreign key relationships established
- [ ] Check constraints working properly
- [ ] Sample data inserted correctly
- [ ] Test queries execute without errors
- [ ] Metadata collection script runs successfully
- [ ] Screenshots captured for all test cases
- [ ] CSV metadata files generated

## Support

For technical issues or questions:
- Review the comprehensive documentation in `05_COMPREHENSIVE_RESULTS/`
- Check the data dictionary for entity definitions
- Examine the ER diagrams for relationship understanding
- Refer to the phase-specific documentation for detailed explanations

## File Structure Reference

```
FINAL_SUBMISSION_STREAMLINED/
├── SQL_FILES/                  # All SQL scripts organized by phase
│   ├── phase2/                 # Phase 2 implementation files
│   └── phase3/                 # Phase 3 enhanced files
├── DOCUMENTATION/              # Installation manual and data dictionary
├── metadata/                   # Database analysis CSV files
└── README.md                   # Submission overview
```

---

**Last Updated:** 27/10/2025  
**Version:** 1.0  
**Status:** Ready for Submission
