# Technical Standards

## Database System Requirements

### Recommended Database System
- **Primary**: PostgreSQL (recommended for academic projects)
- **Alternative**: MySQL, SQL Server, or Oracle (specify choice in documentation)
- **Version**: Use current stable version
- **Documentation**: Include version information in all reports

### ER Model Standards
- **Notation**: IEEE notation (Crow's foot)
- **Tool**: Draw.io, Lucidchart, or similar professional diagramming tool
- **Format**: Export as high-resolution images (minimum 300 DPI)
- **Legend**: Must include notation legend on all diagrams

### SQL Standards
- **Version**: ANSI SQL:2016 compliance
- **Naming**: Follow established naming conventions
- **Formatting**: Consistent indentation and structure
- **Comments**: Comprehensive documentation for complex queries

## Normalization Requirements

### Target Normalization Level
- **Minimum**: 3NF (Third Normal Form)
- **Bonus**: BCNF (Boyce-Codd Normal Form) for additional points
- **Documentation**: Show complete normalization process (0NF → 1NF → 2NF → 3NF)

### Functional Dependencies
- Document all functional dependencies clearly
- Show partial and transitive dependencies
- Justify normalization decisions with business logic
- Consider performance vs. normalization trade-offs

## Documentation Standards

### Citation Format
- **Style**: APA 7th Edition with IU modifications
- **In-text**: (Author, Year, p. XX)
- **References**: Alphabetical by author surname
- **Sources**: Academic sources only, no course materials

### Figure and Table Standards
- **Numbering**: Sequential (Figure 1, Table 1, etc.)
- **Captions**: Above tables, below figures
- **Quality**: High resolution, professional appearance
- **Attribution**: Proper source citations

## File Organization Standards

### Naming Conventions
- **Reports**: LASTNAME_Firstname_DDMMYYYY_PhaseX.pdf
- **SQL Files**: LASTNAME_Firstname_DDMMYYYY.sql
- **Diagrams**: descriptive_name_vX.drawio
- **Working Files**: numbered_purpose.sql

### Directory Structure
```
project/
├── docs/                    # Documentation
├── sql/                     # SQL scripts
├── diagrams/                # ER diagrams and schemas
├── reports/                 # Final reports
└── data/                    # Sample data files
```

## Quality Assurance Standards

### Code Quality
- All SQL must execute without errors
- Include comprehensive comments
- Use consistent indentation and formatting
- Test all queries with sample data
- Validate all constraints work as intended

### Documentation Quality
- Clear, academic writing style
- Proper grammar and spelling
- Logical flow and structure
- All figures and tables referenced in text
- Complete reference list with no missing information

### Technical Depth
- Justify all design decisions with references
- Explain trade-offs in design choices
- Demonstrate understanding of database theory
- Show awareness of real-world constraints
- Include performance considerations
