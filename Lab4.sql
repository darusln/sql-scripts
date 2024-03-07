use SchoolTutoring
go

------------------------------------------------------------------------------
/*
a. Implement a stored procedure for the INSERT operation on 2 tables in 1-
n relationship; the procedure’s parameters should describe the entities /
relationships in the tables; the procedure should use at least 1 user-defined
function to validate certain parameters
*/
------------------------------------------------------------------------------

--CREATING PROCEDURES FOR SUBJECTS AND TUTORS

--function to check price of subject
create function checkPrice(@n int)
returns int as
begin
	declare @no int
	if @n>100 and @n<=500
		set @no=1
	else
		set @no=0
	return @no
end
go 

--function to check name
create function checkName(@v varchar(50))
returns bit as
begin
	declare @b bit
	if @v LIKE '[a-z]%[a-z]'
		set @b=1
	else
		set @b=0
	return @b
end
go
--function to check the salary of a tutor
create function checkSalary(@n int)
returns int as
begin
	declare @no int
	if @n>=1500 and @n<=4500
		set @no=1
	else
		set @no=0
	return @no
end
go 

--function to check the email
create function checkEmail(@v varchar(50))
returns bit as
begin
	declare @b bit
	if @v LIKE '_%@__%.__%'
		set @b=1
	else
		set @b=0
	return @b
end
go
drop function dbo.checkEmail

create procedure addSubjectsTutors @n varchar(50), @p int, @nt varchar(50), @s int, @e varchar(50)
as
begin
	if dbo.checkPrice(@p)=1 and dbo.checkName(@n)=1 and dbo.checkSalary(@s)=1 and dbo.checkName(@nt)=1 and dbo.checkEmail(@e)=1
	begin
		insert into Subjects(Name, Price) Values (@n, @p)
		insert into Tutors(Name, Salary, Email, Sjid) Values (@nt, @s, @e, (select top 1 Sjid from Subjects order by sjid desc))
		print 'Values added.'
		select * from Subjects
		select * from Tutors
	end
	else
		begin
		print 'The parameters are not correct'
		select * from Subjects
		select * from Tutors
	end
end
go

exec addSubjectsTutors 'Italian', 300, 'Mihaela Zaharia', 3000, 'mz@gmail.com'

delete from Tutors where name like 'Mihaela%'
delete from Subjects where name like 'Italian'

drop procedure addSubjectsTutors



select * from Tutors
select * from Subjects


------------------------------------------------------------------------------
/*
b. Create a view that extract data from at least 3 tables and write a SELECT
on the view that returns useful information for a potential user.
*/
------------------------------------------------------------------------------
create view v_st_t_sj
as
	select t.Name as TutorName, s.Name as StudentName, sj.Name as SubjectName
	from Students s
	inner join StudentsTutors st
	on s.Stid = st.Stid 
	inner join Tutors t
	on st.Tid = t.Tid
	inner join Subjects sj
	on sj.Sjid = t.Sjid
go

select * from v_st_t_sj	


------------------------------------------------------------------------------
/*
c. Implement a trigger for a table, for INSERT, UPDATE or/and DELETE;
the trigger will introduce in a log table, the following data: the date and the
time of the triggering statement, the trigger type (INSERT / UPDATE /
DELETE), the name of the affected table and the number of added /
modified / removed records.
*/
------------------------------------------------------------------------------

--create table Logs
create table Logs
(Lid int primary key identity not null,
TriggerDate date not null,
TriggerType varchar(15) not null,
NameAffectedTable varchar(15) not null,
NoAMDRows int not null)

drop table Logs

--IMPLEMENTING TRIGGERS FOR TABLE STUDENTS
--create table StudentsT
create table StudentsT
(stid int primary key,
Name varchar(50) not null,
Email varchar(50) not null,
Year int not null,
AverageGrade float not null)
go

drop table StudentsT

--create trigger for insert
create trigger Add_Students on Students for
insert
as
begin
	insert into StudentsT(stid, Name, Email, Year, AverageGrade)
	select stid, Name, Email, Year, AverageGrade
	from inserted
	insert into Logs(TriggerDate, TriggerType, NameAffectedTable, NoAMDRows)
	values (GETDATE(), 'INSERT', 'Students', @@ROWCOUNT) 
end
go

--create trigger for update
create trigger Update_Students on Students for
update
as
begin
	--set nocount on
	select i.stid, i.Name, i.Email, i.Year, i.AverageGrade
	from deleted d inner join inserted i on d.Stid=i.Stid	
	insert into Logs(TriggerDate, TriggerType, NameAffectedTable, NoAMDRows)
	values (GETDATE(), 'UPDATE', 'Students', @@ROWCOUNT) 
end
go

--create trigger for delete
drop trigger Update_Students

create trigger Delete_Students on Students for
delete
as
begin
	--set nocount on
	select stid, Name, Email, Year, AverageGrade
	from deleted
	insert into Logs(TriggerDate, TriggerType, NameAffectedTable, NoAMDRows)
	values (GETDATE(), 'DELETE', 'Students', @@ROWCOUNT) 
end
go

drop trigger Delete_Students

select * from Students
select * from StudentsT
select * from Logs


--some queries to test the triggers
insert into Students values('Caramela Sarata','cs@gmail.com', 13, 8.8)

update Students 
set Year = Year - 1
where AverageGrade < 5
update Students
set Year = Year +1
where AverageGrade >=5

delete from Students
where Year > 12


------------------------------------------------------------------------------
/*
d. Write a query that contains at least 2 of the following operators in the
execution plan (by using WHERE, ORDER BY, JOIN’s clauses):
	-clustered index scan;
	-clustered index seek;
	-nonclustered index scan;
	-nonclustered index seek;
	-key lookup
*/
------------------------------------------------------------------------------

SELECT * FROM sys.indexes
SELECT name FROM sys.indexes
select * from sys.indexes
where name like 'N%'

--create index tutors name
if exists (select name from sys.indexes where name='N_idx_tutors_name')
	drop index N_idx_tutors_name on Tutors
create nonclustered index N_idx_tutors_name on Tutors(Name)

--create index subjects name --i didnt do anything with it
if exists (select name from sys.indexes where name='N_idx_subjects_name')
	drop index N_idx_subjects_name on Subjects
create nonclustered index N_idx_subjects_name on Subjects(Name)

--create index students name
if exists (select name from sys.indexes where name='N_idx_students_name')
	drop index N_idx_students_name on Students
create nonclustered index N_idx_students_name on Students(Name)

--create index students year
if exists (select name from sys.indexes where name='N_idx_students_year')
	drop index N_idx_students_year on Students
create nonclustered index N_idx_students_year on Students(Year)

insert into Tutors values('Regghina Simion', 1500, 'rs@gmail.com', 2)

delete from Tutors where Name like 'Regghina%'

--ON TABLE TUTORS
--clustered index scan and seek
select t.Name, s.Name from Tutors t
inner join StudentsTutors st
on t.Tid=st.Tid 
inner join Students s
on st.Stid=s.Stid

--nonclustered index scan and key lookup
select * from Tutors
order by Name

--nonclustered index seek
select Name from Tutors
where Name like 'M%'

--ON TABLE STUDENTS
--clustered index scan and seek
select s.Name, st.ClassesPerWeek from StudentsTutors st
inner join Students s
on st.Stid=s.Stid 

--nonclustered index scan and key lookup
select * from Students
order by Year

--nonclustered index seek
select Year from Students
where Year >=10

