--(1)    ---lab4(3)
CREATE VIEW Ex3Lab4 AS
  (SELECT DISTINCT D.Id_Disciplina, D.Disciplina,  
           P.Nume_Profesor, P.Prenume_Profesor
	FROM [dbo].[Discipl] D 
		JOIN [dbo].[SReusita] S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
        JOIN [dbo].[Prof] P ON P.Id_Profesor = S_r.Id_Profesor);
GO
SELECT * FROM Ex3Lab4
ORDER BY
		Nume_Profesor DESC, 
		Prenume_Profesor DESC;

SELECT * FROM [dbo].View_2

-- It adds Sisteme Operare MIcro Procesoare to discipline
INSERT INTO View_2 (Id_disciplina, disciplina)
VALUES ((Select MAX (Id_disciplina) FROM [dbo].[Discipl]) + 1 , 'Sisteme Operare MIcro Procesoare');

-- It turns SOMIP into TIDPP
UPDATE View_2 SET disciplina ='TIDPP' WHERE disciplina='Sisteme Operare MIcro Procesoare	';

-- It deletes TIDPP from studenti
DELETE FROM View_2 WHERE disciplina='TIDPP';

--(3) -(4)   
Use universitatea
Go

DROP VIEW IF EXISTS [dbo].[Ex4LAb4];

Go
CREATE VIEW [dbo].[Ex4LAb4] WITH SCHEMABINDING AS 
SELECT Disciplina
    FROM [plan_studii].discipline
    WHERE LEN(Disciplina) > 20
	WITH CHECK OPTION
Go
SELECT *
FROM [dbo].[Ex4LAb4];
Go
ALTER TABLE [plan_studii].Disciplina 
	DROP COLUMN discipline;
Go
UPDATE [dbo].[Ex4LAb4]
	SET Disciplina = 'Deprecated'
WHERE Disciplina LIKE 'A%';



--(5)
--(a)
Use universitatea
Go
WITH StudNames(Nume_Student, Prenume_Student) AS 
	(SELECT Nume_Student, Prenume_Student FROM [dbo].[Stdnt] WHERE Nume_Student LIKE '%u')
SELECT * FROM StudNames;
--(b)
WITH Marks(Id_Disciplina, Nota) AS (SELECT Id_Disciplina, Nota FROM [dbo].[SReusita] WHERE Tip_Evaluare='Examen')
select TOP 1 AVG(Cast(Nota as decimal(4, 2))) as avg_nota, Id_Disciplina from Marks
	group by Id_Disciplina
	order by avg_nota DESC;


--(6)
WITH verts(vertex) AS (
	SELECT 3
	UNION ALL
	SELECT 
		vertex - 1 FROM verts
		Where vertex > 0 )
 SELECT * FROM verts;