@echo off
chcp 65001 >nul
echo Instalando Godot 4 e Git para o Jogo Ninja...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar-godot.ps1" %*
echo.
pause
