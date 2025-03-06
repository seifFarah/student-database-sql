# student-database-sql

# Media Store SQL Database & Analysis

## Overview
This project involves creating a SQL database for a media store and conducting various analytical queries to understand its current state. The queries focus on employee details, sales trends, payroll adjustments, customer segmentation, and media popularity.

## Project Structure
- `database.sql`: Contains the SQL code to create the database schema.
- `queries.sql`: Includes various SQL queries to analyse the data.
- `README.md`: Documentation explaining the project and how to use it.

## Features & Queries
### Employee Data Analysis
- Retrieves a sorted list of employees.
- Updates an employee's address.
- Creates an employment history table.

### Sales and Revenue Insights
- Aggregates yearly sales to understand revenue trends.

### Payroll Adjustments
- Determines employee pay rate based on years of experience.

### Customer & Employee Performance
- Identifies customers served by younger employees.
- Analyses the popularity of audio tracks in Germany.

### Media and Artist Analysis
- Lists artists, their albums, and the number of tracks per album.
- Evaluates AC/DC's popularity based on playlist data.

### Management Hierarchy Insights
- Finds the employee managing the most employees while being supervised.

## Getting Started
### Prerequisites
- Install SQLite or any SQL database management system of your choice.
- Clone this repository:
  
  ```bash
  git clone https://github.com/seifFarah/student-database-sql.git
  cd student-database-sql
  ```

### Running the Project
1. **Create the Database**
   
   ```sql
   .read database.sql
   ```

2. **Run Queries**
   
   ```sql
   .read queries.sql
   ```

## Contributions
Contributions are welcome! Feel free to submit pull requests or open issues for improvements.
