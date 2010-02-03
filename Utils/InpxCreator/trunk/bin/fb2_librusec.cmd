@ECHO OFF
SETLOCAL

IF .%1. == .. GOTO usage

SET NAME=librusec
SET SITE=http://lib.rus.ec
SET CDIR=%~dp0
SET WDIR=%~dp0%NAME%
SET TF=%TEMP%\%~n0.tmp

IF NOT .%2. == .. GOTO skip

IF EXIST %WDIR%_old RD /Q /S %WDIR%_old
IF EXIST %WDIR%     MOVE %WDIR% %WDIR%_old
MD %WDIR%

DEL %CDIR%\log_%NAME%_archives.log

REM Download latest daily archives
wget --progress=dot:mega --user-agent=Mozilla/5.0 --append-output=%CDIR%\log_%NAME%_archives.log --recursive --no-directories --no-parent --no-remove-listing --accept=*.zip --directory-prefix=%1\%NAME% --no-clobber %SITE%/all/daily

forfiles /D +0 /P %1 /M ??????-??????.zip /C "cmd /c echo @path" 2>NUL >%TF%
IF %ERRORLEVEL% GTR 0 (DEL %TF% & GOTO :db_load)
IF NOT EXIST %TF% GOTO :db_load

REM Test new archives and remove broken ones
FOR /F %%a IN (%TF%) DO call :TEST_ZIP %%a

REM Remove non-FB2 files
REM FOR /F %%a IN (%TF%) DO (IF EXIST %%a (7za.exe d %%a *.* -x!*.fb2))

DEL %TF%

GOTO db_load

:TEST_ZIP
7za.exe t %1 >NUL
IF %ERRORLEVEL% GTR 0 DEL %1

:db_load

DEL %CDIR%\log_%NAME%_sql.log

REM Download latest database
FOR %%t IN (libgenrelist libbook libavtoraliase libavtorname libavtor libgenre librate libseq libseqname libfilename) DO (wget --progress=dot:mega --user-agent=Mozilla/5.0 --append-output=%CDIR%\log_%NAME%_sql.log --directory-prefix=%WDIR% %SITE%/sql/lib.%%t.sql.gz & gzip -d %WDIR%/lib.%%t.sql.gz)

:skip

REM Create INPX file for FB2
%CDIR%\lib2inpx.exe --db-name=%NAME% --process=fb2 --read-fb2=last --quick-fix --archives=%1;%1\%NAME% %WDIR%
REM %CDIR%\lib2inpx.exe --db-name=%NAME% --process=fb2 --archives=%1;%1\%NAME% %WDIR%
IF %ERRORLEVEL% GTR 0 GOTO :EOF

REM Create INPX file for FB2 (complete database, online usage)
%CDIR%\lib2inpx.exe --db-name=%NAME% --process=fb2 --no-import --quick-fix --clean-when-done %WDIR%

GOTO :EOF

:usage
echo Need path to local archives, for example: "sync_script.cmd c:\librusec\local"
echo If there is second parameter - daily archives and dumps would not be downloaded,
echo for example "sync_script.cmd c:\librusec\local skip"

ENDLOCAL
