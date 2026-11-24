-- ICT371 Q6 (g): schedule pr_process_payroll on the 1st of each month at 02:00,
-- passing the first day of the PREVIOUS month.
CREATE EXTENSION IF NOT EXISTS pg_cron;

SELECT cron.schedule(
    'q06_monthly_payroll',
    '0 2 1 * *',
    $$CALL pr_process_payroll(date_trunc('month', CURRENT_DATE - INTERVAL '1 month')::date)$$
);

-- Inspect the job:
SELECT jobid, jobname, schedule, command, active
FROM cron.job
WHERE jobname = 'q06_monthly_payroll';

-- Inspect its run history:
SELECT d.runid, d.status, d.return_message, d.start_time, d.end_time
FROM cron.job_run_details d
JOIN cron.job j ON j.jobid = d.jobid
WHERE j.jobname = 'q06_monthly_payroll'
ORDER BY d.start_time DESC
LIMIT 10;

-- To remove the job:  SELECT cron.unschedule('q06_monthly_payroll');
