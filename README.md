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
| **Phase 1** | ER Model Design (20+ entities) | 📋 Planning |
| **Phase 2** | Normalization & Constraints | 📋 Planning |
| **Phase 3** | SQL Implementation & Queries | 📋 Planning |

## 🏗️ Database Architecture

### Core Entities (20+ Required)
- **Users**: Hosts, guests, administrators with verification systems
- **Properties**: Listings with detailed descriptions, amenities, and rules
- **Bookings**: Reservation management with status tracking
- **Reviews**: Rating and feedback systems
- **Payments**: Financial transaction processing
- **Location**: Geographic data and address management
- **Communication**: Messaging and notification systems

### Technical Specifications
- **Database System**: PostgreSQL (recommended)
- **ER Notation**: IEEE notation (Crow's foot)
- **SQL Standard**: ANSI SQL:2016 compliance
- **Normalization**: 3NF minimum (BCNF bonus)
- **Documentation**: APA 7th Edition with IU modifications

## 📚 Documentation Structure

```
docs/
├── assignment/          # Original assignment documents
├── guidelines/          # Technical standards and best practices
├── submission/          # Submission requirements and checklists
├── quality/            # Evaluation criteria and standards
├── references/         # Citation guidelines and academic sources
└── changelog/          # Project version history
```

### 📖 Key Documentation
- **[Project Guidelines](docs/guidelines/README.md)** - Technical standards and development workflow
- **[Submission Requirements](docs/submission/README.md)** - Phase-specific deliverables and formatting
- **[Quality Standards](docs/quality/evaluation-criteria.md)** - Evaluation criteria and success factors
- **[Citation Guidelines](docs/references/README.md)** - APA 7th Edition citation standards

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
- PostgreSQL (or compatible database system)
- SQL client (pgAdmin, DBeaver, or command line)
- Diagramming tool (Draw.io, Lucidchart)
- Text editor with SQL syntax highlighting

### Project Structure
```
airbnb-clone-database/
├── docs/                    # Comprehensive documentation
├── sql/                     # SQL scripts and implementations
├── diagrams/                # ER diagrams and schemas
├── reports/                 # Final academic reports
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
- [ ] Phase 1: ER Model implementation
- [ ] Phase 2: Normalization and constraints
- [ ] Phase 3: SQL implementation and queries
- [ ] Final documentation and submission

## 📞 Support

For questions about this academic project:
- Review the comprehensive documentation in `/docs/`
- Check the [Quality Standards](docs/quality/evaluation-criteria.md) for evaluation criteria
- Refer to [Technical Standards](docs/guidelines/technical-standards.md) for implementation guidelines

## 📄 License

This project is developed for academic purposes as part of the Database Design course at IU International University. All work follows academic integrity standards and proper citation practices.

---

**Note**: This is an academic project for educational purposes. All database designs, implementations, and documentation follow university standards and academic integrity guidelines.
