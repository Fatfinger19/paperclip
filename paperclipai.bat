@echo off
SETLOCAL EnableDelayedExpansion

:: Ensure we are in the repository root
cd /d "%~dp0"

set SCRIPT_DIR=%~dp0
set CLI_ENTRY=%SCRIPT_DIR%cli\src\index.ts

:: Check for Node.js
where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo [paperclip] Error: Node.js is not installed or not in your PATH.
    echo Please install Node.js 20+ from https://nodejs.org/
    pause
    exit /b 1
)

:: Check for pnpm
where pnpm >nul 2>nul
set HAS_PNPM=%ERRORLEVEL%

:: Check if node_modules exists
if not exist "%SCRIPT_DIR%node_modules" (
    echo [paperclip] Dependencies not found.
    if !HAS_PNPM! eq 0 (
        set /p REQ="Would you like to run 'pnpm install' now? (y/n): "
        if /i "!REQ!"=="y" (
            pnpm install
            if !ERRORLEVEL! neq 0 (
                echo [paperclip] Installation failed.
                pause
                exit /b 1
            )
        ) else (
            echo Please run 'pnpm install' manually before using this tool.
            pause
            exit /b 1
        )
    ) else (
        echo [paperclip] Error: pnpm is not installed.
        echo Please install it first: npm install -g pnpm
        echo Then run 'pnpm install' in this directory.
        pause
        exit /b 1
    )
)

:: Run Paperclip CLI
if !HAS_PNPM! eq 0 (
    pnpm exec tsx "%CLI_ENTRY%" %*
) else (
    echo [paperclip] Warning: pnpm not found, falling back to npx...
    npx --prefix "%SCRIPT_DIR%cli" tsx "%CLI_ENTRY%" %*
)

set EXIT_CODE=%ERRORLEVEL%
if %EXIT_CODE% neq 0 (
    echo.
    echo [paperclip] Exited with error code %EXIT_CODE%
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
