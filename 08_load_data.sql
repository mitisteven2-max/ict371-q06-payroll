-- ICT371 Q6 (a): two payroll months, produced by the procedure
CALL pr_process_payroll(DATE '2026-09-01');
CALL pr_process_payroll(DATE '2026-10-01');

-- Employee 5 leaves: history stays in payroll
UPDATE employees SET active = FALSE WHERE employee_id = 5;

-- Salary change after October payroll (logged by the trigger; old payroll untouched)
UPDATE employees SET basic_salary = 4500.00 WHERE employee_id = 3;
