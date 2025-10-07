@echo off
echo ========================================
echo    Luna Music - Run with Maven Wrapper
echo ========================================

echo.
echo Checking for Maven Wrapper...
if exist "mvnw.cmd" (
    echo Found Maven Wrapper, using it...
    call mvnw.cmd clean package tomcat10:run
) else (
    echo Maven Wrapper not found. Checking for Maven...
    where mvn >nul 2>&1
    if %errorlevel% equ 0 (
        echo Found Maven, using it...
        mvn clean package tomcat10:run
    ) else (
        echo Maven not found. Please install Maven or use manual deployment.
        echo.
        echo You can:
        echo 1. Install Maven from https://maven.apache.org/download.cgi
        echo 2. Use deploy-to-tomcat.bat for manual deployment
        pause
        exit /b 1
    )
)

pause
