# Requirements Specification for Airbnb Database System

**Course:** Build a Data Mart in SQL (DLBDSPBDM01)  
**Phase:** Conception Phase  
**Date:** 05/10/2025   
**Student:** Nikolas Daniel Vincenti

---

## 1. Problem Statement

The objective is to design and implement a comprehensive database system for an Airbnb-like platform that facilitates the connection between hosts and guests for short-term accommodation rentals. The system must handle user management, property listings, booking processes, payment transactions, and review systems while ensuring data integrity and supporting complex business operations.

## 2. USER ROLES AND RESPONSIBILITIES

### 2.1 Guest Role

#### **Description**
Users who search for, book, and stay at properties on the platform. Guests are the primary consumers of accommodation services.

#### **Key Responsibilities**
- **Search and Discovery:** Search and filter available properties based on location, dates, price, and preferences
- **Booking Management:** Make booking requests, confirmations, and manage reservation details
- **Payment Processing:** Process payments for bookings using various payment methods
- **Communication:** Communicate with hosts through the platform's messaging system
- **Review System:** Leave reviews and ratings for hosts and properties after stays
- **Profile Management:** Maintain personal profiles, preferences, and travel history
- **Verification:** Complete identity verification processes as required

#### **Required Permissions**
- Access to property search and filtering
- Ability to create and modify bookings
- Payment processing capabilities
- Messaging with hosts
- Review submission after completed stays
- Profile and preference management

#### **Relationship to Other Roles**
- **Primary Interaction:** Books properties from Hosts
- **Communication:** Direct messaging with Hosts
- **Reviews:** Can review Hosts and properties
- **Multi-Role Support:** Can simultaneously act as a Host (listing their own properties)

### 2.2 Host Role

#### **Description**
Users who list and manage rental properties on the platform. Hosts provide accommodation services to guests and generate revenue through property rentals.

#### **Key Responsibilities**
- **Property Management:** Create, edit, and manage property listings with detailed descriptions and photos
- **Pricing Strategy:** Set dynamic pricing, availability calendars, and house rules
- **Booking Management:** Respond to booking requests, confirmations, and manage reservations
- **Guest Communication:** Communicate with guests through messaging and provide support
- **Financial Management:** Process payouts, manage payment methods, and handle financial transactions
- **Performance Management:** Maintain high standards, respond to reviews, and build reputation
- **Verification:** Complete enhanced verification including identity and property ownership validation

#### **Required Permissions**
- Property listing creation and management
- Booking request management and confirmation
- Pricing and availability calendar management
- Guest communication and support
- Payout processing and financial management
- Review response and reputation management

#### **Relationship to Other Roles**
- **Primary Interaction:** Provides properties to Guests
- **Communication:** Direct messaging with Guests
- **Reviews:** Can review Guests and receive reviews from Guests
- **Multi-Role Support:** Can simultaneously act as a Guest (booking other properties)
- **Delegation:** Can delegate property management to Property Managers

### 2.3 Administrator Role

#### **Description**
Platform staff with system-wide management capabilities. Administrators ensure platform operations, user support, and policy enforcement.

#### **Key Responsibilities**
- **User Management:** Monitor user accounts, handle verification processes, and manage disputes
- **Content Moderation:** Review and moderate property listings, reviews, and user-generated content
- **Support Operations:** Handle customer support, resolve disputes, and provide technical assistance
- **System Management:** Configure platform settings, manage policies, and monitor system performance
- **Analytics and Reporting:** Generate reports, analyze platform metrics, and provide business intelligence
- **Security Management:** Monitor security threats, handle account suspensions, and ensure compliance

#### **Required Permissions**
- Full system access with audit trail
- User account management and modification
- Content moderation and policy enforcement
- Financial oversight and reporting
- System configuration and monitoring
- Security and compliance management

#### **Relationship to Other Roles**
- **Oversight:** Manages all user roles (Guests, Hosts, Property Managers)
- **Support:** Provides support to all platform users
- **Enforcement:** Enforces platform policies and resolves disputes
- **Monitoring:** Monitors platform operations and user behavior

### 2.4 Property Manager Role

#### **Description**
Professional managers who operate properties on behalf of hosts. Property Managers handle multiple properties and coordinate with hosts for efficient property management.

#### **Key Responsibilities**
- **Multi-Property Management:** Manage multiple property listings under delegated authority
- **Guest Coordination:** Handle guest communications, check-ins, and support
- **Maintenance Coordination:** Coordinate cleaning, maintenance, and property upkeep
- **Host Reporting:** Provide regular reports to property owners on performance and issues
- **Operational Management:** Handle day-to-day operations and guest services
- **Financial Coordination:** Coordinate with hosts on pricing and financial matters

#### **Required Permissions**
- Property management under delegated authority
- Guest communication and support
- Maintenance and cleaning coordination
- Host reporting and communication
- Operational management capabilities

#### **Relationship to Other Roles**
- **Delegation:** Receives authority from Hosts to manage their properties
- **Guest Interaction:** Direct communication with Guests on behalf of Hosts
- **Host Coordination:** Regular communication and reporting to Hosts
- **Administrative Oversight:** Subject to Administrator monitoring and policies

### 2.5 Multi-Role Support

#### **Critical Design Decision**
Users can hold multiple roles simultaneously, which is fundamental to the Airbnb business model:

- **Guest + Host:** A user can list properties as a Host while also booking other properties as a Guest
- **Guest + Property Manager:** A user can manage properties for others while booking accommodations for themselves
- **Role Transitions:** Users can transition between roles (e.g., start as Guest, become Host later)

#### **Business Logic Implementation**
- **Role Flags:** Each user has boolean flags indicating active roles (is_guest, is_host, is_admin)
- **Profile Separation:** Role-specific attributes stored in separate profile tables
- **Context Awareness:** System tracks which role a user is performing in any given transaction
- **Permission Management:** Permissions granted based on active roles and context

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
