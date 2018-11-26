@ECHO OFF
title 预约关机时间
mode con cols=70 lines=18
color 37
:select
echo 请选择要进行的操作：
echo 1、预约今日关机(默认18:00)
echo 2、取消今日预约关机
echo 3、预约每日关机(默认每日18:00)
echo 4、取消每日预约关机
set /p sel=您的选择是：
if not defined sel goto select
if %sel% equ 1 (title 预约今日关机时间 
goto revise)
if %sel% equ 2 goto cancel
if %sel% equ 3 (title 预约每日关机时间 
goto revise)
if %sel% equ 4 goto dailycancel
sel=
cls
echo 您的输入有误，请重新输入
goto select

:revise
cls
set defaulttime=18:00
set currtime=%time:~0,5%
echo 请输入要预约的关机时间，默认为%defaulttime%：

:putin
set shuttime=
set /p shuttime=
if not defined shuttime set shuttime=%defaulttime%

:format
if "%shuttime:~4,1%" == "" goto formatwrong
if not "%shuttime:~5,1%" == "" goto formatwrong
if %shuttime:~2,1% equ : goto formatright
if %shuttime:~2,1% equ ： goto formatright
if %shuttime:~2,1% equ / goto formatright
if %shuttime:~2,1% equ - goto formatright

:formatwrong
cls
echo 你输入的时间为 %shuttime% 
echo 格式不正确,时间格式为 HH:MM 
echo 请重新输入关机时间：
goto putin

:formatright
if %shuttime:~0,2%%shuttime:~3,2% geq 0 if %shuttime:~0,2%%shuttime:~3,2% leq 2359 if %shuttime:~3,2% leq 59 goto onceordaily
goto formatwrong

:past
if %shuttime:~0,2%%shuttime:~3,2% gtr %currtime:~0,2%%currtime:~3,2% goto shut
cls
echo 现在已经过了%shuttime%,请重新输入关机时间：
goto putin

:shut
set ftime=%shuttime:~0,2%:%shuttime:~3,2%
schtasks /create /tn "shut" /sc once /tr "shutdown /s" /st %ftime%
cls
echo 您的电脑将在%ftime%自动关机，需要取消自动关机请重新打开本文件
pause
exit

:cancel
schtasks /delete /tn "shut" /f
cls
echo 您已取消预约关机
pause
exit

:dailyshut
set ftime=%shuttime:~0,2%:%shuttime:~3,2%
schtasks /create /tn "dailyshut" /sc daily /tr "shutdown /s" /st %ftime%
cls
echo 您的电脑将在每天的%ftime%自动关机，需要取消自动关机请重新打开本文件
pause
exit

:dailycancel
schtasks /delete /tn "dailyshut" /f
cls
echo 您已取消预约每日关机
pause
exit

:onceordaily
if %sel% equ 1 goto past 
if %sel% equ 3 goto dailyshut
