# Azure Data Platform Projects

Hands-on learning and implementation of Azure Data Factory (ADF) pipelines and data engineering concepts.

This repository documents a series of mini projects, from basic file copies to a complete metadata-driven ingestion framework. Each project builds on the previous one and has its own README with the implementation steps and screenshots.

## Projects

| # | Project | Description | Key Concepts | Pipelines |
|---|---|---|---|---|
| 01 | [Basic File Copy](./docs/01-basic-copy-single-file/README.md) | Copy a single file between ADLS Gen2 locations, with and without a file-name parameter | Linked services, datasets, Copy activity, pipeline and dataset parameters, managed identity | `pl_copy_single_file_from_adls_to_adls`, `pl_copy_single_file_from_adls_to_adls_copy_with_param` |
| 02 | [Multiple File Copy](./docs/02-basic-copy-multiple-files/README.md) | Copy all files in a folder and rename them dynamically with the current date | Get Metadata, ForEach, Set Variable, dynamic file naming | `pl_copy_multiple_files_from_adls_to_adls` |
| 03 | [Copy SQL Tables to ADLS Gen2](./docs/03-basic-copy-sql-tables/README.md) | Copy a single SQL table, then multiple tables driven by a configuration table | Lookup, ForEach, parameterised datasets, metadata-driven design | `pl_copy_single_table`, `pl_copy_multiple_tables` |
| 04 | [Metadata-Driven Full and Incremental Ingestion](./docs/04-complete-data-ingestion/README.md) | End-to-end ingestion from Azure SQL to the ADLS Gen2 Bronze layer, with full and incremental loads | Parent and child pipelines, If Condition, watermark-based incremental load, stored procedures, success and failure audit logging | `pl_data_ingestion`, `pl_data_load_child` |

## Project READMEs

| # | Project | README |
|---|---|---|
| 01 | Basic File Copy | [docs/01-basic-copy-single-file/README.md](./docs/01-basic-copy-single-file/README.md) |
| 02 | Multiple File Copy | [docs/02-basic-copy-multiple-files/README.md](./docs/02-basic-copy-multiple-files/README.md) |
| 03 | Copy SQL Tables to ADLS Gen2 | [docs/03-basic-copy-sql-tables/README.md](./docs/03-basic-copy-sql-tables/README.md) |
| 04 | Metadata-Driven Full and Incremental Ingestion | [docs/04-complete-data-ingestion/README.md](./docs/04-complete-data-ingestion/README.md) |

## Learning Path

1. **[01 - Basic File Copy](./docs/01-basic-copy-single-file/README.md):** Learn the core building blocks of ADF: linked services, datasets, the Copy activity and parameters.
2. **[02 - Multiple File Copy](./docs/02-basic-copy-multiple-files/README.md):** Move from one file to many using Get Metadata and ForEach.
3. **[03 - Copy SQL Tables to ADLS Gen2](./docs/03-basic-copy-sql-tables/README.md):** Move from files to database tables and introduce a configuration table.
4. **[04 - Metadata-Driven Full and Incremental Ingestion](./docs/04-complete-data-ingestion/README.md):** Combine everything into a reusable ingestion framework with full and incremental loads, watermark management and audit logging.

## Repository Structure

```text
azure-data-platform-projects/
├── adf/                                  # ADF resources synced through Git integration
│   ├── dataset/                          # Source and sink datasets
│   ├── linkedService/                    # Connections to Azure SQL, ADLS Gen2 and Key Vault
│   ├── pipeline/                         # Pipeline definitions (JSON)
│   └── publish_config.json               # Publish branch configuration
├── docs/
│   ├── 01-basic-copy-single-file/        # README, architecture diagram, screenshots
│   ├── 02-basic-copy-multiple-files/     # README, architecture diagram, screenshots
│   ├── 03-basic-copy-sql-tables/         # README, architecture diagram, screenshots
│   └── 04-complete-data-ingestion/       # README, screenshots
└── README.md
```

## Technologies Used

- Azure Data Factory (ADF)
- Azure Data Lake Storage Gen2 (ADLS Gen2)
- Azure SQL Database
- Azure Key Vault
- SQL and Stored Procedures
- Dynamic Content and Expressions
- Git and GitHub (ADF Git integration)