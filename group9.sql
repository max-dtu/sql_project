USE DTU;
SELECT CourseID, SectionID, COUNT(StudID) AS StudentCount
FROM Takes
WHERE Semester = 'Fall' AND StudyYear = 2009
GROUP BY CourseID, SectionID;
