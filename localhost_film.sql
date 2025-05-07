CREATE TABLE film(
filmID int PRIMARY KEY AUTO_INCREMENT,
filmNimetus varchar(30) not null,
aasta int,
eelarveHind decimal(7,1)
);

INSERT INTO film(filmNimetus, aasta, eelarveHind)
VALUES('Titanic',  2024, 555555.5);

CREATE TABLE zanr(
zanrID int PRIMARY KEY AUTO_INCREMENT,
zanrNimetus varchar(20) UNIQUE
);

INSERT INTO zanr(zanrNimetus)
VALUES ('draama'), ('detektiiv');

SELECT * FROM zanr;

ALTER TABLE film ADD zanrID int;
SELECT * FROM film;
--tabeli film struktuuri muutmine --> 
--FK lisamine mis on seotud tabeliga zanr(zanrID)
ALTER TABLE film ADD CONSTRAINT fk_zanr
FOREIGN KEY (zanrID) REFERENCES zanr(zanrID);

select * from film;
select * from zanr;
UPDATE film SET zanrID=2 WHERE filmID=3
