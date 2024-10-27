select *
from employee_staging;

-- Data Cleaning

-- 1. Removing duplicates

-- a) Createing copy of main hr_data.employee table for any future mistakes

create table employee_staging
like employee;

insert employee_staging
select *
from employee;

-- b) First, before I'll start cleaning anything, I have to change first column name because it can affect my work later.

ALTER TABLE employee
RENAME COLUMN ď»żEmployee_Name TO Employee_Name;

ALTER TABLE employee_staging
RENAME COLUMN ď»żEmployee_Name TO Employee_Name;

-- c) removing duplicates - it's easier when we have column with unique values but despite that I'm going to search for duplicates,
--                          because of that, I'm gonna use CTE to make sure there are no rows with sam values.
--                          If there's going to be one, we will get a duplicate. I'm choosing 7 diffrent columns to veryfie it.


with duplicate_cte as
(
select *,
row_number () over (
partition by Employee_Name,
EmpID,
Salary,
PositionID,
Position,
EmpStatusID,
Zip) as row_num
from employee_staging
)
select*
from duplicate_cte
where row_num>1;

-- As I ran that code, if there were any duplicates, I would get rows with row_num value of at least 2.
-- I didn't get any rows in return so there are no duplicates.

-- 2. Data Standarization

-- a) Removing unwanted spaces - there are some spaces after full names in "Employee_Name" column, so I'm going to get rid of those.

update employee_staging
set Employee_Name = TRIM(employee_name);

-- b) Removing typos - there are some typos in few rows of "RecruitmentSource". The word "Inded" instead of "Indeed". I'm going to get rid of those.

-- I checked it by:

Select Distinct RecruitmentSource
from employee_staging
order by 1;

-- Changing "Inded" to "Indeed"

Update employee_staging
set recruitmentsource= 'Indeed'
where recruitmentsource like 'inded';

-- c) Removing unwanted dots (".") - There were some unwanted dots in "Department" column after the word "Production". I'm going to get rid of those.

-- I checked it by:

Select Distinct Department
from employee_staging
order by 1;

-- Removing dots:

Update employee_staging
set Department= TRIM(Trailing '.' from Department)
Where Department like 'Production%';

-- d) Changing data type - After checking data type of each column ("dob", "DateofHire", ) , there's a problem with date like columns. 
--                         All of them use text type. I'm going to change that columns into data type.

update employee_staging
set `dob` = str_to_date (`dob`,'%m/%d/%Y');

update employee_staging
set `DateofHire` = str_to_date (`DateofHire`,'%m/%d/%Y');

-- now I'm going to change type of columns ("dob", "dateofhire")


alter table employee_staging
modify column `dob` date;


alter table employee_staging
modify column `dateofhire` date;


-- 3. Looking at NULL's and empty records

-- The only NULL's that I got are in "DateOfTermination" column which is valid because employees that 
-- still work have no value in "DateOfTermination" column. So I'm going to leave it as it is.


-- 4. Removing unnecessery rows and columns

-- Because I made a list of questions that I'm going to answer with "employee_table" I can with absolute certainty remove these columns:
-- "MarriedID"
-- "MariatStatusID"
-- "GenderID"
-- "EmpstatusID"
-- "DeptID"
-- "PrefScoreID"
-- "FromDiversityJobFairID"
-- "Termd"
-- "PositionID"
-- "ManagerID"
-- "SpecialProjectCounts"
-- "LastPerformanceReview_Date"
-- "DaysLateLast30"

Alter table employee_staging
drop MarriedID,
drop MaritalStatusID,
drop GenderID,
drop EmpstatusID,
drop DeptID,
drop PerfScoreID,
drop FromDiversityJobFairID,
drop Termd,
drop PositionID,
drop ManagerID,
drop SpecialProjectsCount,
drop LastPerformanceReview_Date,
drop DaysLateLast30;














