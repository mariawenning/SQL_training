--First solution
--select abs(max(salary) filter (where db_dept.department = 'marketing') -max(salary) filter (where db_dept.department = 'engineering') )
--from db_employee
--inner join db_dept
--on db_employee.department_id = db_dept.id

--Second solution
select ABS(
    (select max(salary)
    from db_employee
    inner join db_dept
    on db_employee.department_id = db_dept.id
    where db_dept.department = 'engineering') - 
    (select max(salary)
    from db_employee
    inner join db_dept
    on db_employee.department_id = db_dept.id
    where db_dept.department = 'marketing')    
)

