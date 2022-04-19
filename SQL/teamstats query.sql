;with cte1 as
(
select
g.gameid,
g.teamid,
t.[name] as teamName,
g.leagueid,
l.[name] as leagueName,
l.understatNotation as leageCode,
g.season, 
cast(date as varchar(25)) as datentime,
[location],
g.[goals] as goalsScored,
goalsConceded,
xGoals, 
shots,
shotsOnTarget,
deep, 
ppda,
fouls, 
corners, 
YellowCards, 
redCards, 
result, 
probWin, 
HTGoals
from naghmezamani.matchmerged2 as g
join leagues as l 
on l.leagueID=g.leagueID
join teams as t 
on g.teamID=t.teamid
)

select
gameid,
teamid,
teamName,
leagueName,
season, 
substring(datentime, 1, 11) as [Date],
substring(datentime, 12, 5) as [Time],
[location],
goalsScored,
goalsConceded,
xGoals, 
shots,
shotsOnTarget,
deep, 
ppda,
fouls, 
corners, 
YellowCards, 
redCards, 
result, 
probWin, 
HTGoals 
from cte1 as c
where leagueid=1