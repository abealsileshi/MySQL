use classicmodels;

#1) List in alphabetical order without duplicates the names of the cities in Spain where ClassicModels has customers. (3)
select distinct(city)
	from Customers 
    where country in ('Spain')
    Order by city asc;
    
#2) List the employee id, last name, first name of each employee who works in Paris (use a subquery). (5)

select employeeNumber, lastName, firstName
    from Employees
    where
		officeCode = '4';

#3. List the ProductCode, ProductName, ProductScale, ProductVendor, buyPrice for all products that are in the Motorcycles product line and have a buyPrice greater than 50 and less than 80. (5)
select productCode, productName, productScale, productVendor, buyPrice
	from Products
    where
		productLine = 'motorcycles'
        having (buyPrice > 50 && buyPrice < 80);
        
#4. List the productCode, productName, productLine, quantityInStock, buyPrice for the least expensive Vintage Cars from ExotoDesigns. (1)

select productCode, productName, productLine, quantityinStock, MIN(buyPrice)
	from Products
    where productVendor = 'Exoto Designs'
    AND productLine = 'Vintage Cars';
/*
select productCode, productName, productLine, quantityinStock, MIN(buyPrice)
	from Products
    where buyPrice = (select min(buyPrice)
    from products
    where productVendor = "Exoto Designs" and productLine = "Vintage Cars");
*/

#5. List the top 5 most expensive Order Items (by total cost) listing the product name, the vendor, the quantity and the total cost for each ordered item. (5) HINT: total cost = (quantityOrdered * priceEach)
select productName, productVendor, orderNumber, quantityOrdered, priceEach, sum(priceEach * quantityOrdered) as 'Total Cost'
	from OrderDetails O, Products P
    #where does the join
    where O.productCode = P.productCode
    group by productName, productVendor, orderNumber, quantityOrdered, priceEach
    order by 'Total Cost' desc
    limit 5;
    
#6. List the customerNumber, customerName, phone, country, state, corresponding RepEmployee’s Number, and creditLimit for customers with a credit limit of more than 130,000. List them in order from lowest to highest creditLimit. (5)
select customerNumber, customerName, phone, country, state, salesRepEmployeeNumber, creditLimit
	from Customers
	where creditLimit > 130000;
    
#7. List the productCode, productName, and count of orders for the product with the most orders where the productVendor is Welly Diecast Productions. Make sure to title the column heading for the count of orders as “OrderCount”. (1)
select O.productCode, productName, count(quantityOrdered) AS 'OrderCount' #SQL doesn't know where quantityOrdered is from
	from Products P, orderDetails O
    where productVendor = 'Welly Diecast Productions'
    and P.productCode = O.productCode
    #the rule for a group by is that every column name that is not a group function
	group by O.productCode, productName
    order by count(quantityOrdered)  desc
    limit 2; 

/*8. (use SUBQUERY)
List the name, city, state, country, credit limit, and total products ordered for the top 3 customers who ordered the most products. (3)
(hint: who has the highest total quantity in OrderProducts across all their orders?) (3) */

select C.customerName, C.city, C.state, C.country, C.creditLimit, sum(OD.quantityOrdered) as totalorders
	from Customers C
	join Orders O
    on C.customerNumber = O.customerNumber
    join OrderDetails OD
    on O.orderNumber = OD.orderNumber
    group by C.customerNumber
    order by totalorders desc
    limit 3;
    
/*9. List the OfficeCode, city, state, country of all the offices that are not in USA 
and occupying the entire building (the office has no addressLine2 recorded).(2)*/
    
select officeCode, city, state, country
	from Offices 
	where country != "USA"
	and addressline2 is null;
        
#10. List the productName and productLine for all Vintage Cars made in the 1930s (productName contains the string “193...”). (12)
select productName, productLine
	from Products
    where productName like '193%'
    and productLine = "Vintage Cars";
    
/* 11. Select the order number, required date, shipped date, date difference, and shipped month for orders 
which were shipped less than 3 days before they were due (required date - shipping date < 3) for orders shipped in 2005 (10). */
select orderNumber, requiredDate, shippedDate, (requiredDate - shippedDate) as dateDif, month(shippedDate)
	from Orders
    where (requiredDate - shippedDate) < 3 
    and year(shippedDate) = 2005;
    
/*12. List the customerNumber, customerName, city, country, and count of their orders for all customers whose customer number is lower than 150.
 List them in descending order from highest to least number of orders. Title the column heading for the count of orders “Orders”. (15) */
 select C.customerNumber, C.customerName, C.city, C.country, O.Orders
	from Customers C 
    join(select customerNumber, count(orderNumber) as Orders from Orders group by customerNumber order by Orders) as O
    on C.customerNumber = O.customerNumber
    where C.customerNumber < 150
    order by Orders desc;
    
/*13. List the customerName and customerNumber for customers in Switzerland that have no orders. (2) */
select C.customerName, C.customerNumber
	from Customers C
    left join Orders O
    on C.customerNumber = O.customerNumber
    where country = "Switzerland" 
    and O.customerNumber is null;
    
/*14. Select the product lines with over 12,000 orders (3)
In other words, if you tally up all the orders for classic cars, ships, trains, planes, etc., which categories have over 12,000 orders? */
select P.productLine
	from Products P
    join OrderDetails O
    on P.productCode = O.productCode
    group by P.productLine
    having (sum(O.quantityOrdered) > 12000);
    
/*15. Create a NEW table named “TopCustomers” with four columns: CustomerNumber (integer), ContactDate (DATE), OrderCount(integer), 
and OrderTotal (a decimal number with 9 digits in total having two decimal places). None of these columns can be NULL.
Include a PRIMARY KEY constraint named “TopCustomer_PK” on CustomerNumber. (no answer set) */
create table TopCustomers
	(CustomerNumber int not null,
    ContactDate date not null,
    OrderCount int not null,
    OrderTotal decimal(9,2) not null,
    constraint TopCustomer_PK
    primary key(CustomerNumber));

/* 16. Populate the new table “TopCustomers” with the CustomerNumber, today’s date, total number of orders (quantity), 
and the total value of all their orders (PriceEach * quantityOrdered) for those customers whose order total value is greater than $130,000. (inserted 16 rows, no answer set) */
insert into TopCustomers(CustomerNumber, ContactDate, OrderCount, OrderTotal)
	select C.CustomerNumber, curdate(), sum(quantityOrdered), sum(priceEach * quantityOrdered) as Total
    from Customers C, Orders O, OrderDetails OD
    where (C.CustomerNumber = O.CustomerNumber and O.orderNumber = OD.orderNumber)
    group by customerNumber
    having Total > 130000;
    
/*17. List the customerNumber, contactDate, orderCount, and orderTotal with the top five highest order totals from “TopCustomers” in descending orderTotal amount. (5) */
select CustomerNumber, ContactDate, OrderCount, OrderTotal
	from TopCustomers
    order by OrderTotal desc
    limit 5;
    
/*18. Add a new column to the TopCustomers table called CustomerRatings (integer) set to zero by default. (No answer set) */
alter table TopCustomers
	add CustomerRatings int default 0;
    
/*19. Update the TopCustomers table, setting the CustomerRatings column to a random number from 0 to*/
SET SQL_SAFE_UPDATES = 0;
update TopCustomers
	set CustomerRatings = floor(rand() * (10-0) + 0);

/*20. List the contents of the TopCustomers table in descending CustomerRatings sequence. (16)*/
select * 
	from TopCustomers
	order by CustomerRatings desc;
    
drop table TopCustomers;