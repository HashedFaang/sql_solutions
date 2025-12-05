# SQL Test – Solution Submission
Author: Harshit Mohan  
Platform: MySQL  8.4.0

This repository contains my responses to the SQL assessment shared during the technical evaluation process.  
The solutions are based entirely on the two tables provided in the problem statement: `transactions` and `items`.



## Approach Overview

For each question, I attempted to follow a clean and straightforward analytical approach.  
Wherever window functions helped reduce complexity, I used them instead of nested subqueries.  
Timestamp differences were computed using MySQL’s TIMESTAMPDIFF function for clarity and accuracy.



## Contents

### `harshit_sql_test.sql`
This file includes solutions for:

1. Monthly purchase counts excluding refunded orders  
2. Store count with 5+ transactions in October 2020  
3. Minimum purchase-to-refund time interval per store  
4. First-order transaction value per store  
5. Most frequent first-purchase item across buyers  
6. Refund eligibility flag (within 72 hours rule)  
7. Second successful purchase per buyer  
8. Timestamp of each buyer’s second transaction  

All queries are labelled, commented, and written with readability in mind.


## Assumptions

- Missing (NULL) refund_time indicates no refund was processed.  
- First order = earliest purchase_time for that entity.  
- The snapshot represents the entire dataset.  
- No additional constraints or indexes were assumed.

---

## Running the Queries

To execute the queries in MySQL Workbench or CLI:
