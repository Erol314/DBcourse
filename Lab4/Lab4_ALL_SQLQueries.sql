--(1)
--select *  from grupe;

--(2)
--Select Id_Disciplina,Disciplina,Nr_ore_plan_disciplina from discipline
-- ORDER BY  Nr_ore_plan_disciplina DESC; 

--(3)
--SELECT DISTINCT D.Id_Disciplina, D.Disciplina,  
--           P.Nume_Profesor, P.Prenume_Profesor
--	FROM [discipline] D 
--		JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
--        JOIN Profesori P ON P.Id_Profesor = S_r.Id_Profesor
--    ORDER BY
--		Nume_Profesor DESC, 
--		Prenume_Profesor DESC;

----(4)
--SELECT Id_Disciplina,Disciplina FROM discipline 
--	WHERE LEN(Disciplina) > 20; 

----(5)
--SELECT * FROM studenti
--	WHERE LOWER(Nume_Student) LIKE '%u';

----(6) Aici Coloana Nota a fost afisata doar pentru verificarea rezultatului
--SELECT TOP(5) WITH TIES S.Nume_Student,S. Prenume_Student, S_r.Nota FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--	WHERE Tip_Evaluare =  'Testul 2' 
--		AND Id_Disciplina = (SELECT Id_Disciplina FROM discipline
--				 Where Disciplina = 'Baze de date ' )
--	ORDER BY
--	S_r.Nota DESC

	--SELECT TOP(10) * FROM studenti  ----- To test data
	--SELECT TOP(10) * FROM discipline
	--SELECT TOP(10) * FROM grupe
	--SELECT TOP(5)  * FROM studenti_reusita;

	--SELECT TOP(10) * FROM profesori 

----(7)
--SELECT DISTINCT G.Cod_Grupa--, Adresa_Postala_Student ,Nume_Student,Prenume_Student
          
--	FROM [grupe] G 
--		JOIN studenti_reusita S_r ON G.Id_Grupa = S_r.Id_Grupa 
--        JOIN studenti S ON S.Id_Student = S_r.Id_Student
--	WHERE LOWER(Adresa_Postala_Student) LIKE '%31 august%'

----(8) IDK Why so many answers/ Does it mean that all of them had exams in 2018? ///
--SELECT  S.Id_Student,S. Nume_Student FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--	WHERE (CONVERT(varchar, Data_Evaluare) LIKE '2018%'
--	AND Tip_Evaluare = 'Examen')
--	Group BY S.Id_Student, Nume_Student

----(9) 
--SELECT DISTINCT  S.Id_Student,S. Nume_Student, s.Adresa_Postala_Student, Id_Disciplina FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--	WHERE CONVERT(varchar, Data_Evaluare) LIKE '2018%' AND Nota > 8


----(10) 
--SELECT DISTINCT  Prenume_Student,Nume_Student, Nota FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--	JOIN discipline D ON  S_r.Id_Disciplina = D.Id_Disciplina 
--	WHERE CONVERT(varchar, Data_Evaluare) LIKE '2018%'
--			AND Tip_Evaluare like '%Examen%' 
--			AND Nota BETWEEN 5 AND 7
--			AND Disciplina = 'Baze de date ';

----(11) Here i Added Nota and Id_student to Check myself. 
--		--So withot additional rows we would have 1 answer -- Micu Elena
--SELECT DISTINCT  Nume_Profesor,Prenume_Profesor, Nota, Id_Student FROM profesori P
--	JOIN studenti_reusita S_r ON P.Id_Profesor = S_r.Id_Profesor 
--	JOIN discipline D ON  S_r.Id_Disciplina = D.Id_Disciplina 
--	WHERE CONVERT(varchar, Data_Evaluare) LIKE '2018%'
--			AND Tip_Evaluare like 'Reusita curenta' 
--			AND Nota < 5 AND Disciplina = 'Baze de date ';
			
----(12) 
--SELECT DISTINCT  Nume_Student,Prenume_Student,Disciplina,Tip_Evaluare,
--				 Nota,  SUBSTRING(CONVERT(varchar, Data_Evaluare), 1, 4) AS TheYear FROM studenti S
--		JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--		JOIN discipline D ON  S_r.Id_Disciplina = D.Id_Disciplina 
--		WHERE Prenume_Student = 'Alex';
	
----(13) 
--SELECT DISTINCT  Nume_Student, Prenume_Student, Disciplina, D.Id_Disciplina FROM discipline D
--		JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
--		JOIN studenti S ON  S_r.Id_Student = S.Id_Student 
--		WHERE Nume_Student LIKE '%Florea%' AND			
--						Prenume_Student LIKE '%Ioan%' 

----(14) 
--SELECT DISTINCT  Prenume_Student,Nume_Student, Disciplina, Nota FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--	JOIN discipline D ON  S_r.Id_Disciplina = D.Id_Disciplina 
--	WHERE Tip_Evaluare like '%Examen%' AND Nota > 8;
			

----(24)
--SELECT  Disciplina,  COUNT(DISTINCT Id_Profesor) AS NrOfProf FROM discipline D
--  JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina
--GROUP BY Disciplina HAVING  COUNT(DISTINCT Id_Profesor) >= 2;

----(25)
--SELECT  COUNT(DISTINCT Id_Student), G.Cod_Grupa FROM grupe G
--  JOIN studenti_reusita S_r ON G.Id_Grupa = S_r.Id_Grupa
--GROUP BY G.Cod_Grupa HAVING  COUNT(DISTINCT Id_Student) > 24;

----(26)
--(SELECT Nume_Profesor AS Nume, Prenume_Profesor AS Prenume FROM profesori
--	WHERE Adresa_Postala_Profesor LIKE '%31 August%')
--	UNION
--(SELECT Nume_Student AS Nume, Prenume_Student AS Prenume  FROM studenti
--	WHERE Adresa_Postala_Student LIKE '%31 August%'); 


--(27)
SELECT DISTINCT Id_Student FROM discipline D
  JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina
    JOIN profesori P ON P.Id_Profesor = S_r.Id_Profesor 
	WHERE Prenume_Profesor = 'Ion' AND Tip_Evaluare like '%Examen%'
	GROUP BY Id_Student HAVING  MAX(Nota) > 5;

--	--(28)
--SELECT DISTINCT  Nume_Student, Prenume_Student FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student
--	WHERE Tip_Evaluare like '%Examen%' AND Nota <
--	ALL (SELECT DISTINCT Nota FROM studenti_reusita WHERE Id_Student = 100
--			 AND Tip_Evaluare like '%Examen%' );
	
--(32)
--SELECT 

--(37)
--SELECT TOP (1) AVG(CONVERT(float ,Nota )) AS Nota_, Id_Disciplina FROM studenti_reusita
--	WHERE Tip_Evaluare like '%Examen%'
--	GROUP BY Id_Disciplina
--	ORDER BY Nota_ DESC;




----(39)

--SELECT  Id_Disciplina FROM studenti_reusita 
--	WHERE (SELECT COUNT(Nota) From studenti_reusita WHERE Nota < 5 AND Tip_Evaluare = 'Examen') 
--			/(SELECT ) >0.05
--	GROUP BY Id_Disciplina;

----(38)
--SELECT DISTINCT D.Id_Disciplina, Disciplina from discipline D
--	JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
--	WHERE (SELECT AVG(Nota) FROM  discipline D
--		JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
--			WHERE  Tip_Evaluare = 'Examen' AND  Disciplina = 'Baze de date ' 
--		Group By S_r.Id_Disciplina)
--		  > AVG(Nota) 
--		  --AND Tip_Evaluare = 'Examen'
--	GROUP BY S_r.Id_Disciplina

--SELECT AVG(Nota) FROM  discipline D
--		JOIN studenti_reusita S_r ON D.Id_Disciplina = S_r.Id_Disciplina 
--			WHERE  Tip_Evaluare = 'Examen' AND  Disciplina = 'Baze de date ' 
--		Group By S_r.Id_Disciplina

--SELECT AVG(Nota), Id_Disciplina FROM  studenti_reusita 
--			WHERE  Tip_Evaluare = 'Examen'
--			GROUP BY Id_Disciplina

		





