
### SQL
SQL Queries, Optimization, Lab


### SQL Optimization Notes

* **SELECT clause** - The sql query becomes faster if you use the actual columns names in SELECT statement instead of than '*' , as only the required data will be fetched

* **Optimal order of joining tables** - It is best to join tables starting with the one that will produce the least amount of results after filtering

* **HAVING clause** - Do not use HAVING clause for filtering use WHERE instead where ever possible. HAVING should only be used when filtering on an aggregated field

* **Predicates** - Push predicates into the OUTER JOIN clause whenever possibleFor SQL queries with the LEFT OUTER JOIN, pushing predicates of the right table from the WHERE clause into the ON condition helps the database optimizer generate a more efficient query. 
  
  Predicates of the left table can stay in the WHERE clause. 
  
   *Suboptimal SQL statement:* 
  
   ```SELECT TAB_A.COL1, TAB_B.COL1 FROM TAB_A LEFT OUTER JOIN TAB_B ON TAB_A.COL3 = TAB_B.COL3 WHERE TAB_A.COL1=123 AND TAB_B.COL2=456;``` 
  
   *Optimized SQL statement:*
  
   ```SELECT TAB_A.COL1, TAB_B.COL1 FROM TAB_A LEFT OUTER JOIN TAB_B ON TAB_A.COL3 = TAB_B.COL3 AND TAB_B.COL2=456 WHERE TAB_A.COL1=123;```

* **Functions in Predicate** : Avoid using functions in predicates.The index is not used by the database if there is a function on the column

* **Wildcard at beginning of Predicate** : Avoid using wildcard (%) at the beginning of a predicate.The predicate LIKE '%abc' causes full table scan. For example:SELECT * FROM TABLE1 WHERE COL1 LIKE '%ABC'


* **Subqueries** - Sometimes you may have more than one subqueries in your main query. Try to minimize the number of subquery block in your query

   *Suboptimal SQL statement:* 
  
   ```SELECT name FROM employee WHERE salary = (SELECT MAX(salary) FROM employee_details) AND age = (SELECT MAX(age) FROM employee_details) AND emp_dept = 'Electronics';```
  
   *Optimized SQL statement:*
  
   ```SELECT name FROM employee WHERE (salary, age ) = (SELECT MAX (salary), MAX (age)FROM employee_details) AND dept = 'Electronics';``` 
  

* **EXISTS vs IN** : Use operator EXISTS, IN and table joins appropriately in your query.

    * Usually IN has the slowest performance.
    * IN is efficient when most of the filter criteria is in the sub-query.
    * EXISTS is efficient when most of the filter criteria is in the main query. 
    
    *Suboptimal SQL statement:*
     
    ```Select * from product p where product_id IN (select product_id from order_items)```
    
    *Optimized SQL statement:*
    
    ```Select * from product p where EXISTS (select * from order_items o where o.product_id = p.product_id)``` 
    
* **EXISTS vs DISTINCT** : Use EXISTS instead of DISTINCT when using joins which involves tables having one-to-many relationship.

   *Suboptimal SQL statement:*
    
    ```SELECT DISTINCT d.dept_id, d.dept FROM dept d,employee e WHERE e.dept = e.dept;```


   *Optimized SQL statement:*

    ```SELECT d.dept_id, d.dept FROM dept d WHERE EXISTS ( SELECT 'X' FROM employee e WHERE e.dept = d.dept);```
    
* **UNION ALL vs UNION** : Try to use UNION ALL in place of UNION wherever possible (as UNION performs sorting as well)
  
  
* **WHERE clause** : Be careful while using conditions in WHERE clause 

    * < or > (allows indexing) should be used instead of != (doesn't allow indexing)
    * LIKE (allows indexing) should be used instead of functions like SUBSTR (doesn't allow indexing)
    * Use non-column expression on one side of the query because it will be processed earlier.
  
  *Suboptimal SQL statement:*
  
  ```SELECT id, name, salary FROM employee WHERE salary + 10000 < 35000;```
    
  *Optimized SQL statement:* 
    
   ```SELECT id, name, salary FROM employee WHERE salary < 25000;```

* **Indexing** :

  * Over-Indexing a Table - 
            When a table has too many indexes, write operations become slower as every UPDATE, DELETE, and INSERT that touches an indexed column must update the indexes on it. 
            In addition, those indexes take up space on storage as well as in database backups. 
            “Too Many” is vague, but emphasizes that ultimately application performance is the key to determining whether things are optimal or not. 
  
  * Under-Indexing a Table - 
            An under-indexed table does not serve read queries effectively. Ideally, the most common queries executed against a 
            table should benefit from indexes. Less frequent queries are evaluated on a case-by-case need and indexed when beneficial. 
            When troubleshooting a performance problem against tables that have few or no non-clustered indexes, then the issue is likely 
            an under-indexing one. In these cases, feel empowered to add indexes to improve performance as needed!

* **Too many tables in join** :
           What are some useful ways to optimize a query that is suffering due to too many tables? 
     * Move metadata or lookup tables into a separate query that places this data into a temporary table.
     * Joins that are used to return a single constant can be moved to a parameter or variable.
     * Break a large query into smaller queries whose data sets can later be joined together when ready.
     * For very heavily used queries, consider an indexed view to streamline constant access to important data.
     * Remove unneeded tables, subqueries, and joins

* **Use Explain Plan !!**


* **Subquery vs JOIN**

  Modern RDBMs, including Oracle, optimize most joins and sub queries down to the same execution plan. Thererfore, write your query in the way that is simplest for you and focus on ensuring that you've fully optimized your indexes.
  
  However, keep in mind below scnarios - 
  
  * JOINS should be used - We need columns from other tables as well - Joins work on tables, tables have indices, and indexed queries are faster. Subqueries return a set of data. Joins return a dataset which is necessarily indexed. Working on indexed data is faster so if the dataset returned by subqueries is large, joins are a better idea  
  
  * SUBQUERY should be used - Use a subquery when you need no columns from the tables referenced in the subquery. Use a join when you do need some of the columns.  
  
    *Suboptimal SQL statement:*
  
    ```select emp.* from emp, dept where emp.deptno = dept.deptno;```
  
    *Optimized SQL statement:* 

    ```select * from emp where deptno in ( select deptno from dept );```
    
 * **Correlated vs Non-correlated Subqueries**
    
    * A non-correlated subquery is executed only once and its result can be swapped back for a query, on the other hand, 
    * A correlated subquery executed multiple times, precisely once for each row returned by the outer query. 
    
    *Correlated :* 
    
     ```SELECT e.Name, e.Salary FROM Employee eWHERE 2 = (SELECT COUNT(Salary) FROM Employee p WHERE p.salary >= e.salary)```  
     
    
   *Non-correlated :*
    
     ```SELECT MAX(Salary) FROM Employee WHERE Salary NOT IN ( SELECT MAX(Salary) FROM Employee)``` 
    
    
   * In many cases, you can replace correlated subquery with inner join which would result in better performance. 
    
   For example, to find all employees whose salary is greater than the average salary of the department you can write following correlated subquery: 
    
   *Correlated :*
    
    ```SELECT e.id, e.name FROM Employee eWHERE salary > (SELECT AVG(salary)FROM Employee p WHERE p.department = e.department)```
    
   Now, you can convert this correlated subquery to a JOIN based query for better performance as shown below: 
  
   *Non-correlated :* 
    
    ```SELECT e.id, e.name FROM Employee INNER JOIN (SELECT department, AVG(salary) AS department_average FROM Employee GROUP BY department) AS t ON e.department = t.departmentWHERE e.salary > t.department_average;```
    
    
    
  **HIVE** 
  
  * Map Side (Auto Map Join, or Map Side Join, or Broadcast Join.) vs Reduce Side Joins (Common Join or Sort Merge Join) 
  
       * We use Hive Map Side Join since one of the tables in the join is a small table and can be loaded into memory. 
        So that a join could be performed within a mapper without using a Map/Reduce step 
       
       * Map side join is a process where joins between between two tables are performed in the map phase without the involvement of reduce phase. 
        
       * Map side join allows a table to get loaded into memory ensuring a very fast join operation, performed entirely within a mapper and that too without having to use both map and reduce phases. 
        
       * Reduce side join also called as Repartitioned join or Repartitioned sort merge join and also it is mostly used join type. It will have to go through sort and shuffle phase 
         which would incur network overhead.
       * Reduce side join uses few terms like data source, tag and group key lets be familiar with it.
         
       * set hive.auto.convert.join=True (However, this option set true, by default. Moreover, when a table with a size less than 25 MB 
        (hive.mapjoin.smalltable.filesize) is found, When it is enabled, during joins, the joins are converted to map-based joins)
       
       * Below are some limitations of Map Side join in Hive: 
         
         First, the major restriction is, we can never convert Full outer joins to map-side joins.However, 
         it is possible to convert a left-outer join to a map-side join in the Hive. 
         However, only possible since the right table that is to the right side of the join conditions, is lesser than 25 MB in size. 
         Also, we can convert a right-outer join to a map-side join in the Hive. 
         Similarly, only possible if the left table size is lesser than 25 MB 