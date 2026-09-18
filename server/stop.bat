@echo off
REM Stops the aerophys server. Can take up to 5 minutes (stop_grace_period) —
REM the world needs to finish saving. Do not close this window early.
cd /d "%~dp0"
echo Stopping aerophys-mc — this can take up to 5 minutes while the world saves...
docker compose stop mc
pause
