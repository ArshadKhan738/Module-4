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
	WHEN studentAverage >= 0 AND studentAverage <= 0.49 THEN 10
	WHEN studentAverage >= 0.49 AND studentAverage <= 0.52 THEN 4
	WHEN studentAverage >= 0.52 AND studentAverage <= 0.55 THEN 6
	WHEN studentAverage >= 0.55 AND studentAverage <= 0.60 THEN 5
	WHEN studentAverage >= 0.61 AND studentAverage <= 0.64 THEN 7
	WHEN studentAverage >= 0.65 AND studentAverage <= 0.69 THEN 1
	WHEN studentAverage >= 0.69 AND studentAverage <= 0.75 THEN 3
	WHEN studentAverage >= 0.76 AND studentAverage <= 0.80 THEN 2
	WHEN studentAverage >= 0.81 AND studentAverage <= 0.89 THEN 8
	WHEN studentAverage >= 0.89 AND studentAverage <= 0.96 THEN 9
	ELSE 0
	END
WHERE StudentAverage IN (0.42,0.49,0.50,0.54,0.55,0.57,0.58,0.60,0.61,0.63,0.66,0.67,0.70,0.71,0.75,0.76,0.82,0.88,0.89,0.93);

ALTER TABLE avgGrade
ADD gradeID INT;

CREATE TABLE GradeGlossary(
			GradeID INT,
			Grade varchar(3));

INSERT INTO GradeGlossary(GradeID, Grade)
		VALUES (11,'A+'),
			(12,'A'),
			(13,'A-'),
			(21,'B+'),
			(22,'B'),
			(23,'B-'),
			(31,'C+'),
			(32,'C'),
			(33,'C-'),
			(41,'D+'),
			(42,'D'),
			(43,'D-'),
			(51,'F');

