@echo off
echo ==========================================
echo Nettoyage complet du projet
echo ==========================================

echo.
echo 1. Arrêt des processus Java/Gradle...
taskkill /f /im java.exe 2>nul
taskkill /f /im gradle.exe 2>nul

echo.
echo 2. Nettoyage Flutter...
call flutter clean

echo.
echo 3. Suppression des dossiers de build...
if exist .dart_tool rmdir /s /q .dart_tool
if exist build rmdir /s /q build
if exist android\app\build rmdir /s /q android\app\build
if exist android\build rmdir /s /q android\build
if exist android\.gradle rmdir /s /q android\.gradle

echo.
echo 4. Suppression de pubspec.lock...
if exist pubspec.lock del pubspec.lock

echo.
echo 5. Suppression du cache Gradle global...
if exist %USERPROFILE%\.gradle\caches rmdir /s /q %USERPROFILE%\.gradle\caches
if exist %USERPROFILE%\.gradle\kotlin-dsl rmdir /s /q %USERPROFILE%\.gradle\kotlin-dsl

echo.
echo 6. Vérification des fichiers Gradle...
if not exist android\settings.gradle.kts (
    echo ERREUR: android/settings.gradle.kts manquant!
    echo Veuillez créer ce fichier.
    pause
    exit /b 1
)

echo.
echo 7. Réinstallation des dépendances...
call flutter pub get

echo.
echo 8. Lancement de l'application...
call flutter run

echo.
echo Terminé!
pause