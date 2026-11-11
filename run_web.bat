@echo off
title CupBack Cafe Owner Web Portal
echo ======================================================
echo       CupBack - Cafe Owner Web Portal Runner
echo ======================================================
echo.
echo Launching Cafe Owner Web Portal on http://localhost:5173 ...
echo.

cd /d "%~dp0cafe_owner_web"

if not exist "node_modules" (
    echo Installing dependencies for the first time...
    call npm install
)

echo Starting development server...
start http://localhost:5173
call npm run dev

pause
