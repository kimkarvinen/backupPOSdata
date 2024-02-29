@echo off

REM Close running applications

REM List of processes to close (add more if needed)
taskkill /IM "posread.exe" /F
taskkill /IM "poswin.exe" /F
taskkill /IM "tsceressql.exe" /F
taskkill /IM "finedine.exe" /F
taskkill /IM "bacchussql.exe" /F


REM Display message
echo Please do not use the Point of Sale system during the backup process.
echo.
echo Backup process is in progress...

REM Get current date in YYYYMMDD format
for /f "tokens=2 delims==." %%a in ('wmic os get localdatetime /value') do set "datetime=%%a"
set "datestamp=%datetime:~0,4%%datetime:~4,2%%datetime:~6,2%"

set "source=data"
set "destination=data_%datestamp%"
set "backup_count=0"

:check_backup_existence
if exist "%destination%" (
    set /a "backup_count+=1"
    set "destination=data_%datestamp%-%backup_count%"
    goto :check_backup_existence
)

REM Create destination directory
mkdir "%destination%"

REM Copy files and subdirectories from source to destination
xcopy /E /I /Y "%source%" "%destination%"

REM Create compressed (zipped) folder using Windows utility
powershell -command "Add-Type -A 'System.IO.Compression.FileSystem'; [System.IO.Compression.ZipFile]::CreateFromDirectory('%destination%', '%destination%.zip')"

echo Backup completed and zipped
echo you can upload the zip backup to your goolge drive
echo or copy the backup files to your flash drive
echo --Kim Karvinen

pause