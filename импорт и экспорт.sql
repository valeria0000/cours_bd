--экспорт
CREATE OR ALTER PROCEDURE ExportToJson
    @path NVARCHAR(500)
AS
BEGIN
    DECLARE @output NVARCHAR(MAX);
    DECLARE @cmd NVARCHAR(4000);
    DECLARE @psCmd NVARCHAR(4000);
    SELECT @output = (
        SELECT 
            ID,
            name,
            price,
            [type],
            smell,
            photo,
            quantity,
            supply
        FROM 
            Candle
        FOR JSON AUTO, ROOT('Candle')
    );
    SET @output = REPLACE(@output, '"', '\"');
    SET @psCmd = 'powershell.exe -Command "$jsonContent = ''' + @output + '''; $filePath = ''' + @path + '''; $jsonContent | Out-File -FilePath $filePath -Encoding default"';
    IF LEN(@psCmd) > 2000
    BEGIN
        RAISERROR('Команда слишком длинная', 16, 1);
        RETURN;
    END
    EXEC xp_cmdshell @psCmd;
END;
EXEC ExportToJson @path = 'C:\Users\user\Desktop\course3\file.json';




--импорт
CREATE OR ALTER PROCEDURE ImportFromJson
AS
BEGIN
    CREATE TABLE #TempCandle (
        ID INT IDENTITY(1,1) PRIMARY KEY,
        name NVARCHAR(255) NOT NULL,
        price INT,
        [type] NVARCHAR(255),
        smell NVARCHAR(255),
        photo NVARCHAR(255),
        quantity INT,
        supply INT
    );

    DECLARE @Input NVARCHAR(MAX);

    SELECT @Input = BulkColumn
    FROM OPENROWSET (BULK 'C:\Users\user\Desktop\course3\file.json', SINGLE_CLOB) AS j;

    INSERT INTO #TempCandle (name, price, [type], smell, photo, quantity, supply)
    SELECT 
        name,
        price,
        [type],
        smell,
        photo,
        quantity,
        supply
    FROM OPENJSON(@Input, '$.Candle') 
    WITH (
        name NVARCHAR(255) '$.name',
        price INT '$.price',
        [type] NVARCHAR(255) '$.type',
        smell NVARCHAR(255) '$.smell',
        photo NVARCHAR(255) '$.photo',
        quantity INT '$.quantity',
        supply INT '$.supply'
    );

    MERGE Candle AS target
    USING #TempCandle AS source
    ON target.ID = source.ID
    WHEN MATCHED THEN 
        UPDATE SET 
            target.name = source.name,
            target.price = source.price,
            target.[type] = source.[type],
            target.smell = source.smell,
            target.photo = source.photo,
            target.quantity = source.quantity,
            target.supply = source.supply
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (name, price, [type], smell, photo, quantity, supply)
        VALUES (source.name, source.price, source.[type], source.smell, source.photo, source.quantity, source.supply);

    DROP TABLE #TempCandle;
END;
