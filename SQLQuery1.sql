use SchoolTutoring
go

--insert subjects
set identity_insert Subjects on
insert into Subjects(Sjid, Name, Price) values(1, 'Math', 150)
set identity_insert Subjects off
insert into Subjects values('English', 160)
insert into Subjects values('Biology', 100)
insert into Subjects values('Computer Science', 170)
insert into Subjects values('Romanian', 200)
insert into Subjects values('Religion', 300)

--insert tutors
insert into Tutors values('Vasile Chindris', 4000, 'vc@gmail.com', 6)
insert into Tutors values('Maria Pop', 2600, 'mp1@gmail.com', 2)
insert into Tutors values('Sorina Marcel', 2000, 'sm@gmail.com', 3)
insert into Tutors values('Anda Adam', 2700, 'aa@gmail.com', 4)
insert into Tutors values('Dana Rinzis', 2500, 'dr@gmail.com', 1)
insert into Tutors values('Marcel Pop', 3000, 'mp2@gmail.com', 5)
insert into Tutors values('Florin Petre', 3500, 'fp@gmail.com', 6)
insert into Tutors values('Costel Gheorghe', 1500, 'fp@gmail.com', 2)

--insert students and connect them to tutors
DBCC CHECKIDENT (Students, RESEED, 1)
go

insert into Students values('Bianca Busica','bb@gmail.com', 9, 5.5)
insert into Students values('Mara Calamitate','mc1@gmail.com', 11, 4.6)
insert into Students values('Mircea Calamitate','mc2@gmail.com', 11, 2.5)
insert into Students values('Constantina Brancusi', 'cb@yahoo.ro', 10, 8.5)
insert into Students values('Corina Pop', 'cp@yahoo.ro', 8, 9)
insert into Students values('Sorina Ciubuc', 'sc@yahoo.ro', 7, 9.5)
insert into Students values('Catalina Almasan', 'ca@yahoo.ro', 8, 4)
insert into Students values('Corina Butica', 'cb@yahoo.ro', 9, 6.6)

insert into StudentsTutors values(3, 1, 4)
insert into StudentsTutors values(5, 2, 3)
insert into StudentsTutors values(2, 3, 5)
insert into StudentsTutors values(4, 4, 6)
insert into StudentsTutors values(6, 2, 7)
insert into StudentsTutors values(1, 3, 8)
insert into StudentsTutors values(3, 5, 2)
insert into StudentsTutors values(5, 6, 3)
insert into StudentsTutors values(6, 7, 6)

--updates
update Tutors
set Salary = Salary + 100 
where Salary = 2500 and Name like 'M%'

update Students 
set Year = Year - 1, AverageGrade -= 1
where AverageGrade >= 5 



--delete
delete from StudentsTutors
where ClassesPerWeek between 6 and 8 

--union
select Name , Salary
from Tutors t
where Name like 'M_%'
union 
select Name ,Salary
from Tutors
where Salary >= 2500

--intersect
select Stid, Name, Year
from Students
where AverageGrade > 5
intersect
select Stid, Name, Year
from Students
where Year < 10

--except
select Stid, Name, Year
from Students
where Year < 10
except
select Stid, Name, Year
from Students
where AverageGrade < 5

 --inner join
select t.Name , st.ClassesPerWeek
from StudentsTutors st
inner join Tutors t
on t.Tid = st.Tid
select t.Name, s.Name 
from Students s
inner join Tutors t
on st.Stid = s.Stid

--left join
select s.Name, st.Tid
from Students s
left join StudentsTutors st
on s.Stid = st.Stid

--right join
select t.Tid, t.Name, s.Name, s.Stid
from Students s
right join StudentsTutors st
on s.Stid = st.Stid
--and st.Tid = 1
right join Tutors t
on st.Tid = t.Tid

--full join
select t.Name, s.Name, sj.Name
from Students s
full join StudentsTutors st
on s.Stid = st.Stid 
--and st.Tid = 1
full join Tutors t
on st.Tid = t.Tid
full join Subjects sj
on sj.Sjid = t.Sjid
order by t.Name desc

--in
select top 3 s.Name, s.AverageGrade
from Students s
where AverageGrade > 5 and s.Stid in (select st.Stid
										from StudentsTutors st)
order by s.AverageGrade desc

--exists
select distinct t.Salary
from Tutors t
where Salary > 2500 or exists (select st.Tid
										from StudentsTutors st
										where st.Tid = t.Tid)
order by t.Salary



--group by
select s.Year, t.Name, count(s.Stid)
from Students s
inner join StudentsTutors st
on s.Stid = st.Stid
inner join Tutors t
on t.Tid = st.Tid
group by s.Year, t.Name

--having 
select sj.Name, AVG(t.Salary) as Average
from Subjects sj
inner join Tutors t
on sj.Sjid = t.Sjid
group by sj.Name
having AVG(t.Salary) >= 2500
order by Average desc


select s.Year, s.AverageGrade, t.Name
from Students s
inner join StudentsTutors st
on s.Stid = st.Stid
inner join Tutors t
on t.Tid = st.Tid
group by s.Year, s.AverageGrade, t.Name
having AVG(s.AverageGrade) >=(select  top 1 MIN(s.AverageGrade) from Students)

select SS.Tid, SS.Name, SS.AverageGrade
from (select st.Tid, s.Name, s.AverageGrade
				from StudentsTutors st
				inner join Students s
				on st.Stid = s.Stid
				where s.AverageGrade >=5) SS order by SS.AverageGrade desc

select * from Subjects
select * from Tutors
select * from Students
select * from StudentsTutors

