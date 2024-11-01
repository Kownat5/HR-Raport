select *
from employee_staging;


-- Questions:
-- 1. Age distribution among employees
-- 2. Gender breakdown in company
-- 3. Number of current employees in company
-- 4. How does gender vary across departments
-- 5. Average Salary
-- 6. Salary distribution among employees
-- 7. State of origin of Employees
-- 8. Race distribution in company
-- 9. Average turnover rate in departments
-- 10. Average number of absences in departments
-- 11. Average employee satisfaction in departments
-- 12. Average employee engagment in departments



-- 1. Age distribution among employees


-- First of all we have to calculate age of employees by using "dob" (Date of Birth) column.

alter table employee_staging
add age nvarchar(50);


update employee_staging
set age = timestampdiff (year, dob, curdate());

select age
from employee_staging
order by age;

-- I took for account only employees that still work at company

Select age_group,
	count(*) as count
    from
    (select
		case
        when age >= 32 and age <=38 then '32 to 38'
        when age >= 39 and age <=45 then '39 to 45'
        when age >= 46 and age <=50 then '46 to 50'
        else '50+'
        end as age_group
	from employee_staging
    where EmploymentStatus = 'active'
    )
as subquery
group by age_group;

-- 2. Gender breakdown in company

select
sex,
count(sex) as count
from employee_staging
where EmploymentStatus = 'active'
group by sex;

-- 3. Number of current employees in company

select
count(*) as count
from employee_staging
where EmploymentStatus = 'active';


-- 4. How does gender vary across departments

select department,
sex,
count(sex) as count
from employee_staging
where EmploymentStatus = 'active'
group by department, sex
order by department, sex asc;

-- 5. Average Salary

select round(avg(salary),2)
from employee_staging
where EmploymentStatus = 'active';

-- 6. Salary distribution among employees

select salary
from employee_staging
order by salary;

-- I took for account only employees that still work at company

Select salary_group,
	count(*) as count
    from
    (select
		case
        when salary >= 40000 and salary <=60000 then '40000 to 60000'
        when salary >= 60001 and salary <=80000 then '60001 to 80000'
        when salary >= 80001 and salary <=100000 then '80001 to 100000'
        else '100000+'
        end as salary_group
	from employee_staging
    where EmploymentStatus = 'active'
    )
as subquery
group by salary_group
order by count desc;

-- 7. State of origin of Employees

select
state,
count(*) as count
from employee_staging
where EmploymentStatus = 'active'
group by state
order by count desc;

-- 8. Race distribution in company

select racedesc,
count(racedesc) as count
from employee_staging
where EmploymentStatus = 'active'
group by racedesc
order by count desc;

-- 9. Which department has the highest turnover rate?

select
department,
count(dateoftermination) as count
from employee_staging
where employmentstatus != 'active'
group by department
order by count desc;

-- 10. Average number of absences in departments

select
department,
round(avg(absences),2) as avg_absences
from employee_staging
where EmploymentStatus = 'active'
group by department
order by avg_absences desc;


-- 11. Average employee satisfaction in departments

select
department,
round(avg(empsatisfaction),2) as avg_emp_satisfaction
from employee_staging
where EmploymentStatus = 'active'
group by department
order by avg_emp_satisfaction desc;

-- 12. Average employee engagment in departments

select
department,
round(avg(engagementsurvey),2) as avg_emp_engagement
from employee_staging
where EmploymentStatus = 'active'
group by department
order by avg_emp_engagement desc;


