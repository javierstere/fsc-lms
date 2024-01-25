
CREATE PROCEDURE dbo.MaiQueue_List
AS
BEGIN
SET NOCOUNT ON;

IF EXISTS (
SELECT * FROM ClientSession WHERE
ReminderOffset IS NOT NULL AND
ReminderSent IS NULL AND
SessionDate > GETUTCDATE() AND
DATEADD(hh, -ReminderOffset, SessionDate) < GETUTCDATE()
) BEGIN


INSERT INTO MailQueue (Template, CreatedAt, ScheduledAt, Params)


SELECT 'group-session', GETDATE(), GETDATE(), CONVERT(VARCHAR, IdClientSession) + '|' + CONVERT(VARCHAR, IdEmployee) FROM ClientSessionEmployee WHERE IdClientSession IN 
(
SELECT IdClientSession FROM ClientSession WHERE
ReminderOffset IS NOT NULL AND
ReminderSent IS NULL AND
SessionDate > GETUTCDATE() AND
DATEADD(hh, -ReminderOffset, SessionDate) < GETUTCDATE()
)


UPDATE ClientSession
SET ReminderSent = '1'
WHERE
ReminderOffset IS NOT NULL AND
ReminderSent IS NULL AND
SessionDate > GETUTCDATE() AND
DATEADD(hh, -ReminderOffset, SessionDate) < GETUTCDATE()

END




SELECT * FROM MailQueue
WHERE ExecutedAt IS NULL
AND ScheduledAt < GETDATE()
END