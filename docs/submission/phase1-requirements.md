# Phase 1 Requirements: Conception - ER Model

## Deliverables

### Required Documents
1. **ER Diagram** - Complete entity-relationship model with 20+ entities
2. **Entity Descriptions** - Detailed documentation of all entities
3. **Relationship Documentation** - Cardinality and participation specifications
4. **Business Rules** - Comprehensive list of business constraints
5. **Report** - Formal academic report (PDF format)

### File Requirements
- **Report**: `LASTNAME_Firstname_DDMMYYYY_Phase1.pdf`
- **Diagram**: High-resolution image (minimum 300 DPI)
- **Working Files**: Keep original .drawio files

## ER Model Requirements

### Minimum Entity Count
- **Required**: 20+ entities
- **Recommended**: 25-30 entities for comprehensive coverage
- **Bonus**: Additional entities for complex business scenarios

### Required Entity Types

#### Core Entities
- **Users** (guests, hosts, admins)
- **Properties/Listings**
- **Bookings/Reservations**
- **Reviews** (property, host, guest)
- **Payments/Transactions**

#### Supporting Entities
- **Property Amenities**
- **Location/Address**
- **Calendar/Availability**
- **Messages/Communication**
- **Property Types**
- **User Verification**
- **Pricing Rules**
- **Photos/Media**
- **Cancellation Policies**
- **House Rules**

### Relationship Requirements

#### Relationship Types
- **1:1 (One-to-One)** - e.g., User to Profile
- **1:N (One-to-Many)** - e.g., Property to Reviews
- **N:M (Many-to-Many)** - e.g., Properties to Amenities

#### Cardinality Notation
- Use min,max notation: (0,1), (1,1), (0,N), (1,N)
- Specify participation: total (mandatory) or partial (optional)
- Document all cardinality decisions with business justification

### Attribute Requirements

#### Attribute Types
- **Simple Attributes** - Single values (name, email)
- **Composite Attributes** - Multiple components (address)
- **Multivalued Attributes** - Multiple values (phone numbers)
- **Derived Attributes** - Calculated values (age from birth_date)

#### Documentation Requirements
- Specify data types for all attributes
- Identify domains and constraints
- Mark derived attributes clearly
- Resolve multivalued attributes with bridge tables

## Report Structure

### Required Sections
1. **Title Page**
   - Course information
   - Student details
   - Date and word count

2. **Table of Contents**
   - All sections and subsections
   - Page numbers

3. **Introduction**
   - Problem statement
   - Project objectives
   - Scope and limitations

4. **Requirements Analysis**
   - Functional requirements
   - Non-functional requirements
   - Stakeholder analysis

5. **ER Model**
   - Complete diagram
   - Legend and notation explanation
   - Entity descriptions

6. **Entity Descriptions**
   - Detailed attributes
   - Data types and constraints
   - Business rules per entity

7. **Relationship Descriptions**
   - Cardinality specifications
   - Participation rules
   - Business justifications

8. **Business Rules**
   - Comprehensive list
   - Categorized by domain
   - Real-world examples

9. **Conclusion**
   - Summary of findings
   - Design decisions
   - Future considerations

10. **References**
    - APA formatted citations
    - Academic sources only

## Quality Standards

### Diagram Quality
- **Professional Layout** - Use grid alignment
- **Readable Font** - Minimum 10pt font size
- **Clear Notation** - Consistent symbol usage
- **Complete Legend** - Explain all notation
- **High Resolution** - Minimum 300 DPI

### Documentation Quality
- **Academic Writing** - Formal, clear style
- **Proper Citations** - APA 7th Edition format
- **Logical Structure** - Clear flow and organization
- **Complete Coverage** - All requirements addressed
- **Professional Presentation** - Clean formatting

### Technical Accuracy
- **Valid Relationships** - Realistic cardinalities
- **Complete Attributes** - All necessary fields
- **Business Logic** - Real-world applicability
- **Consistency** - No contradictions
- **Completeness** - All entities and relationships

## Submission Checklist

### Pre-Submission
- [ ] ER diagram with 20+ entities
- [ ] All relationships clearly labeled with cardinality
- [ ] Entity descriptions with attributes and data types
- [ ] Business rules documented
- [ ] Report in PDF format
- [ ] File named correctly: `LASTNAME_Firstname_DDMMYYYY_Phase1.pdf`
- [ ] All figures cited if adapted from sources
- [ ] Reference list in APA format
- [ ] Grammar and spelling checked
- [ ] All requirements met

### Technical Verification
- [ ] Diagram opens and displays correctly
- [ ] All text is readable
- [ ] Legend is complete and accurate
- [ ] No overlapping elements
- [ ] Consistent notation throughout

### Content Verification
- [ ] Minimum 20 entities included
- [ ] All required entity types present
- [ ] Relationships are realistic and justified
- [ ] Business rules are comprehensive
- [ ] All entities have complete attribute lists
- [ ] Data types specified for all attributes
- [ ] Cardinalities are appropriate and documented
