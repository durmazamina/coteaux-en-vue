@echo off
chcp 65001 >nul
title Publier le site Les Coteaux en Vue
cd /d "%~dp0"
set "PATH=C:\Program Files\Git\cmd;%PATH%"

echo.
echo   ==============================================
echo     Publication du site Les Coteaux en Vue
echo   ==============================================
echo.

where git >nul 2>nul
if errorlevel 1 (
  echo   [ERREUR] Git n'est pas installé sur cet ordinateur.
  goto fin
)

git add -A
git diff --cached --quiet
if not errorlevel 1 (
  echo   Aucune modification à publier.
  echo   As-tu bien cliqué sur « Enregistrer » dans le panneau admin ?
  goto fin
)

echo   Modifications trouvées :
git -c core.quotepath=off diff --cached --name-status
echo.

git commit -q -m "Mise à jour du site (%date% %time:~0,5%)"
if errorlevel 1 (
  echo   [ERREUR] Impossible d'enregistrer les modifications.
  goto fin
)

echo   Envoi sur GitHub en cours...
git pull -q --rebase --autostash
if errorlevel 1 (
  echo   [ERREUR] Le site sur GitHub a été modifié ailleurs et ne correspond plus.
  echo   Demande de l'aide à Claude avant de continuer.
  goto fin
)
git push -q
if errorlevel 1 (
  echo   [ERREUR] L'envoi a échoué. Vérifie ta connexion internet puis réessaie.
  goto fin
)

echo.
echo   C'est publié !
echo   Le site sera à jour d'ici 1 à 2 minutes :
echo   https://durmazamina.github.io/coteaux-en-vue/

:fin
echo.
if not defined NOPAUSE pause
