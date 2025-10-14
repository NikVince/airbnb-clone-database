-- ==============================================
-- Airbnb Database Creation Script
-- Phase 2: Database Implementation
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 14/10/2025
-- ==============================================

-- Database Creation
DROP DATABASE IF EXISTS airbnb_database;
CREATE DATABASE airbnb_database;
USE airbnb_database;

-- ==============================================
-- USER MANAGEMENT DOMAIN
-- ==============================================

-- Users table with role tracking
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    date_of_birth DATE,
    is_guest BOOLEAN DEFAULT TRUE,
    is_host BOOLEAN DEFAULT FALSE,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Constraints
    CONSTRAINT chk_users_email CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_users_phone CHECK (phone REGEXP '^\\+[1-9]\\d{1,14}$'),
    CONSTRAINT chk_users_role_consistency CHECK (
        (is_guest = TRUE AND is_host = FALSE AND is_admin = FALSE) OR
        (is_guest = TRUE AND is_host = TRUE AND is_admin = FALSE) OR
        (is_guest = FALSE AND is_host = FALSE AND is_admin = TRUE)
    )
);

-- Guest profiles table
CREATE TABLE guest_profiles (
    guest_profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    preferred_price_range VARCHAR(50),
    preferred_property_types JSON,
    travel_preferences JSON,
    guest_verification_status VARCHAR(20) DEFAULT 'unverified',
    verification_date DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_guest_verification_status CHECK (guest_verification_status IN ('unverified', 'email_verified', 'phone_verified', 'id_verified', 'fully_verified'))
);

-- Host profiles table
CREATE TABLE host_profiles (
    host_profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    host_verification_status VARCHAR(20) DEFAULT 'pending',
    verification_date DATETIME,
    host_since DATETIME,
    response_rate DECIMAL(5,2) DEFAULT 0.00,
    response_time_hours INT,
    acceptance_rate DECIMAL(5,2) DEFAULT 0.00,
    host_rating DECIMAL(3,2),
    total_properties INT DEFAULT 0,
    superhost_status BOOLEAN DEFAULT FALSE,
    payout_method_id INT,
    tax_id VARCHAR(50),
    business_name VARCHAR(255),
    business_registration VARCHAR(100),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_host_verification_status CHECK (host_verification_status IN ('pending', 'verified', 'rejected', 'suspended')),
    CONSTRAINT chk_host_response_rate CHECK (response_rate >= 0 AND response_rate <= 100),
    CONSTRAINT chk_host_acceptance_rate CHECK (acceptance_rate >= 0 AND acceptance_rate <= 100),
    CONSTRAINT chk_host_rating CHECK (host_rating >= 1 AND host_rating <= 5),
    CONSTRAINT chk_host_total_properties CHECK (total_properties >= 0)
);

-- User profiles table
CREATE TABLE user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    bio TEXT,
    profile_picture VARCHAR(500),
    language_preference VARCHAR(10) DEFAULT 'en',
    currency_preference VARCHAR(3) DEFAULT 'USD',
    timezone VARCHAR(50),
    notification_settings JSON,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_user_profiles_language CHECK (language_preference IN ('en', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'zh', 'ja', 'ko')),
    CONSTRAINT chk_user_profiles_currency CHECK (currency_preference IN ('USD', 'EUR', 'GBP', 'CAD', 'AUD', 'JPY', 'CHF', 'CNY'))
);

-- User verification table
CREATE TABLE user_verification (
    verification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    verification_type VARCHAR(50) NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    document_number VARCHAR(100) NOT NULL,
    verification_status VARCHAR(20) NOT NULL,
    verified_at DATETIME,
    expires_at DATETIME,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_verification_type CHECK (verification_type IN ('email', 'phone', 'identity', 'payment', 'address')),
    CONSTRAINT chk_document_type CHECK (document_type IN ('passport', 'drivers_license', 'national_id', 'utility_bill', 'bank_statement')),
    CONSTRAINT chk_verification_status CHECK (verification_status IN ('pending', 'verified', 'rejected', 'expired'))
);

-- User preferences table
CREATE TABLE user_preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    preference_key VARCHAR(100) NOT NULL,
    preference_value JSON NOT NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Unique constraint
    UNIQUE KEY uk_user_preferences_user_key (user_id, preference_key)
);

-- ==============================================
-- LOCATION DOMAIN
-- ==============================================

-- Countries table
CREATE TABLE countries (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE,
    country_code VARCHAR(3) NOT NULL UNIQUE,
    currency_code VARCHAR(3) NOT NULL,
    phone_code VARCHAR(5),
    
    -- Constraints
    CONSTRAINT chk_country_code CHECK (LENGTH(country_code) = 3),
    CONSTRAINT chk_currency_code CHECK (LENGTH(currency_code) = 3)
);

-- Cities table
CREATE TABLE cities (
    city_id INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(100) NOT NULL,
    state_province VARCHAR(100),
    country_id INT NOT NULL,
    timezone VARCHAR(50),
    population INT,
    
    -- Foreign key
    FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_cities_population CHECK (population >= 0)
);

-- Addresses table
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street_address VARCHAR(200) NOT NULL,
    city_id INT NOT NULL,
    postal_code VARCHAR(20),
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    country_id INT NOT NULL,
    
    -- Foreign keys
    FOREIGN KEY (city_id) REFERENCES cities(city_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (country_id) REFERENCES countries(country_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_addresses_latitude CHECK (latitude >= -90 AND latitude <= 90),
    CONSTRAINT chk_addresses_longitude CHECK (longitude >= -180 AND longitude <= 180)
);

-- ==============================================
-- PROPERTY MANAGEMENT DOMAIN
-- ==============================================

-- Property types table
CREATE TABLE property_types (
    property_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    icon_url VARCHAR(500),
    
    -- Constraints
    CONSTRAINT chk_property_types_icon_url CHECK (icon_url REGEXP '^https?://[^\\s]+$' OR icon_url IS NULL)
);

-- Property amenities table
CREATE TABLE property_amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    amenity_name VARCHAR(100) NOT NULL UNIQUE,
    amenity_category VARCHAR(50) NOT NULL,
    icon_url VARCHAR(500),
    description TEXT,
    
    -- Constraints
    CONSTRAINT chk_amenities_icon_url CHECK (icon_url REGEXP '^https?://[^\\s]+$' OR icon_url IS NULL)
);

-- Properties table
CREATE TABLE properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,
    host_id INT NOT NULL,
    property_type_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    address_id INT NOT NULL,
    max_guests INT NOT NULL,
    bedrooms INT NOT NULL,
    bathrooms DECIMAL(3,1) NOT NULL,
    size_sqm DECIMAL(8,2),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Foreign keys
    FOREIGN KEY (host_id) REFERENCES host_profiles(host_profile_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (property_type_id) REFERENCES property_types(property_type_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_properties_max_guests CHECK (max_guests > 0),
    CONSTRAINT chk_properties_bedrooms CHECK (bedrooms >= 0),
    CONSTRAINT chk_properties_bathrooms CHECK (bathrooms >= 0),
    CONSTRAINT chk_properties_size_sqm CHECK (size_sqm > 0 OR size_sqm IS NULL)
);

-- Property amenity links table
CREATE TABLE property_amenity_links (
    link_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    amenity_id INT NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    additional_info TEXT,
    
    -- Foreign keys
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES property_amenities(amenity_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Unique constraint
    UNIQUE KEY uk_property_amenity_links_unique (property_id, amenity_id)
);

-- Property photos table
CREATE TABLE property_photos (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    photo_url VARCHAR(500) NOT NULL,
    caption VARCHAR(200),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INT DEFAULT 0,
    uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_property_photos_url CHECK (photo_url REGEXP '^https?://[^\\s]+$'),
    CONSTRAINT chk_property_photos_display_order CHECK (display_order >= 0)
);

-- Property pricing table
CREATE TABLE property_pricing (
    pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    base_price_per_night DECIMAL(10,2) NOT NULL,
    weekend_price_per_night DECIMAL(10,2),
    weekly_discount_percentage DECIMAL(5,2) DEFAULT 0,
    monthly_discount_percentage DECIMAL(5,2) DEFAULT 0,
    minimum_stay_nights INT DEFAULT 1,
    maximum_stay_nights INT,
    is_available BOOLEAN DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign key
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_pricing_dates CHECK (end_date > start_date),
    CONSTRAINT chk_pricing_base_price CHECK (base_price_per_night > 0),
    CONSTRAINT chk_pricing_weekend_price CHECK (weekend_price_per_night > 0 OR weekend_price_per_night IS NULL),
    CONSTRAINT chk_pricing_weekly_discount CHECK (weekly_discount_percentage >= 0 AND weekly_discount_percentage <= 100),
    CONSTRAINT chk_pricing_monthly_discount CHECK (monthly_discount_percentage >= 0 AND monthly_discount_percentage <= 100),
    CONSTRAINT chk_pricing_minimum_stay CHECK (minimum_stay_nights > 0),
    CONSTRAINT chk_pricing_maximum_stay CHECK (maximum_stay_nights > 0 OR maximum_stay_nights IS NULL)
);

-- ==============================================
-- BOOKING SYSTEM DOMAIN
-- ==============================================

-- Booking status table
CREATE TABLE booking_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- Bookings table
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    guest_profile_id INT NOT NULL,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    booking_status_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    confirmed_at DATETIME,
    
    -- Foreign keys
    FOREIGN KEY (guest_profile_id) REFERENCES guest_profiles(guest_profile_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (booking_status_id) REFERENCES booking_status(status_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_bookings_dates CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_bookings_guests CHECK (number_of_guests > 0),
    CONSTRAINT chk_bookings_amount CHECK (total_amount > 0)
);

-- Booking modifications table
CREATE TABLE booking_modifications (
    modification_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    modification_type VARCHAR(50) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    reason TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    approved_by INT,
    
    -- Foreign keys
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (approved_by) REFERENCES users(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_modification_type CHECK (modification_type IN ('date_change', 'guest_count_change', 'cancellation', 'refund', 'price_adjustment'))
);

-- ==============================================
-- FINANCIAL DOMAIN
-- ==============================================

-- Payment methods table
CREATE TABLE payment_methods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    method_type VARCHAR(50) NOT NULL,
    card_last_four VARCHAR(4),
    expiry_date VARCHAR(7),
    is_default BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_payment_method_type CHECK (method_type IN ('credit_card', 'debit_card', 'paypal', 'bank_transfer', 'apple_pay', 'google_pay')),
    CONSTRAINT chk_card_last_four CHECK (card_last_four REGEXP '^[0-9]{4}$' OR card_last_four IS NULL),
    CONSTRAINT chk_expiry_date CHECK (expiry_date REGEXP '^[0-9]{2}/[0-9]{4}$' OR expiry_date IS NULL)
);

-- Payments table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    payment_status VARCHAR(20) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    processed_at DATETIME,
    refunded_at DATETIME,
    
    -- Foreign keys
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_payments_amount CHECK (amount > 0),
    CONSTRAINT chk_payments_currency CHECK (LENGTH(currency) = 3),
    CONSTRAINT chk_payments_status CHECK (payment_status IN ('pending', 'processing', 'completed', 'failed', 'refunded', 'cancelled'))
);

-- Payouts table
CREATE TABLE payouts (
    payout_id INT AUTO_INCREMENT PRIMARY KEY,
    host_profile_id INT NOT NULL,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    payout_status VARCHAR(20) NOT NULL,
    scheduled_date DATETIME,
    processed_date DATETIME,
    
    -- Foreign keys
    FOREIGN KEY (host_profile_id) REFERENCES host_profiles(host_profile_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_payouts_amount CHECK (amount > 0),
    CONSTRAINT chk_payouts_currency CHECK (LENGTH(currency) = 3),
    CONSTRAINT chk_payouts_status CHECK (payout_status IN ('pending', 'scheduled', 'processing', 'completed', 'failed', 'cancelled'))
);

-- ==============================================
-- REVIEW SYSTEM DOMAIN
-- ==============================================

-- Review categories table
CREATE TABLE review_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    weight DECIMAL(3,2) DEFAULT 1.00,
    
    -- Constraints
    CONSTRAINT chk_review_categories_weight CHECK (weight > 0 AND weight <= 1)
);

-- Reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    reviewer_id INT NOT NULL,
    reviewee_id INT NOT NULL,
    booking_id INT NOT NULL,
    rating INT NOT NULL,
    review_text TEXT,
    is_public BOOLEAN DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign keys
    FOREIGN KEY (reviewer_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (reviewee_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_reviews_rating CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT chk_reviews_different_users CHECK (reviewer_id != reviewee_id)
);

-- Review ratings table
CREATE TABLE review_ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    review_id INT NOT NULL,
    category_id INT NOT NULL,
    rating_value INT NOT NULL,
    
    -- Foreign keys
    FOREIGN KEY (review_id) REFERENCES reviews(review_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES review_categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_review_ratings_value CHECK (rating_value >= 1 AND rating_value <= 5)
);

-- ==============================================
-- COMMUNICATION DOMAIN
-- ==============================================

-- Conversations table
CREATE TABLE conversations (
    conversation_id INT AUTO_INCREMENT PRIMARY KEY,
    participant1_id INT NOT NULL,
    participant2_id INT NOT NULL,
    booking_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_message_at DATETIME,
    
    -- Foreign keys
    FOREIGN KEY (participant1_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (participant2_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_conversations_different_participants CHECK (participant1_id != participant2_id)
);

-- Messages table
CREATE TABLE messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    conversation_id INT NOT NULL,
    sender_id INT NOT NULL,
    message_text TEXT NOT NULL,
    message_type VARCHAR(20) DEFAULT 'text',
    sent_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME,
    
    -- Foreign keys
    FOREIGN KEY (conversation_id) REFERENCES conversations(conversation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (sender_id) REFERENCES users(user_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_messages_type CHECK (message_type IN ('text', 'image', 'file', 'system'))
);

-- ==============================================
-- SYSTEM DOMAIN
-- ==============================================

-- Notifications table
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sent_at DATETIME,
    
    -- Foreign key
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_notifications_type CHECK (notification_type IN ('booking_confirmation', 'payment_received', 'payout_sent', 'review_received', 'message_received', 'system_alert'))
);

-- ==============================================
-- TRIPLE RELATIONSHIP JUNCTION TABLES
-- ==============================================

-- Triple Relationship 1: Property-Booking-Pricing
CREATE TABLE property_booking_pricing (
    pbp_id INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT NOT NULL,
    booking_id INT NOT NULL,
    pricing_id INT NOT NULL,
    applied_price DECIMAL(10,2) NOT NULL,
    pricing_rule_applied VARCHAR(100),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (pricing_id) REFERENCES property_pricing(pricing_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_pbp_applied_price CHECK (applied_price > 0)
);

-- Triple Relationship 2: User-Booking-Review
CREATE TABLE user_booking_review (
    ubr_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    booking_id INT NOT NULL,
    review_id INT NOT NULL,
    review_role VARCHAR(20) NOT NULL,
    interaction_type VARCHAR(50),
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (review_id) REFERENCES reviews(review_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_ubr_review_role CHECK (review_role IN ('reviewer', 'reviewee')),
    CONSTRAINT chk_ubr_interaction_type CHECK (interaction_type IN ('written', 'received', 'responded'))
);

-- Triple Relationship 3: Booking-Payment-Payout
CREATE TABLE booking_payment_payout (
    bpp_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    payment_id INT NOT NULL,
    payout_id INT,
    transaction_chain_status VARCHAR(20) NOT NULL,
    processing_notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign keys
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES payments(payment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (payout_id) REFERENCES payouts(payout_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- Constraints
    CONSTRAINT chk_bpp_transaction_status CHECK (transaction_chain_status IN ('pending', 'completed', 'failed'))
);

-- ==============================================
-- INDEXES FOR PERFORMANCE
-- ==============================================

-- User management indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_active ON users(is_active);
CREATE INDEX idx_guest_profiles_user_id ON guest_profiles(user_id);
CREATE INDEX idx_host_profiles_user_id ON host_profiles(user_id);

-- Property management indexes
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_type_id ON properties(property_type_id);
CREATE INDEX idx_properties_address_id ON properties(address_id);
CREATE INDEX idx_properties_active ON properties(is_active);
CREATE INDEX idx_property_amenity_links_property_id ON property_amenity_links(property_id);
CREATE INDEX idx_property_amenity_links_amenity_id ON property_amenity_links(amenity_id);
CREATE INDEX idx_property_photos_property_id ON property_photos(property_id);
CREATE INDEX idx_property_pricing_property_id ON property_pricing(property_id);
CREATE INDEX idx_property_pricing_dates ON property_pricing(start_date, end_date);

-- Booking system indexes
CREATE INDEX idx_bookings_guest_profile_id ON bookings(guest_profile_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_status_id ON bookings(booking_status_id);
CREATE INDEX idx_bookings_dates ON bookings(check_in_date, check_out_date);
CREATE INDEX idx_booking_modifications_booking_id ON booking_modifications(booking_id);

-- Financial system indexes
CREATE INDEX idx_payments_booking_id ON payments(booking_id);
CREATE INDEX idx_payments_method_id ON payments(payment_method_id);
CREATE INDEX idx_payments_status ON payments(payment_status);
CREATE INDEX idx_payouts_host_profile_id ON payouts(host_profile_id);
CREATE INDEX idx_payouts_booking_id ON payouts(booking_id);
CREATE INDEX idx_payouts_status ON payouts(payout_status);

-- Review system indexes
CREATE INDEX idx_reviews_reviewer_id ON reviews(reviewer_id);
CREATE INDEX idx_reviews_reviewee_id ON reviews(reviewee_id);
CREATE INDEX idx_reviews_booking_id ON reviews(booking_id);
CREATE INDEX idx_review_ratings_review_id ON review_ratings(review_id);
CREATE INDEX idx_review_ratings_category_id ON review_ratings(category_id);

-- Communication indexes
CREATE INDEX idx_conversations_participant1_id ON conversations(participant1_id);
CREATE INDEX idx_conversations_participant2_id ON conversations(participant2_id);
CREATE INDEX idx_conversations_booking_id ON conversations(booking_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_messages_sender_id ON messages(sender_id);

-- System indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(notification_type);
CREATE INDEX idx_notifications_read ON notifications(is_read);

-- Triple relationship indexes
CREATE INDEX idx_pbp_property_id ON property_booking_pricing(property_id);
CREATE INDEX idx_pbp_booking_id ON property_booking_pricing(booking_id);
CREATE INDEX idx_pbp_pricing_id ON property_booking_pricing(pricing_id);
CREATE INDEX idx_ubr_user_id ON user_booking_review(user_id);
CREATE INDEX idx_ubr_booking_id ON user_booking_review(booking_id);
CREATE INDEX idx_ubr_review_id ON user_booking_review(review_id);
CREATE INDEX idx_bpp_booking_id ON booking_payment_payout(booking_id);
CREATE INDEX idx_bpp_payment_id ON booking_payment_payout(payment_id);
CREATE INDEX idx_bpp_payout_id ON booking_payment_payout(payout_id);

-- ==============================================
-- DATABASE CREATION COMPLETE
-- ==============================================

-- Display completion message
SELECT 'Airbnb Database Created Successfully!' AS Status,
       '27 entities with 3 triple relationships and 1 recursive relationship' AS Description,
       NOW() AS Created_At;
