USE
 universitatea; 
GO
--DROP TABLE IF EXISTS orarul_grupa;
--GO 
--CREATE SCHEMA schema_universitatea2 AUTHORIZATION dbo 
--GO 
--CREATE TABLE orarul_grupa(Id_Disciplina INT,
--						Cod_Grupa CHAR(6),
--						 Zi CHAR(2), 
--						 Ora TIME, 
--						 Auditoriu INT, 
--						 Bloc CHAR(1)) 
-- GRANT SELECT ON SCHEMA :: schema_universitatea2 TO Anna 
-- DENY  SELECT ON SCHEMA :: schema_universitatea2 TO Ion 

--ALTER TABLE grupe ADD UNIQUE (Sef_grupa) ;  

--(6)
--Use universitatea
--Go
--CREATE SCHEMA cadre_didactice
--GO
--CREATE SCHEMA plan_studii
--GO
--CREATE SCHEMA studenti
--GO
--ALTER SCHEMA cadre_didactice TRANSFER [dbo].[profesori]
--GO
--ALTER SCHEMA plan_studii TRANSFER [dbo].[orarul]
--GO
--ALTER SCHEMA plan_studii TRANSFER [dbo].[discipline]
--GO
--ALTER SCHEMA studenti TRANSFER [dbo].[studenti]
--GO
--ALTER SCHEMA studenti TRANSFER [dbo].[studenti_reusita]
--GO

--(7)
Select Id_Disciplina,Disciplina,Nr_ore_plan_disciplina from plan_studii.discipline
 ORDER BY  Nr_ore_plan_disciplina DESC; 

SELECT DISTINCT D.Id_Disciplina, D.Disciplina,  
           P.Nume_Profesor, P.Prenume_Profesor
	FROM plan_studii.discipline D 
		JOIN studenti.studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
        JOIN cadre_didactice.Profesori P ON P.Id_Profesor = S_r.Id_Profesor
    ORDER BY
		Nume_Profesor DESC, 
		Prenume_Profesor DESC;


SELECT Id_Disciplina,Disciplina FROM plan_studii.discipline 
	WHERE LEN(Disciplina) > 20; 

--(8)
CREATE SYNONYM Stdnt FOR [studenti].[studenti]
CREATE SYNONYM Prof FOR [cadre_didactice].[profesori]
CREATE SYNONYM Discipl FOR [plan_studii].[discipline]
CREATE SYNONYM SReusita FOR [studenti].[studenti_reusita]

Select Id_Disciplina,Disciplina,Nr_ore_plan_disciplina from Discipl
 ORDER BY  Nr_ore_plan_disciplina DESC; 

SELECT DISTINCT D.Id_Disciplina, D.Disciplina,  
           P.Nume_Profesor, P.Prenume_Profesor
	FROM Discipl D 
		JOIN SReusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
        JOIN Prof P ON P.Id_Profesor = S_r.Id_Profesor
    ORDER BY
		Nume_Profesor DESC, 
		Prenume_Profesor DESC;


SELECT Id_Disciplina,Disciplina FROM Discipl
	WHERE LEN(Disciplina) > 20; 


