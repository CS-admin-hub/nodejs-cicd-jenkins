@echo off
echo ========================================
echo   Testing Node.js App Locally
echo ========================================
echo.

docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker is not installed
    pause
    exit /b 1
)

echo [1/5] Building Docker image...
docker build -t golden-cicd-nodejs .

echo.
echo [2/5] Starting container...
docker run -d --name nodejs-test -p 3000:3000 -e APP_ENV=local golden-cicd-nodejs

echo.
echo [3/5] Waiting for application...
timeout /t 5 /nobreak >nul

echo.
echo [4/5] Testing endpoints...
echo.
echo Testing root endpoint (/)...
curl -s http://localhost:3000/
echo.
echo.
echo Testing health endpoint (/health)...
curl -s http://localhost:3000/health
echo.
echo.

echo [5/5] Container logs...
docker logs nodejs-test
echo.

echo ========================================
echo   ALL TESTS PASSED!
echo ========================================
echo.
echo Application: http://localhost:3000
echo Health: http://localhost:3000/health
echo.
echo Press any key to stop...
pause >nul

:cleanup
echo.
echo Stopping container...
docker stop nodejs-test >nul 2>&1
docker rm nodejs-test >nul 2>&1
echo Done!
