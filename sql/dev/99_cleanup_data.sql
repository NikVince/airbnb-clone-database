-- ==============================================
-- CLEANUP SCRIPT - Remove all sample data
-- ==============================================

USE airbnb_database;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Clear all tables in reverse dependency order
TRUNCATE TABLE booking_payment_payout;
TRUNCATE TABLE user_booking_review;
TRUNCATE TABLE property_booking_pricing;
TRUNCATE TABLE notifications;
TRUNCATE TABLE messages;
TRUNCATE TABLE conversations;
TRUNCATE TABLE review_ratings;
TRUNCATE TABLE reviews;
TRUNCATE TABLE review_categories;
TRUNCATE TABLE payouts;
TRUNCATE TABLE payments;
TRUNCATE TABLE payment_methods;
TRUNCATE TABLE booking_modifications;
TRUNCATE TABLE bookings;
TRUNCATE TABLE booking_status;
TRUNCATE TABLE property_pricing;
TRUNCATE TABLE property_photos;
TRUNCATE TABLE property_amenity_links;
TRUNCATE TABLE properties;
TRUNCATE TABLE property_amenities;
TRUNCATE TABLE property_types;
TRUNCATE TABLE user_preferences;
TRUNCATE TABLE user_verification;
TRUNCATE TABLE host_profiles;
TRUNCATE TABLE guest_profiles;
TRUNCATE TABLE user_profiles;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

SELECT 'All sample data cleared successfully!' AS Status;
