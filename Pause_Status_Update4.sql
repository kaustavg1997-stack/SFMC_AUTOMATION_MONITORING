/* 
   Author: Kaustav Ghosh
   Description: This query is used to update the DE with Paused/active status
   Date Created: 02/28/2025
   Revision History:
*/

SELECT 
    auto.automationname,
    auto.automationinstanceid,
    auto.automationcustomerkey,
    CASE 
        WHEN (auto.FilenameFromTrigger !='' and DATEDIFF(day,auto.automationinstanceendtime_utc, GETDATE()) != 0 and auto.ErrorDetails = 'NA')
        THEN 'No_File_Today'
        WHEN (((auto.ScheduleType LIKE '%Daily%' and auto.ErrorDetails = 'NA') AND DATEDIFF(day,auto.automationinstanceendtime_utc, GETDATE()) != 0)
                 OR (((auto.ScheduleType = 'Weekly' OR auto.ScheduleType = 'Run Once') and auto.ErrorDetails = 'NA')
                     AND DATEDIFF(day,auto.automationinstanceendtime_utc, GETDATE()) != 0
                     AND DATEPART(WEEKDAY, GETDATE()) = DATEPART(WEEKDAY, auto.automationinstanceendtime_utc))
                 OR ((auto.ScheduleType = 'Weekday' and auto.ErrorDetails = 'NA')
                     AND DATEDIFF(day,auto.automationinstanceendtime_utc, GETDATE()) != 0
                     AND DATEPART(WEEKDAY, GETDATE()) IN (2,3,4,5,6))
             )
        THEN 'Paused'
        WHEN (DATEDIFF(day,auto.automationinstanceendtime_utc, GETDATE()) = 0 and auto.ErrorDetails = 'NA')
        THEN 'Completed'
        WHEN auto.ErrorDetails != 'NA' THEN 'Errored'
        ELSE 'Active'
    END AS AutomationStatus
FROM Prod_Automation_Status_Monitoring_DE auto
