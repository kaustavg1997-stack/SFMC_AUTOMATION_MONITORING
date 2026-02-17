/* 
   Author: Kaustav Ghosh
   Description: This query is to fetch all automations to the DE with automation instance ID, customer Key, Automation status
   Date Created: 02/28/2025
   Revision History:
*/

SELECT TOP 1000
    ai.automationname,
    ai.automationinstanceid,
    ai.automationcustomerkey,
    ai.AutomationType,
    DATEADD(HOUR, -6, ai.automationinstanceendtime_utc) AS automationinstanceendtime_utc,
    ai.FilenameFromTrigger,
    ai.automationinstancestatus as AutomationStatus,
    CASE 
        WHEN ai.automationinstancestatus = 'Error' THEN ai.AutomationInstanceActivityErrorDetails
        ELSE 'NA'
        END AS ErrorDetails
FROM (
    SELECT 
        ai.*,
        ROW_NUMBER() OVER (
            PARTITION BY ai.automationcustomerkey 
            ORDER BY automationinstanceendtime_utc DESC
        ) AS rn
    FROM [_AutomationInstance] ai
    WHERE ai.automationname like 'Prod%'
    
) ai

WHERE ai.rn = 1
ORDER BY automationinstanceendtime_utc DESC
