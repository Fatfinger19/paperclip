@echo off
SETLOCAL EnableDelayedExpansion

set SCRIPT_DIR=%~dp0
set TSX_PATH=%SCRIPT_DIR%cli\node_modules\tsx\dist\cli.mjs
set CLI_ENTRY=%SCRIPT_DIR%cli\src\index.ts

:: Check for Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: Node.js is not installed or not in your PATH.
    echo Please install Node.js 20+ from https://nodejs.org/
    pause
    exit /b 1
)

:: Check if dependencies are installed
if not exist "%TSX_PATH%" (
    echo Error: Dependencies not found.
    echo Please run 'pnpm install' in the repository root first.
    echo.
    echo If you don't have pnpm installed, run: npm install -g pnpm
    pause
    exit /b 1
)

:: Run Paperclip CLI
node "%TSX_PATH%" "%CLI_ENTRY%" %*

set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% neq 0 (
    echo.
    echo Paperclip exited with error code %EXIT_CODE%
    pause
    exit /b %EXIT_CODE%
)

:: If run without arguments, pause so the user can see the help/output before the window closes
if "%~1"=="" (
    echo.
    echo Press any key to close this window...
    pause >nul
)

ENDLOCAL
