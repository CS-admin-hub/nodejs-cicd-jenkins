@echo off
echo ========================================
echo   Push Node.js App to Docker Hub
echo ========================================
echo.

set DOCKERHUB_USERNAME=ninad04
set IMAGE_NAME=golden-cicd-nodejs

echo [1/4] Logging in to Docker Hub...
docker login -u %DOCKERHUB_USERNAME%

if %errorlevel% neq 0 (
    echo ERROR: Docker login failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Building Docker image...
docker build -t %DOCKERHUB_USERNAME%/%IMAGE_NAME%:latest .

if %errorlevel% neq 0 (
    echo ERROR: Docker build failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Tagging image...
docker tag %DOCKERHUB_USERNAME%/%IMAGE_NAME%:latest %DOCKERHUB_USERNAME%/%IMAGE_NAME%:v1.0

echo.
echo [4/4] Pushing to Docker Hub...
docker push %DOCKERHUB_USERNAME%/%IMAGE_NAME%:latest
docker push %DOCKERHUB_USERNAME%/%IMAGE_NAME%:v1.0

echo.
echo ========================================
echo   SUCCESS! Image pushed to Docker Hub
echo ========================================
echo.
echo Your image: https://hub.docker.com/r/%DOCKERHUB_USERNAME%/%IMAGE_NAME%
echo.
echo Pull: docker pull %DOCKERHUB_USERNAME%/%IMAGE_NAME%:latest
echo Run: docker run -d -p 3000:3000 %DOCKERHUB_USERNAME%/%IMAGE_NAME%:latest
echo.
pause
