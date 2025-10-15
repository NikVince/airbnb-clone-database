# 🏠 Airbnb Clone Database Design Project

[![Database](https://img.shields.io/badge/Database-PostgreSQL-blue?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![SQL Standard](https://img.shields.io/badge/SQL-ANSI%20SQL:2016-green?style=flat-square&logo=sql&logoColor=white)](https://www.iso.org/standard/76583.html)
[![Normalization](https://img.shields.io/badge/Normalization-3NF%2B-orange?style=flat-square&logo=code&logoColor=white)](https://en.wikipedia.org/wiki/Third_normal_form)
[![Documentation](https://img.shields.io/badge/Documentation-APA%207th%20Edition-red?style=flat-square&logo=readthedocs&logoColor=white)](https://apastyle.apa.org/)
[![Academic](https://img.shields.io/badge/Academic-IU%20International%20University-purple?style=flat-square&logo=graduation-cap&logoColor=white)](https://www.iu.org/)
[![License](https://img.shields.io/badge/License-Academic%20Use-yellow?style=flat-square&logo=creative-commons&logoColor=white)](https://creativecommons.org/licenses/by-nc/4.0/)

> **Academic Database Design Project** - A comprehensive database design and implementation for an Airbnb-like platform, developed as part of the Database Design course at IU International University.

## 📋 Project Overview

This project implements a complete database solution for a vacation rental platform similar to Airbnb, covering all phases from conceptual design to implementation. The database supports complex business operations including property management, booking systems, user interactions, and financial transactions.

### 🎯 Project Phases

| Phase | Description | Status |
|-------|-------------|--------|
| **Phase 1** | ER Model Design (25 entities) | ✅ Completed (2025-10-05) |
| **Phase 2** | Database Implementation (27 entities) | ✅ Completed (2025-10-15) |
| **Phase 3** | Final Documentation & Submission | 🔄 In Progress |

## 🏗️ Database Architecture

### Core Entities (27 Implemented)
- **Users**: Hosts, guests, administrators with verification systems
- **Properties**: Listings with detailed descriptions, amenities, and rules
- **Bookings**: Reservation management with status tracking
- **Reviews**: Rating and feedback systems
- **Payments**: Financial transaction processing
- **Location**: Geographic data and address management
- **Communication**: Messaging and notification systems
- **Triple Relationships**: 3 complex many-to-many-to-many relationships
- **Recursive Relationships**: 1 self-referencing relationship

### Technical Specifications
- **Database System**: MySQL 8.0+ (implemented)
- **ER Notation**: IEEE notation (Crow's foot)
- **SQL Standard**: ANSI SQL:2016 compliance
- **Normalization**: 3NF/BCNF achieved
- **Documentation**: APA 7th Edition with IU modifications
- **Constraints**: 89+ business rule constraints
- **Performance**: Strategic indexing and optimization

## 📚 Documentation Structure

```
docs/
├── PROJECT_OVERVIEW.md           # Complete project status and achievements
├── TECHNICAL_DOCUMENTATION.md    # Technical specifications and architecture
├── README.md                     # Documentation index and navigation
├── assignment/                   # Original assignment documents
├── guidelines/                   # Technical standards and best practices
├── submission/                   # Submission requirements and checklists
├── quality/                      # Evaluation criteria and standards
├── references/                   # Citation guidelines and academic sources
├── changelog/                    # Project version history
└── feedback/                     # Phase feedback and responses
```

### 📖 Essential Documentation
- **[Project Overview](docs/PROJECT_OVERVIEW.md)** - Complete project status and achievements
- **[Technical Documentation](docs/TECHNICAL_DOCUMENTATION.md)** - Technical specifications and architecture
- **[Installation Guide](INSTALLATION.md)** - Quick installation and setup instructions
- **[Documentation Index](docs/README.md)** - Navigation guide for all documentation

## 🛠️ Development Standards

### SQL Coding Standards
- **Naming**: `snake_case` for tables and columns
- **Keys**: `table_name_id` for primary keys
- **Constraints**: Descriptive names with business logic
- **Formatting**: Consistent indentation and structure
- **Comments**: Comprehensive documentation for complex queries

### Quality Assurance
- ✅ All SQL executes without errors
- ✅ Comprehensive constraint validation
- ✅ Realistic sample data
- ✅ Performance optimization
- ✅ Professional documentation

## 📊 Evaluation Criteria

| Category | Weight | Focus Areas |
|----------|--------|-------------|
| **Content Quality** | 40% | Technical accuracy, completeness, real-world applicability |
| **Methodology** | 20% | Design process, documentation, justification |
| **Formal Requirements** | 20% | Formatting, citations, professional presentation |
| **Innovation** | 10% | Creative solutions, advanced features |
| **Literature Research** | 10% | Academic sources, proper citations |

## 🚀 Getting Started

### Prerequisites
- MySQL 8.0+ (or compatible database system)
- SQL client (DBeaver, MySQL Workbench, or command line)
- Text editor with SQL syntax highlighting

### Project Structure
```
airbnb-clone-database/
├── docs/                    # Comprehensive documentation
├── sql/                     # SQL scripts and implementations
├── diagrams/                # ER diagrams and schemas
├── reports/                 # Final academic reports
│   ├── phase1/              # Phase 1 deliverables (completed)
│   ├── phase2/              # Phase 2 deliverables (planned)
│   └── phase3/              # Phase 3 deliverables (planned)
└── data/                    # Sample data files
```

## 📝 Academic Requirements

### Citation Standards
- **Style**: APA 7th Edition with IU modifications
- **Format**: (Author, Year, p. XX) for in-text citations
- **Sources**: Academic sources only, no course materials
- **Quality**: Peer-reviewed journals and authoritative sources

### File Naming Conventions
- **Reports**: `LASTNAME_Firstname_DDMMYYYY_PhaseX.pdf`
- **SQL Files**: `LASTNAME_Firstname_DDMMYYYY.sql`
- **Diagrams**: `descriptive_name_vX.drawio`

## 🔄 Project Status

- [x] Project structure and documentation framework
- [x] Technical standards and guidelines
- [x] Evaluation criteria and quality standards
- [x] Phase 1: ER Model implementation (25 entities, 3 triple relationships, 1 recursive relationship)
- [x] Phase 2: Database implementation (27 entities, 89+ constraints, bulletproof installation)
- [x] Streamlined documentation (essential files only)
- [x] Quality assurance framework
- [x] Version control and change management
- [ ] Phase 3: Final documentation and submission

## 📞 Support

For questions about this academic project:
- Review the comprehensive documentation in `/docs/`
- Check the [Quality Standards](docs/quality/evaluation-criteria.md) for evaluation criteria
- Refer to [Technical Standards](docs/guidelines/technical-standards.md) for implementation guidelines

## 📄 License

This project is developed for academic purposes as part of the Database Design course at IU International University. All work follows academic integrity standards and proper citation practices.

---

**Note**: This is an academic project for educational purposes. All database designs, implementations, and documentation follow university standards and academic integrity guidelines.
