

--this command is included to make sure the database tournament has been deleted
DROP DATABASE tournament;

CREATE DATABASE tournament;

--connect to database
\c tournament

--keeps track of all players in tournament
CREATE TABLE players
  (
    id serial primary key,
    player_name text,
  );

--keeps track of matches between two players
CREATE TABLE matches
  (
    id serial primary key,
    winner integer references players(id),
    loser integer references players(id)
  );

--this view displays win totals for each player
CREATE VIEW win_counts as
SELECT players.id, count(matches.winner) as wins
from players left join matches
on players.id = matches.winner
group by players.id
order by wins desc;

--this view displays loss totals for each player
CREATE VIEW loss_counts as
SELECT players.id, count(matches.loser) as losses
from players left join matches
on players.id = matches.loser
group by players.id;

--this view keeps track of total matches played by a user
CREATE VIEW match_counts as
SELECT players.id, loss_counts.losses + win_counts.wins as matches
from players, loss_counts, win_counts
where players.id = loss_counts.id and players.id = win_counts.id;

--this view keeps track of a player's wins and matchcounts
CREATE VIEW standings as
SELECT players.id, players.player_name, win_counts.wins, match_counts.matches
from players, win_counts, match_counts
where players.id = win_counts.id and players.id = match_counts.id;
