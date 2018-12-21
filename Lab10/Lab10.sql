--(1)
DROP TRIGGER IF EXISTS inregistrare_noua
GO

CREATE TRIGGER inregistrare_noua ON plan_studii.orarul
AFTER UPDATE
AS
	IF(UPDATE(Auditoriu))
	BEGIN
		SELECT Cod_Grupa + ' has ' + Disciplina + ' in room ' + CAST(Auditoriu AS VARCHAR(4)) + ' at ' + Zi + ' ' + CONVERT(VARCHAR(5), Ora)
		FROM inserted
		JOIN grupe ON grupe.Id_Grupa=inserted.Id_Grupa
		JOIN discipline ON  discipline.Id_Disciplina=inserted.Id_Disciplina
	END
GO

UPDATE plan_studii.orarul SET Auditoriu=201 WHERE Zi='Luni';

--(2)
DROP TRIGGER IF EXISTS [studenti].[Studenti_StudentiReusita_Insertion]
GO

CREATE TRIGGER Studenti_StudentiReusita_Insertion ON studenti.studenti_reusita
INSTEAD OF INSERT
AS 
	SET NOCOUNT ON
	DECLARE @ID_STUDENT INT;
	DECLARE @NUME_STUDENT VARCHAR(50) = 'UNKNOWN';
	DECLARE @PRENUME_STUDENT VARCHAR(50) = 'UNKNOWN';
	DECLARE @DATA_NASTERE_STUDENT DATE = NULL;
	DECLARE @ADRESA_POSTALA_STUDENT VARCHAR(255) = 'mun. Chisinau';

	SELECT @ID_STUDENT = inserted.Id_Student
	FROM inserted;
	
	INSERT INTO studenti.studenti
	VALUES 
        (@ID_STUDENT, @NUME_STUDENT, @PRENUME_STUDENT, @DATA_NASTERE_STUDENT, @ADRESA_POSTALA_STUDENT);
	
	INSERT INTO studenti.studenti_reusita
	SELECT * 
	FROM inserted;
GO

GO
INSERT INTO studenti.studenti_reusita VALUES (601, 102, 102, 1, 'Examen', 9, null);
GO
SELECT * FROM studenti.studenti WHERE Id_Student = 601;
SELECT * FROM studenti.studenti_reusita WHERE Id_Student = 601;

--(3)
DROP TRIGGER IF EXISTS CIB171_guard
GO
CREATE TRIGGER CIB171_guard ON studenti.studenti_reusita
AFTER UPDATE, DELETE
AS
	DECLARE @nota INT;
	DECLARE @nota_msg VARCHAR(255) = 'Students mark from CIB171 group cant be decreased';
	DECLARE @date_msg VARCHAR(255) = 'Evaluation date changing not supported for student from CIB171';

	SELECT @nota = deleted.Nota FROM deleted, grupe
		WHERE deleted.Id_Grupa = grupe.Id_Grupa AND Cod_Grupa='CIB171';

	IF(@Nota > (SELECT TOP 1 Nota FROM inserted, grupe WHERE inserted.Id_Grupa = grupe.Id_Grupa AND Cod_Grupa = 'CIB171'))
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR(@nota_msg, 16, 1)
	END
	IF( UPDATE(Data_Evaluare) and exists (SELECT TOP 1 Data_Evaluare FROM inserted, grupe
		WHERE inserted.Id_Grupa = grupe.Id_Grupa AND Cod_Grupa = 'CIB171'))
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR(@date_msg, 16, 1)
	END
GO

UPDATE studenti.studenti_reusita SET Nota=nota-2 WHERE Id_Grupa= (select Id_Grupa from grupe where Cod_Grupa='CIB171')

UPDATE studenti.studenti_reusita SET Data_Evaluare='2018-11-13' WHERE Id_Grupa= (select Id_Grupa from grupe where Cod_Grupa='CIB171')

--(4)
DROP TRIGGER IF EXISTS Ex4Lab10 ON Database
GO
Create trigger Ex4Lab10
on Database
FOR ALTER_TABLE
AS
	DECLARE @Disciplina VARCHAR(50)
	SELECT @Disciplina=EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]', 'nvarchar(100)') 
	
	IF @Disciplina='Disciplina'
	BEGIN 
		PRINT ('No modifications accepted for column "Disciplina" ')
		ROLLBACK;
	END
GO
ALTER TABLE plan_studii.discipline ALTER COLUMN Disciplina VARCHAR(709)

--(5)
DROP TRIGGER IF EXISTS SCHEME_PROTECT ON DATABASE;
GO

CREATE TRIGGER SCHEME_PROTECT
ON DATABASE
FOR ALTER_TABLE
AS
	DECLARE @START INT = 9 * 60 * 60;
	DECLARE @END INT = 20 * 60 * 60;

	DECLARE @DATE DATETIME = GETDATE();
	DECLARE @CURRENT_TIME INT = (DATEPART(HOUR, @DATE) * 60 * 60) +
								(DATEPART(MINUTE, @DATE) * 60) +
								(DATEPART(SECOND, @DATE));
	

	IF @CURRENT_TIME NOT BETWEEN @START AND @END
		BEGIN
		PRINT('Schema can not be modified in non-working hours!')
		ROLLBACK
		END;

ALTER TABLE plan_studii.orarul  ADD tryADD DATE

--(6)
DROP TRIGGER IF EXISTS Ex6Lab10 ON database
GO
CREATE TRIGGER Ex6Lab10
ON database
FOR alter_table 
AS
	Declare @Id_Profesor varchar(50)
	Declare @event1 varchar(500)
	Declare @event2 varchar(500)
	Declare @event3 varchar(100)
	SELECT @Id_Profesor=EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]', 'nvarchar(100)') 
	
	IF @Id_Profesor='Id_Profesor'
	BEGIN
	SELECT @event1 = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') 
	SELECT @event3 = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)') 
	SELECT @event2 = REPLACE(@event1, @event3, 'profesori');
	EXECUTE (@event2) 
	SELECT @event2 = REPLACE(@event1, @event3, 'orarul');
	EXECUTE (@event2) 
	SELECT @event2 = REPLACE(@event1, @event3, 'studenti_reusita');
	EXECUTE (@event2)   
	PRINT 'THE DATA HAS BEEN MODIFIED ELSEWHERE!'   
	END 
GO

ALTER TABLE [dbo].[Prof] ALTER column Id_Profesor SMALLINT 
ALTER TABLE studenti.studenti_reusita ALTER column Id_Profesor SMALLINT 

SELECT * FROM sys.triggers