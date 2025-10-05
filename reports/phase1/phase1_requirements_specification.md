# Requirements Specification for Airbnb Database System

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Conception Phase  
**Date:** 05/10/2025   
**Student:** Nikolas Daniel Vincenti

---

## 1. Problem Statement

The objective is to design and implement a comprehensive database system for an Airbnb-like platform that facilitates the connection between hosts and guests for short-term accommodation rentals. The system must handle user management, property listings, booking processes, payment transactions, and review systems while ensuring data integrity and supporting complex business operations.

## 2. Roles and User Groups

### 2.1 Primary Roles

#### **Guests**
- **Purpose:** Book and stay at accommodations
- **Key Actions:**
  - Create and manage user profiles
  - Search and filter available properties
  - Make booking requests and reservations
  - Process payments for bookings
  - Write reviews and ratings for hosts and properties
  - Communicate with hosts through messaging system
  - Manage booking history and preferences

#### **Hosts**
- **Purpose:** List and manage rental properties
- **Key Actions:**
  - Create and manage host profiles with verification
  - List properties with detailed descriptions and photos
  - Set pricing, availability, and house rules
  - Manage booking requests and confirmations
  - Process payouts and financial transactions
  - Respond to guest reviews and ratings
  - Communicate with guests through messaging system

#### **Administrators**
- **Purpose:** Manage platform operations and user support
- **Key Actions:**
  - Monitor user accounts and verification status
  - Manage property listings and content moderation
  - Handle disputes and customer support
  - Generate reports and analytics
  - Manage platform settings and policies

### 2.2 Secondary Roles

#### **Property Managers**
- **Purpose:** Manage multiple properties for hosts
- **Key Actions:**
  - Manage multiple property listings
  - Coordinate with multiple hosts
  - Handle bulk operations and reporting

## 3. Core Business Functions

### 3.1 User Management
- User registration and authentication
- Profile management and verification
- User preferences and settings
- Account security and privacy controls

### 3.2 Property Management
- Property listing creation and editing
- Photo and media management
- Pricing and availability management
- Property categorization and search optimization

### 3.3 Booking System
- Search and filtering capabilities
- Booking request and confirmation process
- Calendar management and availability tracking
- Cancellation and modification handling

### 3.4 Payment Processing
- Secure payment processing
- Commission and fee calculation
- Payout management to hosts
- Refund and dispute handling

### 3.5 Communication System
- Messaging between hosts and guests
- Notification system
- Support ticket management

### 3.6 Review and Rating System
- Property and host reviews
- Guest reviews by hosts
- Rating aggregation and display
- Review moderation

## 4. Data Requirements

### 4.1 User Data
- Personal information (name, email, phone, address)
- Verification documents and status
- Payment methods and billing information
- Preferences and settings
- Activity history and statistics

### 4.2 Property Data
- Property details (type, size, amenities, location)
- Photos and media files
- Pricing information and rules
- Availability calendar
- House rules and policies

### 4.3 Booking Data
- Booking details (dates, guests, pricing)
- Booking status and history
- Payment information
- Communication records
- Review and rating data

### 4.4 Financial Data
- Transaction records
- Commission calculations
- Payout schedules
- Refund processing
- Financial reporting

## 5. Functional Requirements

### 5.1 Search and Discovery
- Advanced search with multiple filters
- Location-based search with maps
- Price range and date filtering
- Property type and amenity filtering
- Saved searches and favorites

### 5.2 Booking Management
- Real-time availability checking
- Booking confirmation and cancellation
- Guest and host communication
- Check-in and check-out processes

### 5.3 Payment Processing
- Secure payment handling
- Multiple payment methods
- Automatic commission calculation
- Scheduled payouts to hosts
- Refund processing

### 5.4 Review System
- Post-stay review submission
- Review display and aggregation
- Review moderation and reporting
- Rating calculation and display

## 6. Non-Functional Requirements

### 6.1 Performance
- Support for high concurrent user load
- Fast search and query response times
- Efficient data storage and retrieval
- Scalable architecture design

### 6.2 Security
- Secure user authentication
- Data encryption and privacy protection
- Secure payment processing
- Access control and authorization

### 6.3 Reliability
- Data backup and recovery
- System uptime and availability
- Error handling and logging
- Transaction integrity

### 6.4 Usability
- Intuitive user interface design
- Mobile-responsive design
- Multi-language support
- Accessibility compliance

## 7. Business Rules

### 7.1 User Rules
- Users must verify identity before listing properties
- Hosts must provide valid contact information
- Guests must have valid payment methods
- Users can have multiple roles (guest and host)

### 7.2 Property Rules
- Properties must have at least one photo
- Pricing must be set for all available dates
- House rules must be clearly defined
- Properties must be in valid locations

### 7.3 Booking Rules
- Bookings cannot overlap for the same property
- Minimum and maximum stay requirements
- Cancellation policies must be enforced
- Booking modifications have restrictions

### 7.4 Payment Rules
- Payments must be processed before check-in
- Commission rates are fixed by platform
- Payouts to hosts are delayed for security
- Refunds follow cancellation policies

### 7.5 Review Rules
- Reviews can only be written after stay completion
- Reviews cannot be edited after submission
- Both parties can review each other
- Reviews are permanent and cannot be deleted

## 8. Technical Requirements

### 8.1 Database System
- SQL-compliant database management system
- Support for complex queries and relationships
- Data integrity and consistency
- Backup and recovery capabilities

### 8.2 Data Storage
- Efficient storage of large amounts of data
- Support for multimedia files
- Scalable data architecture
- Data archival and retention policies

### 8.3 Integration Requirements
- Payment gateway integration
- Email and notification services
- Map and location services
- Social media integration

## 9. Success Criteria

### 9.1 Functional Success
- All user roles can perform required actions
- Booking process is seamless and reliable
- Payment processing is secure and accurate
- Review system provides valuable feedback

### 9.2 Technical Success
- Database performs efficiently under load
- Data integrity is maintained
- System is secure and reliable
- Scalability requirements are met

### 9.3 Business Success
- Platform supports business operations
- User experience is positive
- Data provides valuable insights
- System supports growth and expansion

---

**Document Version:** 1.0  
**Last Updated:** 05/10/2025
