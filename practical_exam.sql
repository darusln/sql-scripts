create database BookPrinting
go
use BookPrinting
go

create table Authors
(Aid int primary key identity,
Name varchar(20) not null,
Surname varchar(20) not null,
Bday date not null)

create table Books
(Bid int primary key identity,
Name varchar(50) not null,
NoPages int not null,
PubDate date not null,
Aid int foreign key references Authors(Aid))

create table Typographies
(Tid int primary key identity,
Name varchar(50) not null,
Address varchar(50) not null)

create table Printings
(Bid int foreign key references Books(Bid),
Tid int foreign key references Typographies(Tid),
constraint pk_Print primary key (Bid, Tid),
DelDate date not null,
NoCopies int not null)

create table Machines
(Mid int primary key identity,
Name varchar(50) not null,
Capacity int not null,
Price float not null)

create table TyposMachines
(Mid int foreign key references Machines(Mid),
Tid int foreign key references Typographies(Tid),
constraint pk_TyMa primary key (Mid, Tid),
StageName varchar(50) not null,
NoPieces int not null)

go

create or alter procedure Add_Printings @Bid int, @Tid int, @d date, @n int
as 
	declare @nr int;
	set @nr = 0;
	select @nr = COUNT(*) from Printings where Bid=@Bid and Tid=@Tid
	if(@nr<>0) begin
		update Printings
		set DelDate=@d, NoCopies=@n
		WHERE Tid=@Tid and Bid=@Bid
	end
	else begin
		insert into Printings values (@Bid, @Tid, @d, @n)
	END
go

exec Add_Printings 5, 3, '12/07/2003', 100
exec Add_Printings 5, 3, '08/07/2003', 50

exec Add_Printings 6, 2, '12/07/2006', 300

select * from Printings


insert into Authors values ('ana', 'banana', '12/12/1898')
insert into Authors values ('crina', 'pop', '11/13/1999') --4
insert into Authors values ('sorin', 'almasan', '03/06/1700') --5
insert into Authors values ('mara', 'cearea', '05/14/1998') --6

select * from Authors

insert into Books values ('ana plange' ,199, '12/12/1960', 1)
insert into Books values ('aventurile mele' ,987, '04/03/2012', 6) --3
insert into Books values ('familia mea' ,210, '07/23/2000', 4) --5
insert into Books values ('almasan story' ,230, '07/07/1730', 5) --6

select * from Books

insert into Typographies values ('noidea', 'str bucuriei 4')
insert into Typographies values ('randomtypography', 'str bucuresti 5')
insert into Typographies values ('hihiprinting', 'str ploiesti 17-19')

select * from Typographies

insert into Machines values ('boomachine', 300, 1999.9)
insert into Machines values ('anothermachine', 1000, 3999)
insert into Machines values ('cutemachine', 50, 599)
insert into Machines values ('lastmachine', 5000, 9999.99)

select * from Machines

insert into TyposMachines values (1, 1, 'cassandra', 200)
insert into TyposMachines values (2, 2, 'maria ioana', 890)
insert into TyposMachines values (2, 3, 'chiqal', 30)
insert into TyposMachines values (4, 3, 'koral', 3000)

select * from TyposMachines

go

create view author_copes
as
	select a.Name, a.Surname, p.NoCopies
	from Authors a
	left join Books b
	on a.Aid=b.Aid
	left join Printings p
	on b.Bid=p.Bid
go

select * from author_copes

go

create function  uf_TypoNames(@m int)
returns table 
as
	return
		select distinct t.Tid, t.Name , count(t.Name) as TName
		from Typographies t inner join TyposMachines tm on t.Tid=tm.Tid
		group by t.Tid, t.Name
		having count(t.Name)<=@m
go

drop function uf_TypoNames
go

select * from  uf_TypoNames(2)

