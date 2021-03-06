﻿Create Database Football_Management
Go
Use Football_Management
Go

Create table Team(
Team_ID varchar(5) primary key,
Team_Name nvarchar(30)
);

Create table Match(
Match_ID INT,
Team_ID varchar(5),
Goals INT check (Goals >= 0),
primary key(Match_ID, Team_ID),
foreign key(Team_ID) references Team
);

insert into Team(Team_ID, Team_Name)
values('VN', N'Việt Nam'),
	  ('LA', N'Lào'),
      ('TL', N'Thái Lan'),
	  ('CPC', 'Campuchia');

insert into Match(Match_ID, Team_ID, Goals)
values('01', 'VN', '3'),
	  ('01', 'TL', '1'),
	  ('02', 'VN', '5'),
	  ('02', 'LA', '0'),
	  ('03', 'TL', '3'),
	  ('03', 'CPC', '3'),
	  ('04', 'TL', '2'),
	  ('04', 'LA', '0');


--1-	Write an SQL query to print the number of matches each team has played. Show: TeamID, TeamName, NumberOfMatches.
select distinct a.Team_ID, Team_Name, a.NumberOfMatches
from Team,(select Team_ID, count(Match_ID)  NumberOfMatches
		   from Match
           group by Team_ID) a
where Team.Team_ID = a.Team_ID

--2-	Write an SQL query to write the name of team who is the most wins.
select top 1 c.Team_Name, count(*) win
from Team c, Match a, Match b
where(a.Match_ID = b.Match_ID and a.Goals > b.Goals and c.Team_ID = a.Team_ID)
group by c.Team_Name
order by win desc

--3-	Write an SQL query to write the name of team who has not yet to play with Viet Nam.
select top 1 c.Team_Name TeamNotPlayerWithVietNam
from Match a, Match b,Team c
where a.Match_ID <> b.Match_ID and a.Team_ID = 'VN' and a.Team_ID <> b.Team_ID and c.Team_ID = b.Team_ID
group by c.Team_Name
order by c.Team_Name

--4-	Write an SQL query to print the match result according to the score.
select distinct a.Match_ID, a.Team_ID + ' - ' + b.Team_ID Teams, str(a.Goals,2) + '-' + str(b.Goals,2)
from Match a, Match b
where a.Match_ID = b.Match_ID and
	  a.Team_ID > b.Team_ID

--5-	Write an SQL query to print results for each match in points.
select a.Match_ID, a.Team_ID, Point = case
when a.Goals > b.Goals then '3'
when a.Goals < b.Goals then '0'
when a.Goals = b.Goals then '1'
	end
from Match a, Match b
Where a.Match_ID = b.Match_ID and a.Team_ID <> b.Team_ID

--6-	Write an SQL query to print teamID, team name, total points.
select a.Team_ID, Team_Name, sum(Point) as total_point
from Team a,(select distinct b.Match_ID, b.Team_ID, case when a.Goals > b.Goals then '3' when a.Goals < b.Goals then '0' when a.Goals = b.Goals then '1'
			 end as Point
			 from Match a, Match b
			 where a.Match_ID = b.Match_ID and a.Team_ID <> b.Team_ID 
			 where a.Team_ID = b.Team_ID
			 group by a.Team_ID, Team_Name

--7-	Write an SQL query to sort the list of teams for rankings.
select a.Team_ID, sum(a.Goals) WinGoal
from Match a, Match b
group by a.Team_ID

select a.Team_ID, sum(a.Goals) LostGoal
from Match a, Match b
where a.Match_ID = b.Match_ID and a.Team_ID <> b.Team_ID
group by a.Team_ID

select a.Team_ID, a.Team_Name, b.total_point, goaldifference = Wingoal-Lostgoal
from Team a,(select a.Team_ID, Team_Name, sum(Point)as total_point
from Team a,(select distinct b.Match_ID, b.Team_ID, case when a.Goals > b.Goals then '3' when a.Goals < b.Goals then '0' when a.Goals = b.Goals then '1'
			 end as Point
			 from Match a, Match b
			 where a.Match_ID = b.Match_ID and a.Team_ID <> b.Team_ID 
			 where a.Team_ID = b.Team_ID
			 group by a.Team_ID, Team_Name) b,(select a.Team_ID, sum(a.Goals) Wingoal
											   from Match a
											   group by a.Team_ID) c,(select a.Team_ID, sum(b.Goals) Lostgoal
																	  from Match a, Match B
																	  where a.Match_ID = b.Match_ID and a.Team_ID <> b.Team_ID
																	  group by a.Team_ID)d
																	  where a.Team_ID = b.Team_ID and a.Team_ID = c.Team_ID and a.Team_ID = d.Team_ID
																	  order by total_point desc, goaldifference desc

--8-	Write an SQL query to show unplayed matches:Unplayed matches	LA - CPCVN – CPC