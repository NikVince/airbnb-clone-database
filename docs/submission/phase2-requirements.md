# Phase 2 Requirements: Design - Normalization and Constraints

## Deliverables

### Required Documents
1. **Refined ER Model** - Updated model addressing Phase 1 feedback
2. **Normalization Documentation** - Complete 1NF, 2NF, 3NF process
3. **Functional Dependencies** - Detailed analysis and documentation
4. **Constraint Definitions** - All PKs, FKs, checks, unique constraints
5. **Report** - Formal academic report (PDF format)

### File Requirements
- **Report**: `LASTNAME_Firstname_DDMMYYYY_Phase2.pdf`
- **Updated Diagram**: High-resolution image
- **Working Files**: Keep original .drawio files

## Normalization Requirements

### Process Documentation
- **0NF (Unnormalized Form)** - Original structure
- **1NF (First Normal Form)** - Eliminate repeating groups and multivalued attributes
- **2NF (Second Normal Form)** - Eliminate partial dependencies
- **3NF (Third Normal Form)** - Eliminate transitive dependencies
- **BCNF (Bonus)** - Boyce-Codd Normal Form for additional points

### Functional Dependencies Analysis
- **Complete FD Set** - All functional dependencies identified
- **Partial Dependencies** - Documented and resolved
- **Transitive Dependencies** - Identified and eliminated
- **Business Justification** - Explain why each step is necessary

### Documentation Requirements
- **Before/After Schemas** - Show transformation at each step
- **Dependency Diagrams** - Visual representation of FDs
- **Justification** - Business logic for each decision
- **Trade-offs** - Performance vs. normalization considerations

## Constraint Requirements

### Primary Key Constraints
- **Every Table** - Must have a primary key
- **Composite Keys** - When necessary, document justification
- **Natural vs. Surrogate** - Explain choice for each table
- **Naming Convention** - table_name_id format

### Foreign Key Constraints
- **Referential Integrity** - All FKs properly defined
- **ON DELETE Actions** - CASCADE, SET NULL, RESTRICT, NO ACTION
- **ON UPDATE Actions** - CASCADE, SET NULL, RESTRICT, NO ACTION
- **Naming Convention** - fk_table_column format

### Check Constraints
- **Business Rules** - Implement as CHECK constraints
- **Data Validation** - Range checks, format validation
- **Domain Constraints** - Valid values for categorical data
- **Naming Convention** - chk_table_column format

### Unique Constraints
- **Natural Keys** - Email addresses, usernames, etc.
- **Business Rules** - One active booking per property
- **Composite Uniques** - Multiple column combinations
- **Naming Convention** - uk_table_column format

### NOT NULL Constraints
- **Required Fields** - All mandatory attributes
- **Business Logic** - Fields that must have values
- **Data Integrity** - Prevent incomplete records
- **Documentation** - Explain why each field is required

## Data Types and Domains

### Data Type Specifications
- **Numeric Types** - INTEGER, DECIMAL, FLOAT with precision
- **Character Types** - VARCHAR with length, CHAR for fixed length
- **Date/Time Types** - DATE, TIMESTAMP, TIME with timezone
- **Boolean Types** - BOOLEAN for true/false values
- **Special Types** - JSON, UUID, ENUM where appropriate

### Domain Definitions
- **Valid Values** - Enumerate all possible values
- **Range Constraints** - Min/max values for numeric fields
- **Format Constraints** - Pattern matching for text fields
- **Business Rules** - Domain-specific validation rules

## Integrity Rules

### Entity Integrity
- **Primary Keys** - No null values, unique values
- **Surrogate Keys** - Auto-incrementing, system-generated
- **Natural Keys** - Business-meaningful identifiers

### Referential Integrity
- **Foreign Keys** - Must reference existing primary keys
- **Cascade Rules** - Define behavior for updates/deletes
- **Orphan Prevention** - Prevent dangling references

### Domain Integrity
- **Data Types** - Correct type for each attribute
- **Constraints** - CHECK constraints for business rules
- **Validation** - Ensure data quality and consistency

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
   - Recap of Phase 1
   - Phase 2 objectives
   - Scope and approach

4. **Schema Refinement**
   - Changes from Phase 1
   - Justification for modifications
   - Impact analysis

5. **Normalization Process**
   - 0NF → 1NF transformation
   - 1NF → 2NF transformation
   - 2NF → 3NF transformation
   - BCNF consideration (if applicable)

6. **Functional Dependencies Analysis**
   - Complete FD set
   - Partial dependencies
   - Transitive dependencies
   - Dependency diagrams

7. **Constraint Definitions**
   - Primary key constraints
   - Foreign key constraints
   - Check constraints
   - Unique constraints
   - NOT NULL constraints

8. **Data Types and Domains**
   - Type specifications
   - Domain definitions
   - Business rules implementation

9. **Integrity Rules**
   - Entity integrity
   - Referential integrity
   - Domain integrity

10. **Conclusion**
    - Summary of design decisions
    - Trade-offs considered
    - Future considerations

11. **References**
    - APA formatted citations
    - Academic sources only

## Quality Standards

### Normalization Quality
- **Complete Process** - All steps documented
- **Clear Justification** - Business logic for each decision
- **Visual Documentation** - Diagrams and examples
- **No Redundancy** - Eliminate all unnecessary duplication
- **Performance Consideration** - Balance normalization vs. performance

### Constraint Quality
- **Comprehensive Coverage** - All necessary constraints
- **Business Logic** - Real-world applicable rules
- **Data Integrity** - Prevent invalid data entry
- **Performance Impact** - Consider constraint overhead
- **Documentation** - Clear explanation of each constraint

### Documentation Quality
- **Academic Writing** - Formal, clear style
- **Technical Accuracy** - Correct database theory
- **Visual Clarity** - Clear diagrams and tables
- **Complete Coverage** - All requirements addressed
- **Professional Presentation** - Clean formatting

## Submission Checklist

### Pre-Submission
- [ ] Refined ER model addressing Phase 1 feedback
- [ ] Normalization documented (1NF, 2NF, 3NF)
- [ ] Functional dependencies identified
- [ ] All constraints specified (PK, FK, CHECK, UNIQUE, NOT NULL)
- [ ] Report in PDF format
- [ ] File named correctly: `LASTNAME_Firstname_DDMMYYYY_Phase2.pdf`
- [ ] References updated and properly formatted
- [ ] Grammar and spelling checked
- [ ] All requirements met

### Technical Verification
- [ ] All normalization steps completed
- [ ] Functional dependencies correctly identified
- [ ] Constraints are implementable
- [ ] Data types are appropriate
- [ ] No redundancy in final schema
- [ ] All relationships maintainable

### Content Verification
- [ ] Minimum 20 entities maintained
- [ ] All entities properly normalized
- [ ] Business rules implemented as constraints
- [ ] Data integrity ensured
- [ ] Performance considerations documented
- [ ] All design decisions justified
