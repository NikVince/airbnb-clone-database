-- ==============================================
-- Airbnb Database Presentation Queries
-- Phase 2: Database Implementation - SIMPLIFIED FOR SLIDES
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 14/10/2025
-- ==============================================

USE airbnb_database;

-- ==============================================
-- SLIDE 1: USERS TABLE
-- ==============================================
-- Simple query showing basic user information
SELECT user_id, first_name, last_name, email, is_guest, is_host, created_at
FROM users
WHERE is_active = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 2: GUEST PROFILES TABLE
-- ==============================================
-- Simple query showing guest profile information
SELECT guest_profile_id, user_id, guest_verification_status, created_at
FROM guest_profiles
LIMIT 5;

-- ==============================================
-- SLIDE 3: HOST PROFILES TABLE
-- ==============================================
-- Simple query showing host profile information
SELECT host_profile_id, user_id, host_verification_status, superhost_status, host_rating
FROM host_profiles
LIMIT 5;

-- ==============================================
-- SLIDE 4: USER PROFILES TABLE
-- ==============================================
-- Simple query showing user profile information
SELECT profile_id, user_id, language_preference, currency_preference
FROM user_profiles
LIMIT 5;

-- ==============================================
-- SLIDE 5: USER VERIFICATION TABLE
-- ==============================================
-- Simple query showing verification information
SELECT verification_id, user_id, verification_type, verification_status
FROM user_verification
LIMIT 5;

-- ==============================================
-- SLIDE 6: USER PREFERENCES TABLE
-- ==============================================
-- Simple query showing user preferences
SELECT preference_id, user_id, preference_key, updated_at
FROM user_preferences
LIMIT 5;

-- ==============================================
-- SLIDE 7: COUNTRIES TABLE
-- ==============================================
-- Simple query showing country information
SELECT country_id, country_name, country_code, currency_code
FROM countries
LIMIT 5;

-- ==============================================
-- SLIDE 8: CITIES TABLE
-- ==============================================
-- Simple query showing city information
SELECT city_id, city_name, state_province, country_id, population
FROM cities
LIMIT 5;

-- ==============================================
-- SLIDE 9: ADDRESSES TABLE
-- ==============================================
-- Simple query showing address information
SELECT address_id, street_address, city_id, postal_code, latitude, longitude
FROM addresses
LIMIT 5;

-- ==============================================
-- SLIDE 10: PROPERTY TYPES TABLE
-- ==============================================
-- Simple query showing property types
SELECT property_type_id, type_name, description
FROM property_types
LIMIT 5;

-- ==============================================
-- SLIDE 11: PROPERTY AMENITIES TABLE
-- ==============================================
-- Simple query showing property amenities
SELECT amenity_id, amenity_name, amenity_category, description
FROM property_amenities
LIMIT 5;

-- ==============================================
-- SLIDE 12: PROPERTIES TABLE
-- ==============================================
-- Simple query showing properties
SELECT property_id, host_id, title, max_guests, bedrooms, bathrooms, is_active
FROM properties
WHERE is_active = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 13: PROPERTY AMENITY LINKS TABLE
-- ==============================================
-- Simple query showing property-amenity relationships
SELECT link_id, property_id, amenity_id, is_available
FROM property_amenity_links
LIMIT 5;

-- ==============================================
-- SLIDE 14: PROPERTY PHOTOS TABLE
-- ==============================================
-- Simple query showing property photos
SELECT photo_id, property_id, photo_url, is_primary, display_order
FROM property_photos
LIMIT 5;

-- ==============================================
-- SLIDE 15: PROPERTY PRICING TABLE
-- ==============================================
-- Simple query showing property pricing
SELECT pricing_id, property_id, start_date, end_date, base_price_per_night, is_available
FROM property_pricing
WHERE is_available = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 16: BOOKING STATUS TABLE
-- ==============================================
-- Simple query showing booking statuses
SELECT status_id, status_name, description, is_active
FROM booking_status
WHERE is_active = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 17: BOOKINGS TABLE
-- ==============================================
-- Simple query showing bookings
SELECT booking_id, guest_profile_id, property_id, check_in_date, check_out_date, total_amount
FROM bookings
LIMIT 5;

-- ==============================================
-- SLIDE 18: BOOKING MODIFICATIONS TABLE
-- ==============================================
-- Simple query showing booking modifications
SELECT modification_id, booking_id, modification_type, created_at
FROM booking_modifications
LIMIT 5;

-- ==============================================
-- SLIDE 19: PAYMENT METHODS TABLE
-- ==============================================
-- Simple query showing payment methods
SELECT payment_method_id, user_id, method_type, is_default, is_active
FROM payment_methods
WHERE is_active = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 20: PAYMENTS TABLE
-- ==============================================
-- Simple query showing payments
SELECT payment_id, booking_id, amount, currency, payment_status, processed_at
FROM payments
LIMIT 5;

-- ==============================================
-- SLIDE 21: PAYOUTS TABLE
-- ==============================================
-- Simple query showing payouts
SELECT payout_id, host_profile_id, booking_id, amount, currency, payout_status
FROM payouts
LIMIT 5;

-- ==============================================
-- SLIDE 22: REVIEW CATEGORIES TABLE
-- ==============================================
-- Simple query showing review categories
SELECT category_id, category_name, description, weight
FROM review_categories
LIMIT 5;

-- ==============================================
-- SLIDE 23: REVIEWS TABLE
-- ==============================================
-- Simple query showing reviews
SELECT review_id, reviewer_id, reviewee_id, rating, is_public, created_at
FROM reviews
WHERE is_public = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 24: REVIEW RATINGS TABLE
-- ==============================================
-- Simple query showing review ratings
SELECT rating_id, review_id, category_id, rating_value
FROM review_ratings
LIMIT 5;

-- ==============================================
-- SLIDE 25: CONVERSATIONS TABLE
-- ==============================================
-- Simple query showing conversations
SELECT conversation_id, participant1_id, participant2_id, booking_id, created_at
FROM conversations
LIMIT 5;

-- ==============================================
-- SLIDE 26: MESSAGES TABLE
-- ==============================================
-- Simple query showing messages
SELECT message_id, conversation_id, sender_id, message_type, sent_at
FROM messages
LIMIT 5;

-- ==============================================
-- SLIDE 27: NOTIFICATIONS TABLE
-- ==============================================
-- Simple query showing notifications
SELECT notification_id, user_id, notification_type, title, is_read, created_at
FROM notifications
LIMIT 5;

-- ==============================================
-- SLIDE 28: TRIPLE RELATIONSHIP 1 - Property-Booking-Pricing
-- ==============================================
-- Simple query showing triple relationship
SELECT pbp_id, property_id, booking_id, pricing_id, applied_price
FROM property_booking_pricing
LIMIT 5;

-- ==============================================
-- SLIDE 29: TRIPLE RELATIONSHIP 2 - User-Booking-Review
-- ==============================================
-- Simple query showing triple relationship
SELECT ubr_id, user_id, booking_id, review_id, review_role
FROM user_booking_review
LIMIT 5;

-- ==============================================
-- SLIDE 30: TRIPLE RELATIONSHIP 3 - Booking-Payment-Payout
-- ==============================================
-- Simple query showing triple relationship
SELECT bpp_id, booking_id, payment_id, payout_id, transaction_chain_status
FROM booking_payment_payout
LIMIT 5;

-- ==============================================
-- SLIDE 31: RECURSIVE RELATIONSHIP DEMONSTRATION
-- ==============================================
-- Simple query showing recursive relationship
SELECT u.user_id, u.first_name, u.last_name, u.is_guest, u.is_host
FROM users u
WHERE u.is_guest = TRUE AND u.is_host = TRUE
LIMIT 5;

-- ==============================================
-- SLIDE 32: DATABASE SUMMARY
-- ==============================================
-- Simple query showing database statistics
SELECT 
    'Database Statistics' AS info,
    COUNT(*) AS total_tables
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'airbnb_database';
