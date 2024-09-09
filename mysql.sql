1. What is mysql?
Ans.. Mysql is relational database management system, for orgranizing and managing the data;

2. What is the meaning of relational databse?
Ans. Relational database is type of database where data are stored in the form of rows and columns.

3. What is sql?
Ans.. SQL is a structured query language used to interact with relational databases. 
      It is used to query, update, and manage data, as well as to define and control database structures.

4. What is contraints?
Ans. Contrains are set of rules and regulation that we applied on columns in database table.
  such as Unique, Primary Key, Not Null, Auto_Increment, Foreign Key

Unique: 'Ensures all values in a column are distict'

Primary Key :'Used for uniquely identify each record in the table'

Not Null : 'Ensures that a column cannot have NULL values.'

AUTO_INCREMENT : 'Used to generate unique number for each record automatically'


Simple Crud Operation using mysql raw query.

1. Create User Table with userId, name, email, password, dob.
2. Insert some records into it.
3. Retreive all users name, id, and email add search option as well by users name;
4. Update users email to 'user@gmail.com' where userId id is 2;
5. Retreive single users details where userdId is 2;
6. Delete user details where userId is 2;



Types of sql statement;
DDL - data definition language
CREATE, ALTER, DROP, TRUNCATE, RENAME

DML: DATA manipulation language
SELECT, delete, update, insert

DCL: Data controll language;
allow us to manage users access to database;

1. 
CREATE USER 'frank'@'localhost' IDENTIFIED BY 'pass'

GRANT SELECT ON practice.users to 'frank'@'localhost';

GRANT ALL ON practice.* to 'frank'@'localhost';

GRANT type_of_permission ON database_name.table_name to 'username'@'localhost'

permissions - DROP, DELETE, ALTER, UPDATE, ALL, SELECT 



Data Types;
String data types;
CHAR fixed length   max 255 bytes;
example CHAR(3), it store 3 characters even if data is shorter than also.
extra space will be accupied by space.

Varchar 
it will store data max up to specified length 
example varchar(20)


Integar
--

Decimal

salary Decimal(3,3)
total six digit number, 3 digit after decimal.
Decimal(4,2) 10.22

float
used for approximate values only.
salary float(5,3)   
10.52367   -stored -- 10.524
size   - 4bytes 
maximum number of digits 23

Double 
size - 8 bytes 
maximum number of digits 53


Date.
YYYY-MM-DD;
2024-09-09
DATETIME;
TIMESTAMP;


CREATE TABLE USERS (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(70) NOT NULL,
    dob datetime default CURRENT_TIMESTAMP
);

2.
INSERT INTO USERS (name, email, password, dob) VALUES
('suresh', 'suresh@gmail.com', 'suresh@123', CURDATE()),
('ramesh', 'ramesh@gmail.com', 'ramesh@123', '2024-09-08'),
('hitesh', 'hitesh@gmail.com', 'hitesh@123', '2024-09-10'),
('rohan', 'rohan@gmail.com', 'rohan@123', '2024-09-15');

3.
SELECT * FROM USERS;
SELECT * FROM USERS WHERE name LIKE '%sh%';


5.
UPDATE USERS set email = 'rumesh@gmail.com' where userId = 2;

6. 
SELECT * FROM USERS where userId =2;

7.
DELETE FROM USERS WHERE userId =1;



RELATIONSHIP AND JOIN.

One to one RELATIONSHIP
User one profile,
User has many types of leaves;
user has many leaves;


-- 
one to many

create table orders
(
  order_id int auto_increment primary key,
  date_of_purchase date,
  userId int,
  Foreign key (userId) REFERENCES users(userId) ON DELETE CASCADE
);

create table order_item(
  itemId int auto_increment primary key,
  item_name varchar(20),
  item_quantity integer,
  item_price integer,
  order_id integer,
  Foreign key (order_id) references orders(order_id)
);


insert some records into it.
INSERT INTO orders (date_of_purchase, userId) VALUES
('2024-09-01', 2),   
('2024-09-02', 3);   



INSERT INTO order_item (item_name, item_quantity, item_price, order_id) VALUES
('Laptop', 1, 1000, 3),     
('Mouse', 2, 50, 3),        
('Keyboard', 1, 70, 4),     
('Monitor', 1, 300, 4);     

mysql> INSERT INTO order_item (item_name, item_quantity, item_price, order_id) VALUES
    -> ('Laptop', 1, 1000, 3),
    -> ('Mouse', 2, 50, 3),
    -> ('Keyboard', 1, 70, 4),
    -> ('Monitor', 1, 300, 4);
Query OK, 4 rows affected (0.01 sec)
Records: 4  Duplicates: 0  Warnings: 0

mysql> select * from users right join orders on users.userId=orders.order_id;
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+
| userId | name   | email            | password   | dob                 | order_id | date_of_purchase | userId |
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+
|      3 | numesh | ramesh@gmail.com | ramesh@123 | 2024-09-08 00:00:00 |        3 | 2024-09-01       |      2 |
|      4 | numesh | hitesh@gmail.com | hitesh@123 | 2024-09-10 00:00:00 |        4 | 2024-09-02       |      3 |
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+
2 rows in set (0.00 sec)

mysql> select * from users right join orders on users.userId=orders.order_id right join order_item on order_item.order_id=orders.order_id;
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+--------+-----------+---------------+------------+----------+
| userId | name   | email            | password   | dob                 | order_id | date_of_purchase | userId | itemId | item_name | item_quantity | item_price | order_id |
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+--------+-----------+---------------+------------+----------+
|      3 | numesh | ramesh@gmail.com | ramesh@123 | 2024-09-08 00:00:00 |        3 | 2024-09-01       |      2 |      5 | Laptop    |             1 |       1000 |        3 |
|      3 | numesh | ramesh@gmail.com | ramesh@123 | 2024-09-08 00:00:00 |        3 | 2024-09-01       |      2 |      6 | Mouse     |             2 |         50 |        3 |
|      4 | numesh | hitesh@gmail.com | hitesh@123 | 2024-09-10 00:00:00 |        4 | 2024-09-02       |      3 |      7 | Keyboard  |             1 |         70 |        4 |
|      4 | numesh | hitesh@gmail.com | hitesh@123 | 2024-09-10 00:00:00 |        4 | 2024-09-02       |      3 |      8 | Monitor   |             1 |        300 |        4 |
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+--------+-----------+---------------+------------+----------+
4 rows in set (0.00 sec)

mysql> select * from users right join orders on users.userId=orders.order_id right join order_item on order_item.order_id=orders.order_id where userId = 3;
ERROR 1052 (23000): Column 'userId' in where clause is ambiguous
mysql> select * from users right join orders on users.userId=orders.order_id right join order_item on order_item.order_id=orders.order_id where users.userId = 3;
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+--------+-----------+---------------+------------+----------+
| userId | name   | email            | password   | dob                 | order_id | date_of_purchase | userId | itemId | item_name | item_quantity | item_price | order_id |
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+--------+-----------+---------------+------------+----------+
|      3 | numesh | ramesh@gmail.com | ramesh@123 | 2024-09-08 00:00:00 |        3 | 2024-09-01       |      2 |      5 | Laptop    |             1 |       1000 |        3 |
|      3 | numesh | ramesh@gmail.com | ramesh@123 | 2024-09-08 00:00:00 |        3 | 2024-09-01       |      2 |      6 | Mouse     |             2 |         50 |        3 |
+--------+--------+------------------+------------+---------------------+----------+------------------+--------+--------+-----------+---------------+------------+----------+
2 rows in set (0.00 sec)
