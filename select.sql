use MerkulovaBaas;
CREATE TABLE laps(
lapsID int primary key identity(1,1),
nimi varchar(10) not null,
pikkus smallint,
synniaasta smallint,
synnilinn varchar(20)
);
SELECT * FROM laps;
--https://meet.google.com/pgc-mjbe-wuu
INSERT INTO laps(nimi, pikkus, synniaasta, synnilinn)
VALUES
('Kati', 156, 2001, 'Tallinn'),
('Mati', 166, 2005, 'Tartu'),
('Sati', 176, 2001, 'Tallinn'),
('Tati', 126, 2000, 'Tallinn'),
('Nuti', 125, 2003, 'Tartu');
--sorteerimine
--Asc, DESC- suurimast väikseni
SELECT nimi, pikkus
FROm laps
ORDER by pikkus DESC;

SELECT nimi, pikkus
FROm laps
ORDER by pikkus DESC, nimi;

--lapsed, mis on sündinud peale 2005
SELECT nimi, synniaasta
FROM laps
WHERE synniaasta >=2005
ORDER by nimi;
-- DISTINCT- näitab ainult 1 kordus
SELECT DISTINCT synniaasta
FROM laps
WHERE synniaasta>2000;
--BETWEEN
--lapsed mis on sündinud (2000 kuni 2005)
SELECT nimi, synniaasta
FROM laps
WHERE synniaasta >=2000 AND synniaasta <=2005

SELECT nimi, synniaasta
FROM laps
WHERE synniaasta  BETWEEN 2000 AND 2005;
--LIKE
-- näita lapsed, kelle nimi algab K
-- % kõik võimalikud sümboolid
-- sisaldab K täht - '%K%'
SELECT nimi
FROM laps
WHERE nimi like '%K%';

-- täpsem määratud tähtede arv _
SELECT nimi
FROM laps
WHERE nimi like '_a__';

--AND / OR
SELECT nimi, synnilinn
FROM laps
WHERE nimi like 'K%' 
OR synnilinn like 'Tartu';

SELECT nimi, synnilinn
FROM laps
WHERE nimi like 'K%' 
AND synnilinn like 'Tartu';

--Agregaatfunktsioonid
SUM, AVG, MIN, MAX, COUNT
SELECT COUNT(nimi)  AS 'laste Arv'
FROM laps;

SELECT AVG(pikkus) AS 'keskmine pikkus'
FROM laps
WHERE synnilinn='Tallinn';

--näita keskmine pikkus linnade järgi
-- GROUP by

SELECT AVG(pikkus) AS 'keskmine pikkus', synnilinn
FROM laps
GROUP by synnilinn
--näita laste arv, mis on sündinud 
--konkreetsel synniaastal

SELECT synniaasta, count(*) AS lasteARV
FROM laps
GROUP by synniaasta;

--HAVING -- piirang juba grupeeritud andmete osas
--keskmine pikkus iga synniaasta järgi
SELECT synniaasta, AVG(pikkus) AS keskmine
FROM laps
GROUP by synniaasta
HAVING AVG(pikkus)>150;

SELECT synniaasta, AVG(pikkus) AS keskmine
FROM laps
WHERE NOT synniaasta=2001
GROUP by synniaasta

--seotud tabel
CREATE TABLE loom(
loomID int PRIMARY KEY identity(1,1),
loomNimi varchar(50),
lapsID int,
FOREIGN KEY (lapsID) REFERENCES laps(lapsID)
);
INSERT INTO loom(loomNimi, lapsID)
VALUES('kass Kott', 1),
('koer Bobik', 1),
('koer Tuzik', 2),
('kass Tuzik', 3),
('kass Mura', 3),
('kilpkonn', 3);

SELECT * FROM loom;
--select seotud tabelite põhjal
SELECT * FROM loom, laps; -- ei näita õiged andmed
SELECT * FROM loom
INNER JOIN laps
ON loom.lapsID=laps.lapsID;
--lihtne vaade
SELECT l.loomNimi, la.nimi, la.synniaasta
FROM loom l, laps la
WHERE l.lapsID=la.lapsID;

