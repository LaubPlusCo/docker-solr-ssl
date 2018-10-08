@echo off
echo [1/2] Checking if certificate exists
IF NOT EXIST %~dp0certs\solr-ssl.keystore.pfx (
    echo [1/2] Generating certificate
    powershell.exe -ExecutionPolicy Bypass -Command ".\Generate-Certificate.ps1"
) ELSE (
    echo [1/2] Using existing %~dp0certs\solr-ssl.keystore.pfx
)
echo [2/2] Starting solr container detached.. 
docker-compose up -d