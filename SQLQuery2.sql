create database SchoolTutoring
go
use SchoolTutoring
go

create table Schools
(Sid int primary key identity,
Name varchar(50) not null,
City varchar(50) not null,
NoOfStudents int not null)

create table Tutors
(Tid int primary key identity,
Name varchar(50) not null,
Salary int not null,
Email varchar(50) not null,
Sjid int foreign key references Subjects(Sjid))

create table TutorsSchools
(Sid int foreign key references Schools(Sid),
Tid int foreign key references Tutors(Tid),
NoOfTutors int not null,
constraint pk_TutSchool primary key (Sid, Tid))

--create table Years
--(Yid int primary key identity)

create table Students
(Stid int primary key identity,
Name varchar(50) not null,
Email varchar(50) not null,
Year int not null,
AverageGrade float not null)

create table StudentsTutors
(Tid int foreign key references Tutors(Tid),
Stid int foreign key references Students(Stid),
ClassesPerWeek int not null
constraint pk_StudTut primary key (Tid, Stid))

create table Subjects
(Sjid int primary key,
Name varchar(50) not null,
Price money not null)

create table Directors
(Did int foreign key references Schools(Sid),
Salary int not null,
Name varchar(50) not null,
Email varchar(50) not null
constraint pk_SchoolDirector primary key(Did))

drop table StudentsTutors
go

















.
constraint pk_StudTut primary key (Stid, Tid))

create table Subjects
(Sjid int primary key identity,
Name varchar(50) not null,
Price money not null)

create table Directors
(Did int foreign key references Schools(Sid),
Salary money not null,
Name varchar(50) not null,
Email varchar(50) not null
constraint pk_DirSchools primary key(Did))


--drop table years
--go

drop table Subjects
go

drop table StudentsTutors
go

drop table Tutors
go

drop table TotorsSchools
go
