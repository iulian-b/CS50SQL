---- Tables
-- Students
CREATE INDEX "stud_id" ON "students"("id");
-- COurses
CREATE INDEX "crs_dept_num_sem" ON "courses"("department", "number", "semester");
CREATE INDEX "crs_title_sem" ON "courses"("title", "semester");
-- Enrollments
CREATE INDEX "enrl_stud_id" ON "enrollments"("student_id");
CREATE INDEX "enrl_crs_id" ON "enrollments"("course_id");
-- Satisfies
CREATE INDEX "sat_crs_id" ON "satisfies"("course_id");
CREATE INDEX "sat_req_id" ON "satisfies"("requirement_id");

---- Queries
-- Enrollments
CREATE INDEX "enrl_stud_id_crs_id" ON "enrollments"("student_id", "course_id");
CREATE INDEX "enrl_crs_id_stud_id" ON "enrollments"("course_id", "student_id");
-- Satisfies
CREATE INDEX "sat_crs_id_req_id" ON "satisfies"("course_id", "requirement_id");
CREATE INDEX "sat_req_id_crs_id" ON "satisfies"("requirement_id", "course_id");


---- Benchmarks
--- SELECT Queries
-- Query 1: Run Time: real 0.001 user 0.000000 sys 0.000663
-- Query 2: Run Time: real 0.001 user 0.000000 sys 0.000497
-- Query 3: Run Time: real 0.038 user 0.020270 sys 0.011927
-- Query 4: Run Time: real 0.001 user 0.001024 sys 0.000139
-- Query 5: Run Time: real 0.000 user 0.000182 sys 0.000025
-- Query 6: Run Time: real 0.000 user 0.000000 sys 0.000355
-- Query 7: Run Time: real 0.006 user 0.005925 sys 0.000000

--- INSERT/UPDATE/DELETE Queries
-- Query 1: Run Time: real 0.044 user 0.001232 sys 0.000045
-- QUery 2: Run Time: real 0.054 user 0.008854 sys 0.000129
-- Query 3: Run Time: real 0.000 user 0.000000 sys 0.000174
-- Query 4: Run Time: real 0.001 user 0.000000 sys 0.000510
