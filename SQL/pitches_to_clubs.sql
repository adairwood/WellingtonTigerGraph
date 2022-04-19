
select
  f.Stadium,
  f.Town_city,
  f.Capacity,
  f.Team,
  f2.Dimensions
from [football pitches2] as f2
inner join [footy2] as f
on f.Team = f2.Club
