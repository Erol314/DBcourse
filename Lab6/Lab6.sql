--Go
-- CREATE TABLE orarul 
-- ( Id_Disciplina INT, Id_Profesor INT, Id_Grupa SMALLINT , Zi VARCHAR (50), Ora TIME, Auditoriu INT)

-- SELECT c.name 
--	FROM sysobjects o JOIN syscolumns c ON o.id = c.id 
--		WHERE o.name = 'orarul' ; 
--ALTER TABLE orarul ADD Bloc CHAR (1) NOT NULL; 

--SELECT c.name 
--FROM sysobjects o JOIN syscolumns c ON o.id = c.id 
--		WHERE o.name = 'orarul' ; 

--ALTER TABLE orarul ALTER COLUMN Zi CHAR(2); 

--ALTER TABLE orarul DROP COLUMN Bloc; 

--USE universitatea 
--GO 
--	IF OBJECT_ID('orarul', 'U') IS  NOT NULL DROP TABLE orarul ;
--GO
--	CREATE TABLE orarul
--		 (Id_Disciplina INT NOT NULL,
--		  Id_Profesor INT,
--		  Id_Grupa SMALLINT,
--		  Zi CHAR(2),
--		  Ora TIME,
--		  Auditoriu  INT ,
--		  Bloc CHAR (1) NOT NULL DEFAULT ' B', 
--		  PRIMARY KEY (Id_Grupa, Zi, Ora, Auditoriu));



--from here starts the tasks
--(1)
--UPDATE profesori SET Adresa_Postala_Profesor = 'mun. Chisinau,' WHERE Adresa_Postala_Profesor IS NULL ;
--SELECT * FROM profesori 

--(2)
--ALTER TABLE grupe ALTER COLUMN Cod_Grupa char(8) NOT NULL;
--ALTER TABLE grupe ADD UNIQUE (Cod_Grupa) ;  

--(3)
--ALTER TABLE grupe ADD Sef_grupa INT, Prof_Indrumator INT;
	

--DECLARE  @Counter SMALLINT ;
--UPDATE grupe SET Sef_grupa = NULL , Prof_Indrumator = NULL;
--SET @Counter = 1;
--WHILE @Counter <> (SELECT  COUNT( * ) FROM grupe) +1
--	BEGIN
--		UPDATE grupe SET Sef_grupa = (SELECT TOP(1)   Id_Student  FROM
--										(SELECT  (SUM(Nota)*1.0 /COUNT(ID_STUDENT))
--												AS Nota_medie, id_student, Id_Grupa  FROM  studenti_reusita 
--										GROUP BY Id_Student, Id_Grupa HAVING Id_Grupa = @Counter) AS SubQuery
--									 ORDER BY Nota_medie DESC) 
--		WHERE Id_Grupa = @Counter; 


--		UPDATE grupe SET Prof_Indrumator = (SELECT TOP(1)   Id_Profesor FROM
--											(SELECT  TOP(1)  COUNT(Id_Disciplina)
--												AS Discipline_profesor, Id_Profesor, Id_Grupa  FROM  studenti_reusita 
--												GROUP BY Id_Profesor, Id_Grupa HAVING Id_Grupa = @Counter
--												ORDER BY COUNT(Id_Disciplina) DESC) AS SubQuery 
--											ORDER BY Id_Profesor ) 
--		WHERE Id_Grupa = @Counter; 

--		SET  @Counter =   @Counter + 1
--	END;
--SELECT * FROM grupe;

--SELECT * FROM grupe;
--SELECT * FROM studenti_reusita;

--(4)
--UPDATE studenti_reusita SET Nota = 1 + Nota
--	WHERE Nota < 10 AND Nota IN 
--				(SELECT  Nota FROM  studenti_reusita  S_r
--					JOIN grupe G ON S_r.Id_Student = G.Sef_grupa); 

--(5)
--IF OBJECT_ID('dbo.profesori_new', 'U') IS NOT NULL 
--  DROP TABLE dbo.profesori_new; 

--CREATE TABLE [dbo].[profesori_new](
--	[Id_Profesor] [int] NOT NULL,
--	[Nume_Profesor] [varchar](60) NOT NULL,
--	[Prenume_Profesor] [varchar](60) NOT NULL,
--	[Localitate] [varchar](255) NULL,
--	[Adresa_1] [varchar](255) NULL,
--	[Adresa_2] [varchar](255) NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[Id_Profesor] ASC)) ON [PRIMARY]

--DECLARE @id_prof INT;

--DECLARE IdProfesorCursor CURSOR FOR SELECT Id_Profesor FROM profesori;

--OPEN IdProfesorCursor FETCH NEXT FROM IdProfesorCursor INTO @id_prof;
--WHILE @@FETCH_STATUS = 0
--BEGIN
--    DECLARE @adresa_postala VARCHAR(255);
--	DECLARE @reversedAdresa_postala varchar(255)
--	DECLARE @reversedIndex INT;
--    DECLARE @localitatea VARCHAR(255);
--    DECLARE @adresa_1 VARCHAR(255);
--    DECLARE @adresa_2 VARCHAR(255);

--    DECLARE @street INT;
--    DECLARE @house INT;


--    SELECT @adresa_postala = Adresa_Postala_Profesor FROM profesori WHERE Id_Profesor = @id_prof;
--	SET @reversedAdresa_postala = REVERSE(@adresa_postala)
--	SET @reversedIndex = CHARINDEX(',',@reversedAdresa_postala);
--	IF ((@reversedIndex = 0) OR (@reversedIndex = 1)) 
--		BEGIN
--			SET @adresa_2 = NULL;
--			SET @house = 0;
--		END
--	ELSE
--		BEGIN
--			SET @house = LEN(@adresa_postala) - @reversedIndex;  
--			SELECT @adresa_2 =  RIGHT(@adresa_postala,LEN(@adresa_postala) - @house - 1);
--		END
--	SET @reversedIndex = CHARINDEX(',',@reversedAdresa_postala , LEN(@adresa_postala) - @house + 1)
	
--	SET @street = LEN(@adresa_postala) - @reversedIndex; 
--	IF (@reversedIndex = 0) 
--		SET @adresa_1 = NULL;
--	ELSE
--		SELECT @adresa_1 =  SUBSTRING (@adresa_postala, @street + 2,  @house - @street -1 )


--	SELECT @localitatea =  LEFT(@adresa_postala, @street);

--    INSERT INTO profesori_new
--    SELECT
--        Id_Profesor,
--        Nume_Profesor,
--        Prenume_Profesor,
--        @localitatea AS Localitatea,
--        @adresa_1 AS Adresa_1,
--        @adresa_2 AS Adresa_2
--    FROM profesori
--    WHERE Id_Profesor = @id_prof;

--    FETCH NEXT FROM IdProfesorCursor INTO @id_prof;
--END;

--DEALLOCATE IdProfesorCursor   

--SELECT * FROM profesori_new;
	
--(6)
--DROP TABLE IF EXISTS orarul;

--create table orarul
--(
--    Id_Disciplina INT NOT NULL,
--	Id_Profesor INT,
--	Id_Grupa SMALLINT,
--	Zi CHAR(10),
--	Ora TIME,
--	Auditoriu  INT ,
--	Bloc CHAR (1) NOT NULL DEFAULT ' B', 
--	PRIMARY KEY (Id_Grupa, Zi, Ora, Auditoriu)
--);

--DECLARE @CIB171 SMALLINT;
--SET @CIB171=(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa='CIB171');

--insert into orarul values
--    (107, 101, @CIB171, 'Luni', '08:00', 202, 'B'),
--    (108, 101, @CIB171, 'Luni', '11:30', 501, 'B'),
--    (119, 117, @CIB171, 'Luni', '13:30', 501, 'B');

--SELECT * FROM orarul;