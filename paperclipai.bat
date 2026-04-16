@echo off
SETLOCAL
set SCRIPT_DIR=%~dp0
node "%SCRIPT_DIR%cli\node_modules\tsx\dist\cli.mjs" "%SCRIPT_DIR%cli\src\index.ts" %*
ENDLOCAL
