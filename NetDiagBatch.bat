:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Network connectivity diagnostic
::Tyler Applebaum
::10/24/2014
::Rev 1.0
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@ECHO off
::Set background color to black so text displays as we expect.
Title Network Diagnostics
@(color 00)
SETLOCAL DISABLEDELAYEDEXPANSION
SET q=^"
ECHO(
ECHO(
SETLOCAL ENABLEDELAYEDEXPANSION

cd %userprofile%\desktop
ECHO Running traceroute, please wait
>output.txt (
  ipconfig /all
  tracert 8.8.8.8
)

::Use findstr to grab the default gateway from route.exe output
ECHO Testing connectivity to your local default gateway
@For /f "tokens=3" %%* in (
   'route.exe print ^|findstr "\<0.0.0.0\>"'
   ) Do @Set "DefaultGateway=%%*"
SET count=0
FOR /F "tokens=* USEBACKQ" %%F IN (`ping %DefaultGateway%`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)
CALL :c 0F "%var0%" /n
CALL :c 0B "%var1%" /n
CALL :c 0B "%var2%" /n
CALL :c 0B "%var3%" /n
CALL :c 0B "%var4%" /n
CALL :c 0F "%var5%" /n
CALL :c 0B "%var6%" /n
CALL :c 0F "%var7%" /n
CALL :c 0B "%var8%" /n
ECHO.

::Resolve your.own.tld
ECHO Testing DNS resolution of your.own.tld
SET count=9
FOR /F "tokens=* USEBACKQ" %%F IN (`nslookup -q your.own.tld`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)
CALL :c 0E "%var9%" /n
CALL :c 0A "%var10%" /n
CALL :c 0E "%var11%" /n
CALL :c 0A "%var12%" /n
ECHO.

::Resolve pool.ntp.org
ECHO Testing DNS resolution of pool.ntp.org
SET count=13
FOR /F "tokens=* USEBACKQ" %%F IN (`nslookup -q pool.ntp.org`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)
CALL :c 0E "%var13%" /n
CALL :c 0A "%var14%" /n
CALL :c 0E "%var15%" /n
CALL :c 0A "%var16%" /n
ECHO.

::Ping 192.0.2.2
ECHO Testing connectivity to 192.0.2.2 - your.own.tld
SET count=17
FOR /F "tokens=* USEBACKQ" %%F IN (`ping -n 4 -a 192.0.2.2`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)

CALL :c 0F "%var17%" /n
CALL :c 0B "%var18%" /n
CALL :c 0B "%var19%" /n
CALL :c 0B "%var20%" /n
CALL :c 0B "%var21%" /n
CALL :c 0F "%var22%" /n
CALL :c 0B "%var23%" /n
CALL :c 0F "%var24%" /n
CALL :c 0B "%var25%" /n
ECHO.

::Ping 8.8.8.8 Google DNS anycast IP
ECHO Testing connectivity to 8.8.8.8 - Google public DNS server
SET count=26
FOR /F "tokens=* USEBACKQ" %%F IN (`ping -n 4 -a 8.8.8.8`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)

CALL :c 0F "%var26%" /n
CALL :c 0B "%var27%" /n
CALL :c 0B "%var28%" /n
CALL :c 0B "%var29%" /n
CALL :c 0B "%var30%" /n
CALL :c 0F "%var31%" /n
CALL :c 0B "%var32%" /n
CALL :c 0F "%var33%" /n
CALL :c 0B "%var34%" /n
ECHO.

::Ping www.pool.ntp.org
ECHO Testing connectivity to www.pool.ntp.org
SET count=35
FOR /F "tokens=* USEBACKQ" %%F IN (`ping -n 4 -a www.pool.ntp.org`) DO (
  SET var!count!=%%F
  SET /a count=!count!+1
)

CALL :c 0F "%var35%" /n
CALL :c 0B "%var36%" /n
CALL :c 0B "%var37%" /n
CALL :c 0B "%var38%" /n
CALL :c 0B "%var39%" /n
CALL :c 0F "%var40%" /n
CALL :c 0B "%var41%" /n
CALL :c 0F "%var42%" /n
CALL :c 0B "%var43%" /n
ECHO.

ENDLOCAL

CALL :c 0C "Please copy the above information into a Jira." /n
ECHO.
CALL :c 0C "This window will close after pressing any key." /n

PAUSE
::End of editable code. Below code is for text color only. Do not modify.

ECHO(

:c
SETLOCAL ENABLEDELAYEDEXPANSION
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:colorPrint Color  Str  [/n]
SETlocal
SET "s=%~2"
CALL :colorPrintVar %1 s %3
EXIT /b

:colorPrintVar  Color  StrVar  [/n]
IF not defined DEL CALL :initColorPrint
SETLOCAL ENABLEDELAYEDEXPANSION
PUSHD .
':
CD \
SET "s=!%~2!"
::The single blank line within the following IN() clause is critical - DO NOT REMOVE
for %%n in (^"^

^") do (
  SET "s=!s:\=%%~n\%%~n!"
  SET "s=!s:/=%%~n/%%~n!"
  SET "s=!s::=%%~n:%%~n!"
)
for /f delims^=^ eol^= %%s in ("!s!") do (
  IF "!" equ "" SETlocal disableDelayedExpansion
  IF %%s==\ (
    findstr /a:%~1 "." "\'" nul
    <nul SET /p "=%DEL%%DEL%%DEL%"
  ) else IF %%s==/ (
    findstr /a:%~1 "." "/.\'" nul
    <nul SET /p "=%DEL%%DEL%%DEL%%DEL%%DEL%"
  ) else (
    >colorPrint.txt (ECHO %%s\..\')
    findstr /a:%~1 /f:colorPrint.txt "."
    <nul SET /p "=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
  )
)
IF /i "%~3"=="/n" ECHO(
POPD
EXIT /b

:initColorPrint
for /f %%A in ('"prompt $H&for %%B in (1) do rem"') do SET "DEL=%%A %%A"
<nul >"%temp%\'" SET /p "=."
SUBST ': "%temp%" >nul
EXIT /b

:cleanupColorPrint
2>NUL DEL "%temp%\'"
2>NUL DEL "%temp%\colorPrint.txt"
>NUL SUBST ': /d
