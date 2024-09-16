use database pratice.

--retreive all employee details along with projects they are working on.

select e.empId, e.name,ifnull(p.name,'not assigned to project') as project_name from employee e left join emp_projects as emp_p on e.empId=emp_p.empId left join projects p on p.id=emp_p.projectId order by e.empId;

+-------+--------+-------------------------+
| empId | name   | project_name            |
+-------+--------+-------------------------+
|     1 | suresh | project1                |
|     2 | hitesh | project2                |
|     2 | hitesh | project1                |
|     3 | mahesh | not assigned to project |
|     4 | kitesh | not assigned to project |
+-------+--------+-------------------------+

how many employees are working on a project = input projectId =1

select p.id, count(e.empId) from projects p left join emp_projects e_p on e_p.projectId = p.id join employee e on e_p.empId=e.empId group by p.id;

+----+----------------+
| id | count(e.empId) |
+----+----------------+
|  1 |              2 |
|  2 |              1 |
+----+----------------+


count number of employee working on same project.

select ep.projectId, p.name,count(e.empId) as emp_count from employee e 
join emp_projects as ep 
on e.empId = ep.empId
join
projects as p
on ep.projectId = p.id
group by ep.projectId,p.name;

+-----------+----------+-----------+
| projectId | name     | emp_count |
+-----------+----------+-----------+
|         1 | project1 |         2 |
|         2 | project2 |         1 |
+-----------+----------+-----------+

1.solution.

select e.empId, e.name, e.salary from employee e
join emp_projects ep1 on e.empId = ep1.empId
where ep1.projectId in (select ep.projectId from emp_projects as ep
group by ep.projectId
having count(ep.empId)>1);

-- altername solution

mysql> with same_project(projectId) as (
    ->     select projectId from emp_projects
    ->     group by projectId
    ->     having count(empId)>1
    -> )
    -> select e.empId,e.name, ep.projectId as project_id, p.name as project_name from employee e
    -> join emp_projects ep on
    -> e.empId = ep.empId
    -> join projects p on ep.projectId = p.id
    -> where ep.projectId in (select sp.projectId from same_project sp)
    -> ;
+-------+--------+------------+--------------+
| empId | name   | project_id | project_name |
+-------+--------+------------+--------------+
|     1 | suresh |          1 | project1     |
|     2 | hitesh |          1 | project1     |
+-------+--------+------------+--------------+



-- create store procedure which accept projectid as parameter and list all the employee whose is working on that project.

delimiter //

create procedure get_project_emps(In projectId integer)
begin
select e.empId, e.name, e.salary, p.id as projectId, p.name as project_name
from employee e 
join 
emp_projects ep on ep.empId = e.empId
join
projects p on p.id= ep.projectId
where p.id =projectId;
end //

delimiter ;

call get_project_emps(1);
+-------+--------+--------+-----------+--------------+
| empId | name   | salary | projectId | project_name |
+-------+--------+--------+-----------+--------------+
|     1 | suresh |  40.00 |         1 | project1     |
|     2 | hitesh |  23.00 |         1 | project1     |
+-------+--------+--------+-----------+--------------+


-- create store procedure that takes projectId and returns details of employee working on that project as well as count .
delimiter //

create procedure get_project_emps_and_count(In projectId integer)
begin
select e.empId, e.name, e.salary, p.id as projectId, p.name as project_name
from employee e 
join 
emp_projects ep on ep.empId = e.empId
join
projects p on p.id= ep.projectId
where p.id =projectId;

select count(ep.empId) as emp_count from emp_projects ep
where ep.projectId = projectId;
end //

delimiter ;

 call get_project_emps_and_count(1);
+-------+--------+--------+-----------+--------------+
| empId | name   | salary | projectId | project_name |
+-------+--------+--------+-----------+--------------+
|     1 | suresh |  40.00 |         1 | project1     |
|     2 | hitesh |  23.00 |         1 | project1     |
+-------+--------+--------+-----------+--------------+
2 rows in set (0.00 sec)

+-----------+
| emp_count |
+-----------+
|         2 |
+-----------+



-- 
mysql> select * from order_item;
+--------+-----------+---------------+------------+----------+
| itemId | item_name | item_quantity | item_price | order_id |
+--------+-----------+---------------+------------+----------+
|      5 | Laptop    |             1 |       1000 |        3 |
|      6 | Mouse     |             2 |         50 |        3 |
|      7 | Keyboard  |             1 |         70 |        4 |
|      8 | Monitor   |             1 |        300 |        4 |
+--------+-----------+---------------+------------+----------+
4 rows in set (0.00 sec)

mysql> select * from orders;
+----------+------------------+--------+
| order_id | date_of_purchase | userId |
+----------+------------------+--------+
|        3 | 2024-09-01       |      2 |
|        4 | 2024-09-02       |      3 |
+----------+------------------+--------+
2 rows in set (0.00 sec)

mysql> select * from users;
+--------+--------+-------------------+-------------+---------------------+
| userId | name   | email             | password    | dob                 |
+--------+--------+-------------------+-------------+---------------------+
|      2 | numesh | rumesh@gmail.com  | suresh@123  | 2024-09-09 00:00:00 |
|      3 | numesh | ramesh@gmail.com  | ramesh@123  | 2024-09-08 00:00:00 |
|      4 | numesh | hitesh@gmail.com  | hitesh@123  | 2024-09-10 00:00:00 |
|      5 | numesh | rohan@gmail.com   | rohan@123   | 2024-09-15 00:00:00 |
|      7 | numesh | himesh@gmail.com  | himesh@123  | 2024-09-08 00:00:00 |
|      8 | numesh | sutesh@gmail.com  | suteshh@123 | 2024-09-08 00:00:00 |
|      9 | numesh | durgesh@gmail.com | durgesh@123 | 2024-09-08 00:00:00 |
|     10 | numesh | kireshh@gmail.com | kiresh@123  | 2024-09-08 00:00:00 |
|     11 | numesh | litesh@gmail.com  | litesh@123  | 2024-09-08 00:00:00 |
|     12 | numesh | nimesh@gmail.com  | nimesh@123  | 2024-09-08 00:00:00 |
+--------+--------+-------------------+-------------+---------------------+



-- add one column total_price in order_item, and create store procedure for that takes
-- item_id as input add update total_price for that item;

mysql> select * from order_item;
+--------+-----------+---------------+------------+----------+-------------+
| itemId | item_name | item_quantity | item_price | order_id | total_price |
+--------+-----------+---------------+------------+----------+-------------+
|      5 | Laptop    |             1 |       1000 |        3 |        NULL |
|      6 | Mouse     |             2 |         50 |        3 |        NULL |
|      7 | Keyboard  |             1 |         70 |        4 |        NULL |
|      8 | Monitor   |             1 |        300 |        4 |        NULL |
+--------+-----------+---------------+------------+----------+-------------+
4 rows in set (0.00 sec)

mysql> delimiter //
mysql> create procedure update_item_total_price(in item_id int)
    -> begin
    -> update order_item set total_price= item_quantity*item_price where
    -> itemId=item_id;
    -> end //
Query OK, 0 rows affected (0.03 sec)

mysql> delimiter ;
mysql> call update_item_total_price(5);
Query OK, 1 row affected (0.02 sec)

mysql> call update_item_total_price(6);
Query OK, 1 row affected (0.03 sec)

mysql> call update_item_total_price(7);
Query OK, 1 row affected (0.01 sec)

mysql> call update_item_total_price(8);
Query OK, 1 row affected (0.02 sec)

mysql> select * from order_item;
+--------+-----------+---------------+------------+----------+-------------+
| itemId | item_name | item_quantity | item_price | order_id | total_price |
+--------+-----------+---------------+------------+----------+-------------+
|      5 | Laptop    |             1 |       1000 |        3 |        1000 |
|      6 | Mouse     |             2 |         50 |        3 |         100 |
|      7 | Keyboard  |             1 |         70 |        4 |          70 |
|      8 | Monitor   |             1 |        300 |        4 |         300 |
+--------+-----------+---------------+------------+----------+-------------+
4 rows in set (0.00 sec)

-- create trigger that update total_price for order_item while inserting;
 delimiter //

 create trigger update_order_item_total_price 
 before insert on order_item 
 for each row
 begin
 set NEW.total_price = NEW.item_quantity * NEW.item_price;
 end //

 delimiter ;

--- add column final_price in order tabale and update final_price 

 with order_item_price(orderId, total_price) as
     (select order_id, sum(total_price) from order_item group by order_id)
     update orders o
     join order_item_price c 
     on c.orderId = o.order_id
     set o.final_price=c.total_price;


with order_item_price(orderId, total_price) as
    ->      (select order_id, sum(total_price) from order_item group by order_id)
    ->      update orders o
    ->      join order_item_price c
    ->      on c.orderId = o.order_id
    ->      set o.final_price=c.total_price;
Query OK, 2 rows affected (0.02 sec)
Rows matched: 2  Changed: 2  Warnings: 0

mysql> select * from orders;
+----------+------------------+--------+-------------+
| order_id | date_of_purchase | userId | final_price |
+----------+------------------+--------+-------------+
|        3 | 2024-09-01       |      2 |        1100 |
|        4 | 2024-09-02       |      3 |         370 |
+----------+------------------+--------+-------------+
2 rows in set (0.00 sec)


-- write trigger that update total price column for that item in orders table when ever new item inserted;

delimiter //

create trigger update_order_final_price 
after insert on order_item
for each row
begin
declare order_final_price decimal(10,2);
select sum(total_price) into order_final_price from order_item where order_id= NEW.order_id;
update orders 
set final_price = order_final_price 
where order_id = NEW.order_id;
end //

delimiter ;



-- write query to retrive  order detials of user; 
-- the output should contain detilas about users id,name, email
-- detaials about orders
-- order_id, date of purchase, total_price;


select u.userId, u.name, u.email, o.order_id, o.date_of_purchase, o.final_price 
from users u
join 
orders o 
on u.userId = o.userId;