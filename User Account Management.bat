echo off
color 03
title User Account Management - Batlez#3740
cls

:wincheck
%SystemRoot%\System32\reg.exe query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v ProductName | find "Microsoft Windows XP" >nul 2>nul
%SystemRoot%\System32\reg.exe query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v ProductName | find "Windows Vista" >nul 2>nul
%SystemRoot%\System32\reg.exe query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v ProductName | find "Windows 7" >nul 2>nul
%SystemRoot%\System32\reg.exe query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v ProductName | find "Windows 8" >nul 2>nul
%SystemRoot%\System32\reg.exe query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v ProductName | find "Windows 8.1" >nul 2>nul
if %errorlevel% EQU 0 (goto :nosupport) (else :UserAccountManagement)

:nosupport
echo Your Windows Version is not Support This Script.
echo Supported OS is: Windows 10 Higher OS.
timeout 2 > nul 
cls
goto :exit

:UserAccountManagement
cls
echo.User Account Management
echo.
echo.You are signing in with username: %username%
echo.
echo.ID	Option
echo.
echo.1	View list user accounts
echo.2	Create a new user
echo.3	Delete user account
echo.4	Enable user account
echo.5	Disable user account
echo.6	Change password
echo.7	Delete password
echo.8	Return Main menu
echo.
choice /c:12345678 /n /m "Select ID for continue : "
if %errorlevel% EQU 1 goto list-user-accounts
if %errorlevel% EQU 2 goto create-a-new-user
if %errorlevel% EQU 3 goto delete-user-account
if %errorlevel% EQU 4 goto enable-user-account
if %errorlevel% EQU 5 goto disable-user-account
if %errorlevel% EQU 6 goto change-password
if %errorlevel% EQU 7 goto delete-password
if %errorlevel% EQU 8 goto exit
:: ------------------------------------------------------------------------------------

:list-user-accounts
cls
echo.List user accounts
echo.
net user
echo.
pause
goto UserAccountManagement
:: ------------------------------------------------------------------------------------

:create-a-new-user
cls
choice /c:YN /n /m "Are you sure? (Yes/No) "
if %errorlevel% EQU 1 goto username
if %errorlevel% EQU 2 goto UserAccountManagement

:username
cls
echo.Create a new user
echo.
echo.You can not create a new user already in the list of user accounts below:
echo.
wmic useraccount where domain='%computername%' get Name,Status
set /p usr=Type a name for the new user :
if [!usr!]==[] goto username
:: --------------------------------------------------

:password
set /p pwd=Type a password for the new user (can be left blank) :
:: --------------------------------------------------

echo.
pause
net user /add "%usr%" %pwd%
net localgroup administrators /add "%usr%"
goto user-account-information

:user-account-information
cls
echo.Name of the new user is: %usr%
echo.Password of the new user is: %pwd%
echo.
echo.You must sign out and sign in with your new user account to complete this operation.
choice /c YN /n /m "Would you like to sign out now? (Yes/No) "
if %errorlevel% EQU 1 goto signout
if %errorlevel% EQU 2 goto UserAccountManagement
:: ------------------------------------------------------------------------------------

:delete-user-account
cls
echo.Delete user account
echo.
echo.Name
for /f "delims=" %%a in ('net localgroup Administrators^|more +6^|find /v "The command completed successfully."') do (
	echo.%%a
)
echo.
echo.WARNING: You can not delete Administrator and %username% account.
set /p usr1=Type username for continue if not press M to return Menu :
if [!usr1!]==[] goto enable-user-account
if [!usr1!]==[M] goto UserAccountManagement
net user "%usr1%" /del
pause
goto UserAccountManagement
:: ------------------------------------------------------------------------------------

:enable-user-account
cls
echo.Enable user account
echo.
wmic useraccount where Status='Degraded' get Name
set /p usr2=Type username for continue if not press M to return Menu :
if [!usr2!]==[] goto enable-user-account
if [!usr2!]==[M] goto UserAccountManagement
net user "%usr2%" /active:yes
pause
goto UserAccountManagement
:: ------------------------------------------------------------------------------------

:disable-user-account
cls
echo.Disable user account
echo.
wmic useraccount where Status='OK' get Name
echo.WARNING: You can not disable the user account that is logged on: %username%
set /p usr3=Type username for continue if not press M to return Menu :
if [!usr3!]==[] goto disable-user-account
if [!usr3!]==[M] goto UserAccountManagement
net user "%usr3%" /active:no
pause
goto UserAccountManagement
:: ------------------------------------------------------------------------------------

:change-password
cls
echo.Change password
echo.
wmic useraccount where Status='OK' get Name
set /p usr4=Type username for continue if not press M to return Menu :
if [!usr4!]==[] goto change-password
if [!usr4!]==[M] goto UserAccountManagement
net user "%usr4%" *
pause
goto UserAccountManagement
:: ------------------------------------------------------------------------------------

:delete-password
cls
echo.Delete password
echo.
wmic useraccount where Status='OK' get Name
set /p usr5=Type username for continue if not press M to return Menu :
if [!usr5!]==[] goto delete-password
if [!usr5!]==[M] goto UserAccountManagement
net user "%usr5%" ""
pause
goto UserAccountManagement

:exit
exit
cls
exit
