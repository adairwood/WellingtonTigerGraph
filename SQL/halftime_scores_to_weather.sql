use de25_iwanthomas
;

with 
cte1 as
(
select
	w.gameID,
	w.Season,
	w.time,
	w.homeGoals,
	w.awayGoals,
	w.[Column 5],
	w.[Column 6],
	w.[Column 7],
	w.[Column 8],
	w.[Column 9],
	g.[Location],
	g.HTGoals

from matchResultsSimple_with_weather as w
inner join [GamesData-PremManager] as g
on w.gameID = g.gameID
where [Location] = 'h'
),
cte2 as
(
select
w.gameID,
	w.Season,
	w.time,
	w.homeGoals,
	w.awayGoals,
	w.[Column 5],
	w.[Column 6],
	w.[Column 7],
	w.[Column 8],
	w.[Column 9],
	g.[Location],
	g.HTGoals

from matchResultsSimple_with_weather as w
inner join [GamesData-PremManager] as g
on w.gameID = g.gameID
where [Location] = 'a'
)
select
	cte1.gameID,
	cte1.[time],
	cte1.Season,
	cte1.homeGoals,
	cte1.awayGoals,
	cte1.[Column 5] as temperature,
	cte1.[Column 6] as dewpoint,
	cte1.[Column 7] as humidity,
	cte1.[Column 8] as windSpeedKPH,
	cte1.[Column 9] as weather,
	cte1.HTGoals as HTGoalsHome,
	cte2.HTGoals as HTGoalsAway
from cte1
inner join cte2
on cte1.gameID = cte2.gameID



