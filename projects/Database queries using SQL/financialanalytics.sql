create database FinancialAnalytics;
use FinancialAnalytics;

-- customers table
create table customers(
	customerId int primary key,
    name varchar(100),
	email varchar(100),
    signupDate date,
    city varchar(100),
    isActive boolean
);

-- insert values in customer table
insert into customers values
(1,'param','mustafa12@gmail.com','2005-2-21','ahmedbad',True),
(2,'devarsh','devarsh12@gmail.com','2005-2-22','thailand',False),
(3,'jainam','jianam12@gmail.com','2005-2-24','mumbai',True),
(4,'vraj','vraj12@gmail.com','2005-2-23','goa',True);

-- accounts table
create table accounts(
	accountId int primary key,
    customerId int,
    balance decimal(10,2),
    accountType varchar(20),
    createdOn date,
    foreign key (customerId) references customers(customerId)
);

-- insert values in accounts table 
insert into accounts values
(101,1,14000.00,'personal','2005-2-2'),
(102,2,11000.00,'business','2005-1-11'),
(103,3,12000.00,'business','2005-1-14'),
(104,4,10000.00,'personal','2005-1-13');


-- transactions table
create table transactions(
	transactionId int primary key,
    accountId int,
    transactionDate date,
    trasactionType varchar(20), -- credit or debit
    amount decimal(10,2),
    merchant varchar(100),
    isFraud boolean,
    foreign key (accountId) references accounts(accountId)
);

-- transactions
insert into transactions values
(1001,101,'2007-1-1','credit',90000.00,'net banking',false),
(1002,102,'2007-1-11','debit',80000.00,'pintola',true),
(1003,103,'2007-1-4','credit',30000.00,'uber',true),
(1004,104,'2007-1-3','debit',10000.00,'UPI',false);

select * from customers;
select * from accounts;
select * from transactions;

-- total number of active customers
select count(*) as active_customers 
from customers
where isActive = 1;

-- total transactions and amount per month
select 
	date_format(transactionDate, '%Y-%m') as month,
    count(*) as totalTransactions,
    sum(amount) as totalAmount
from transactions
group by month
order by month;

-- customer wise total debit and credit

select  
	c.name,
    sum(case when t.trasactionType = 'credit' then t.amount else 0 end) as TotalCredit,
    sum(case when t.trasactionType = 'debit' then t.amount else 0 end) as TotalDebit
from customers c
join accounts a on c.customerId = a.customerId
join transactions t on a.accountId = t.accountId
group by c.name;

-- TOP 3 MERCHANTS by transaction volume
select merchant, count(*) as transactions, sum(amount) as totalSpent
from transactions 
group by merchant
order by totalSpent desc
limit 3;

-- detecting fraud rate by city
select 
	c.city,
    count(t.transactionId) as TotalTransactions,
    sum(case when t.isFraud = 1 then 1 else 0 end) as FraudTransactions,
    round(100 * sum(case when t.isFraud = 1 then 1 else 0 end) / count(t.transactionId),2) as FraudRatePct
from transactions t 
join accounts a on t.accountId = a.accountId
join customers c on a.customerId = c.customerId
group by c.city;


-- average debit per customer

select 
	c.name,avg(t.amount) as AvgDebit
from customers c
join accounts a on c.customerId = a.customerId
join transactions t on a.accountId = t.accountId
where t.trasactionType = 'debit'
group by c.name;

-- customers with no transactions 
select c.name
from customers c 
left join accounts a on c.customerId = a.customerId
left join transactions t on a.accountId = t.accountId
where t.transactionId is not null;