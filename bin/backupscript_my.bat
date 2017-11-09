@echo off
SetLocal EnableExtensions
call :GetDateToday DateToday
Exit /B
 
:GetDateToday [Переменная для хранения текущей даты]
  :: Получает текущую дату в формате DD.MM.YYYY независимо от настроек региональных стандартов
  call :ParseDateSafe "%Date%" DayToday MonthToday YearToday
  set "%~1=%DayToday%.%MonthToday%.%YearToday%"
  ;;; echo Today 
  ;;; echo Day - %DayToday%
  ;;; echo Month - %MonthToday%
  ;;; echo Year - %YearToday%
  
set Days=5 
set Path=C:\backup\
  
cd C:\BCS\bin\
call backup -o C:\Backup\%DayToday%.%MonthToday%.%YearToday%-rights.zip -force -rights
call backup -o C:\Backup\%DayToday%.%MonthToday%.%YearToday%.zip -force

copy /Y C:\Backup\%DayToday%.%MonthToday%.%YearToday%-rights.zip \\sgf-actdir-vwp1\c$\tmp\%DayToday%.%MonthToday%.%YearToday%-rights.zip
copy /Y C:\Backup\%DayToday%.%MonthToday%.%YearToday%.zip \\sgf-actdir-vwp1\c$\tmp\%DayToday%.%MonthToday%.%YearToday%.zip

C:\Windows\System32\forfiles.exe  /P %Path% /M *.* /S /D -%Days% /C "CMD /C echo @PATH .. @fdate .. @fsize && del /q @PATH " > %Path%\dellog_%DayToday%.%MonthToday%.%YearToday%.txt
Exit /B
 
:ParseDateSafe [Дата] [Переменная - День] [Переменная - Месяц] [Переменная - Год]
  :: Функция безопасного парсинга даты на составляющие вне зависимости от настроек региональных стандартов
  if not Defined iDate For /F "Tokens=1,3" %%i IN ('REG QUERY "HKCU\Control Panel\International" /s^|FindStr /C:"iDate" /C:"sDate"') DO Set "%%i=%%j"
  set "DateToParse=%~1"
  For /F "Tokens=2" %%? IN ("%~1") Do if not "%%?"=="" set "DateToParse=%%?"
  For /F "Tokens=1-4* Delims=%sDate% " %%A IN ("%DateToParse%") Do (
    If "%iDate%"=="0" Set "Year=%%C"& Set "Month=%%A"& Set "Day=%%B"
    If "%iDate%"=="1" Set "Year=%%C"& Set "Month=%%B"& Set "Day=%%A"
    If "%iDate%"=="2" Set "Year=%%A"& Set "Month=%%B"& Set "Day=%%C"
  )
  ::if "%Day:~0,1%"=="0" set "Day=%Day:~1,1%"
  ::if "%Month:~0,1%"=="0" set "Month=%Month:~1,1%"
  if "%Day:~1,1%"=="" set "Day=0%Day%"
  if "%Month:~1,1%"=="" set "Month=0%Month%"
  set "%~2=%Day%"& set "%~3=%Month%"& set "%~4=%Year%"
Exit /B
