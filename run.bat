```bat
@echo off
cd /d "%~dp0"

docker compose up -d

echo.
echo Docker Compose iniciado. Terminal disponible.
echo.

cmd /k
```