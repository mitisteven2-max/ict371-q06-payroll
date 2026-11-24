# ICT371 Q6 - Monthly Payroll Processing

**Student:** Steven Miti (202405283)  
**DBMS:** PostgreSQL 13+ with the pg_cron extension

## How to run
Use a fresh database for this question (several questions share table names such as `students`):

```bash
createdb ict371_q06
psql -d ict371_q06 -f run_all.sql
```

Files run in order: schema, function, procedure, trigger, view, index, scheduled job, data load, tests.
The data load (`08_load_data.sql`) runs after the trigger/procedure exist, as the question requires.

| Part | File |
|------|------|
| (a) Tables + seed data | `01_schema_seed.sql`, `08_load_data.sql` |
| (b) Function | `02_function.sql` |
| (c) Procedure | `03_procedure.sql` |
| (d) Trigger | `04_trigger.sql` |
| (e) View | `05_view.sql` |
| (f) Index + EXPLAIN | `06_index.sql` |
| (g) Scheduled job | `07_scheduled_job.sql` |
| Demonstration queries | `09_tests.sql` |

## Index
`idx_payroll_pay_month ON payroll (pay_month)`

The existing UNIQUE (employee_id, pay_month) index starts with employee_id, so it cannot efficiently answer 'everyone in one month'. This index starts with pay_month, so it is not a duplicate of the unique index.

## Design notes
- pr_process_payroll uses ON CONFLICT DO NOTHING, so existing payroll rows are left unchanged.
- A negative net pay raises an exception, which rolls back the whole call (no partial month).
- The cron command passes date_trunc('month', CURRENT_DATE - INTERVAL '1 month')::date, the first day of last month.

## Output
_Paste screenshots / output of `09_tests.sql` and the `EXPLAIN` plan here._
