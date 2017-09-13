IF EXIST C:\tmp\_site (
RD C:\tmp\_site\ /Q /S
IF ERRORLEVEL 1 GOTO :ERROR
)

git checkout source
IF ERRORLEVEL 1 GOTO :ERROR
XCOPY _site C:\tmp\_site\ /E
IF ERRORLEVEL 1 GOTO :ERROR
git checkout master
IF ERRORLEVEL 1 GOTO :ERROR

GOTO :SUCCESS

:ERROR
echo "Error"
EXIT /B

:SUCCESS
echo "Deploy success"