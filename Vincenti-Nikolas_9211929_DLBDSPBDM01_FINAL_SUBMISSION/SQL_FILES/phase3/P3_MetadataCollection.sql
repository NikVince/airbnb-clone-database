-- ==============================================
-- Database Metadata Collection Script
-- Phase 3: Final Implementation - Metadata Analysis
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 24/10/2025
-- ==============================================

USE airbnb_database;

-- ==============================================
-- TABLE COUNT AND RECORD STATISTICS
-- ==============================================

-- 1. Table Count and Record Statistics
SELECT 
    'TABLE_COUNT' AS metric_type,
    COUNT(*) AS total_tables,
    'Total number of tables in the database' AS description
FROM information_schema.tables 
WHERE table_schema = 'airbnb_database' 
    AND table_type = 'BASE TABLE';

-- 2. Record Counts for All Tables
SELECT 
    'RECORD_COUNTS' AS metric_type,
    t.table_name,
    stats.table_rows AS estimated_rows,
    ROUND(((stats.data_length + stats.index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.tables t
LEFT JOIN (
    SELECT 
        table_name,
        table_rows,
        data_length,
        index_length
    FROM information_schema.tables 
    WHERE table_schema = 'airbnb_database'
) stats ON t.table_name = stats.table_name
WHERE t.table_schema = 'airbnb_database' 
    AND t.table_type = 'BASE TABLE'
ORDER BY t.table_name;

-- ==============================================
-- DETAILED RECORD COUNTS (EXACT)
-- ==============================================

-- 3. Exact Record Counts for All Tables
SELECT 'Users' AS table_name, COUNT(*) AS record_count FROM users
UNION ALL
SELECT 'Guest Profiles', COUNT(*) FROM guest_profiles
UNION ALL
SELECT 'Host Profiles', COUNT(*) FROM host_profiles
UNION ALL
SELECT 'User Profiles', COUNT(*) FROM user_profiles
UNION ALL
SELECT 'User Verification', COUNT(*) FROM user_verification
UNION ALL
SELECT 'User Preferences', COUNT(*) FROM user_preferences
UNION ALL
SELECT 'Countries', COUNT(*) FROM countries
UNION ALL
SELECT 'Cities', COUNT(*) FROM cities
UNION ALL
SELECT 'Addresses', COUNT(*) FROM addresses
UNION ALL
SELECT 'Property Types', COUNT(*) FROM property_types
UNION ALL
SELECT 'Property Amenities', COUNT(*) FROM property_amenities
UNION ALL
SELECT 'Properties', COUNT(*) FROM properties
UNION ALL
SELECT 'Property Amenity Links', COUNT(*) FROM property_amenity_links
UNION ALL
SELECT 'Property Photos', COUNT(*) FROM property_photos
UNION ALL
SELECT 'Property Pricing', COUNT(*) FROM property_pricing
UNION ALL
SELECT 'Booking Status', COUNT(*) FROM booking_status
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'Booking Modifications', COUNT(*) FROM booking_modifications
UNION ALL
SELECT 'Payment Methods', COUNT(*) FROM payment_methods
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Payouts', COUNT(*) FROM payouts
UNION ALL
SELECT 'Review Categories', COUNT(*) FROM review_categories
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Review Ratings', COUNT(*) FROM review_ratings
UNION ALL
SELECT 'Conversations', COUNT(*) FROM conversations
UNION ALL
SELECT 'Messages', COUNT(*) FROM messages
UNION ALL
SELECT 'Notifications', COUNT(*) FROM notifications
UNION ALL
SELECT 'Property Booking Pricing', COUNT(*) FROM property_booking_pricing
UNION ALL
SELECT 'User Booking Review', COUNT(*) FROM user_booking_review
UNION ALL
SELECT 'Booking Payment Payout', COUNT(*) FROM booking_payment_payout
ORDER BY record_count DESC;

-- ==============================================
-- DATABASE SIZE ANALYSIS
-- ==============================================

-- 4. Database Size Information
SELECT 
    'DATABASE_SIZE' AS metric_type,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS total_size_mb,
    ROUND(SUM(data_length) / 1024 / 1024, 2) AS data_size_mb,
    ROUND(SUM(index_length) / 1024 / 1024, 2) AS index_size_mb,
    COUNT(*) AS total_tables
FROM information_schema.tables 
WHERE table_schema = 'airbnb_database';

-- 5. Individual Table Sizes
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb,
    ROUND((data_length / 1024 / 1024), 2) AS data_mb,
    ROUND((index_length / 1024 / 1024), 2) AS index_mb,
    table_rows AS estimated_rows
FROM information_schema.tables 
WHERE table_schema = 'airbnb_database' 
    AND table_type = 'BASE TABLE'
ORDER BY (data_length + index_length) DESC;

-- ==============================================
-- CONSTRAINT AND RELATIONSHIP ANALYSIS
-- ==============================================

-- 6. Foreign Key Relationships Count
SELECT 
    'FOREIGN_KEYS' AS metric_type,
    COUNT(*) AS total_foreign_keys,
    'Total foreign key relationships' AS description
FROM information_schema.key_column_usage 
WHERE table_schema = 'airbnb_database' 
    AND referenced_table_name IS NOT NULL;

-- 7. Primary Keys Count
SELECT 
    'PRIMARY_KEYS' AS metric_type,
    COUNT(*) AS total_primary_keys,
    'Total primary key constraints' AS description
FROM information_schema.key_column_usage 
WHERE table_schema = 'airbnb_database' 
    AND constraint_name = 'PRIMARY';

-- 8. Unique Constraints Count
SELECT 
    'UNIQUE_CONSTRAINTS' AS metric_type,
    COUNT(DISTINCT constraint_name) AS total_unique_constraints,
    'Total unique constraints' AS description
FROM information_schema.key_column_usage 
WHERE table_schema = 'airbnb_database' 
    AND constraint_name != 'PRIMARY'
    AND constraint_name LIKE '%UNIQUE%';

-- ==============================================
-- DATA DISTRIBUTION ANALYSIS
-- ==============================================

-- 9. User Role Distribution
SELECT 
    'USER_ROLES' AS metric_type,
    CASE 
        WHEN is_guest = TRUE AND is_host = FALSE AND is_admin = FALSE THEN 'Guest Only'
        WHEN is_guest = TRUE AND is_host = TRUE AND is_admin = FALSE THEN 'Guest & Host'
        WHEN is_guest = FALSE AND is_host = FALSE AND is_admin = TRUE THEN 'Admin Only'
        ELSE 'Other'
    END AS role_type,
    COUNT(*) AS user_count
FROM users
GROUP BY role_type;

-- 10. Property Type Distribution
SELECT 
    'PROPERTY_TYPES' AS metric_type,
    pt.type_name,
    COUNT(p.property_id) AS property_count
FROM property_types pt
LEFT JOIN properties p ON pt.property_type_id = p.property_type_id
GROUP BY pt.type_name
ORDER BY property_count DESC;

-- 11. Booking Status Distribution
SELECT 
    'BOOKING_STATUS' AS metric_type,
    bs.status_name,
    COUNT(b.booking_id) AS booking_count
FROM booking_status bs
LEFT JOIN bookings b ON bs.status_id = b.booking_status_id
GROUP BY bs.status_name
ORDER BY booking_count DESC;

-- 12. Geographic Distribution
SELECT 
    'GEOGRAPHIC_DISTRIBUTION' AS metric_type,
    co.country_name,
    COUNT(DISTINCT c.city_id) AS cities_count,
    COUNT(DISTINCT p.property_id) AS properties_count
FROM countries co
LEFT JOIN cities c ON co.country_id = c.country_id
LEFT JOIN addresses ad ON c.city_id = ad.city_id
LEFT JOIN properties p ON ad.address_id = p.address_id
GROUP BY co.country_name
ORDER BY properties_count DESC;

-- ==============================================
-- BUSINESS METRICS
-- ==============================================

-- 13. Revenue Analysis
SELECT 
    'REVENUE_ANALYSIS' AS metric_type,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue,
    AVG(b.total_amount) AS avg_booking_value,
    MIN(b.total_amount) AS min_booking_value,
    MAX(b.total_amount) AS max_booking_value
FROM bookings b
JOIN booking_status bs ON b.booking_status_id = bs.status_id
WHERE bs.status_name = 'confirmed';

-- 14. Review Analysis
SELECT 
    'REVIEW_ANALYSIS' AS metric_type,
    COUNT(*) AS total_reviews,
    AVG(rating) AS avg_rating,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating
FROM reviews;

-- 15. Communication Analysis
SELECT 
    'COMMUNICATION_ANALYSIS' AS metric_type,
    COUNT(DISTINCT c.conversation_id) AS total_conversations,
    COUNT(m.message_id) AS total_messages,
    AVG(message_count) AS avg_messages_per_conversation
FROM conversations c
LEFT JOIN messages m ON c.conversation_id = m.conversation_id
LEFT JOIN (
    SELECT conversation_id, COUNT(*) AS message_count
    FROM messages
    GROUP BY conversation_id
) msg_counts ON c.conversation_id = msg_counts.conversation_id;

-- ==============================================
-- SUMMARY STATISTICS
-- ==============================================

-- 16. Overall Database Statistics Summary
SELECT 
    'SUMMARY' AS metric_type,
    'Total Tables' AS metric_name,
    COUNT(*) AS metric_value
FROM information_schema.tables 
WHERE table_schema = 'airbnb_database' 
    AND table_type = 'BASE TABLE'

UNION ALL

SELECT 
    'SUMMARY',
    'Total Records',
    (SELECT SUM(record_count) FROM (
        SELECT COUNT(*) AS record_count FROM users
        UNION ALL SELECT COUNT(*) FROM guest_profiles
        UNION ALL SELECT COUNT(*) FROM host_profiles
        UNION ALL SELECT COUNT(*) FROM user_profiles
        UNION ALL SELECT COUNT(*) FROM user_verification
        UNION ALL SELECT COUNT(*) FROM user_preferences
        UNION ALL SELECT COUNT(*) FROM countries
        UNION ALL SELECT COUNT(*) FROM cities
        UNION ALL SELECT COUNT(*) FROM addresses
        UNION ALL SELECT COUNT(*) FROM property_types
        UNION ALL SELECT COUNT(*) FROM property_amenities
        UNION ALL SELECT COUNT(*) FROM properties
        UNION ALL SELECT COUNT(*) FROM property_amenity_links
        UNION ALL SELECT COUNT(*) FROM property_photos
        UNION ALL SELECT COUNT(*) FROM property_pricing
        UNION ALL SELECT COUNT(*) FROM booking_status
        UNION ALL SELECT COUNT(*) FROM bookings
        UNION ALL SELECT COUNT(*) FROM booking_modifications
        UNION ALL SELECT COUNT(*) FROM payment_methods
        UNION ALL SELECT COUNT(*) FROM payments
        UNION ALL SELECT COUNT(*) FROM payouts
        UNION ALL SELECT COUNT(*) FROM review_categories
        UNION ALL SELECT COUNT(*) FROM reviews
        UNION ALL SELECT COUNT(*) FROM review_ratings
        UNION ALL SELECT COUNT(*) FROM conversations
        UNION ALL SELECT COUNT(*) FROM messages
        UNION ALL SELECT COUNT(*) FROM notifications
        UNION ALL SELECT COUNT(*) FROM property_booking_pricing
        UNION ALL SELECT COUNT(*) FROM user_booking_review
        UNION ALL SELECT COUNT(*) FROM booking_payment_payout
    ) AS all_counts)

UNION ALL

SELECT 
    'SUMMARY',
    'Database Size (MB)',
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2)
FROM information_schema.tables 
WHERE table_schema = 'airbnb_database';
