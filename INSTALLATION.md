# Installation Guide - Airbnb Database

**Last Updated:** 15/10/2025  
**Version:** 2.0.0  
**Author:** Nikolas Daniel Vincenti  
**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  

## Quick Start

### Prerequisites
- MySQL 8.0 or higher
- DBeaver (recommended) or MySQL Workbench
- Command line access to MySQL

### Installation Steps

#### Method 1: Command Line (Recommended)
```bash
# Connect to MySQL
mysql -u root -p

# Run the complete installation script
source /path/to/sql/phase2_submitted/Vincenti-Nikolas_9211929_DLBDSPBDM01_P2_S_CompleteInstallation.sql
```

#### Method 2: DBeaver GUI
1. **Open DBeaver** and connect to your MySQL server
2. **File → Open File** → Select `Vincenti-Nikolas_9211929_DLBDSPBDM01_P2_S_CompleteInstallation.sql`
3. **Execute the entire script** (Ctrl+A, then Ctrl+Enter)
4. **Verify installation** by checking the results panel

### Testing the Installation

#### Run Presentation Queries
```bash
# Run presentation queries to test database functionality
source /path/to/sql/phase2_submitted/Vincenti-Nikolas_9211929_DLBDSPBDM01_P2_S_PresentationQueries.sql
```

#### Verify Installation
```sql
-- Check database creation
SHOW DATABASES;

-- Check table creation
USE airbnb_database;
SHOW TABLES;

-- Check sample data
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM properties;
SELECT COUNT(*) FROM bookings;
```

## What's Included

### Database Structure
- **27 Entities** with comprehensive relationships
- **3 Triple Relationships** (many-to-many-to-many)
- **1 Recursive Relationship** (self-referencing)
- **89+ Constraints** enforcing business rules
- **Strategic Indexing** for performance optimization

### Sample Data
- **25+ Countries** with major cities
- **25+ Users** with guest and host profiles
- **20+ Properties** with amenities and photos
- **20+ Bookings** with complete transaction flow
- **20+ Reviews** with detailed ratings
- **20+ Messages** in conversation threads

### Business Rules Implemented
- User role management and verification
- Property listings with amenities
- Complete booking and payment flow
- Review system with ratings
- Geographic distribution
- Host performance metrics
- Communication system
- Financial transaction tracking

## Troubleshooting

### Common Issues

#### Database Creation Fails
- Ensure MySQL 8.0+ is running
- Check user privileges (CREATE, DROP, INSERT)
- Verify MySQL service is accessible

#### Constraint Violations
- The installation script includes bulletproof sample data
- All constraint conflicts have been resolved
- Script executes without errors

#### Connection Issues
- Verify MySQL server is running
- Check connection credentials
- Ensure proper network access

### Verification Queries

```sql
-- Check table counts
SELECT 
    TABLE_NAME,
    TABLE_ROWS
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'airbnb_database'
ORDER BY TABLE_ROWS DESC;

-- Check foreign key relationships
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'airbnb_database'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

## Support

For technical issues:
- Check MySQL error logs
- Verify constraint violations
- Ensure proper data types
- Check foreign key relationships

---

**Installation Complete**  
**Database Status:** Production Ready  
**Quality Level:** Industry Standard
