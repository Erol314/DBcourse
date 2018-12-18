--(1a)
DROP PROCEDURE IF EXISTS Ex1Lab9a;
GO

CREATE PROCEDURE Ex1Lab9a
	@street VARCHAR(20) 
AS 
	(select Nume_Student as last_name, Prenume_Student as first_name from [dbo].[Stdnt]
		where Adresa_Postala_Student like '%' + @street + '%') 
	UNION
	(select Nume_Profesor as last_name, Prenume_Profesor as first_name from Prof
		where Adresa_Postala_Profesor like '%' + @street + '%');
GO

EXEC Ex1Lab9a @street='31 August';


--(1b)
Use universitatea
Go

DROP PROCEDURE IF EXISTS Ex1Lab9b;

Go

CREATE PROCEDURE Ex1Lab9b 
	@Len INT = 20
AS
	(SELECT Disciplina
    FROM [dbo].[Discipl]
    WHERE LEN(Disciplina) > @Len);
GO
	EXEC Ex1Lab9b @Len = 20;

--(2)
DROP PROCEDURE IF EXISTS AflaRestantieri;
GO
CREATE PROCEDURE AflaRestantieri
	@restantieri INT OUTPUT
AS
	SELECT @restantieri=COUNT(DISTINCT Id_Student)
		FROM [dbo].[SReusita]
		WHERE Nota < 5 OR Nota IS NULL
GO

DECLARE @Result INT=0;

EXEC AflaRestantieri @restantieri = @Result output;

SELECt @Result as [NumarRestantieri];


--(3)
DROP PROCEDURE IF EXISTS AddStudent;
GO
CREATE PROCEDURE AddStudent
	@nume VARCHAR(50),
	@prenume VARCHAR(50),
	@data_nastere DATE,
	@adresa_postala VARCHAR(500),
	@cod_grupa VARCHAR(6)
AS
BEGIN
	DECLARE @id INT = (SELECT MAX(Id_Student) + 1 FROM [dbo].[Stdnt]);
	INSERT INTO [dbo].[Stdnt] 
	(
		Id_Student,
		Nume_Student,
		Prenume_Student,
		Data_Nastere_Student,
		Adresa_Postala_Student
	) 
	VALUES 
	(
		@id,
		@nume,
		@prenume,
		@data_nastere,
		@adresa_postala
	);

	INSERT INTO [dbo].[SReusita] 
	(
		Id_Student,
		Id_Disciplina,
		Id_Profesor,
		Id_Grupa,
		Tip_Evaluare,
		Nota,
		Data_Evaluare
	)
	VALUES
	(
		@id,
		(SELECT TOP 1 Id_Disciplina FROM [dbo].[Discipl]),
		(SELECT TOP 1 Id_Profesor FROM Prof),
		(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa = @cod_grupa),
		'Atestare 2',
		NULL,
		NULL
	)
END
GO

EXEC AddStudent
	@nume = 'Howard',
	@prenume = 'Lovecraft',
	@data_nastere = '20/08/1890',
	@adresa_postala = 'MD8000',
	@cod_grupa = 'TI171';

SELECT * FROM [dbo].[Stdnt] WHERE Nume_Student='Howard';
SELECT * FROM [dbo].[SReusita] WHERE Tip_Evaluare='Atestare 2';


--(4)
Use universitatea
Go

DROP PROCEDURE IF EXISTS ProfNou;
Go

CREATE PROCEDURE ProfNou
	@NumeProfPrecedent VARCHAR(60),
	@PrenumeProfPrecedent VARCHAR(60),
	@NumeProfNou VARCHAR(60),
	@PrenumeProfNou VARCHAR(60),
	@Disciplina VARCHAR(255)
AS
	BEGIN
	BEGIN TRY
		
		DECLARE @IdProfPrecedent INT = (SELECT p.Id_Profesor
				FROM [dbo].[Prof] AS p
				WHERE p.Nume_Profesor = @NumeProfPrecedent AND p.Prenume_Profesor = @PrenumeProfPrecedent);
		
		DECLARE @IdProfNou INT = (SELECT p.Id_Profesor
				FROM [dbo].[Prof] AS p
				WHERE p.Nume_Profesor = @NumeProfNou AND p.Prenume_Profesor = @PrenumeProfNou);

		DECLARE @IdDisciplina INT = (SELECT d.Id_Disciplina
				FROM [dbo].[Discipl] AS d
				WHERE d.Disciplina = @DISCIPLINA);

		IF @IdProfPrecedent IS NOT NULL AND @IdProfNou IS NOT NULL AND @IdDisciplina IS NOT NULL
			BEGIN
				UPDATE [dbo].[SReusita]
				SET Id_Profesor = @IdProfNou
				WHERE Id_Profesor = @IdProfPrecedent AND Id_Disciplina = @IdDisciplina
				RETURN;
			END
		RAISERROR ('Incorrect Data entered for NewProfesor', -- Message text.  
					11, -- Severity.  
					1 -- State.  
					);
	END TRY
	BEGIN CATCH
		SELECT   
        ERROR_NUMBER() AS ErrorNumber  
       ,ERROR_MESSAGE() AS ErrorMessage;
	END CATCH
END;

GO

EXEC ProfNou
	@NumeProfPrecedent = 'Popescu',
	@PrenumeProfPrecedent = 'Gabriel',
	@NumeProfNou = 'Micu',
	@PrenumeProfNou = 'Elena',
	@disciplina = 'Sisteme de operare'

EXEC ProfNou
	@NumeProfPrecedent = 'Micu',
	@PrenumeProfPrecedent = 'Elena',
	@NumeProfNou = 'Popescu',
	@PrenumeProfNou = 'Gabriel',
	@disciplina = 'Sisteme de operare'
	
	select * from[dbo].[Prof]

--(5)
DROP PROCEDURE IF EXISTS Reward
GO

CREATE PROCEDURE Reward
	@disciplina CHAR(255)
AS
BEGIN
	DECLARE @result TABLE
	(
		Id_Student INT,
		Cod_Grupa CHAR(255),
		Nume_Prenume_Student CHAR(255),
		Disciplina CHAR(255),
		OldMark TINYINT,
		NewMark TINYINT
	);

	INSERT INTO @result
	(
		Id_Student,
		Cod_Grupa,
		Nume_Prenume_Student,
		Disciplina,
		OldMark,
		NewMark
	)
	SELECT DISTINCT TOP 3
		[dbo].[Stdnt].Id_Student,
		Cod_Grupa,
		Nume_Student + ' ' + Prenume_Student,
		Disciplina,
		sr.Nota AS OldMark,
		sr.Nota AS NewMark
	FROM [dbo].[Stdnt]
	JOIN [dbo].[SReusita] sr ON sr.Id_Student = [dbo].[Stdnt].Id_Student
	JOIN [dbo].[Discipl] ON sr.Id_Disciplina = [dbo].[Discipl].Id_Disciplina
	JOIN grupe ON sr.Id_Grupa = grupe.Id_Grupa
	WHERE
		Disciplina = @disciplina AND
		Nota IS NOT NULL
	ORDER BY Nota DESC;

	UPDATE [dbo].[SReusita]
	SET Nota = Nota + 1
	WHERE
		Id_Student IN (SELECT Id_Student FROM @result) AND
		Nota < 10;

	UPDATE @result
	SET NewMark = OldMark + 1
	WHERE OldMark < 10;
	
	SELECT * FROM @result;
	RETURN SELECT
		Cod_Grupa,
		Nume_Prenume_Student,
		Disciplina,
		OldMark,
		NewMark
	FROM @result;
END
GO


EXEC Reward @disciplina = 'Sisteme de calcul';

--(6)
DROP FUNCTION IF EXISTS Ex6Lab9;
GO
CREATE FUNCTION Ex6Lab9(@street VARCHAR(20))
RETURNS TABLE
AS
	RETURN 
	(
		(select Nume_Student as last_name, Prenume_Student as first_name from [dbo].[Stdnt]
		where Adresa_Postala_Student like '%' + @street + '%') 
	UNION
		(select Nume_Profesor as last_name, Prenume_Profesor as first_name from Prof
		where Adresa_Postala_Profesor like '%' + @street + '%')
	)
GO
SELECT * FROM Ex6Lab9('31 August');

--(7)
DROP FUNCTION IF EXISTS Ex7Lab9
GO

CREATE FUNCTION Ex7Lab9(@Data_Nastere DATE)
RETURNS INT
BEGIN
	RETURN DATEDIFF(YEAR, @Data_Nastere, GETDATE())
END
GO

SELECT
	Nume_Student,
	Prenume_Student,
	dbo.Ex7Lab9(Data_Nastere_Student) AS Virsta
FROM [dbo].[Stdnt];

--(8)
Use universitatea
Go
drop function if exists Ex8Lab9
Go
create function Ex8Lab9(@Nume_Prenume_Student as varchar(255))
returns table 
as
return
select concat(Nume_Student, ' ', Prenume_Student) Nume_Prenume, Disciplina, Nota, Data_Evaluare
from [dbo].[Stdnt] st, [dbo].[Discipl] d, [dbo].[SReusita] st_r
where st.Id_Student = st_r.Id_Student and st_r.Id_Disciplina = d.Id_Disciplina
and @Nume_Prenume_Student = concat(Nume_Student, ' ', Prenume_Student)
go
select * from Ex8Lab9('Demian Bogdan')

--(9)

Use universitatea
Go
Drop function if exists Ex9Lab9
Go 
create function Ex9Lab9(@CodGrupa varchar(6), @Is_Good varchar(20))
returns @result table (Grupa varchar(6), Nume_Prenume varchar(50), Nota_Medie decimal(4, 2), Is_Good varchar(20)) 
with encryption 
as 
begin
if(@Is_Good = 'sarguincios')
	Insert @result
	Select top 1 Cod_Grupa, concat(Nume_Student, ' ', Prenume_Student) as Nume_Prenume, convert(decimal(5,2),round(Avg(Nota+0.0),3)) as Nota_Medie, @Is_Good as Is_Good
	from grupe g, studenti.studenti st, studenti.studenti_reusita st_R
	where g.Id_Grupa = st_R.Id_Grupa and st_R.Id_Student = st.Id_Student
	and Cod_Grupa = @CodGrupa
	Group by Cod_Grupa, concat(Nume_Student, ' ', Prenume_Student)
	order by Nota_Medie desc
else
if(@Is_Good = 'slab')
	Insert @result
		Select top 1 Cod_Grupa, concat(Nume_Student, ' ', Prenume_Student) as Nume_Prenume, convert(decimal(5,2),round(Avg(Nota+0.0),3)) as Nota_Medie, @Is_Good as Is_Good
		from grupe g, studenti.studenti st, studenti.studenti_reusita st_R
		where g.Id_Grupa = st_R.Id_Grupa and st_R.Id_Student = st.Id_Student
		and Cod_Grupa = @CodGrupa
		Group by Cod_Grupa, concat(Nume_Student, ' ', Prenume_Student)
		order by Nota_Medie asc
return
end
go

select * from Ex9Lab9('CIB171','slab')
SELECT * FROM Ex9Lab9('TI171', 'sarguincios');
--SELECT * FROM Ex9Lab9('TI171', 'slab');