-- (b)
SELECT employee_id, fn_net_pay(employee_id) AS net FROM employees ORDER BY 1;
DO $$ BEGIN PERFORM fn_net_pay(999);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN
    UPDATE employees SET deduction = 99999 WHERE employee_id = 1;   -- rolled back by the handler
    PERFORM fn_net_pay(1);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (c) month must be a month start
DO $$ BEGIN CALL pr_process_payroll(DATE '2026-11-15');
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- process November; rerun leaves everything unchanged
CALL pr_process_payroll(DATE '2026-11-01');
CALL pr_process_payroll(DATE '2026-11-01');
SELECT pay_month, COUNT(*) AS rows_per_month FROM payroll GROUP BY pay_month ORDER BY 1;  -- Sep 5, Oct 5, Nov 4

-- an invalid employee fails the WHOLE call: nothing stored for December
DO $$ BEGIN
    UPDATE employees SET deduction = 99999 WHERE employee_id = 2;
    CALL pr_process_payroll(DATE '2026-12-01');
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Whole call failed: %', SQLERRM; END $$;
SELECT COUNT(*) AS december_rows FROM payroll WHERE pay_month = DATE '2026-12-01';  -- 0

-- (d) only a real basic_salary change is audited
UPDATE employees SET basic_salary = basic_salary WHERE employee_id = 1;   -- no audit
UPDATE employees SET allowance = allowance + 100 WHERE employee_id = 1;   -- no audit
UPDATE employees SET basic_salary = 5200 WHERE employee_id = 1;          -- audited
SELECT * FROM salary_audit ORDER BY audit_id;

-- (e) includes the inactive employee's history
SELECT * FROM v_payroll_report;

-- (f) EXPLAIN again now that the tables contain data
ANALYZE payroll;
SET enable_seqscan = off;   -- tiny table: force the planner to show the index

EXPLAIN
SELECT employee_id, gross_pay, net_pay
FROM payroll
WHERE pay_month = DATE '2026-10-01';

RESET enable_seqscan;
