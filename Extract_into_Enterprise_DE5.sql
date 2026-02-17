SELECT
    automationname,
    AutomationType,
    automationinstanceendtime_utc,
    FilenameFromTrigger,
    InstanceCounter,
    ScheduleType,
    AutomationStatus,
    ErrorDetails,
    automationinstanceid,
    automationcustomerkey,
    'Branded Consumer' AS Business_Unit
FROM Prod_Automation_Status_Monitoring_DE
