-- ICT371 Q6 (f): index for "all employees in one month" reports
-- The existing UNIQUE (employee_id, pay_month) index leads with employee_id,
-- so it cannot be used efficiently to filter on pay_month alone.
-- This index leads with pay_month instead (it is NOT a duplicate).
CREATE INDEX IF NOT EXISTS idx_payroll_pay_month
    ON payroll (pay_month);

ANALYZE payroll;
SET enable_seqscan = off;   -- tiny table: force the planner to show the index

EXPLAIN
SELECT employee_id, gross_pay, net_pay
FROM payroll
WHERE pay_month = DATE '2026-10-01';

RESET enable_seqscan;
