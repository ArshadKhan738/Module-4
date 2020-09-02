***** gradeRecordModule.csv a CSV file imported into database *********

SELECT * FROM gradeRecordModule

sp_rename 'gradeRecordModule.Totalpoints','totalPoints','column';

******* CHECK DUPLICATES IN StudentID*******

SELECT studentID, COUNT(studentID)
FROM gradeRecordModule GROUP BY studentID
HAVING COUNT(studentID)>1 ORDER BY studentID;

****** TO REMOVE DUPLICATE studentID *****

DELETE FROM gradeRecordModule
WHERE studentID IN(
		SELECT studentID
		FROM(
			SELECT studentID,
			ROW_NUMBER() OVER (PARTITION BY studentID ORDER BY studentID) AS ROW_NUM
			FROM gradeRecordModule) T
			WHERE T.ROW_NUM > 1);

***** CREATING TABLES FROM gradeRecordModule (Master Table) *****

SELECT studentID,midtermExam,finalExam
INTO studentExamGrades
FROM gradeRecordModule;

SELECT studentID,CW1,CW2
INTO studentCWGrades
FROM gradeRecordModule;

SELECT studentID,Grade
INTO letterGrade
FROM gradeRecordModule;

SELECT studentID,firstName,lastName
INTO studentInfo
FROM gradeRecordModule;

**** ADDING PK_CONSTRAINT (IN StudentInfo Table) *****

ALTER TABLE studentInfo
ADD CONSTRAINT pk_stundentID PRIMARY KEY(studentID);

**** ADDING FK_CONSTRAINT (IN StudentExamGrades Table) *****

ALTER TABLE studentExamGrades
ADD CONSTRAINT fk_studentID FOREIGN KEY(studentID)
REFERENCES studentInfo(studentID);

**** ADDING FK_CONSTRAINT (IN StudentCWGrades Table) *****

ALTER TABLE studentCWGrades
ADD CONSTRAINT fk_studentID1 FOREIGN KEY(studentID)
REFERENCES studentInfo(studentID);

SELECT studentID,studentAverage
INTO avgGrade
FROM gradeRecordModule;

UPDATE avgGrade
SET gradeID = CASE
	WHEN studentAverage >= 0.42 AND studentAverage <= 0.60 THEN 10
	WHEN studentAverage >= 0.60 AND studentAverage <= 0.63 THEN 4
	WHEN studentAverage >= 0.63 AND studentAverage <= 0.66 THEN 6
	WHEN studentAverage >= 0.66 AND studentAverage <= 0.67 THEN 5
	WHEN studentAverage >= 0.70 AND studentAverage <= 0.71 THEN 7
	WHEN studentAverage >= 0.71 AND studentAverage <= 0.75 THEN 1
	WHEN studentAverage >= 0.76 AND studentAverage <= 0.77 THEN 3
	WHEN studentAverage >= 0.77 AND studentAverage <= 0.83 THEN 2
	WHEN studentAverage >= 0.88 AND studentAverage <= 0.89 THEN 8
	WHEN studentAverage >= 0.89 AND studentAverage <= 0.93 THEN 9
	ELSE 0
	END
WHERE StudentAverage IN (0.42,0.49,0.50,0.54,0.55,0.57,0.58,0.60,0.61,0.63,0.66,0.67,0.70,0.71,0.75,0.76,0.77,0.82,0.88,0.89,0.93);

ALTER TABLE avgGrade
ADD gradeID INT;


CREATE TABLE GradeGlossary(
			GradeID INT NOT NULL,
			Grade varchar(3));

INSERT INTO GradeGlossary(GradeID, Grade)
		VALUES (1,'C'),
			(2,'B-'),
			(3,'C+'),
			(4,'D-'),
			(5,'D+'),
			(6,'D'),
			(7,'C-'),
			(8,'B+'),
			(9,'A-'),
			(10,'F');

ALTER TABLE letterGrade
ADD CONSTRAINT fk_studentID3 FOREIGN KEY(studentID)
REFERENCES studentInfo(studentID);

ALTER TABLE GradeGlossary
ADD CONSTRAINT pk_GradeID PRIMARY KEY(GradeID);

ALTER TABLE avgGrade
ADD CONSTRAINT fk_GradeID FOREIGN KEY(GradeID)
REFERENCES GradeGlossary(GradeID);
 
********* JOINING 3 TABLES(studentInfo, avgGrade, letterGrade) WITH INNER JOIN STATEMENT **************				      
				      
SELECT studentInfo.studentID, studentInfo.firstName, studentInfo.lastName, avgGrade.studentAverage,letterGrade.Grade
FROM studentInfo INNER JOIN avgGrade ON studentInfo.studentID = avgGrade.studentID
		 INNER JOIN letterGrade ON studentInfo.studentID = letterGrade.studentID;
