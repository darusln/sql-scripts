use SchoolTutoring
go

create or alter procedure do_1
as
begin
	alter table Tutors
	add PhoneNumber int
end
go --musai daca vreau sa pun mai multe proceduri intr un fisier

create or alter procedure undo_1
as
begin
	alter table Tutors
	drop column PhoneNumber
end
go

create or alter procedure do_2
as
begin
	alter table Tutors
	add constraint df_TutorsSalary default 1000 for Salary
end
go

create or alter procedure undo_2
as
begin
	alter table Tutors
	drop df_TutorsSalary
end
go

create or alter procedure do_3
as
begin
	create table Assistants(
	aid int primary key identity,
	Name varchar(50) not null,
	tid int not null)
end
go

create or alter procedure undo_3
as
begin
	drop table Assistants
end
go

create or alter procedure do_4
as
begin
	alter table Assistants
	add constraint fk_Assistants foreign key (tid) references Tutors(tid)
end
go

create or alter procedure undo_4
as
begin
	alter table Assistants
	drop fk_Assistants
end 
go


select * from Tutors

create table Version(version int)
insert into Version values(1)



create or alter procedure main @n int
as
begin

	declare @v int
	set @v = (select top 1 version from Version)
	print @v

	if @n < 1 or @n > 5
		begin
			print 'Incorrect version'
		end
	else
	begin
		declare @proc varchar(10)

		while @v < @n
		begin
			set @proc = concat('do_',@v)
			exec @proc

			set @v= @v+1

			update Version set version=@v
			
		end

		while @v > @n
		begin
			set @v= @v-1

			set @proc = concat('undo_',@v)
			exec @proc

			update Version set version=@v
			
		end
	end
end
go

declare @vs int
set @vs = (select top 1 version from Version)
print @vs

exec main @n = 3
go