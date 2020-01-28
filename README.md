
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
     
    ```Select * from product pwhere product_id IN(select product_id from order_items```
    
    Optimized SQL statement:
    
    ```Select * from product pwhere EXISTS (select * from order_items owhere o.product_id = p.product_id)``` 
    
* EXISTS vs DISTINCT : Use EXISTS instead of DISTINCT when using joins which involves tables having one-to-many relationship.

    Suboptimal SQL statement:
    
    ```SELECT DISTINCT d.dept_id, d.deptFROM dept d,employee eWHERE e.dept = e.dept;```


   Optimized SQL statement:

    ```SELECT d.dept_id, d.deptFROM dept dWHERE EXISTS ( SELECT 'X' FROM employee e WHERE e.dept = d.dept);```

