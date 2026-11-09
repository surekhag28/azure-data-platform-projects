# 03 - Copy Single and Multiple SQL Tables to ADLS Gen2 using Azure Data Factory

## 1. Overview

This project demonstrates how to build data movement pipelines using Azure Data Factory (ADF) to copy data from Azure SQL Database to Azure Data Lake Storage Gen2 (ADLS Gen2).

Two implementations are covered:

- **Single-table copy:** Copying data from an individual SQL table to ADLS Gen2 using a Copy activity.
- **Multiple-table copy:** Dynamically copying data from multiple SQL tables to ADLS Gen2 using a Lookup activity, a configuration table and a ForEach activity.

Three source tables are used for the multiple-table implementation: `employee`, `department` and `customer`.

**Objective:** Understand how to build reusable and metadata-driven data pipelines in ADF, reducing the need to create separate pipelines for individual tables.

## 2. Architecture

### Section 1: Single-table copy

Copy data from a single Azure SQL Database table to ADLS Gen2.

**Pipeline flow:**

1. Configure an Azure SQL Database linked service.
2. Configure an ADLS Gen2 linked service.
3. Create a source dataset pointing to the SQL table.
4. Create a sink dataset pointing to the destination in ADLS Gen2.
5. Configure a Copy activity to move the data.
6. Execute the pipeline and validate the output in ADLS Gen2.

**Pipeline:** `pipeline-source-single-table`

### Section 2: Metadata-driven multiple-table copy

Copy multiple SQL tables to ADLS Gen2 using a configuration-driven approach.

Instead of hardcoding individual tables in the pipeline, a configuration table stores the list of tables to be copied. A Lookup activity retrieves the configuration, and a ForEach activity iterates through the returned records to execute the Copy activity dynamically.

**Source tables:**
- `employee`
- `department`
- `customer`

**Pipeline flow:**

1. Create a configuration table in Azure SQL Database containing the source table names.
2. Populate the configuration table with `employee`, `department` and `customer`.
3. Configure a Lookup activity to retrieve the table names from the configuration table.
4. Configure a ForEach activity to iterate over the Lookup output.
5. Configure a parameterised source dataset to dynamically reference each SQL table.
6. Configure a parameterised sink dataset to dynamically generate the destination file name and path.
7. Execute the Copy activity inside the ForEach loop.
8. Validate that all three tables have been copied successfully to ADLS Gen2.

**Pipeline:** `pipeline-multiple-tables-config-driven`

### Architecture Diagram

The following diagram illustrates the two data movement approaches implemented in this project.

![Architecture Diagram](screenshots/architecture-diagram)

## 3. Implementation Steps

### Section 1: Copy a Single SQL Table to ADLS Gen2

**Step 1: Configure Linked Services**

Create the following linked services:

- Azure SQL Database: Connect to the source database.
- ADLS Gen2: Connect to the destination storage account.

**Step 2: Configure the Source Dataset**

- Create an Azure SQL Database dataset.
- Select the required source table.
- Configure the dataset to use the SQL Database linked service.

**Step 3: Configure the Sink Dataset**

- Create an ADLS Gen2 dataset.
- Select the appropriate file format.
- Configure the destination container and folder.

**Step 4: Build the Pipeline**

- Create a pipeline named `pipeline-source-single-table`.
- Add a Copy activity.
- Configure the source using the SQL dataset.
- Configure the sink using the ADLS Gen2 dataset.

**Step 5: Execute and Validate**

- Debug or trigger the pipeline.
- Verify that the Copy activity completes successfully.
- Navigate to the destination folder in ADLS Gen2.
- Confirm that the output file has been created and contains the expected data.

### Section 2: Copy Multiple SQL Tables using a Lookup Configuration Table

**Step 1: Create the Configuration Table**

Create a configuration table in Azure SQL Database to maintain the list of source tables.

Example:

| table_name |
|---|
| employee |
| department |
| customer |

This table acts as the metadata source for the pipeline.

**Step 2: Configure the Lookup Activity**

- Add a Lookup activity to retrieve the table names from the configuration table.
- Configure the SQL dataset to point to the configuration table.
- Enable **First row only = False** to retrieve all configuration records.

**Step 3: Configure the ForEach Activity**

- Add a ForEach activity after the Lookup activity.
- Pass the Lookup activity output to the ForEach items property:

```text
@activity('Lookup_Config').output.value
```

- This allows the pipeline to iterate through each table name returned by the Lookup activity.

**Step 4: Parameterise the Source Dataset**

- Create a parameterised Azure SQL Database dataset.
- Add a dataset parameter named `table_name`.
- Use the parameter to dynamically select the source table:

```text
@dataset().table_name
```

- Pass the current table name from the ForEach iteration to the source dataset parameter:

```text
@item().table_name
```

**Step 5: Parameterise the Sink Dataset**

- Create a parameterised ADLS Gen2 dataset.
- Configure the destination folder and file name dynamically.
- Pass the table name to generate separate output files for each source table.

For example:

```text
@concat(item().table_name, '.parquet')
```

**Step 6: Configure the Copy Activity**

Inside the ForEach activity:

- Add a Copy activity.
- Configure the source using the parameterised SQL dataset.
- Pass the current table name from the ForEach iteration.
- Configure the sink using the parameterised ADLS Gen2 dataset.
- Pass the table name to generate the corresponding destination file.

**Step 7: Execute and Validate**

- Execute the pipeline.
- Verify that the Lookup activity retrieves all three configuration records.
- Check that the ForEach activity iterates through all three tables.
- Verify that each Copy activity completes successfully.
- Navigate to ADLS Gen2 and confirm that separate files have been created for `employee`, `department` and `customer`.

## 4. Snapshots

### Section 1: Single-table copy

**1. Source Configuration**

Shows the Copy activity configured with Azure SQL Database as the source.

![Single Table Source](./screenshots/01-pipeline-source-single-table)

**2. Target Configuration**

Shows the Copy activity configured with ADLS Gen2 as the destination.

![Single Table Target](./screenshots/01-pipeline-target-single-table)

**3. Pipeline Execution Output**

Shows the pipeline execution results and successful data movement.

![Single Table Pipeline Output](./screenshots/03-pipeline-output)

### Section 2: Metadata-driven multiple-table copy

**4. Lookup Configuration**

Shows the Lookup activity retrieving the source table names (`employee`, `department` and `customer`) from the SQL configuration table.

![Lookup Configuration](./screenshots/04-lookup-config)

**5. Dynamic Source Configuration**

Shows the parameterised SQL source dataset, dynamically selecting the source table based on the current ForEach iteration.

![Dynamic Source Configuration](./screenshots/05-pipeline-source-config)

**6. Dynamic Target Configuration**

Shows the parameterised ADLS Gen2 sink dataset, dynamically generating destination files for each source table.

![Dynamic Target Configuration](./screenshots/05-pipeline-target-config)

**7. Pipeline Execution and Validation**

Shows the pipeline execution results and validation of the multiple-table copy operation.

![Pipeline Validation](./screenshots/07-pipeline-validation)

## 5. Key Concepts Covered

- Azure SQL Database and ADLS Gen2 linked services.
- Source and sink dataset configuration.
- Copy activity for data movement.
- Lookup activity for retrieving metadata.
- ForEach activity for iterating over multiple records.
- Dataset parameterisation and dynamic expressions.
- Metadata-driven and reusable pipeline design.
- Pipeline execution monitoring and data validation.

## 6. Key Learnings

This project demonstrates two approaches to data movement using Azure Data Factory.

The single-table implementation introduces the fundamentals of configuring source and sink datasets and executing a Copy activity.

The metadata-driven implementation builds on these concepts by using a configuration table, Lookup and ForEach activities, and parameterised datasets to dynamically copy multiple tables.

The second approach makes the pipeline more reusable and scalable. Adding another source table only requires updating the configuration table rather than creating a separate pipeline or Copy activity for each table.

## 7. Technologies Used

- Azure Data Factory (ADF)
- Azure SQL Database
- Azure Data Lake Storage Gen2 (ADLS Gen2)
- SQL
- Dynamic Content and Expressions