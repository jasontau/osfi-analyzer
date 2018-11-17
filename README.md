# Balsam API

Balsam provides a way to query, visualize and analyze financial data for Canadian property and casualty insurers.

## Concept

There is a wealth of publicly available financial data that has been filed with OSFI. By exposing this data to fast, modern means of analysis it is hoped that new insights into risk management can be found.

## Concerns

- Rails ActiveRecord does not support certain database features like composite keys.
- As the analysis aspect grows more complex this may impact performance.
- Must maintain detailed ERDs and documentation on data consumption in case migration to a different backend is necessary.

## Roadmap
1. Single Financial Statement Mapping (60.20 Consolidated Premiums and Claims)
a. Create a template to display the data as a financial statement
b. Generate year-specific schema
c. Parse, record, index and map the raw data to the template
2. Multiple Mapping
3. 