--DECLARE @maxNumber INT, @n1 INT, @n2 INT, @n3 INT
--SELECT @n1 = RAND() * 60
--SELECT @n2 = RAND() * 60
--SELECT @n3 = RAND() * 60
---- Aici ar trebui plasate IF-urile
--IF @n1 > @n2 SELECT @maxNumber = @n1 ELSE SELECT @maxNumber = @n2
--IF @n3 > @maxNumber SELECT @maxNumber = @n3

--print @n1
--print @n2
--print @n3
--print 'MAX=' + cast(@maxNumber as varchar(2))

----(2)
--DECLARE @Id_Disciplina INT, @Counter INT ;
--SET @Counter = 0
--SET @Id_Disciplina = (SELECT Id_Disciplina FROM discipline WHERE Disciplina='Baze de date')
--WHILE @Counter <> 10 BEGIN
--SELECT DISTINCT Prenume_Student, Nume_Student, Nota FROM studenti S
--	JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--	WHERE Id_Disciplina = @Id_Disciplina AND Tip_Evaluare='Testul 1'
--		AND iif(Nota = 8 OR Nota = 6, 'FALSE', 'TRUE')='TRUE'
--	ORDER BY  Nota DESC
--	OFFSET  @Counter ROWS 
--	FETCH NEXT 1 ROWS ONLY
--	SET  @Counter =   @Counter + 1
--END;

--(3)
--declare @maxNumber int, @n1 int, @n2 int, @n3 int
--set @n1 = RAND() * 60
--set @n2 = RAND() * 60
--set @n3 = RAND() * 60

--SET @maxNumber = CASE  
-- WHEN (@n1 > @n2) AND (@n1 > @n3) THEN @n1 
-- WHEN (@n2 > @n3) AND (@n2 > @n3)THEN @n2 
-- ELSE @n3 
-- END

--print @n1
--print @n2
--print @n3
--print 'max Number = ' + cast(@maxNumber as varchar(2))

----(4 a)
---- Verify that the stored procedure does not already exist.  
--IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
--    DROP PROCEDURE usp_GetErrorInfo;  
--GO  

---- Create procedure to retrieve error information.  
--CREATE PROCEDURE usp_GetErrorInfo  
--AS  
--SELECT  
--    ERROR_NUMBER() AS ErrorNumber  
--    ,ERROR_SEVERITY() AS ErrorSeverity  
--    ,ERROR_STATE() AS ErrorState  
--    ,ERROR_PROCEDURE() AS ErrorProcedure  
--    ,ERROR_LINE() AS ErrorLine  
--    ,ERROR_MESSAGE() AS ErrorMessage;  
--GO  

--DECLARE @maxNumber FLOAT, @n1 FLOAT, @n2 FLOAT, @n3 FLOAT, @Upper INT, @Lower INT

--SET @Lower = -5 ---- The lowest random number
--SET @Upper = 5 ---- One more than the highest random number


--BEGIN TRY  
--    SELECT @n1 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)/ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
--	SELECT @n2 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)/ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
--	SELECT @n3 = ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)/ROUND(((@Upper - @Lower -1) * RAND() + @Lower), 0)
--	-- Aici ar trebui plasate IF-urile
--	IF @n1 > @n2 SELECT @maxNumber = @n1 ELSE SELECT @maxNumber = @n2
--	IF @n3 > @maxNumber SELECT @maxNumber = @n3

--	print @n1
--	print @n2
--	print @n3
--	print 'MAX NUMBER IS ' +  CAST(@maxNumber AS varchar)
--END TRY  
--BEGIN CATCH  
--    -- Execute error retrieval routine.  
--    EXECUTE usp_GetErrorInfo;  
--END CATCH;  

----(4 b)
---- Verify that the stored procedure does not already exist.  
--IF OBJECT_ID ( 'usp_GetErrorInfo', 'P' ) IS NOT NULL   
--    DROP PROCEDURE usp_GetErrorInfo;  
--GO  

---- Create procedure to retrieve error information.  
--CREATE PROCEDURE usp_GetErrorInfo  
--AS  
--SELECT  
--    ERROR_NUMBER() AS ErrorNumber  
--    ,ERROR_SEVERITY() AS ErrorSeverity  
--    ,ERROR_STATE() AS ErrorState  
--    ,ERROR_PROCEDURE() AS ErrorProcedure  
--    ,ERROR_LINE() AS ErrorLine  
--    ,ERROR_MESSAGE() AS ErrorMessage;  
--GO 

--DECLARE @maxNumber FLOAT, @n1 FLOAT, @n2 FLOAT, @n3 FLOAT, @Upper INT, @Lower INT

--SET @Lower = -5 ---- The lowest random number
--SET @Upper = 5 ---- One more than the highest random number


--BEGIN TRY  
--	-- RAISERROR with severity 11-19 will cause execution to   
--    -- jump to the CATCH block.  
     
--    DECLARE @Id_Disciplina INT, @Counter INT ;
--	SET @Counter = 0
--	SET @Id_Disciplina = (SELECT Id_Disciplina FROM discipline WHERE Disciplina='Baze de datte')
--	IF	@Id_Disciplina IS NULL RAISERROR ('Such Object can not be found', -- Message text.  
--               12, -- Severity.  
--               1 -- State.  
--               )  
--	WHILE @Counter <> 10 BEGIN
--	 SELECT DISTINCT Prenume_Student, Nume_Student, Nota FROM studenti S
--		FULL OUTER JOIN studenti_reusita S_r ON S.Id_Student = S_r.Id_Student 
--		WHERE Id_Disciplina = @Id_Disciplina AND Tip_Evaluare LIKE'%1%'
--			AND iif(Nota = 8 OR Nota = 6, 'FALSE', 'TRUE')='TRUE'
--		ORDER BY  Nota DESC
--		OFFSET  @Counter ROWS 
--		FETCH NEXT 1 ROWS ONLY
--		SET  @Counter =   @Counter + 1
		 
--	END
--END TRY  
--BEGIN CATCH   
--   EXECUTE usp_GetErrorInfo;
--END CATCH; 
 