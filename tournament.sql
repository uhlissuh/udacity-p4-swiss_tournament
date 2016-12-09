-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE tournament;

CREATE DATABASE tournament;

CREATE TABLE players
  (
    id serial primary key,
    player_name text,
  );

CREATE TABLE matches
  (
    id serial primary key,
    winner integer references players(id),
    loser integer references players(id)
  );

CREATE VIEW win_counts as
SELECT players.id, count(matches.winner) as wins
from players left join matches
on players.id = matches.winner
group by players.id
order by wins desc;

CREATE VIEW loss_counts as
SELECT players.id, count(matches.loser) as losses
from players left join matches
on players.id = matches.loser
group by players.id;

CREATE VIEW match_counts as
SELECT players.id, loss_counts.losses + win_counts.wins as matches
from players, loss_counts, win_counts
where players.id = loss_counts.id and players.id = win_counts.id;

CREATE VIEW standings as
SELECT players.id, players.player_name, win_counts.wins, match_counts.matches
from players, win_counts, match_counts
where players.id = win_counts.id and players.id = match_counts.id;
