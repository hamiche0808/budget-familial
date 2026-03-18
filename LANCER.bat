@echo off
title Budget Familial - Demarrage...
color 1F

echo.
echo  ============================================
echo   Demarrage de Budget Familial...
echo  ============================================
echo.

cd /d "%~dp0"

:: Vérifier que Node.js est installé
node --version >nul 2>&1
if errorlevel 1 (
    echo  ERREUR : Node.js n'est pas installe.
    echo  Telechargez-le sur https://nodejs.org
    pause
    exit
)

:: Installer les dépendances si besoin
if not exist "node_modules" (
    echo  Premiere utilisation - Installation des modules...
    echo  (cela prend 1 minute, seulement la premiere fois)
    echo.
    npm install
    echo.
)

:: Lancer le serveur et ouvrir le navigateur
echo  Ouverture de l'application dans votre navigateur...
echo.
start "" "http://localhost:3000"
timeout /t 1 /nobreak >nul
node server.js

pause
