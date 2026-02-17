/* 
   Author: Kaustav Ghosh
   Description: This query is used to update the DE with scheduled Automation status and Schedule
   Date Created: 02/28/2025
   Revision History:
*/
SELECT TOP 1000
    auto.automationname,
    auto.automationinstanceid,
    auto.automationcustomerkey,
    instance_count.schedule AS InstanceCounter,
    CASE 
        WHEN instance_count.schedule = 14 THEN 'Daily'
        WHEN instance_count.schedule = 2 THEN 'Weekly'
        WHEN instance_count.schedule = 1 THEN 'Run Once'
        WHEN instance_count.schedule = 28 THEN 'Twice Daily'
        WHEN instance_count.schedule = 10 THEN 'Weekday'
        ELSE 'Ad-Hoc'
    END AS ScheduleType
FROM Prod_Automation_Status_Monitoring_DE auto
LEFT JOIN (
    SELECT 
        automationcustomerkey,
        COUNT(*) AS schedule
    FROM [_AutomationInstance]
    WHERE DATEADD(HOUR, -6, automationinstanceendtime_utc) BETWEEN DATEADD(day, -15, GETDATE()) AND DATEADD(day, -1, GETDATE())
    GROUP BY automationcustomerkey
) instance_count 
    ON auto.automationcustomerkey = instance_count.automationcustomerkey
