
### SQL
SQL Queries, Optimization, Lab


### SQL Optimization Notes

* SELECT clause - The sql query becomes faster if you use the actual columns names in SELECT statement instead of than '*' , as only the required data will be fetched

* Optimal order of joining tables - It is best to join tables starting with the one that will produce the least amount of results after filtering

* HAVING clause - Do not use HAVING clause for filtering use WHERE instead where ever possible. HAVING should only be used when filtering on an aggregated field

* Predicates - Push predicates into the OUTER JOIN clause whenever possibleFor SQL queries with the LEFT OUTER JOIN, pushing predicates of the right table from the WHERE clause into the ON condition helps the database optimizer generate a more efficient query. 
  
  Predicates of the left table can stay in the WHERE clause. 
  
   Suboptimal SQL statement: 
  
   ```SELECT TAB_A.COL1, TAB_B.COL1 FROM TAB_A LEFT OUTER JOIN TAB_B ON TAB_A.COL3 = TAB_B.COL3 WHERE TAB_A.COL1=123 AND TAB_B.COL2=456;``` 
  
   Optimized SQL statement:
  
   ```SELECT TAB_A.COL1, TAB_B.COL1 FROM TAB_A LEFT OUTER JOIN TAB_B ON TAB_A.COL3 = TAB_B.COL3 AND TAB_B.COL2=456 WHERE TAB_A.COL1=123;```

* Functions in Predicate : Avoid using functions in predicates.The index is not used by the database if there is a function on the column

* Wildcard at begining of Predicate : Avoid using wildcard (%) at the beginning of a predicate.The predicate LIKE '%abc' causes full table scan. For example:SELECT * FROM TABLE1 WHERE COL1 LIKE '%ABC'


* Subqueries - Sometimes you may have more than one subqueries in your main query. Try to minimize the number of subquery block in your query

   Suboptimal SQL statement: 
  
   ```SELECT name FROM employeeWHERE salary = (SELECT MAX(salary) FROM employee_details) AND age = (SELECT MAX(age) FROM employee_details)AND emp_dept = 'Electronics';```
  
   Optimized SQL statement:
  
   ```SELECT name FROM employee WHERE (salary, age ) = (SELECT MAX (salary), MAX (age)FROM employee_details)AND dept = 'Electronics';``` 
  

* EXISTS vs IN : Use operator EXISTS, IN and table joins appropriately in your query.

    * Usually IN has the slowest performance.
    * IN is efficient when most of the filter criteria is in the sub-query.
    * EXISTS is efficient when most of the filter criteria is in the main query. 
    
    Suboptimal SQL statement:
     
    ```Select * from product p where product_id IN(select product_id from order_items```
    
    Optimized SQL statement:
    
    ```Select * from product p where EXISTS (select * from order_items owhere o.product_id = p.product_id)``` 
    
* EXISTS vs DISTINCT : Use EXISTS instead of DISTINCT when using joins which involves tables having one-to-many relationship.

   Suboptimal SQL statement:
    
    ```SELECT DISTINCT d.dept_id, d.dept FROM dept d,employee eWHERE e.dept = e.dept;```


   Optimized SQL statement:

    ```SELECT d.dept_id, d.dept FROM dept dWHERE EXISTS ( SELECT 'X' FROM employee e WHERE e.dept = d.dept);```
    
* UNION ALL vs UNION : Try to use UNION ALL in place of UNION wherever possible (as UNION performs sorting as well)
  
  
* WHERE clause : Be careful while using conditions in WHERE clause 

    * < or > (allows indexing) should be used instead of != (doesn't allow indexing)
    * LIKE (allows indexing) should be used instead of functions like SUBSTR (doesn't allow indexing)
    * Use non-column expression on one side of the query because it will be processed earlier.
  
  Suboptimal SQL statement:
  
  ```SELECT id, name, salary FROM employee WHERE salary + 10000 < 35000;```
    
  Optimized SQL statement: 
    
   ```SELECT id, name, salaryFROM employee WHERE salary < 25000;```

* Indexing :

  * Over-Indexing a Table - 
            When a table has too many indexes, write operations become slower as every UPDATE, DELETE, and INSERT that touches an indexed column must update the indexes on it. 
            In addition, those indexes take up space on storage as well as in database backups. 
            “Too Many” is vague, but emphasizes that ultimately application performance is the key to determining whether things are optimal or not. 
  
  * Under-Indexing a Table - 
            An under-indexed table does not serve read queries effectively. Ideally, the most common queries executed against a 
            table should benefit from indexes. Less frequent queries are evaluated on a case-by-case need and indexed when beneficial. 
            When troubleshooting a performance problem against tables that have few or no non-clustered indexes, then the issue is likely 
            an under-indexing one. In these cases, feel empowered to add indexes to improve performance as needed!

* Too many tables in join :
           What are some useful ways to optimize a query that is suffering due to too many tables? 
     * Move metadata or lookup tables into a separate query that places this data into a temporary table.
     * Joins that are used to return a single constant can be moved to a parameter or variable.
     * Break a large query into smaller queries whose data sets can later be joined together when ready.
     * For very heavily used queries, consider an indexed view to streamline constant access to important data.
     * Remove unneeded tables, subqueries, and joins
