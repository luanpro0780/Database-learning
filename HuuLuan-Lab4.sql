﻿create database PManagement
go
use PManagement
go

create table Customer(
	CustomerID varchar(5) primary key,
	CusName Nvarchar(30) not null,
	CusAddress Nvarchar (50),
	Phone varchar(10) ,
	Email varchar(30) 
)
create table Product(
	ProductID varchar(5) primary key,
	ProductName Nvarchar(30) not null,
	Unit Nvarchar(20),
	Prices float check (Prices > 0),
	Quantity int check (Quantity >= 0),
)
create table Invoice(
	InvoiceID Nvarchar(10) primary key,
	DateInvoice datetime,
	CustomerID varchar(5),
	TotalValue int,
	Constraint fr_CI foreign key(CustomerID) references Customer(CustomerID)
)
create table InvoiceDetail(
	InvoiceID Nvarchar(10),
	ProductID varchar(5),
	QuantityOfSell int check (QuantityOfSell > 0),
	Price float check (Price > 0),
	Promotion float
	constraint fr_1 primary key(InvoiceID,ProductID),
	constraint fr_2 foreign key(InvoiceID) references Invoice(InvoiceID),
	constraint fr_3 foreign key(ProductID) references Product(ProductID) 
)

1.	Write An SQL Query to display the list of customers whose address is "Tân Bình"
 
	select CustomerID,CusName,CusAddress
	from Customer
	where CusAddress = N'Tân Bình';
2.	Write An SQL Query to display the list of customers who do not have a phone number.

	select CustomerID,CusName,Phone
	from Customer
	where Phone = 'null';
3.	Write An SQL Query to display the list of products with the unit is "Cái".

	select *
	from Product
	where Unit = N'Cái';
4.	Write An SQL Query to displays the list of products including: product code, product name, unit and prices for which the prices is above 25,000.
	
	select ProductID,ProductName,Unit,Prices
	from Product
	where Prices >= 25000;
5.	Write An SQL Query to display the list of products which has product name is "Gạch" (including types of Gạch).

	select *
	from Product
	where ProductName like N'%Gạch%'
/*6.	Write An SQL Query to update the promotion column of table Invoice detail as follows: If the quantityofsell >50 then promotion is 0, If  the quantityofsell >=50 and quantityofsell<100 then promotion is 10% (quantityofsell *price*0,1) else promotion is 20%.

	update InvoiceDetail
		set Promotion = 0
		where QuantityOfSell < 50
	update InvoiceDetail
		set Promotion = QuantityOfSell*Price*0.1
		where QuantityOfSell >= 50 and
			  QuantityOfSell <100		  	
	update InvoiceDetail
		set Promotion = QuantityOfSell*Price*0.2
		where QuantityOfSell >= 100
	select *
	from InvoiceDetail*/
7.	Write An SQL Query to update the column Total_value of the table Invoice.
	
	update Invoice
	set TotalValue = (select sum(QuantityOfSell * Price) from InvoiceDetail B where Invoice.InvoiceID = b.InvoiceID)
	select *
	from Invoice
8.	Write An SQL Query to displays a list of products which has the price range of 20000 to 40000.
	
	select *
	from Product
	where Prices >= 20000	and Prices <= 40000;
9.	Write An SQL Query to display the information including: Invoicecode, customername and customeraddress on 25/5/2019.

	select InvoiceID,CusName,CusAddress
	from Invoice a,Customer b
	where a.CustomerID = b.CustomerID and DateInvoice = '05/25/2019';
10.	Write An SQL Query to display Invoice code, invoicedate, customername of invoices in June 2019.

	select InvoiceID,DateInvoice,CusName
	from Invoice a,Customer b
	where a.CustomerID = b.CustomerID and month(DateInvoice) = 6 and year(DateInvoice) = 2019;
11.	Write An SQL Query to display a list of customers who did not buy product in June 2010. The Information include: customername, address, phone number.

	select CusName,CusAddress,Phone
	from Customer 
	where CustomerID
	not in (select CustomerID from Invoice where month(DateInvoice) = 6 and year(DateInvoice) = 2010);
12.	Write An SQL Query to display invoice details including: invoiceID, productID, name of product, unit,  price, quantity of sell, purchase value (prices * quantity), sale value (price * quantityofsell).

	select ProductID,ProductName,unit,prices,quantity,(Quantity*Prices)as purchase
	from Product
	select InvoiceID,ProductID,QuantityOfSell,Price,(QuantityOfSell*price) as sale
	from InvoiceDetail;
13.	Write An SQL Query to display all the information of unsold products.

	select *
	from Product
	where ProductID not in (select ProductID from InvoiceDetail);
14.	Write An SQL Query to display the statistics table of the first quarter of 2019 with including the following information: The number of invoice, purchase value, sale value, profit (sales value - purchase value).

	select InvoiceID,(Quantity*Prices) as Purchase_Value, (QuantityOfSell*Price) as Sell_Value,(QuantityOfSell*Price - Quantity*Prices) as Profit
	from InvoiceDetail a, Product b
	where a.ProductID = b.ProductID
15.	Write An SQL Query to display the invoices has the largest TotalValues, the information includes: Invoice code, invoice date, customer name and total value of the invoice.

	select top 1 InvoiceID,DateInvoice,Cusname,TotalValue
	from Customer a, Invoice b
	where a.CustomerID = b.CustomerID
	order by TotalValue desc
/*16.	Write An SQL Query to display the customer code, customer name and the number of invoice that customer has.

	select a.CustomerID,CusName,InvoiceID
	from Invoice a, Customer b
	where a.CustomerID = b.CustomerID and InvoiceID is not null*/
17.	Write An SQL Query to display information about products that are sold in the most invoices.

	select a.ProductID,productName,quantity,QuantityOfSell
	from Product a, InvoiceDetail b
	where a.ProductID = b.ProductID and QuantityOfSell is not null
18.	Write An SQL Query to show a list of all customers including: Customer code, customer name and the number of invoice (if the customer has not yet buying anything, the column of invoice number is null). 
	select InvoiceID,(Quantity*Prices) as Purchase_Value, (QuantityOfSell*Price) as Sell_Value,(QuantityOfSell*Price - Quantity*Prices) as Profit
	from InvoiceDetail a, Product b
	where a.ProductID = b.ProductID
