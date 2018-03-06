@echo off
set fname=%1
set dname=%2
set pw=%3
if [%fname%]==[] set /p fname="Enter certificate friendly name: "
if [%dname%]==[] set /p dname="Enter certificate DNS name: "
if [%pw%]==[] set /p pw="Enter certificate Password: "
echo [1/3] Generating certificate
powershell.exe -ExecutionPolicy Bypass -Command ".\builder\Generate-Certificate.ps1 %fname% %dname% %pw%"
echo [2/3] Building docker image 
docker-compose build --build-arg "SOLR_SSL_KEY_STORE_PASSWORD=%pw%" solr_ssl || goto :error
echo [3/3] Starting container detached..
docker-compose up -d || goto :error
goto :EOF
exit /b 1
:error
echo Build failed %errorlevel%.
exit /b %errorlevel%