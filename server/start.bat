@echo off
REM Starts the aerophys server and follows its logs.
REM Ctrl-C here only stops watching logs — it does NOT stop the server.
REM To stop the server, run stop.bat.
cd /d "%~dp0"
docker compose up -d mc
docker compose logs -f mc
