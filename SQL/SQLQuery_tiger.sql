use de25_adairwood;

alter table weather_test_final
alter column tempC float;
alter table weather_test_final
alter column dewpointC float;
alter table weather_test_final
alter column humidity float;
alter table weather_test_final
alter column windSpeedKPH float
;

with cte (gameID,Season,[time],awayGoals,homeGoals,tempC,dewpointC,humidity,windSpeedKPH,weather,AVGtempC,AVGdewpointC,AVGhumidity,AVGwindSpeedKPH)
as
(
select
	matchresultssimple.gameID,
	matchresultssimple.Season,
	matchresultssimple.[time],
	matchresultssimple.awayGoals,
	matchresultssimple.homeGoals,
	weather_test_final.tempC,
	weather_test_final.dewpointC,
	weather_test_final.humidity,
	weather_test_final.windSpeedKPH,
	weather_test_final.weather,
	(select AVG(weather_test_final.tempC) from weather_test_final),
	(select AVG(weather_test_final.dewpointC) from weather_test_final),
	(select AVG(weather_test_final.humidity) from weather_test_final),
	(select AVG(weather_test_final.windSpeedKPH) from weather_test_final)
from matchresultssimple left join weather_test_final on (matchresultssimple.gameID = weather_test_final.gameID)
)
select
	gameID,
	Season,
	[time],
	awayGoals,
	homeGoals,
	case when tempC is null then AVGtempC else tempC end as tempC,
	case when dewpointC is null then AVGdewpointC else dewpointC end as dewpointC,
	case when humidity is null then AVGhumidity else humidity end as humidity,
	case when windSpeedKPH is null then AVGwindSpeedKPH else windSpeedKPH end as windSpeedKPH,
	weather
from cte
;

/*case when weather_test2.tempC is null then AVG(weather_test2.tempC) else weather_test2.tempC end */