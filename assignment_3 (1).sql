use assignment;
/*
1. Write a stored procedure that accepts the month and year as inputs and prints the ordernumber, orderdate and status of the orders placed in that month. 

Example:  call order_status(2005, 11);
code for order_status

select orderNumber, orderDate, status from orders where year(orderDate) = order_year and month(orderDate) = order_month;
*/
call assignment.order_status(2005,5);
##########################################################################################################
/*
2. Write a stored procedure to insert a record into the cancellations table for all cancelled orders.

STEPS: 

a.	Create a table called cancellations with the following fields

id (primary key), 
 	customernumber (foreign key - Table customers), ,

All values except id should be taken from the order table.
*/

create table cancellations (id int primary key, customernumber int, foreign key (customernumber) references customers(customerNumber), 
ordernumber int, foreign key (ordernumber) references orders(orderNumber),comments varchar(255));

alter table cancellations modify id int auto_increment;

#b. Read through the orders table . If an order is cancelled, then put an entry in the cancellations table.

/*
CODE cancel_update:
declare ostatus, ocomments varchar(300);
declare ocustomernumber, oordernumber int;
declare mycur cursor for select customerNumber, orderNumber, status,comments from orders;
declare exit handler for not found
begin
select "UPDATED" as msg;
end;
open mycur;
myloop: loop
fetch mycur into ocustomernumber, oordernumber,ostatus,ocomments;
if (ostatus = 'cancelled') then
insert into cancellations values (default,ocustomerNumber, oorderNumber, ocomments);
end if;
end loop;
close mycur;
*/
call assignment.cancel_update();
select * from cancellations;
################################################################################################################################################33
/*
3. a. Write function that takes the customernumber as input and returns the purchase_status based on the following criteria . [table:Payments]

if the total purchase amount for the customer is < 25000 status = Silver, amount between 25000 and 50000, status = Gold
if amount > 50000 Platinum
*/
set global log_bin_trust_function_creators=1;
select pstatus(496);
/*
CODE pstatus
CREATE DEFINER=`root`@`localhost` FUNCTION `pstatus`(num int) RETURNS char(50) CHARSET utf8mb4
BEGIN
declare msg char(50);
declare pvalue decimal(10,2);
set pvalue = (select sum(amount) from payments where customerNumber=num);
if pvalue <25000 then
set msg = 'SILVER';
elseif  pvalue<50000 then
set msg = 'GOLD';
elseif pvalue>50000 then
set msg = 'PLATINUM';
else
set msg = 'INVALID';
end if;
RETURN msg;
*/

#b. Write a query that displays customerNumber, customername and purchase_status from customers table.

select customerNumber,customerName, pstatus(customerNumber) as Payment_Status from customers;
########################################################################################################################
#4. Replicate the functionality of 'on delete cascade' and 'on update cascade' using triggers on movies and rentals tables. Note: Both tables - movies and rentals - don't have primary or foreign keys. Use only triggers to implement the above.
/*
DELETE CASCADE:

CREATE DEFINER=`root`@`localhost` TRIGGER `DELET_CASCADE` BEFORE DELETE ON `movies` FOR EACH ROW BEGIN
delete from rentals where movieid=old.id;
END
*/
/*
UPDATE CASCADE:
CREATE DEFINER=`root`@`localhost` TRIGGER `UPDATE_ON_CASCADE` BEFORE UPDATE ON `movies` FOR EACH ROW BEGIN
update rentals set movieid=new.id where movieid=old.id;
END
*/
#5. Select the first name of the employee who gets the third highest salary. [table: employee]
select * from (select rank() over (order by salary desc) as rank_value, empid,fname,lname,deptno, salary from employee)t1 where rank_value=3;

#6. Assign a rank to each employee  based on their salary. The person having the highest salary has rank 1.
select rank() over (order by salary desc) as rank_value, empid,fname,lname,deptno, salary from employee;
