-- ==============================================
-- Airbnb Database Test Queries
-- Phase 2: Database Implementation
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 14/10/2025
-- ==============================================

USE airbnb_database;

-- ==============================================
-- TEST QUERY 1: User Management and Role Verification
-- ==============================================
-- Purpose: Demonstrate user role management and profile relationships
-- Expected: Shows users with their guest/host profiles and verification status

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.is_guest,
    u.is_host,
    gp.guest_verification_status,
    hp.host_verification_status,
    hp.superhost_status
FROM users u
LEFT JOIN guest_profiles gp ON u.user_id = gp.user_id
LEFT JOIN host_profiles hp ON u.user_id = hp.user_id
WHERE u.is_active = TRUE
ORDER BY u.user_id
LIMIT 10;

-- ==============================================
-- TEST QUERY 2: Property Listing with Amenities
-- ==============================================
-- Purpose: Demonstrate property-amenity many-to-many relationship
-- Expected: Shows properties with their associated amenities

SELECT 
    p.property_id,
    p.title,
    pt.type_name,
    a.street_address,
    c.city_name,
    co.country_name,
    GROUP_CONCAT(pa.amenity_name SEPARATOR ', ') AS amenities
FROM properties p
JOIN property_types pt ON p.property_type_id = pt.property_type_id
JOIN addresses a ON p.address_id = a.address_id
JOIN cities c ON a.city_id = c.city_id
JOIN countries co ON a.country_id = co.country_id
LEFT JOIN property_amenity_links pal ON p.property_id = pal.property_id
LEFT JOIN property_amenities pa ON pal.amenity_id = pa.amenity_id
WHERE p.is_active = TRUE
GROUP BY p.property_id, p.title, pt.type_name, a.street_address, c.city_name, co.country_name
ORDER BY p.property_id
LIMIT 10;

-- ==============================================
-- TEST QUERY 3: Booking System with Financial Flow
-- ==============================================
-- Purpose: Demonstrate booking-payment-payout triple relationship
-- Expected: Shows complete booking transaction flow

SELECT 
    b.booking_id,
    CONCAT(u.first_name, ' ', u.last_name) AS guest_name,
    p.title AS property_title,
    bs.status_name AS booking_status,
    b.check_in_date,
    b.check_out_date,
    b.total_amount,
    pm.payment_status,
    po.payout_status,
    bpp.transaction_chain_status
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN properties p ON b.property_id = p.property_id
JOIN booking_status bs ON b.booking_status_id = bs.status_id
LEFT JOIN payments pm ON b.booking_id = pm.booking_id
LEFT JOIN payouts po ON b.booking_id = po.booking_id
LEFT JOIN booking_payment_payout bpp ON b.booking_id = bpp.booking_id
ORDER BY b.booking_id
LIMIT 10;

-- ==============================================
-- TEST QUERY 4: Review System Analysis
-- ==============================================
-- Purpose: Demonstrate review system with ratings
-- Expected: Shows reviews with detailed ratings by category

SELECT 
    r.review_id,
    CONCAT(ru.first_name, ' ', ru.last_name) AS reviewer_name,
    CONCAT(ru2.first_name, ' ', ru2.last_name) AS reviewee_name,
    r.rating,
    r.review_text,
    GROUP_CONCAT(
        CONCAT(rc.category_name, ': ', rr.rating_value) 
        SEPARATOR ', '
    ) AS category_ratings
FROM reviews r
JOIN users ru ON r.reviewer_id = ru.user_id
JOIN users ru2 ON r.reviewee_id = ru2.user_id
LEFT JOIN review_ratings rr ON r.review_id = rr.review_id
LEFT JOIN review_categories rc ON rr.category_id = rc.category_id
WHERE r.is_public = TRUE
GROUP BY r.review_id, ru.first_name, ru.last_name, ru2.first_name, ru2.last_name, r.rating, r.review_text
ORDER BY r.created_at DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 5: Property Pricing Analysis
-- ==============================================
-- Purpose: Demonstrate property pricing with seasonal rates
-- Expected: Shows properties with their pricing rules and availability

SELECT 
    p.property_id,
    p.title,
    pp.start_date,
    pp.end_date,
    pp.base_price_per_night,
    pp.weekend_price_per_night,
    pp.weekly_discount_percentage,
    pp.monthly_discount_percentage,
    pp.minimum_stay_nights,
    pp.is_available
FROM properties p
JOIN property_pricing pp ON p.property_id = pp.property_id
WHERE pp.is_available = TRUE
  AND pp.start_date <= CURDATE() 
  AND pp.end_date >= CURDATE()
ORDER BY pp.base_price_per_night
LIMIT 10;

-- ==============================================
-- TEST QUERY 6: Host Performance Analysis
-- ==============================================
-- Purpose: Demonstrate host performance metrics
-- Expected: Shows host statistics and performance indicators

SELECT 
    u.first_name,
    u.last_name,
    hp.host_since,
    hp.response_rate,
    hp.response_time_hours,
    hp.acceptance_rate,
    hp.host_rating,
    hp.total_properties,
    hp.superhost_status,
    COUNT(p.property_id) AS active_properties
FROM host_profiles hp
JOIN users u ON hp.user_id = u.user_id
LEFT JOIN properties p ON hp.host_profile_id = p.host_id AND p.is_active = TRUE
WHERE hp.host_verification_status = 'verified'
GROUP BY u.first_name, u.last_name, hp.host_since, hp.response_rate, hp.response_time_hours, 
         hp.acceptance_rate, hp.host_rating, hp.total_properties, hp.superhost_status
ORDER BY hp.host_rating DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 7: Geographic Distribution
-- ==============================================
-- Purpose: Demonstrate location-based queries
-- Expected: Shows property distribution by country and city

SELECT 
    co.country_name,
    c.city_name,
    COUNT(p.property_id) AS property_count,
    AVG(pp.base_price_per_night) AS avg_price,
    COUNT(DISTINCT hp.host_profile_id) AS host_count
FROM properties p
JOIN addresses a ON p.address_id = a.address_id
JOIN cities c ON a.city_id = c.city_id
JOIN countries co ON a.country_id = co.country_id
JOIN host_profiles hp ON p.host_id = hp.host_profile_id
JOIN property_pricing pp ON p.property_id = pp.property_id
WHERE p.is_active = TRUE
GROUP BY co.country_name, c.city_name
ORDER BY property_count DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 8: Communication System
-- ==============================================
-- Purpose: Demonstrate messaging system between users
-- Expected: Shows conversation threads and message counts

SELECT 
    c.conversation_id,
    CONCAT(u1.first_name, ' ', u1.last_name) AS participant1,
    CONCAT(u2.first_name, ' ', u2.last_name) AS participant2,
    c.created_at,
    c.last_message_at,
    COUNT(m.message_id) AS message_count,
    MAX(m.sent_at) AS last_message_sent
FROM conversations c
JOIN users u1 ON c.participant1_id = u1.user_id
JOIN users u2 ON c.participant2_id = u2.user_id
LEFT JOIN messages m ON c.conversation_id = m.conversation_id
GROUP BY c.conversation_id, u1.first_name, u1.last_name, u2.first_name, u2.last_name, 
         c.created_at, c.last_message_at
ORDER BY c.last_message_at DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 9: Financial Transaction Summary
-- ==============================================
-- Purpose: Demonstrate financial flow and transaction tracking
-- Expected: Shows payment and payout summaries

SELECT 
    DATE(pm.processed_at) AS transaction_date,
    COUNT(pm.payment_id) AS payment_count,
    SUM(pm.amount) AS total_payments,
    COUNT(po.payout_id) AS payout_count,
    SUM(po.amount) AS total_payouts,
    SUM(pm.amount) - SUM(po.amount) AS platform_revenue
FROM payments pm
LEFT JOIN payouts po ON pm.booking_id = po.booking_id
WHERE pm.payment_status = 'completed'
GROUP BY DATE(pm.processed_at)
ORDER BY transaction_date DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 10: Triple Relationship Demonstration
-- ==============================================
-- Purpose: Demonstrate property-booking-pricing triple relationship
-- Expected: Shows how pricing rules are applied to specific bookings

SELECT 
    pbp.pbp_id,
    p.title AS property_title,
    b.booking_id,
    pp.start_date AS pricing_start,
    pp.end_date AS pricing_end,
    pbp.applied_price,
    pbp.pricing_rule_applied,
    b.check_in_date,
    b.check_out_date,
    b.total_amount
FROM property_booking_pricing pbp
JOIN properties p ON pbp.property_id = p.property_id
JOIN bookings b ON pbp.booking_id = b.booking_id
JOIN property_pricing pp ON pbp.pricing_id = pp.pricing_id
ORDER BY pbp.created_at DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 11: User Booking History
-- ==============================================
-- Purpose: Demonstrate user-booking-review triple relationship
-- Expected: Shows user interaction history with bookings and reviews

SELECT 
    ubr.ubr_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    b.booking_id,
    r.review_id,
    ubr.review_role,
    ubr.interaction_type,
    b.check_in_date,
    b.check_out_date,
    r.rating,
    r.review_text
FROM user_booking_review ubr
JOIN users u ON ubr.user_id = u.user_id
JOIN bookings b ON ubr.booking_id = b.booking_id
JOIN reviews r ON ubr.review_id = r.review_id
ORDER BY ubr.created_at DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 12: System Notifications
-- ==============================================
-- Purpose: Demonstrate notification system
-- Expected: Shows user notifications and their status

SELECT 
    n.notification_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    n.notification_type,
    n.title,
    n.message,
    n.is_read,
    n.created_at,
    n.sent_at
FROM notifications n
JOIN users u ON n.user_id = u.user_id
ORDER BY n.created_at DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 13: Property Photo Management
-- ==============================================
-- Purpose: Demonstrate property photo relationships
-- Expected: Shows properties with their photo galleries

SELECT 
    p.property_id,
    p.title,
    pp.photo_id,
    pp.photo_url,
    pp.caption,
    pp.is_primary,
    pp.display_order,
    pp.uploaded_at
FROM properties p
JOIN property_photos pp ON p.property_id = pp.property_id
WHERE p.is_active = TRUE
ORDER BY p.property_id, pp.display_order
LIMIT 20;

-- ==============================================
-- TEST QUERY 14: Booking Status Workflow
-- ==============================================
-- Purpose: Demonstrate booking status management
-- Expected: Shows booking status transitions and modifications

SELECT 
    b.booking_id,
    bs.status_name AS current_status,
    bm.modification_type,
    bm.old_value,
    bm.new_value,
    bm.reason,
    bm.created_at AS modification_date,
    CONCAT(u.first_name, ' ', u.last_name) AS approved_by
FROM bookings b
JOIN booking_status bs ON b.booking_status_id = bs.status_id
LEFT JOIN booking_modifications bm ON b.booking_id = bm.booking_id
LEFT JOIN users u ON bm.approved_by = u.user_id
ORDER BY b.booking_id, bm.created_at DESC
LIMIT 10;

-- ==============================================
-- TEST QUERY 15: Recursive Relationship Demonstration
-- ==============================================
-- Purpose: Demonstrate user self-referencing through bookings
-- Expected: Shows how users can be both guests and hosts

SELECT 
    u.user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.is_guest,
    u.is_host,
    COUNT(DISTINCT b.booking_id) AS bookings_as_guest,
    COUNT(DISTINCT p.property_id) AS properties_as_host,
    COUNT(DISTINCT r.review_id) AS reviews_given,
    COUNT(DISTINCT r2.review_id) AS reviews_received
FROM users u
LEFT JOIN bookings b ON u.user_id = b.user_id
LEFT JOIN host_profiles hp ON u.user_id = hp.user_id
LEFT JOIN properties p ON hp.host_profile_id = p.host_id
LEFT JOIN reviews r ON u.user_id = r.reviewer_id
LEFT JOIN reviews r2 ON u.user_id = r2.reviewee_id
WHERE u.is_active = TRUE
GROUP BY u.user_id, u.first_name, u.last_name, u.is_guest, u.is_host
HAVING COUNT(DISTINCT b.booking_id) > 0 OR COUNT(DISTINCT p.property_id) > 0
ORDER BY user_name
LIMIT 10;

-- ==============================================
-- QUERY EXECUTION SUMMARY
-- ==============================================

SELECT 
    'Test Queries Execution Complete' AS Status,
    '15 comprehensive test queries demonstrating all database relationships' AS Description,
    NOW() AS Completed_At;
