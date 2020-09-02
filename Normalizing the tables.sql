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
