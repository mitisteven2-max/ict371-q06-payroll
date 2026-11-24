-- ICT371 Q6 (e): v_payroll_report
-- No filter on employees.active, so history of later-inactive staff stays visible.
CREATE OR REPLACE VIEW v_payroll_report AS
SELECT e.employee_id,
       e.full_name,
       p.pay_month,
       p.gross_pay,
       p.net_pay
FROM payroll p
JOIN employees e ON e.employee_id = p.employee_id
ORDER BY p.pay_month, e.full_name;
