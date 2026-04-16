@echo off
:: Ensure we are in the repository root
cd /d "%~dp0"

echo == Paperclip Windows Setup ==
echo.

where node >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Error: Node.js is not installed. Please install it from https://nodejs.org/
    pause
    exit /b 1
)

where pnpm >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Installing pnpm...
    call npm install -g pnpm
)

echo.
echo Installing dependencies...
call pnpm install

echo.
echo Building project...
call pnpm build

echo.
echo Setup complete! You can now run Paperclip using paperclipai.bat
echo.
pause
