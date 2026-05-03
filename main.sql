CREATE PROCEDURE sp_employee_hierarchy_and_salary AS 
BEGIN
    DECLARE @avg_salary DECIMAL(10,2);
    SET @avg_salary = (SELECT AVG(salary) FROM employees WHERE salary > 0);

    SELECT e.employee_id, e.first_name, e.last_name, m.first_name AS manager_name, 
           e.salary, d.department_name
    FROM employees e
    LEFT JOIN employees m ON e.manager_id = m.employee_id
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE e.salary > @avg_salary;

    DECLARE @top_department VARCHAR(50);
    SET @top_department = (
        SELECT TOP 1 d.department_name 
        FROM departments d 
        JOIN employees e ON d.department_id = e.department_id 
        GROUP BY d.department_name 
        ORDER BY AVG(e.salary) DESC
    );

    SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = @top_department
    ORDER BY e.hire_date DESC;
END;
