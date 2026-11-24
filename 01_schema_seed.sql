-- ICT371 Q6 (a): tables, constraints, employees
DROP TABLE IF EXISTS salary_audit, payroll, employees CASCADE;

CREATE TABLE employees (
    employee_id   SERIAL PRIMARY KEY,
    full_name     VARCHAR(100)  NOT NULL,
    basic_salary  NUMERIC(12,2) NOT NULL CHECK (basic_salary >= 0),
    allowance     NUMERIC(12,2) NOT NULL CHECK (allowance >= 0),
    deduction     NUMERIC(12,2) NOT NULL CHECK (deduction >= 0),
    active        BOOLEAN       NOT NULL DEFAULT TRUE
);

CREATE TABLE payroll (
    payroll_id   SERIAL PRIMARY KEY,
    employee_id  INTEGER       NOT NULL REFERENCES employees(employee_id),
    pay_month    DATE          NOT NULL,
    gross_pay    NUMERIC(12,2) NOT NULL,
    net_pay      NUMERIC(12,2) NOT NULL,
    CONSTRAINT uq_payroll_employee_month UNIQUE (employee_id, pay_month),
    -- pay_month must be the first day of a month
    CONSTRAINT ck_pay_month_start CHECK (EXTRACT(DAY FROM pay_month) = 1)
);

CREATE TABLE salary_audit (
    audit_id     SERIAL PRIMARY KEY,
    employee_id  INTEGER       NOT NULL REFERENCES employees(employee_id),
    old_salary   NUMERIC(12,2) NOT NULL,
    new_salary   NUMERIC(12,2) NOT NULL,
    changed_at   TIMESTAMP     NOT NULL DEFAULT now()
);

INSERT INTO employees (full_name, basic_salary, allowance, deduction, active) VALUES
    ('Joseph Mulenga',  5000.00,  800.00,  700.00, TRUE),
    ('Grace Chileshe',  6500.00, 1000.00,  900.00, TRUE),
    ('Peter Zimba',     4200.00,  500.00,  450.00, TRUE),
    ('Ruth Mumba',      8000.00, 1200.00, 1100.00, TRUE),
    ('Daniel Katongo',  3000.00,  400.00,  350.00, TRUE);   -- becomes inactive in 08
-- Payroll rows for two months are produced in 08 by pr_process_payroll
