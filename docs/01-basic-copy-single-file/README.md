# 01 - Basic File Copy using Azure Data Factory

## 1. Overview

This project demonstrates file movement using Azure Data Factory (ADF) and Azure Data Lake Storage Gen2 (ADLS Gen2).

Two pipeline implementations are covered:
- Copying a single file using a predefined file path.
- Copying a file using a dynamic file-name parameter.

**Objective:** Understand ADF linked services, datasets, Copy activity and pipeline parameters.

## 2. Architecture

The following diagram illustrates the data movement between the source and destination in ADLS Gen2 through Azure Data Factory.

![File Copy Architecture](./architecture.png)

## 3. Azure Services and Components

| Component | Purpose |
|---|---|
| Azure Data Factory | Orchestrates data movement |
| Azure Data Lake Storage Gen2 | Stores source and destination files |
| Linked Service | Establishes the connection between ADF and ADLS Gen2 |
| Source Dataset | Defines the input file location |
| Sink Dataset | Defines the destination file location |
| Copy Activity | Performs the file copy operation |

## 4. Authentication

The pipelines use the Data Factory System-assigned Managed Identity to authenticate with ADLS Gen2.

The managed identity is granted the `Storage Blob Data Contributor` role on the storage account.

This avoids storing storage account keys or credentials in the linked service.

## 5. Pipeline Implementations

### 5.1 Copy Single File (Without Parameters)

**Pipeline name:** `pl_copy_single_file`

The pipeline copies a file from a predefined source location to a predefined destination location using the Copy Data activity.

**Implementation steps:**
1. Created linked services for connecting to ADLS Gen2.
2. Created source and sink datasets with predefined file paths.
3. Added a Copy Data activity to the pipeline.
4. Configured the source and destination datasets.
5. Executed the pipeline and verified the copied file.

**Pipeline design**

![ADF Pipeline Design](./screenshots/01-pipeline-design.png)

**Source configuration**

![Copy Activity Source Configuration](./screenshots/02-copy-configuration_source.png)

**Sink configuration**

![Copy Activity Sink Configuration](./screenshots/02-copy-configuration_target.png)

**Execution and output verification**

![Pipeline Execution](./screenshots/03-pipeline-execution.png)

![Output Verification](./screenshots/04-output-verification.png)

### 5.2 Copy Single File (With File-Name Parameter)

The pipeline was enhanced to accept a file name dynamically, allowing different files to be copied without modifying the dataset configuration.

**Implementation steps:**
1. Created a pipeline parameter named `fileName`.
2. Parameterised the source dataset to accept the file name.
3. Parameterised the sink dataset to use the same file name.
4. Passed the file name when triggering the pipeline.
5. Executed the pipeline and verified the copied file.

**Demonstration:** [Watch Parameterised File Copy Demo](./videos/parameterised-file-copy.mp4)

## 6. Key Learnings

- Integrating Azure Data Factory with ADLS Gen2.
- Configuring linked services using managed identity authentication.
- Creating and configuring source and sink datasets.
- Implementing Copy Data activities.
- Using pipeline parameters for dynamic file selection.
- Monitoring and validating pipeline execution.
- Integrating ADF with GitHub for version control.

## 7. Possible Enhancements

- Copy multiple files from a folder.
- Use wildcard file selection.
- Implement error handling and retry policies.
- Introduce parallel file processing.

## 8. Repository Structure

ADF pipeline and related dataset and linked service definitions are maintained under the `adf/` directory.

Documentation and supporting materials are maintained under:

```text
docs/
└── 01-basic-copy-single-file/
    ├── README.md
    ├── architecture.png
    ├── screenshots/
    │   ├── 01-pipeline-design.png
    │   ├── 02-copy-configuration_source.png
    │   ├── 02-copy-configuration_target.png
    │   ├── 03-pipeline-execution.png
    │   └── 04-output-verification.png
    └── videos/
        └── parameterised-file-copy.mp4