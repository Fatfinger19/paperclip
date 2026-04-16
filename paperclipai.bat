@echo off
SETLOCAL EnableDelayedExpansion

set SCRIPT_DIR=%~dp0
set CLI_ENTRY=%SCRIPT_DIR%cli\src\index.ts

:: Check for Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: Node.js is not installed or not in your PATH.
    echo Please install Node.js 20+ from https://nodejs.org/
    pause
    exit /b 1
)

:: Prefer pnpm if available
where pnpm >nul 2>nul
if %ERRORLEVEL% eq 0 (
    :: Run using pnpm which handles workspace dependencies correctly
    pnpm --dir "%SCRIPT_DIR%" exec tsx "%CLI_ENTRY%" %*
    goto :handle_exit
)

:: Fallback to npx
where npx >nul 2>nul
if %ERRORLEVEL% eq 0 (
    echo Using npx fallback...
    npx --prefix "%SCRIPT_DIR%cli" tsx "%CLI_ENTRY%" %*
    goto :handle_exit
)

echo Error: Neither pnpm nor npx were found.
echo Please install pnpm (npm install -g pnpm) or ensure npm is in your PATH.
pause
exit /b 1

:handle_exit
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
