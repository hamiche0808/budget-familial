@echo off
title Budget Familial - Personnalisation
color 1F
chcp 65001 >nul

echo.
echo  ============================================
echo   PERSONNALISATION - Budget Familial
echo  ============================================
echo.
echo  Que voulez-vous modifier ?
echo.
echo  [1] Changer le nom de l'application
echo  [2] Changer la couleur principale
echo  [3] Changer le nom de la famille (titre)
echo  [4] Quitter
echo.
set /p choix= Votre choix (1-4) : 

if "%choix%"=="1" goto nom
if "%choix%"=="2" goto couleur
if "%choix%"=="3" goto famille
if "%choix%"=="4" goto fin
goto fin

:nom
echo.
set /p nouveau_nom= Nouveau nom de l'app (ex: Budget Martin) : 
powershell -Command "(Get-Content 'public\manifest.json') -replace '\"name\": \".*\"', '\"name\": \"%nouveau_nom%\"' | Set-Content 'public\manifest.json'"
powershell -Command "(Get-Content 'public\manifest.json') -replace '\"short_name\": \".*\"', '\"short_name\": \"%nouveau_nom%\"' | Set-Content 'public\manifest.json'"
echo.
echo  Nom change en : %nouveau_nom%
echo  Relancez l'application pour voir le changement.
pause
goto fin

:couleur
echo.
echo  Couleurs disponibles :
echo  [1] Bleu (defaut)     #185FA5
echo  [2] Vert emeraude     #1D9E75
echo  [3] Violet            #7F77DD
echo  [4] Rouge bordeaux    #A32D2D
echo  [5] Gris ardoise      #444441
echo  [6] Couleur personnalisee (code hex)
echo.
set /p col= Votre choix (1-6) : 

if "%col%"=="1" set hex=#185FA5& set hexbg=#0C447C
if "%col%"=="2" set hex=#1D9E75& set hexbg=#085041
if "%col%"=="3" set hex=#7F77DD& set hexbg=#3C3489
if "%col%"=="4" set hex=#A32D2D& set hexbg=#501313
if "%col%"=="5" set hex=#5F5E5A& set hexbg=#2C2C2A
if "%col%"=="6" (
    set /p hex= Entrez votre couleur (ex: #E63946) : 
    set hexbg=%hex%
)

powershell -Command "(Get-Content 'public\index.html') -replace '--blue: #[0-9A-Fa-f]{6}', '--blue: %hex%' | Set-Content 'public\index.html'"
powershell -Command "(Get-Content 'public\manifest.json') -replace '\"theme_color\": \".*\"', '\"theme_color\": \"%hex%\"' | Set-Content 'public\manifest.json'"
echo.
echo  Couleur changee en : %hex%
echo  Relancez l'application pour voir le changement.
pause
goto fin

:famille
echo.
set /p nom_famille= Nom de votre famille (ex: Famille Martin) : 
powershell -Command "(Get-Content 'public\index.html') -replace 'Budget Familial', '%nom_famille%' | Set-Content 'public\index.html'"
echo.
echo  Nom de famille change en : %nom_famille%
echo  Relancez l'application pour voir le changement.
pause
goto fin

:fin
exit
