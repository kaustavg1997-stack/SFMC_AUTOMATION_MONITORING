/* 
   Author: Kaustav Ghosh
   Description: This query is used to update the DE with recent executed automation status in last 24 hours
   Date Created: 02/28/2025
   Revision History:
*/

SELECT TOP 1000
    auto.automationname,
    auto.automationcustomerkey,
    auto.automationinstanceid,
    CASE 
        WHEN daily_check.RecentRuns >= 1 THEN  daily_check.RecentRuns
        ELSE auto.InstanceCounter
        END AS InstanceCounter,
    CASE 
        WHEN daily_check.RecentRuns >= 1 THEN 'Daily'
        ELSE auto.ScheduleType
        END AS ScheduleType
FROM Prod_Automation_Status_Monitoring_DE auto 
LEFT JOIN (
    SELECT 
        automationcustomerkey,
        COUNT(automationcustomerkey) AS RecentRuns
    FROM [_AutomationInstance]
    WHERE CAST(DATEADD(HOUR, -6, automationinstanceendtime_utc) AS DATE) IN (CAST(GETDATE() AS DATE), CAST(DATEADD(day, -1, GETDATE()) AS DATE))
    GROUP BY automationcustomerkey
) daily_check
ON auto.automationcustomerkey = daily_check.automationcustomerkey
where auto.ScheduleType LIKE '%Daily%' OR auto.ScheduleType = 'Ad-Hoc' OR auto.ScheduleType = 'Run Once'
