-- ==============================================
-- Airbnb Database Enhanced Test Queries
-- Phase 3: Final Implementation - Multi-Table JOINs
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 24/10/2025
-- ==============================================

USE airbnb_database;

-- ==============================================
-- TEST CASE 1: BOOKING DETAILS WITH USER INFO
-- Multi-table JOIN across 4 tables
-- ==============================================
-- Business Purpose: Show booking details with guest and host information
-- Tables: bookings, guest_profiles, users, properties, host_profiles
SELECT 
    b.booking_id,
    CONCAT(gu.first_name, ' ', gu.last_name) AS guest_name,
    CONCAT(hu.first_name, ' ', hu.last_name) AS host_name,
    p.property_title,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    b.booking_status
FROM bookings b
    INNER JOIN guest_profiles gp ON b.guest_profile_id = gp.guest_profile_id
    INNER JOIN users gu ON gp.user_id = gu.user_id
    INNER JOIN properties p ON b.property_id = p.property_id
    INNER JOIN host_profiles hp ON p.host_profile_id = hp.host_profile_id
    INNER JOIN users hu ON hp.user_id = hu.user_id
WHERE b.booking_status = 'confirmed'
ORDER BY b.created_at DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 2: PROPERTY PERFORMANCE WITH AGGREGATION
-- Multi-table JOIN across 4 tables with aggregation
-- ==============================================
-- Business Purpose: Analyze property performance with bookings and reviews
-- Tables: properties, host_profiles, users, bookings, reviews
SELECT 
    p.property_id,
    p.property_title,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    AVG(r.rating) AS average_rating,
    SUM(b.total_amount) AS total_revenue
FROM properties p
    INNER JOIN host_profiles hp ON p.host_profile_id = hp.host_profile_id
    INNER JOIN users u ON hp.user_id = u.user_id
    LEFT JOIN bookings b ON p.property_id = b.property_id AND b.booking_status = 'confirmed'
    LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY p.property_id, p.property_title, u.first_name, u.last_name
HAVING total_bookings > 0
ORDER BY total_revenue DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 3: GUEST BOOKING ANALYSIS WITH WINDOW FUNCTIONS
-- Multi-table JOIN across 4 tables with window functions
-- ==============================================
-- Business Purpose: Analyze guest booking patterns with ranking
-- Tables: users, guest_profiles, bookings, properties
SELECT 
    gu.user_id,
    CONCAT(gu.first_name, ' ', gu.last_name) AS guest_name,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_spent,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT b.booking_id) DESC) AS booking_rank,
    RANK() OVER (ORDER BY SUM(b.total_amount) DESC) AS spending_rank
FROM users gu
    INNER JOIN guest_profiles gp ON gu.user_id = gp.user_id
    INNER JOIN bookings b ON gp.guest_profile_id = b.guest_profile_id
    INNER JOIN properties p ON b.property_id = p.property_id
WHERE b.booking_status = 'confirmed'
GROUP BY gu.user_id, gu.first_name, gu.last_name
HAVING total_bookings >= 2
ORDER BY total_bookings DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 4: HOST PERFORMANCE ANALYSIS
-- Multi-table JOIN across 4 tables with aggregation
-- ==============================================
-- Business Purpose: Analyze host performance with properties and bookings
-- Tables: users, host_profiles, properties, bookings, reviews
SELECT 
    hu.user_id,
    CONCAT(hu.first_name, ' ', hu.last_name) AS host_name,
    COUNT(DISTINCT p.property_id) AS total_properties,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    AVG(r.rating) AS avg_rating,
    SUM(b.total_amount) AS total_revenue
FROM users hu
    INNER JOIN host_profiles hp ON hu.user_id = hp.user_id
    INNER JOIN properties p ON hp.host_profile_id = p.host_profile_id
    LEFT JOIN bookings b ON p.property_id = b.property_id AND b.booking_status = 'confirmed'
    LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY hu.user_id, hu.first_name, hu.last_name
HAVING total_properties > 0
ORDER BY total_revenue DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 5: LOCATION-BASED PROPERTY ANALYSIS
-- Multi-table JOIN across 5 tables with subquery
-- ==============================================
-- Business Purpose: Analyze properties by location with market metrics
-- Tables: countries, cities, addresses, properties, bookings, reviews
SELECT 
    co.country_name,
    c.city_name,
    COUNT(DISTINCT p.property_id) AS total_properties,
    AVG(p.price_per_night) AS avg_price_per_night,
    AVG(r.rating) AS avg_rating,
    SUM(b.total_amount) AS total_revenue
FROM countries co
    INNER JOIN cities c ON co.country_id = c.country_id
    INNER JOIN addresses ad ON c.city_id = ad.city_id
    INNER JOIN properties p ON ad.address_id = p.address_id
    LEFT JOIN bookings b ON p.property_id = b.property_id AND b.booking_status = 'confirmed'
    LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY co.country_id, co.country_name, c.city_id, c.city_name
HAVING total_properties > 0
ORDER BY total_revenue DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 6: MESSAGE CONVERSATION ANALYSIS
-- Multi-table JOIN across 4 tables with aggregation
-- ==============================================
-- Business Purpose: Analyze conversation patterns between hosts and guests
-- Tables: conversations, users, messages, properties
SELECT 
    c.conversation_id,
    CONCAT(gu.first_name, ' ', gu.last_name) AS guest_name,
    CONCAT(hu.first_name, ' ', hu.last_name) AS host_name,
    p.property_title,
    COUNT(m.message_id) AS total_messages,
    MIN(m.created_at) AS first_message,
    MAX(m.created_at) AS last_message
FROM conversations c
    INNER JOIN users gu ON c.guest_user_id = gu.user_id
    INNER JOIN users hu ON c.host_user_id = hu.user_id
    INNER JOIN properties p ON c.property_id = p.property_id
    LEFT JOIN messages m ON c.conversation_id = m.conversation_id
GROUP BY c.conversation_id, gu.first_name, gu.last_name, hu.first_name, hu.last_name, p.property_title
HAVING total_messages > 0
ORDER BY total_messages DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 7: PAYMENT ANALYSIS WITH SUBQUERY
-- Multi-table JOIN across 4 tables with subquery
-- ==============================================
-- Business Purpose: Analyze payment patterns and amounts
-- Tables: payments, bookings, users, payment_methods
SELECT 
    p.payment_id,
    CONCAT(gu.first_name, ' ', gu.last_name) AS guest_name,
    b.booking_id,
    p.amount,
    p.payment_status,
    pm.payment_method_type,
    p.created_at AS payment_date
FROM payments p
    INNER JOIN bookings b ON p.booking_id = b.booking_id
    INNER JOIN guest_profiles gp ON b.guest_profile_id = gp.guest_profile_id
    INNER JOIN users gu ON gp.user_id = gu.user_id
    INNER JOIN payment_methods pm ON p.payment_method_id = pm.payment_method_id
WHERE p.payment_status = 'completed'
    AND p.amount > (SELECT AVG(amount) FROM payments WHERE payment_status = 'completed')
ORDER BY p.amount DESC
LIMIT 10;

-- ==============================================
-- TEST CASE 8: AMENITY ANALYSIS WITH AGGREGATION
-- Multi-table JOIN across 4 tables with aggregation
-- ==============================================
-- Business Purpose: Analyze which amenities correlate with higher ratings
-- Tables: amenities, property_amenities, properties, reviews
SELECT 
    a.amenity_name,
    a.amenity_category,
    COUNT(DISTINCT pa.property_id) AS properties_with_amenity,
    AVG(r.rating) AS avg_rating,
    COUNT(DISTINCT r.review_id) AS total_reviews
FROM amenities a
    INNER JOIN property_amenities pa ON a.amenity_id = pa.amenity_id
    INNER JOIN properties p ON pa.property_id = p.property_id
    LEFT JOIN reviews r ON p.property_id = r.property_id
GROUP BY a.amenity_id, a.amenity_name, a.amenity_category
HAVING properties_with_amenity > 1
ORDER BY avg_rating DESC
LIMIT 10;

-- ==============================================
-- VERIFICATION QUERIES
-- ==============================================

-- Check total counts for verification
SELECT 'Users' AS table_name, COUNT(*) AS record_count FROM users
UNION ALL
SELECT 'Properties', COUNT(*) FROM properties
UNION ALL
SELECT 'Bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'Reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'Messages', COUNT(*) FROM messages
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments;

-- Check foreign key relationships
SELECT 
    'Foreign Key Check' AS test_type,
    COUNT(*) AS total_records,
    COUNT(DISTINCT guest_profile_id) AS unique_guests,
    COUNT(DISTINCT property_id) AS unique_properties
FROM bookings
WHERE guest_profile_id IS NOT NULL AND property_id IS NOT NULL;
