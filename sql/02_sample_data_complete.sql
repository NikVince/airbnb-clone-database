-- ==============================================
-- Airbnb Database Complete Sample Data
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
-- PROPERTIES DATA
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
-- BOOKINGS DATA
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
(11, 12, 11, 2, '2024-12-03', '2024-12-06', 2, 210.00, '2024-11-15 10:20:00', '2024-11-15 11:00:00'),
(12, 13, 12, 2, '2025-01-20', '2025-01-25', 4, 650.00, '2024-12-03 14:10:00', '2024-12-03 15:00:00'),
(13, 14, 13, 2, '2025-02-14', '2025-02-17', 2, 285.00, '2025-01-20 09:30:00', '2025-01-20 10:00:00'),
(14, 15, 14, 2, '2025-03-08', '2025-03-12', 3, 560.00, '2025-02-14 16:45:00', '2025-02-14 17:30:00'),
(15, 16, 15, 2, '2025-04-12', '2025-04-14', 1, 70.00, '2025-03-08 11:00:00', '2025-03-08 12:00:00'),
(16, 17, 16, 2, '2025-05-25', '2025-05-28', 2, 255.00, '2025-04-12 13:25:00', '2025-04-12 14:00:00'),
(17, 18, 17, 2, '2025-06-18', '2025-06-21', 2, 165.00, '2025-05-25 08:50:00', '2025-05-25 09:30:00'),
(18, 19, 18, 2, '2025-07-30', '2025-08-05', 4, 960.00, '2025-06-18 15:15:00', '2025-06-18 16:00:00'),
(19, 20, 19, 2, '2025-08-22', '2025-08-25', 2, 225.00, '2025-07-30 12:40:00', '2025-07-30 13:30:00'),
(20, 21, 20, 2, '2025-09-15', '2025-09-18', 3, 375.00, '2025-08-22 17:05:00', '2025-08-22 18:00:00');

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
(13, 6, 285.00, 'USD', 'completed', 'TXN001234579', '2025-01-20 10:00:00', NULL),
(14, 7, 560.00, 'USD', 'completed', 'TXN001234580', '2025-02-14 17:30:00', NULL),
(15, 9, 70.00, 'USD', 'completed', 'TXN001234581', '2025-03-08 12:00:00', NULL),
(16, 10, 255.00, 'USD', 'completed', 'TXN001234582', '2025-04-12 14:00:00', NULL),
(17, 11, 165.00, 'USD', 'completed', 'TXN001234583', '2025-05-25 09:30:00', NULL),
(18, 12, 960.00, 'USD', 'completed', 'TXN001234584', '2025-06-18 16:00:00', NULL),
(19, 13, 225.00, 'USD', 'completed', 'TXN001234585', '2025-07-30 13:30:00', NULL),
(20, 1, 375.00, 'USD', 'completed', 'TXN001234586', '2025-08-22 18:00:00', NULL);

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
(11, 12, 585.00, 'USD', 'completed', '2025-01-30 00:00:00', '2025-01-30 08:00:00'),
(12, 13, 256.50, 'USD', 'completed', '2025-02-20 00:00:00', '2025-02-20 08:00:00'),
(13, 14, 504.00, 'USD', 'completed', '2025-03-20 00:00:00', '2025-03-20 08:00:00'),
(14, 15, 63.00, 'USD', 'completed', '2025-04-20 00:00:00', '2025-04-20 08:00:00'),
(15, 16, 229.50, 'USD', 'completed', '2025-05-30 00:00:00', '2025-05-30 08:00:00'),
(16, 17, 148.50, 'USD', 'completed', '2025-06-25 00:00:00', '2025-06-25 08:00:00'),
(17, 18, 864.00, 'USD', 'completed', '2025-08-10 00:00:00', '2025-08-10 08:00:00'),
(18, 19, 202.50, 'USD', 'completed', '2025-08-30 00:00:00', '2025-08-30 08:00:00'),
(19, 20, 337.50, 'USD', 'completed', '2025-09-20 00:00:00', '2025-09-20 08:00:00');

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
