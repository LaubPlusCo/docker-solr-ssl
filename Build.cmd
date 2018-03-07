@echo off
set fname=%1
set dname=%2
set pw=%3
if [%fname%]==[] set /p fname="Enter certificate friendly name: "
if [%dname%]==[] set /p dname="Enter certificate DNS name (use localhost for dev setup): "
if [%pw%]==[] set /p pw="Enter certificate Password: "
echo [1/4] Generating certificate
powershell.exe -ExecutionPolicy Bypass -Command ".\builder\Generate-Certificate.ps1 %fname% %dname% %pw%"
echo [2/4] Building docker image 
docker-compose build --build-arg "SOLR_SSL_KEY_STORE_PASSWORD=%pw%" solr_ssl || goto :error
echo [3/4] Copying in clean solr_home to mounted volume
xcopy %~dp0builder\solr_home %~dp0solr_home /s /e /y
echo [4/4] Starting container detached..
docker-compose up -d || goto :error
goto :EOF
exit /b 1
:error
echo Build failed %errorlevel%.
exit /b %errorlevel%