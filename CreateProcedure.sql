USE LearningDB;
GO

-- Check if the procedure already exists and drop it if it does
IF OBJECT_ID('dbo.MySampleProcedure') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.MySampleProcedure;
END;
GO

-- Create a new sample procedure
CREATE PROCEDURE dbo.MySampleProcedure
    @InputMessage NVARCHAR(255) = 'Hello from MySampleProcedure!'
AS
BEGIN
    -- Prevent row count from being returned for SELECT, INSERT, UPDATE, DELETE statements
    SET NOCOUNT ON;

    -- Print a message to the console
    PRINT 'Procedure dbo.MySampleProcedure executed.';
    PRINT 'Input Message: ' + @InputMessage;

    -- You can add your database logic here, e.g., INSERT, UPDATE, SELECT statements
    -- For example:
    -- INSERT INTO YourLogTable (LogDateTime, Message) VALUES (GETDATE(), @InputMessage);
    
    -- Return a success message or result set
    SELECT 'Success' AS Status, GETDATE() AS ExecutionTime, @InputMessage AS ProvidedMessage;
END;
GO

-- Optional: To execute the procedure after creation (for testing)
-- EXEC dbo.MySampleProcedure @InputMessage = 'This is a test message.';
-- GO
