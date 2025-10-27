-- ==============================================
-- Airbnb Database Complete Installation Script - FIXED VERSION
-- Phase 2: Database Implementation
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 14/10/2025
-- ==============================================

-- This script installs the complete Airbnb database with all entities,
-- relationships, constraints, sample data, and test queries.

-- ==============================================
-- STEP 1: DATABASE CREATION
-- ==============================================

-- Database Creation
DROP DATABASE IF EXISTS airbnb_database;
CREATE DATABASE airbnb_database;
USE airbnb_database;

-- Display installation start
SELECT 'Starting Airbnb Database Installation...' AS Status,
       'Creating 27 entities with comprehensive relationships' AS Description,
       NOW() AS Started_At;

-- ==============================================
-- STEP 2: TABLE CREATION (All 27 Entities)
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
    CONSTRAINT chk_reviews_rating CHECK (rating >= 1 AND rating <= 5)
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
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE RESTRICT ON UPDATE CASCADE
    
    -- Note: Business rule for different participants enforced at application level
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
-- STEP 3: INDEXES FOR PERFORMANCE
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
-- STEP 4: SAMPLE DATA INSERTION
-- ==============================================

-- Countries data
INSERT INTO countries (country_name, country_code, currency_code, phone_code) VALUES
('United States', 'USA', 'USD', '+1'),
('United Kingdom', 'GBR', 'GBP', '+44'),
('Germany', 'DEU', 'EUR', '+49'),
('France', 'FRA', 'EUR', '+33'),
('Spain', 'ESP', 'EUR', '+34'),
('Italy', 'ITA', 'EUR', '+39'),
('Canada', 'CAN', 'CAD', '+1'),
('Australia', 'AUS', 'AUD', '+61'),
('Japan', 'JPN', 'JPY', '+81'),
('Brazil', 'BRA', 'BRL', '+55'),
('Mexico', 'MEX', 'MXN', '+52'),
('Netherlands', 'NLD', 'EUR', '+31'),
('Switzerland', 'CHE', 'CHF', '+41'),
('Sweden', 'SWE', 'SEK', '+46'),
('Norway', 'NOR', 'NOK', '+47'),
('Denmark', 'DNK', 'DKK', '+45'),
('Finland', 'FIN', 'EUR', '+358'),
('Poland', 'POL', 'PLN', '+48'),
('Czech Republic', 'CZE', 'CZK', '+420'),
('Austria', 'AUT', 'EUR', '+43'),
('Belgium', 'BEL', 'EUR', '+32'),
('Portugal', 'PRT', 'EUR', '+351'),
('Greece', 'GRC', 'EUR', '+30'),
('Turkey', 'TUR', 'TRY', '+90'),
('Russia', 'RUS', 'RUB', '+7');

-- Cities data
INSERT INTO cities (city_name, state_province, country_id, timezone, population) VALUES
('New York', 'New York', 1, 'America/New_York', 8336817),
('Los Angeles', 'California', 1, 'America/Los_Angeles', 3979576),
('London', 'England', 2, 'Europe/London', 8982000),
('Berlin', 'Berlin', 3, 'Europe/Berlin', 3669491),
('Paris', 'Île-de-France', 4, 'Europe/Paris', 2161000),
('Madrid', 'Madrid', 5, 'Europe/Madrid', 3223334),
('Rome', 'Lazio', 6, 'Europe/Rome', 2873000),
('Toronto', 'Ontario', 7, 'America/Toronto', 2930000),
('Sydney', 'New South Wales', 8, 'Australia/Sydney', 5312000),
('Tokyo', 'Tokyo', 9, 'Asia/Tokyo', 13960000),
('São Paulo', 'São Paulo', 10, 'America/Sao_Paulo', 12300000),
('Mexico City', 'Mexico City', 11, 'America/Mexico_City', 9209000),
('Amsterdam', 'North Holland', 12, 'Europe/Amsterdam', 872680),
('Zurich', 'Zurich', 13, 'Europe/Zurich', 415367),
('Stockholm', 'Stockholm', 14, 'Europe/Stockholm', 975551),
('Oslo', 'Oslo', 15, 'Europe/Oslo', 697010),
('Copenhagen', 'Capital Region', 16, 'Europe/Copenhagen', 632340),
('Helsinki', 'Uusimaa', 17, 'Europe/Helsinki', 656250),
('Warsaw', 'Masovian', 18, 'Europe/Warsaw', 1790658),
('Prague', 'Prague', 19, 'Europe/Prague', 1308632),
('Vienna', 'Vienna', 20, 'Europe/Vienna', 1911191),
('Brussels', 'Brussels', 21, 'Europe/Brussels', 1211035),
('Lisbon', 'Lisbon', 22, 'Europe/Lisbon', 547733),
('Athens', 'Attica', 23, 'Europe/Athens', 664046),
('Istanbul', 'Istanbul', 24, 'Europe/Istanbul', 15519267);

-- Addresses data
INSERT INTO addresses (street_address, city_id, postal_code, latitude, longitude, country_id) VALUES
('123 Broadway', 1, '10001', 40.7589, -73.9851, 1),
('456 Sunset Blvd', 2, '90028', 34.0522, -118.2437, 1),
('789 Oxford Street', 3, 'W1C 1JN', 51.5074, -0.1278, 2),
('321 Unter den Linden', 4, '10117', 52.5200, 13.4050, 3),
('654 Champs-Élysées', 5, '75008', 48.8566, 2.3522, 4),
('987 Gran Vía', 6, '28013', 40.4168, -3.7038, 5),
('147 Via del Corso', 7, '00186', 41.9028, 12.4964, 6),
('258 Yonge Street', 8, 'M5B 2L9', 43.6532, -79.3832, 7),
('369 George Street', 9, '2000', -33.8688, 151.2093, 8),
('741 Ginza', 10, '104-0061', 35.6762, 139.6503, 9),
('852 Avenida Paulista', 11, '01310-100', -23.5505, -46.6333, 10),
('963 Reforma', 12, '06600', 19.4326, -99.1332, 11),
('159 Damrak', 13, '1012 LP', 52.3676, 4.9041, 12),
('357 Bahnhofstrasse', 14, '8001', 47.3769, 8.5417, 13),
('468 Drottninggatan', 15, '111 51', 59.3293, 18.0686, 14),
('579 Karl Johans gate', 16, '0154', 59.9139, 10.7522, 15),
('680 Strøget', 17, '1160', 55.6761, 12.5683, 16),
('791 Mannerheimintie', 18, '00100', 60.1699, 24.9384, 17),
('802 Krakowskie Przedmieście', 19, '00-071', 52.2297, 21.0122, 18),
('913 Wenceslas Square', 20, '110 00', 50.0755, 14.4378, 19),
('024 Kärntner Straße', 21, '1010', 48.2082, 16.3738, 20),
('135 Grand Place', 22, '1000', 50.8503, 4.3517, 21),
('246 Rua Augusta', 23, '1100-053', 38.7223, -9.1393, 22),
('357 Syntagma Square', 24, '105 63', 37.9755, 23.7348, 23),
('468 Istiklal Caddesi', 25, '34430', 41.0082, 28.9784, 24);

-- Users data
INSERT INTO users (email, password_hash, first_name, last_name, phone, date_of_birth, is_guest, is_host, is_admin, created_at, is_active) VALUES
('john.doe@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'John', 'Doe', '+1234567890', '1985-03-15', TRUE, TRUE, FALSE, '2023-01-15 10:30:00', TRUE),
('jane.smith@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Jane', 'Smith', '+1234567891', '1990-07-22', TRUE, FALSE, FALSE, '2023-02-20 14:45:00', TRUE),
('mike.johnson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Mike', 'Johnson', '+1234567892', '1988-11-08', TRUE, TRUE, FALSE, '2023-03-10 09:15:00', TRUE),
('sarah.wilson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Sarah', 'Wilson', '+1234567893', '1992-05-12', TRUE, FALSE, FALSE, '2023-04-05 16:20:00', TRUE),
('david.brown@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'David', 'Brown', '+1234567894', '1987-09-30', TRUE, TRUE, FALSE, '2023-05-18 11:30:00', TRUE),
('lisa.garcia@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Lisa', 'Garcia', '+1234567895', '1991-12-03', TRUE, FALSE, FALSE, '2023-06-12 13:45:00', TRUE),
('robert.miller@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Robert', 'Miller', '+1234567896', '1986-04-18', TRUE, TRUE, FALSE, '2023-07-08 08:00:00', TRUE),
('emily.davis@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Emily', 'Davis', '+1234567897', '1993-08-25', TRUE, FALSE, FALSE, '2023-08-14 15:30:00', TRUE),
('james.rodriguez@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'James', 'Rodriguez', '+1234567898', '1989-01-14', TRUE, TRUE, FALSE, '2023-09-22 12:15:00', TRUE),
('maria.martinez@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Maria', 'Martinez', '+1234567899', '1994-06-07', TRUE, FALSE, FALSE, '2023-10-30 17:45:00', TRUE),
('admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Admin', 'User', '+1234567800', '1980-01-01', FALSE, FALSE, TRUE, '2023-01-01 00:00:00', TRUE),
('alex.taylor@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Alex', 'Taylor', '+1234567801', '1995-03-28', TRUE, TRUE, FALSE, '2023-11-15 10:20:00', TRUE),
('sophie.anderson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Sophie', 'Anderson', '+1234567802', '1996-10-11', TRUE, FALSE, FALSE, '2023-12-03 14:10:00', TRUE),
('chris.thomas@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Chris', 'Thomas', '+1234567803', '1984-07-16', TRUE, TRUE, FALSE, '2024-01-20 09:30:00', TRUE),
('olivia.jackson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Olivia', 'Jackson', '+1234567804', '1997-02-09', TRUE, FALSE, FALSE, '2024-02-14 16:45:00', TRUE),
('daniel.white@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Daniel', 'White', '+1234567805', '1983-11-23', TRUE, TRUE, FALSE, '2024-03-08 11:00:00', TRUE),
('isabella.harris@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Isabella', 'Harris', '+1234567806', '1998-05-04', TRUE, FALSE, FALSE, '2024-04-12 13:25:00', TRUE),
('matthew.martin@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Matthew', 'Martin', '+1234567807', '1982-09-17', TRUE, TRUE, FALSE, '2024-05-25 08:50:00', TRUE),
('ava.thompson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Ava', 'Thompson', '+1234567808', '1999-12-31', TRUE, FALSE, FALSE, '2024-06-18 15:15:00', TRUE),
('william.garcia@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'William', 'Garcia', '+1234567809', '1981-04-26', TRUE, TRUE, FALSE, '2024-07-30 12:40:00', TRUE),
('charlotte.martinez@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Charlotte', 'Martinez', '+1234567810', '2000-08-13', TRUE, FALSE, FALSE, '2024-08-22 17:05:00', TRUE),
('benjamin.robinson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Benjamin', 'Robinson', '+1234567811', '1980-06-20', TRUE, TRUE, FALSE, '2024-09-15 10:30:00', TRUE),
('amelia.clark@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Amelia', 'Clark', '+1234567812', '2001-01-08', TRUE, FALSE, FALSE, '2024-10-28 14:20:00', TRUE),
('lucas.rodriguez@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Lucas', 'Rodriguez', '+1234567813', '1979-03-11', TRUE, TRUE, FALSE, '2024-11-10 09:45:00', TRUE),
('mia.lewis@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj4J/8KzKz2', 'Mia', 'Lewis', '+1234567814', '2002-07-24', TRUE, FALSE, FALSE, '2024-12-05 16:00:00', TRUE);

-- ==============================================
-- STEP 5: VERIFICATION QUERIES
-- ==============================================

-- Display completion message
SELECT 'Airbnb Database Installation Complete!' AS Status,
       '27 entities with 3 triple relationships and 1 recursive relationship' AS Description,
       'All tables created with sample data and constraints' AS Details,
       NOW() AS Completed_At;

-- Show table counts
SELECT 
    TABLE_NAME,
    TABLE_ROWS
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'airbnb_database'
ORDER BY TABLE_ROWS DESC;

-- Show foreign key relationships
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'airbnb_database'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;
-- ==============================================
-- Airbnb Database Complete Sample Data - FIXED VERSION
-- Phase 2: Database Implementation
-- Course: Build a Data Mart in SQL (DLBDSPBDM01)
-- Student: Nikolas Daniel Vincenti
-- Date: 14/10/2025
-- ==============================================

USE airbnb_database;

-- ==============================================
-- USER PROFILES DATA
-- ==============================================

INSERT INTO user_profiles (user_id, bio, profile_picture, language_preference, currency_preference, timezone, notification_settings) VALUES
(1, 'Experienced traveler and host from New York', 'https://example.com/profiles/john.jpg', 'en', 'USD', 'America/New_York', '{"email": true, "sms": true, "push": true}'),
(2, 'Love exploring new cities and meeting people', 'https://example.com/profiles/jane.jpg', 'en', 'USD', 'America/New_York', '{"email": true, "sms": false, "push": true}'),
(3, 'Host and guest with properties in multiple cities', 'https://example.com/profiles/mike.jpg', 'en', 'USD', 'America/Los_Angeles', '{"email": true, "sms": true, "push": true}'),
(4, 'Digital nomad who loves unique accommodations', 'https://example.com/profiles/sarah.jpg', 'en', 'USD', 'America/New_York', '{"email": true, "sms": false, "push": false}'),
(5, 'Luxury property host and frequent traveler', 'https://example.com/profiles/david.jpg', 'en', 'USD', 'America/Los_Angeles', '{"email": true, "sms": true, "push": true}'),
(6, 'Budget-conscious traveler seeking authentic experiences', 'https://example.com/profiles/lisa.jpg', 'en', 'USD', 'America/New_York', '{"email": true, "sms": false, "push": true}'),
(7, 'Premium host with luxury properties worldwide', 'https://example.com/profiles/robert.jpg', 'en', 'USD', 'America/Los_Angeles', '{"email": true, "sms": true, "push": true}'),
(8, 'Student traveler on a budget', 'https://example.com/profiles/emily.jpg', 'en', 'USD', 'America/New_York', '{"email": true, "sms": false, "push": false}'),
(9, 'Business traveler and property investor', 'https://example.com/profiles/james.jpg', 'en', 'USD', 'America/Los_Angeles', '{"email": true, "sms": true, "push": true}'),
(10, 'Family traveler with young children', 'https://example.com/profiles/maria.jpg', 'en', 'USD', 'America/New_York', '{"email": true, "sms": false, "push": true}');

-- ==============================================
-- GUEST PROFILES DATA
-- ==============================================

INSERT INTO guest_profiles (user_id, preferred_price_range, preferred_property_types, travel_preferences, guest_verification_status, verification_date, created_at) VALUES
(1, '$100-300', '["apartment", "house"]', '{"pets": false, "smoking": false, "accessibility": true}', 'fully_verified', '2023-01-20 10:00:00', '2023-01-15 10:30:00'),
(2, '$50-150', '["apartment", "studio"]', '{"pets": false, "smoking": false, "accessibility": false}', 'email_verified', '2023-02-25 14:00:00', '2023-02-20 14:45:00'),
(3, '$200-500', '["house", "villa"]', '{"pets": true, "smoking": false, "accessibility": true}', 'fully_verified', '2023-03-15 09:00:00', '2023-03-10 09:15:00'),
(4, '$30-100', '["studio", "apartment"]', '{"pets": false, "smoking": false, "accessibility": false}', 'phone_verified', '2023-04-10 16:00:00', '2023-04-05 16:20:00'),
(5, '$150-400', '["house", "apartment"]', '{"pets": true, "smoking": false, "accessibility": true}', 'fully_verified', '2023-05-25 11:00:00', '2023-05-18 11:30:00'),
(6, '$40-120', '["studio", "apartment"]', '{"pets": false, "smoking": false, "accessibility": false}', 'email_verified', '2023-06-17 13:00:00', '2023-06-12 13:45:00'),
(7, '$100-300', '["apartment", "house"]', '{"pets": false, "smoking": false, "accessibility": true}', 'fully_verified', '2023-07-13 08:00:00', '2023-07-08 08:00:00'),
(8, '$50-150', '["apartment", "studio"]', '{"pets": false, "smoking": false, "accessibility": false}', 'phone_verified', '2023-08-19 15:00:00', '2023-08-14 15:30:00'),
(9, '$200-500', '["house", "villa"]', '{"pets": true, "smoking": false, "accessibility": true}', 'fully_verified', '2023-09-27 12:00:00', '2023-09-22 12:15:00'),
(10, '$80-200', '["house", "apartment"]', '{"pets": false, "smoking": false, "accessibility": true}', 'email_verified', '2023-10-15 16:00:00', '2023-10-10 16:00:00');

-- ==============================================
-- HOST PROFILES DATA
-- ==============================================

INSERT INTO host_profiles (user_id, host_verification_status, verification_date, host_since, response_rate, response_time_hours, acceptance_rate, host_rating, total_properties, superhost_status, business_name, business_registration, created_at) VALUES
(1, 'verified', '2023-01-25 10:00:00', '2023-01-15 10:30:00', 95.50, 2, 88.75, 4.85, 3, TRUE, 'Downtown Properties LLC', 'LLC-2023-001', '2023-01-15 10:30:00'),
(3, 'verified', '2023-03-15 09:00:00', '2023-03-10 09:15:00', 98.25, 1, 92.30, 4.92, 5, TRUE, 'Coastal Rentals Inc', 'INC-2023-002', '2023-03-10 09:15:00'),
(5, 'verified', '2023-05-25 11:00:00', '2023-05-18 11:30:00', 89.75, 4, 85.20, 4.78, 2, FALSE, 'Mountain View Properties', 'PROP-2023-003', '2023-05-18 11:30:00'),
(7, 'verified', '2023-07-13 08:00:00', '2023-07-08 08:00:00', 96.80, 1, 94.15, 4.88, 4, TRUE, 'Luxury Stays Co', 'LUX-2023-004', '2023-07-08 08:00:00'),
(9, 'verified', '2023-09-27 12:00:00', '2023-09-22 12:15:00', 91.30, 3, 87.60, 4.65, 1, FALSE, 'Urban Living Rentals', 'URB-2023-005', '2023-09-22 12:15:00'),
(12, 'verified', '2023-11-20 10:00:00', '2023-11-15 10:20:00', 97.45, 2, 90.85, 4.82, 3, TRUE, 'City Center Properties', 'CCP-2023-006', '2023-11-15 10:20:00'),
(14, 'verified', '2024-01-25 09:00:00', '2024-01-20 09:30:00', 93.20, 2, 89.40, 4.71, 2, FALSE, 'Suburban Rentals', 'SUB-2024-007', '2024-01-20 09:30:00'),
(16, 'verified', '2024-03-13 11:00:00', '2024-03-08 11:00:00', 88.90, 5, 83.25, 4.58, 1, FALSE, 'Historic Homes LLC', 'HIST-2024-008', '2024-03-08 11:00:00'),
(18, 'verified', '2024-05-30 08:00:00', '2024-05-25 08:50:00', 95.15, 1, 91.70, 4.79, 4, TRUE, 'Modern Spaces Inc', 'MOD-2024-009', '2024-05-25 08:50:00'),
(20, 'verified', '2024-07-30 12:00:00', '2024-07-30 12:40:00', 90.65, 3, 86.80, 4.62, 2, FALSE, 'Garden District Rentals', 'GDR-2024-010', '2024-07-30 12:40:00'),
(22, 'verified', '2024-09-20 10:00:00', '2024-09-15 10:30:00', 96.40, 2, 93.15, 4.86, 3, TRUE, 'Executive Suites Co', 'EXEC-2024-011', '2024-09-15 10:30:00'),
(24, 'verified', '2024-11-15 09:00:00', '2024-11-10 09:45:00', 87.80, 4, 82.50, 4.54, 1, FALSE, 'Riverside Properties', 'RIV-2024-012', '2024-11-10 09:45:00');

-- ==============================================
-- USER VERIFICATION DATA
-- ==============================================

INSERT INTO user_verification (user_id, verification_type, document_type, document_number, verification_status, verified_at, expires_at) VALUES
(1, 'identity', 'passport', 'US123456789', 'verified', '2023-01-20 10:00:00', '2028-01-20 10:00:00'),
(1, 'phone', 'utility_bill', 'UTIL123456789', 'verified', '2023-01-15 10:30:00', '2026-01-15 10:30:00'),
(2, 'identity', 'drivers_license', 'DL987654321', 'verified', '2023-02-25 14:00:00', '2028-02-25 14:00:00'),
(3, 'identity', 'passport', 'US987654321', 'verified', '2023-03-15 09:00:00', '2028-03-15 09:00:00'),
(4, 'phone', 'utility_bill', 'UTIL987654321', 'verified', '2023-04-10 16:00:00', '2026-04-10 16:00:00'),
(5, 'identity', 'passport', 'US456789123', 'verified', '2023-05-25 11:00:00', '2028-05-25 11:00:00'),
(6, 'phone', 'utility_bill', 'UTIL456789123', 'verified', '2023-06-17 13:00:00', '2026-06-17 13:00:00'),
(7, 'identity', 'passport', 'US789123456', 'verified', '2023-07-13 08:00:00', '2028-07-13 08:00:00'),
(8, 'phone', 'utility_bill', 'UTIL789123456', 'verified', '2023-08-19 15:00:00', '2026-08-19 15:00:00'),
(9, 'identity', 'passport', 'US321654987', 'verified', '2023-09-27 12:00:00', '2028-09-27 12:00:00');

-- ==============================================
-- USER PREFERENCES DATA
-- ==============================================

INSERT INTO user_preferences (user_id, preference_key, preference_value, updated_at) VALUES
(1, 'email_notifications', '{"booking_updates": true, "marketing": false, "security": true}', '2023-01-15 10:30:00'),
(1, 'privacy_settings', '{"profile_visibility": "public", "show_phone": false}', '2023-01-15 10:30:00'),
(2, 'email_notifications', '{"booking_updates": true, "marketing": true, "security": true}', '2023-02-20 14:45:00'),
(3, 'privacy_settings', '{"profile_visibility": "public", "show_phone": true}', '2023-03-10 09:15:00'),
(4, 'email_notifications', '{"booking_updates": false, "marketing": false, "security": true}', '2023-04-05 16:20:00'),
(5, 'privacy_settings', '{"profile_visibility": "private", "show_phone": false}', '2023-05-18 11:30:00'),
(6, 'email_notifications', '{"booking_updates": true, "marketing": true, "security": false}', '2023-06-12 13:45:00'),
(7, 'privacy_settings', '{"profile_visibility": "public", "show_phone": true}', '2023-07-08 08:00:00'),
(8, 'email_notifications', '{"booking_updates": true, "marketing": false, "security": true}', '2023-08-14 15:30:00'),
(9, 'privacy_settings', '{"profile_visibility": "public", "show_phone": false}', '2023-09-22 12:15:00');

-- ==============================================
-- PROPERTY TYPES DATA
-- ==============================================

INSERT INTO property_types (type_name, description, icon_url) VALUES
('Apartment', 'Self-contained residential unit in a building', 'https://example.com/icons/apartment.svg'),
('House', 'Detached residential building', 'https://example.com/icons/house.svg'),
('Villa', 'Luxury detached house with garden', 'https://example.com/icons/villa.svg'),
('Condo', 'Individually owned unit in a building', 'https://example.com/icons/condo.svg'),
('Studio', 'Single room with kitchen and bathroom', 'https://example.com/icons/studio.svg'),
('Loft', 'Open-plan living space in converted building', 'https://example.com/icons/loft.svg'),
('Townhouse', 'Multi-story house sharing walls with neighbors', 'https://example.com/icons/townhouse.svg'),
('Cabin', 'Small house in rural or remote area', 'https://example.com/icons/cabin.svg'),
('Castle', 'Historic fortified building', 'https://example.com/icons/castle.svg'),
('Treehouse', 'Structure built in or around trees', 'https://example.com/icons/treehouse.svg');

-- ==============================================
-- PROPERTY AMENITIES DATA
-- ==============================================

INSERT INTO property_amenities (amenity_name, amenity_category, icon_url, description) VALUES
('WiFi', 'Internet', 'https://example.com/icons/wifi.svg', 'High-speed internet connection'),
('Kitchen', 'Kitchen', 'https://example.com/icons/kitchen.svg', 'Fully equipped kitchen'),
('Parking', 'Parking', 'https://example.com/icons/parking.svg', 'Free parking on premises'),
('Pool', 'Pool', 'https://example.com/icons/pool.svg', 'Private or shared swimming pool'),
('Gym', 'Gym', 'https://example.com/icons/gym.svg', 'Fitness center or gym equipment'),
('Hot tub', 'Pool', 'https://example.com/icons/hot-tub.svg', 'Private hot tub or jacuzzi'),
('Fireplace', 'Heating', 'https://example.com/icons/fireplace.svg', 'Wood-burning or gas fireplace'),
('Air conditioning', 'Heating', 'https://example.com/icons/ac.svg', 'Central air conditioning'),
('Heating', 'Heating', 'https://example.com/icons/heating.svg', 'Central heating system'),
('Washer', 'Laundry', 'https://example.com/icons/washer.svg', 'Washing machine available'),
('Dryer', 'Laundry', 'https://example.com/icons/dryer.svg', 'Clothes dryer available'),
('TV', 'Entertainment', 'https://example.com/icons/tv.svg', 'Television with cable/satellite'),
('Laptop friendly workspace', 'Work', 'https://example.com/icons/laptop.svg', 'Dedicated workspace for remote work'),
('Pets allowed', 'Pets', 'https://example.com/icons/pets.svg', 'Pets are welcome'),
('Smoking allowed', 'Smoking', 'https://example.com/icons/smoking.svg', 'Smoking is permitted'),
('Wheelchair accessible', 'Accessibility', 'https://example.com/icons/wheelchair.svg', 'Wheelchair accessible entrance'),
('Elevator', 'Accessibility', 'https://example.com/icons/elevator.svg', 'Elevator in building'),
('Balcony', 'Outdoor', 'https://example.com/icons/balcony.svg', 'Private balcony or terrace'),
('Garden', 'Outdoor', 'https://example.com/icons/garden.svg', 'Private garden or yard'),
('BBQ grill', 'Outdoor', 'https://example.com/icons/bbq.svg', 'Barbecue grill available');

-- ==============================================
-- PROPERTIES DATA (FIXED: Using host_profile_id instead of host_id)
-- ==============================================

INSERT INTO properties (host_id, property_type_id, title, description, address_id, max_guests, bedrooms, bathrooms, size_sqm, created_at, is_active) VALUES
(1, 1, 'Modern Downtown Apartment', 'Stylish 2-bedroom apartment in the heart of Manhattan with stunning city views', 1, 4, 2, 2.0, 85.5, '2023-01-20 10:00:00', TRUE),
(1, 2, 'Cozy Brooklyn House', 'Charming 3-bedroom house in trendy Brooklyn neighborhood', 2, 6, 3, 2.5, 120.0, '2023-02-15 14:30:00', TRUE),
(1, 3, 'Luxury Hamptons Villa', 'Exclusive beachfront villa with private pool and ocean views', 3, 8, 4, 3.0, 250.0, '2023-03-10 09:15:00', TRUE),
(2, 1, 'Historic London Flat', 'Beautiful Victorian apartment near Hyde Park', 4, 3, 1, 1.0, 65.0, '2023-04-05 16:20:00', TRUE),
(2, 2, 'Traditional English Cottage', 'Quaint cottage in the English countryside', 5, 4, 2, 1.5, 90.0, '2023-05-18 11:30:00', TRUE),
(3, 1, 'Berlin City Center Loft', 'Modern loft in trendy Kreuzberg district', 6, 2, 1, 1.0, 55.0, '2023-06-12 13:45:00', TRUE),
(3, 2, 'Parisian Apartment', 'Elegant apartment near the Eiffel Tower', 7, 4, 2, 1.0, 75.0, '2023-07-08 08:00:00', TRUE),
(3, 3, 'Tuscany Villa', 'Renaissance villa with vineyard views', 8, 10, 5, 4.0, 300.0, '2023-08-14 15:30:00', TRUE),
(4, 1, 'Madrid Studio', 'Compact studio in the heart of Madrid', 9, 2, 0, 1.0, 35.0, '2023-09-22 12:15:00', TRUE),
(4, 2, 'Barcelona Townhouse', 'Traditional townhouse in Gothic Quarter', 10, 6, 3, 2.0, 110.0, '2023-10-30 17:45:00', TRUE),
(5, 1, 'Rome Apartment', 'Historic apartment near the Colosseum', 11, 3, 1, 1.0, 60.0, '2023-11-15 10:20:00', TRUE),
(5, 2, 'Toronto House', 'Modern house in trendy Toronto neighborhood', 12, 5, 3, 2.5, 140.0, '2023-12-03 14:10:00', TRUE),
(6, 1, 'Sydney Harbor View', 'Apartment with stunning harbor views', 13, 4, 2, 2.0, 80.0, '2024-01-20 09:30:00', TRUE),
(6, 2, 'Melbourne House', 'Victorian house in Fitzroy', 14, 6, 3, 2.0, 130.0, '2024-02-14 16:45:00', TRUE),
(7, 1, 'Tokyo Studio', 'Compact studio in Shibuya district', 15, 2, 0, 1.0, 25.0, '2024-03-08 11:00:00', TRUE),
(7, 2, 'Kyoto Traditional House', 'Traditional machiya house in historic district', 16, 4, 2, 1.0, 70.0, '2024-04-12 13:25:00', TRUE),
(8, 1, 'São Paulo Apartment', 'Modern apartment in Vila Madalena', 17, 3, 1, 1.0, 65.0, '2024-05-25 08:50:00', TRUE),
(8, 2, 'Rio Beach House', 'Beachfront house in Copacabana', 18, 6, 3, 2.0, 120.0, '2024-06-18 15:15:00', TRUE),
(9, 1, 'Mexico City Loft', 'Industrial loft in Roma Norte', 19, 3, 1, 1.0, 70.0, '2024-07-30 12:40:00', TRUE),
(9, 2, 'Amsterdam Canal House', 'Historic house on the canal', 20, 5, 2, 1.5, 100.0, '2024-08-22 17:05:00', TRUE);

-- ==============================================
-- PROPERTY AMENITY LINKS DATA
-- ==============================================

INSERT INTO property_amenity_links (property_id, amenity_id, is_available, additional_info) VALUES
(1, 1, TRUE, 'High-speed fiber internet'),
(1, 2, TRUE, 'Fully equipped modern kitchen'),
(1, 3, TRUE, 'Street parking available'),
(1, 4, FALSE, NULL),
(1, 5, TRUE, 'Building gym on 3rd floor'),
(2, 1, TRUE, 'WiFi included'),
(2, 2, TRUE, 'Country kitchen with Aga'),
(2, 3, TRUE, 'Driveway parking for 2 cars'),
(2, 4, TRUE, 'Private pool in garden'),
(2, 5, FALSE, NULL),
(3, 1, TRUE, 'Premium WiFi package'),
(3, 2, TRUE, 'Chef\'s kitchen with island'),
(3, 3, TRUE, 'Garage parking for 4 cars'),
(3, 4, TRUE, 'Infinity pool with ocean view'),
(3, 5, TRUE, 'Private gym with ocean view'),
(4, 1, TRUE, 'Standard WiFi'),
(4, 2, TRUE, 'Compact kitchenette'),
(4, 3, FALSE, 'No parking available'),
(4, 4, FALSE, NULL),
(4, 5, FALSE, NULL),
(5, 1, TRUE, 'Rural broadband'),
(5, 2, TRUE, 'Traditional English kitchen'),
(5, 3, TRUE, 'Private driveway'),
(5, 4, FALSE, NULL),
(5, 5, FALSE, NULL);

-- ==============================================
-- PROPERTY PHOTOS DATA
-- ==============================================

INSERT INTO property_photos (property_id, photo_url, caption, is_primary, display_order, uploaded_at) VALUES
(1, 'https://example.com/photos/prop1_1.jpg', 'Living room with city view', TRUE, 1, '2023-01-20 10:00:00'),
(1, 'https://example.com/photos/prop1_2.jpg', 'Modern kitchen', FALSE, 2, '2023-01-20 10:05:00'),
(1, 'https://example.com/photos/prop1_3.jpg', 'Master bedroom', FALSE, 3, '2023-01-20 10:10:00'),
(2, 'https://example.com/photos/prop2_1.jpg', 'Front facade of house', TRUE, 1, '2023-02-15 14:30:00'),
(2, 'https://example.com/photos/prop2_2.jpg', 'Backyard with garden', FALSE, 2, '2023-02-15 14:35:00'),
(2, 'https://example.com/photos/prop2_3.jpg', 'Living room', FALSE, 3, '2023-02-15 14:40:00'),
(3, 'https://example.com/photos/prop3_1.jpg', 'Ocean view from pool', TRUE, 1, '2023-03-10 09:15:00'),
(3, 'https://example.com/photos/prop3_2.jpg', 'Luxury kitchen', FALSE, 2, '2023-03-10 09:20:00'),
(3, 'https://example.com/photos/prop3_3.jpg', 'Master suite', FALSE, 3, '2023-03-10 09:25:00'),
(4, 'https://example.com/photos/prop4_1.jpg', 'Victorian living room', TRUE, 1, '2023-04-05 16:20:00'),
(4, 'https://example.com/photos/prop4_2.jpg', 'Period kitchen', FALSE, 2, '2023-04-05 16:25:00'),
(5, 'https://example.com/photos/prop5_1.jpg', 'Cottage exterior', TRUE, 1, '2023-05-18 11:30:00'),
(5, 'https://example.com/photos/prop5_2.jpg', 'Cozy living room', FALSE, 2, '2023-05-18 11:35:00'),
(6, 'https://example.com/photos/prop6_1.jpg', 'Industrial loft space', TRUE, 1, '2023-06-12 13:45:00'),
(6, 'https://example.com/photos/prop6_2.jpg', 'Modern kitchen', FALSE, 2, '2023-06-12 13:50:00'),
(7, 'https://example.com/photos/prop7_1.jpg', 'Eiffel Tower view', TRUE, 1, '2023-07-08 08:00:00'),
(7, 'https://example.com/photos/prop7_2.jpg', 'Parisian living room', FALSE, 2, '2023-07-08 08:05:00'),
(8, 'https://example.com/photos/prop8_1.jpg', 'Villa exterior', TRUE, 1, '2023-08-14 15:30:00'),
(8, 'https://example.com/photos/prop8_2.jpg', 'Vineyard views', FALSE, 2, '2023-08-14 15:35:00'),
(9, 'https://example.com/photos/prop9_1.jpg', 'Compact studio', TRUE, 1, '2023-09-22 12:15:00');

-- ==============================================
-- PROPERTY PRICING DATA
-- ==============================================

INSERT INTO property_pricing (property_id, start_date, end_date, base_price_per_night, weekend_price_per_night, weekly_discount_percentage, monthly_discount_percentage, minimum_stay_nights, maximum_stay_nights, is_available, created_at) VALUES
(1, '2024-01-01', '2024-12-31', 150.00, 180.00, 10.00, 20.00, 2, 30, TRUE, '2023-01-20 10:00:00'),
(2, '2024-01-01', '2024-12-31', 120.00, 150.00, 15.00, 25.00, 3, 14, TRUE, '2023-02-15 14:30:00'),
(3, '2024-01-01', '2024-12-31', 500.00, 600.00, 5.00, 15.00, 7, 30, TRUE, '2023-03-10 09:15:00'),
(4, '2024-01-01', '2024-12-31', 80.00, 100.00, 10.00, 20.00, 2, 7, TRUE, '2023-04-05 16:20:00'),
(5, '2024-01-01', '2024-12-31', 100.00, 120.00, 12.00, 22.00, 2, 14, TRUE, '2023-05-18 11:30:00'),
(6, '2024-01-01', '2024-12-31', 60.00, 80.00, 8.00, 18.00, 1, 7, TRUE, '2023-06-12 13:45:00'),
(7, '2024-01-01', '2024-12-31', 90.00, 110.00, 10.00, 20.00, 2, 14, TRUE, '2023-07-08 08:00:00'),
(8, '2024-01-01', '2024-12-31', 300.00, 350.00, 8.00, 18.00, 5, 21, TRUE, '2023-08-14 15:30:00'),
(9, '2024-01-01', '2024-12-31', 45.00, 55.00, 5.00, 15.00, 1, 7, TRUE, '2023-09-22 12:15:00'),
(10, '2024-01-01', '2024-12-31', 110.00, 130.00, 12.00, 22.00, 2, 14, TRUE, '2023-10-30 17:45:00'),
(11, '2024-01-01', '2024-12-31', 70.00, 85.00, 8.00, 18.00, 2, 7, TRUE, '2023-11-15 10:20:00'),
(12, '2024-01-01', '2024-12-31', 130.00, 160.00, 10.00, 20.00, 3, 14, TRUE, '2023-12-03 14:10:00'),
(13, '2024-01-01', '2024-12-31', 95.00, 115.00, 10.00, 20.00, 2, 14, TRUE, '2024-01-20 09:30:00'),
(14, '2024-01-01', '2024-12-31', 140.00, 170.00, 12.00, 22.00, 3, 21, TRUE, '2024-02-14 16:45:00'),
(15, '2024-01-01', '2024-12-31', 35.00, 45.00, 5.00, 15.00, 1, 7, TRUE, '2024-03-08 11:00:00'),
(16, '2024-01-01', '2024-12-31', 85.00, 105.00, 10.00, 20.00, 2, 14, TRUE, '2024-04-12 13:25:00'),
(17, '2024-01-01', '2024-12-31', 55.00, 70.00, 8.00, 18.00, 1, 7, TRUE, '2024-05-25 08:50:00'),
(18, '2024-01-01', '2024-12-31', 160.00, 190.00, 12.00, 22.00, 3, 14, TRUE, '2024-06-18 15:15:00'),
(19, '2024-01-01', '2024-12-31', 75.00, 90.00, 8.00, 18.00, 2, 7, TRUE, '2024-07-30 12:40:00'),
(20, '2024-01-01', '2024-12-31', 125.00, 150.00, 10.00, 20.00, 2, 14, TRUE, '2024-08-22 17:05:00');

-- ==============================================
-- BOOKING STATUS DATA
-- ==============================================

INSERT INTO booking_status (status_name, description, is_active) VALUES
('pending', 'Booking request submitted, awaiting host approval', TRUE),
('confirmed', 'Booking confirmed by host', TRUE),
('cancelled', 'Booking cancelled by guest or host', TRUE),
('completed', 'Stay completed successfully', TRUE),
('no_show', 'Guest did not arrive for booking', TRUE),
('refunded', 'Booking cancelled and refunded', TRUE);

-- ==============================================
-- BOOKINGS DATA (FIXED: Using realistic dates and proper guest_profile_id)
-- ==============================================

INSERT INTO bookings (guest_profile_id, user_id, property_id, booking_status_id, check_in_date, check_out_date, number_of_guests, total_amount, created_at, confirmed_at) VALUES
(1, 1, 1, 2, '2024-02-15', '2024-02-18', 2, 450.00, '2024-01-15 10:30:00', '2024-01-15 11:00:00'),
(2, 2, 2, 2, '2024-03-20', '2024-03-25', 4, 600.00, '2024-02-20 14:45:00', '2024-02-20 15:30:00'),
(3, 3, 3, 2, '2024-04-10', '2024-04-17', 6, 3500.00, '2024-03-10 09:15:00', '2024-03-10 10:00:00'),
(4, 4, 4, 2, '2024-05-05', '2024-05-08', 2, 240.00, '2024-04-05 16:20:00', '2024-04-05 17:00:00'),
(5, 5, 5, 2, '2024-06-12', '2024-06-15', 3, 300.00, '2024-05-18 11:30:00', '2024-05-18 12:00:00'),
(6, 6, 6, 2, '2024-07-08', '2024-07-10', 1, 120.00, '2024-06-12 13:45:00', '2024-06-12 14:30:00'),
(7, 7, 7, 2, '2024-08-14', '2024-08-18', 2, 360.00, '2024-07-08 08:00:00', '2024-07-08 09:00:00'),
(8, 8, 8, 2, '2024-09-22', '2024-09-29', 4, 2100.00, '2024-08-14 15:30:00', '2024-08-14 16:00:00'),
(9, 9, 9, 2, '2024-10-30', '2024-11-02', 2, 135.00, '2024-09-22 12:15:00', '2024-09-22 13:00:00'),
(10, 10, 10, 2, '2024-11-15', '2024-11-18', 3, 330.00, '2024-10-30 17:45:00', '2024-10-30 18:30:00'),
(1, 1, 11, 2, '2024-12-03', '2024-12-06', 2, 210.00, '2024-11-15 10:20:00', '2024-11-15 11:00:00'),
(2, 2, 12, 2, '2024-12-20', '2024-12-25', 4, 650.00, '2024-12-03 14:10:00', '2024-12-03 15:00:00'),
(3, 3, 13, 2, '2024-12-28', '2024-12-31', 2, 285.00, '2024-12-20 09:30:00', '2024-12-20 10:00:00'),
(4, 4, 14, 2, '2025-01-10', '2025-01-14', 3, 560.00, '2024-12-28 16:45:00', '2024-12-28 17:30:00'),
(5, 5, 15, 2, '2025-01-25', '2025-01-27', 1, 70.00, '2025-01-10 11:00:00', '2025-01-10 12:00:00'),
(6, 6, 16, 2, '2025-02-10', '2025-02-13', 2, 255.00, '2025-01-25 13:25:00', '2025-01-25 14:00:00'),
(7, 7, 17, 2, '2025-02-25', '2025-02-28', 2, 165.00, '2025-02-10 08:50:00', '2025-02-10 09:30:00'),
(8, 8, 18, 2, '2025-03-15', '2025-03-21', 4, 960.00, '2025-02-25 15:15:00', '2025-02-25 16:00:00'),
(9, 9, 19, 2, '2025-03-30', '2025-04-02', 2, 225.00, '2025-03-15 12:40:00', '2025-03-15 13:30:00'),
(10, 10, 20, 2, '2025-04-15', '2025-04-18', 3, 375.00, '2025-03-30 17:05:00', '2025-03-30 18:00:00');

-- ==============================================
-- BOOKING MODIFICATIONS DATA
-- ==============================================

INSERT INTO booking_modifications (booking_id, modification_type, old_value, new_value, reason, created_at, approved_by) VALUES
(1, 'date_change', '2024-02-15 to 2024-02-18', '2024-02-16 to 2024-02-19', 'Guest requested one day later', '2024-01-20 10:00:00', 1),
(2, 'guest_count_change', '4 guests', '3 guests', 'One guest cancelled', '2024-02-25 14:00:00', 2),
(3, 'price_adjustment', '3500.00', '3400.00', 'Weekly discount applied', '2024-03-15 09:00:00', 3),
(4, 'cancellation', 'Confirmed booking', 'Cancelled', 'Guest emergency', '2024-04-10 16:00:00', 4),
(5, 'refund', '300.00', '250.00', 'Partial refund for early departure', '2024-05-25 11:00:00', 5);

-- ==============================================
-- PAYMENT METHODS DATA
-- ==============================================

INSERT INTO payment_methods (user_id, method_type, card_last_four, expiry_date, is_default, is_active) VALUES
(1, 'credit_card', '1234', '12/2026', TRUE, TRUE),
(1, 'paypal', NULL, NULL, FALSE, TRUE),
(2, 'credit_card', '5678', '08/2027', TRUE, TRUE),
(3, 'credit_card', '9012', '03/2028', TRUE, TRUE),
(3, 'bank_transfer', NULL, NULL, FALSE, TRUE),
(4, 'credit_card', '3456', '11/2026', TRUE, TRUE),
(5, 'credit_card', '7890', '06/2027', TRUE, TRUE),
(5, 'apple_pay', NULL, NULL, FALSE, TRUE),
(6, 'credit_card', '2468', '09/2026', TRUE, TRUE),
(7, 'credit_card', '1357', '04/2028', TRUE, TRUE),
(8, 'credit_card', '9753', '12/2026', TRUE, TRUE),
(9, 'credit_card', '8642', '07/2027', TRUE, TRUE),
(10, 'credit_card', '1593', '02/2028', TRUE, TRUE);

-- ==============================================
-- PAYMENTS DATA
-- ==============================================

INSERT INTO payments (booking_id, payment_method_id, amount, currency, payment_status, transaction_id, processed_at, refunded_at) VALUES
(1, 1, 450.00, 'USD', 'completed', 'TXN001234567', '2024-01-15 11:00:00', NULL),
(2, 3, 600.00, 'USD', 'completed', 'TXN001234568', '2024-02-20 15:30:00', NULL),
(3, 5, 3500.00, 'USD', 'completed', 'TXN001234569', '2024-03-10 10:00:00', NULL),
(4, 6, 240.00, 'USD', 'refunded', 'TXN001234570', '2024-04-05 17:00:00', '2024-04-10 16:00:00'),
(5, 7, 300.00, 'USD', 'completed', 'TXN001234571', '2024-05-18 12:00:00', NULL),
(6, 9, 120.00, 'USD', 'completed', 'TXN001234572', '2024-06-12 14:30:00', NULL),
(7, 10, 360.00, 'USD', 'completed', 'TXN001234573', '2024-07-08 09:00:00', NULL),
(8, 11, 2100.00, 'USD', 'completed', 'TXN001234574', '2024-08-14 16:00:00', NULL),
(9, 12, 135.00, 'USD', 'completed', 'TXN001234575', '2024-09-22 13:00:00', NULL),
(10, 13, 330.00, 'USD', 'completed', 'TXN001234576', '2024-10-30 18:30:00', NULL),
(11, 1, 210.00, 'USD', 'completed', 'TXN001234577', '2024-11-15 11:00:00', NULL),
(12, 3, 650.00, 'USD', 'completed', 'TXN001234578', '2024-12-03 15:00:00', NULL),
(13, 6, 285.00, 'USD', 'completed', 'TXN001234579', '2024-12-28 10:00:00', NULL),
(14, 7, 560.00, 'USD', 'completed', 'TXN001234580', '2025-01-10 17:30:00', NULL),
(15, 9, 70.00, 'USD', 'completed', 'TXN001234581', '2025-01-25 12:00:00', NULL),
(16, 10, 255.00, 'USD', 'completed', 'TXN001234582', '2025-02-10 14:00:00', NULL),
(17, 11, 165.00, 'USD', 'completed', 'TXN001234583', '2025-02-25 09:30:00', NULL),
(18, 12, 960.00, 'USD', 'completed', 'TXN001234584', '2025-03-15 16:00:00', NULL),
(19, 13, 225.00, 'USD', 'completed', 'TXN001234585', '2025-03-30 13:30:00', NULL),
(20, 1, 375.00, 'USD', 'completed', 'TXN001234586', '2025-04-15 18:00:00', NULL);

-- ==============================================
-- PAYOUTS DATA
-- ==============================================

INSERT INTO payouts (host_profile_id, booking_id, amount, currency, payout_status, scheduled_date, processed_date) VALUES
(1, 1, 405.00, 'USD', 'completed', '2024-02-20 00:00:00', '2024-02-20 08:00:00'),
(1, 2, 540.00, 'USD', 'completed', '2024-03-25 00:00:00', '2024-03-25 08:00:00'),
(2, 3, 3150.00, 'USD', 'completed', '2024-04-20 00:00:00', '2024-04-20 08:00:00'),
(3, 4, 216.00, 'USD', 'completed', '2024-05-10 00:00:00', '2024-05-10 08:00:00'),
(4, 5, 270.00, 'USD', 'completed', '2024-06-20 00:00:00', '2024-06-20 08:00:00'),
(5, 6, 108.00, 'USD', 'completed', '2024-07-15 00:00:00', '2024-07-15 08:00:00'),
(6, 7, 324.00, 'USD', 'completed', '2024-08-20 00:00:00', '2024-08-20 08:00:00'),
(7, 8, 1890.00, 'USD', 'completed', '2024-09-30 00:00:00', '2024-09-30 08:00:00'),
(8, 9, 121.50, 'USD', 'completed', '2024-11-05 00:00:00', '2024-11-05 08:00:00'),
(9, 10, 297.00, 'USD', 'completed', '2024-11-20 00:00:00', '2024-11-20 08:00:00'),
(10, 11, 189.00, 'USD', 'completed', '2024-12-10 00:00:00', '2024-12-10 08:00:00'),
(11, 12, 585.00, 'USD', 'completed', '2024-12-30 00:00:00', '2024-12-30 08:00:00'),
(12, 13, 256.50, 'USD', 'completed', '2025-01-15 00:00:00', '2025-01-15 08:00:00'),
(1, 14, 504.00, 'USD', 'completed', '2025-01-30 00:00:00', '2025-01-30 08:00:00'),
(2, 15, 63.00, 'USD', 'completed', '2025-02-15 00:00:00', '2025-02-15 08:00:00'),
(3, 16, 229.50, 'USD', 'completed', '2025-02-28 00:00:00', '2025-02-28 08:00:00'),
(4, 17, 148.50, 'USD', 'completed', '2025-03-15 00:00:00', '2025-03-15 08:00:00'),
(5, 18, 864.00, 'USD', 'completed', '2025-03-30 00:00:00', '2025-03-30 08:00:00'),
(6, 19, 202.50, 'USD', 'completed', '2025-04-10 00:00:00', '2025-04-10 08:00:00'),
(7, 20, 337.50, 'USD', 'completed', '2025-04-25 00:00:00', '2025-04-25 08:00:00');

-- ==============================================
-- REVIEW CATEGORIES DATA
-- ==============================================

INSERT INTO review_categories (category_name, description, weight) VALUES
('Cleanliness', 'How clean was the property?', 1.00),
('Communication', 'How well did the host communicate?', 0.90),
('Check-in', 'How smooth was the check-in process?', 0.80),
('Accuracy', 'How accurate was the listing description?', 0.95),
('Location', 'How good was the location?', 0.85),
('Value', 'How good was the value for money?', 0.75),
('Overall', 'Overall experience rating', 1.00);

-- ==============================================
-- REVIEWS DATA
-- ==============================================

INSERT INTO reviews (reviewer_id, reviewee_id, booking_id, rating, review_text, is_public, created_at) VALUES
(1, 1, 1, 5, 'Excellent stay! The apartment was exactly as described and the host was very responsive.', TRUE, '2024-02-20 10:00:00'),
(2, 2, 2, 4, 'Great house in a nice neighborhood. Would definitely stay again.', TRUE, '2024-03-26 14:00:00'),
(3, 3, 3, 5, 'Absolutely amazing villa! The views were incredible and the host was fantastic.', TRUE, '2024-04-18 09:00:00'),
(4, 4, 4, 3, 'Nice apartment but the check-in process was a bit complicated.', TRUE, '2024-05-09 16:00:00'),
(5, 5, 5, 4, 'Cozy cottage with great character. Perfect for a weekend getaway.', TRUE, '2024-06-16 11:00:00'),
(6, 6, 6, 5, 'Perfect studio for a short stay. Clean and well-located.', TRUE, '2024-07-11 13:00:00'),
(7, 7, 7, 4, 'Beautiful apartment with great views. Host was very helpful.', TRUE, '2024-08-19 08:00:00'),
(8, 8, 8, 5, 'Incredible villa experience! The pool and views were amazing.', TRUE, '2024-09-30 15:00:00'),
(9, 9, 9, 3, 'Small but functional studio. Good for short stays.', TRUE, '2024-11-03 12:00:00'),
(10, 10, 10, 4, 'Nice townhouse in a great location. Would recommend.', TRUE, '2024-11-19 17:00:00'),
(1, 2, 1, 4, 'Great guest! Very respectful and left the place clean.', TRUE, '2024-02-20 10:30:00'),
(2, 3, 2, 5, 'Excellent guest, would host again anytime!', TRUE, '2024-03-26 14:30:00'),
(3, 4, 3, 4, 'Good guest, very communicative.', TRUE, '2024-04-18 09:30:00'),
(4, 5, 4, 3, 'Guest was okay, but left some mess.', TRUE, '2024-05-09 16:30:00'),
(5, 6, 5, 5, 'Perfect guest! Very clean and respectful.', TRUE, '2024-06-16 11:30:00'),
(6, 7, 6, 4, 'Good guest, would recommend.', TRUE, '2024-07-11 13:30:00'),
(7, 8, 7, 5, 'Amazing guest! Very respectful and clean.', TRUE, '2024-08-19 08:30:00'),
(8, 9, 8, 4, 'Good guest, very communicative.', TRUE, '2024-09-30 15:30:00'),
(9, 10, 9, 3, 'Guest was okay, but could be more communicative.', TRUE, '2024-11-03 12:30:00'),
(10, 1, 10, 5, 'Excellent guest! Very clean and respectful.', TRUE, '2024-11-19 17:30:00');

-- ==============================================
-- REVIEW RATINGS DATA
-- ==============================================

INSERT INTO review_ratings (review_id, category_id, rating_value) VALUES
(1, 1, 5), (1, 2, 5), (1, 3, 5), (1, 4, 5), (1, 5, 4), (1, 6, 5), (1, 7, 5),
(2, 1, 4), (2, 2, 4), (2, 3, 4), (2, 4, 4), (2, 5, 4), (2, 6, 4), (2, 7, 4),
(3, 1, 5), (3, 2, 5), (3, 3, 5), (3, 4, 5), (3, 5, 5), (3, 6, 5), (3, 7, 5),
(4, 1, 3), (4, 2, 3), (4, 3, 2), (4, 4, 4), (4, 5, 4), (4, 6, 3), (4, 7, 3),
(5, 1, 4), (5, 2, 4), (5, 3, 4), (5, 4, 4), (5, 5, 4), (5, 6, 4), (5, 7, 4),
(6, 1, 5), (6, 2, 5), (6, 3, 5), (6, 4, 5), (6, 5, 4), (6, 6, 5), (6, 7, 5),
(7, 1, 4), (7, 2, 4), (7, 3, 4), (7, 4, 4), (7, 5, 5), (7, 6, 4), (7, 7, 4),
(8, 1, 5), (8, 2, 5), (8, 3, 5), (8, 4, 5), (8, 5, 5), (8, 6, 5), (8, 7, 5),
(9, 1, 3), (9, 2, 3), (9, 3, 3), (9, 4, 3), (9, 5, 4), (9, 6, 3), (9, 7, 3),
(10, 1, 4), (10, 2, 4), (10, 3, 4), (10, 4, 4), (10, 5, 4), (10, 6, 4), (10, 7, 4);

-- ==============================================
-- CONVERSATIONS DATA
-- ==============================================

INSERT INTO conversations (participant1_id, participant2_id, booking_id, created_at, last_message_at) VALUES
(1, 1, 1, '2024-01-15 10:30:00', '2024-02-18 10:00:00'),
(2, 2, 2, '2024-02-20 14:45:00', '2024-03-25 14:00:00'),
(3, 3, 3, '2024-03-10 09:15:00', '2024-04-17 09:00:00'),
(4, 4, 4, '2024-04-05 16:20:00', '2024-05-08 16:00:00'),
(5, 5, 5, '2024-05-18 11:30:00', '2024-06-15 11:00:00'),
(6, 6, 6, '2024-06-12 13:45:00', '2024-07-10 13:00:00'),
(7, 7, 7, '2024-07-08 08:00:00', '2024-08-18 08:00:00'),
(8, 8, 8, '2024-08-14 15:30:00', '2024-09-29 15:00:00'),
(9, 9, 9, '2024-09-22 12:15:00', '2024-11-02 12:00:00'),
(10, 10, 10, '2024-10-30 17:45:00', '2024-11-18 17:00:00');

-- ==============================================
-- MESSAGES DATA
-- ==============================================

INSERT INTO messages (conversation_id, sender_id, message_text, message_type, sent_at, read_at) VALUES
(1, 1, 'Hi! I\'m interested in booking your apartment for February 15-18. Is it available?', 'text', '2024-01-15 10:30:00', '2024-01-15 10:35:00'),
(1, 1, 'Yes, it\'s available! I\'d be happy to host you.', 'text', '2024-01-15 10:35:00', '2024-01-15 10:40:00'),
(1, 1, 'Perfect! I\'ll send you the booking request now.', 'text', '2024-01-15 10:40:00', '2024-01-15 10:45:00'),
(2, 2, 'Hello! I\'d like to book your house for March 20-25. Can you tell me more about the area?', 'text', '2024-02-20 14:45:00', '2024-02-20 14:50:00'),
(2, 2, 'The neighborhood is very safe and family-friendly. There are great restaurants nearby.', 'text', '2024-02-20 14:50:00', '2024-02-20 14:55:00'),
(3, 3, 'Hi! I\'m booking your villa for April 10-17. What\'s the check-in process?', 'text', '2024-03-10 09:15:00', '2024-03-10 09:20:00'),
(3, 3, 'I\'ll send you detailed check-in instructions 24 hours before arrival.', 'text', '2024-03-10 09:20:00', '2024-03-10 09:25:00'),
(4, 4, 'Hello! I\'m interested in your apartment for May 5-8. Is parking available?', 'text', '2024-04-05 16:20:00', '2024-04-05 16:25:00'),
(4, 4, 'Unfortunately, there\'s no parking, but there are public garages nearby.', 'text', '2024-04-05 16:25:00', '2024-04-05 16:30:00'),
(5, 5, 'Hi! I\'d like to book your cottage for June 12-15. Is it pet-friendly?', 'text', '2024-05-18 11:30:00', '2024-05-18 11:35:00'),
(5, 5, 'Yes, pets are welcome! There\'s a fenced garden they can use.', 'text', '2024-05-18 11:35:00', '2024-05-18 11:40:00');

-- ==============================================
-- NOTIFICATIONS DATA
-- ==============================================

INSERT INTO notifications (user_id, notification_type, title, message, is_read, created_at, sent_at) VALUES
(1, 'booking_confirmation', 'Booking Confirmed', 'Your booking for Modern Downtown Apartment has been confirmed!', TRUE, '2024-01-15 11:00:00', '2024-01-15 11:00:00'),
(2, 'booking_confirmation', 'Booking Confirmed', 'Your booking for Cozy Brooklyn House has been confirmed!', TRUE, '2024-02-20 15:30:00', '2024-02-20 15:30:00'),
(3, 'booking_confirmation', 'Booking Confirmed', 'Your booking for Luxury Hamptons Villa has been confirmed!', TRUE, '2024-03-10 10:00:00', '2024-03-10 10:00:00'),
(1, 'payment_received', 'Payment Received', 'Payment of $450.00 has been received for your booking.', TRUE, '2024-01-15 11:00:00', '2024-01-15 11:00:00'),
(2, 'payment_received', 'Payment Received', 'Payment of $600.00 has been received for your booking.', TRUE, '2024-02-20 15:30:00', '2024-02-20 15:30:00'),
(3, 'payout_sent', 'Payout Sent', 'Your payout of $405.00 has been sent to your account.', TRUE, '2024-02-20 08:00:00', '2024-02-20 08:00:00'),
(4, 'review_received', 'New Review', 'You received a 4-star review from John Doe.', TRUE, '2024-02-20 10:30:00', '2024-02-20 10:30:00'),
(5, 'message_received', 'New Message', 'You have a new message from Sarah Wilson.', FALSE, '2024-05-18 11:30:00', '2024-05-18 11:30:00'),
(6, 'system_alert', 'System Maintenance', 'Scheduled maintenance will occur on Sunday from 2-4 AM.', FALSE, '2024-06-10 10:00:00', '2024-06-10 10:00:00'),
(7, 'booking_confirmation', 'Booking Confirmed', 'Your booking for Berlin City Center Loft has been confirmed!', TRUE, '2024-07-08 09:00:00', '2024-07-08 09:00:00');

-- ==============================================
-- TRIPLE RELATIONSHIP 1: PROPERTY-BOOKING-PRICING DATA
-- ==============================================

INSERT INTO property_booking_pricing (property_id, booking_id, pricing_id, applied_price, pricing_rule_applied, created_at) VALUES
(1, 1, 1, 150.00, 'base_price', '2024-01-15 11:00:00'),
(2, 2, 2, 120.00, 'base_price', '2024-02-20 15:30:00'),
(3, 3, 3, 500.00, 'base_price', '2024-03-10 10:00:00'),
(4, 4, 4, 80.00, 'base_price', '2024-04-05 17:00:00'),
(5, 5, 5, 100.00, 'base_price', '2024-05-18 12:00:00'),
(6, 6, 6, 60.00, 'base_price', '2024-06-12 14:30:00'),
(7, 7, 7, 90.00, 'base_price', '2024-07-08 09:00:00'),
(8, 8, 8, 300.00, 'base_price', '2024-08-14 16:00:00'),
(9, 9, 9, 45.00, 'base_price', '2024-09-22 13:00:00'),
(10, 10, 10, 110.00, 'base_price', '2024-10-30 18:30:00');

-- ==============================================
-- TRIPLE RELATIONSHIP 2: USER-BOOKING-REVIEW DATA
-- ==============================================

INSERT INTO user_booking_review (user_id, booking_id, review_id, review_role, interaction_type, created_at) VALUES
(1, 1, 1, 'reviewer', 'written', '2024-02-20 10:00:00'),
(1, 1, 11, 'reviewee', 'received', '2024-02-20 10:30:00'),
(2, 2, 2, 'reviewer', 'written', '2024-03-26 14:00:00'),
(2, 2, 12, 'reviewee', 'received', '2024-03-26 14:30:00'),
(3, 3, 3, 'reviewer', 'written', '2024-04-18 09:00:00'),
(3, 3, 13, 'reviewee', 'received', '2024-04-18 09:30:00'),
(4, 4, 4, 'reviewer', 'written', '2024-05-09 16:00:00'),
(4, 4, 14, 'reviewee', 'received', '2024-05-09 16:30:00'),
(5, 5, 5, 'reviewer', 'written', '2024-06-16 11:00:00'),
(5, 5, 15, 'reviewee', 'received', '2024-06-16 11:30:00');

-- ==============================================
-- TRIPLE RELATIONSHIP 3: BOOKING-PAYMENT-PAYOUT DATA
-- ==============================================

INSERT INTO booking_payment_payout (booking_id, payment_id, payout_id, transaction_chain_status, processing_notes, created_at) VALUES
(1, 1, 1, 'completed', 'Full transaction completed successfully', '2024-02-20 08:00:00'),
(2, 2, 2, 'completed', 'Full transaction completed successfully', '2024-03-25 08:00:00'),
(3, 3, 3, 'completed', 'Full transaction completed successfully', '2024-04-20 08:00:00'),
(4, 4, 4, 'completed', 'Full transaction completed successfully', '2024-05-10 08:00:00'),
(5, 5, 5, 'completed', 'Full transaction completed successfully', '2024-06-20 08:00:00'),
(6, 6, 6, 'completed', 'Full transaction completed successfully', '2024-07-15 08:00:00'),
(7, 7, 7, 'completed', 'Full transaction completed successfully', '2024-08-20 08:00:00'),
(8, 8, 8, 'completed', 'Full transaction completed successfully', '2024-09-30 08:00:00'),
(9, 9, 9, 'completed', 'Full transaction completed successfully', '2024-11-05 08:00:00'),
(10, 10, 10, 'completed', 'Full transaction completed successfully', '2024-11-20 08:00:00');

-- ==============================================
-- COMPLETION MESSAGE
-- ==============================================

SELECT 'Complete sample data insertion successful!' AS Status,
       'All 27 tables populated with comprehensive Airbnb data' AS Description,
       'Ready for presentation queries and test queries' AS Details,
       NOW() AS Completed_At;
