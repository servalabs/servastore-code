# Whitelabel script for Servastore

$newName = "Servastore"
$newPackageId = "com.servastore.app"

Write-Host "Whitelabeling to $newName..."

# 1. Update pubspec.yaml (App name and package dependencies)
$pubspecPath = "pubspec.yaml"
$pubspec = Get-Content $pubspecPath
$pubspec = $pubspec -replace "name: obtainium", "name: servastore"
Set-Content $pubspecPath $pubspec

# 2. Update Android Package ID (applicationId)
$gradlePath = "android/app/build.gradle.kts"
$gradle = Get-Content $gradlePath
$gradle = $gradle -replace "applicationId = `"dev.imranr.obtainium`"", "applicationId = `"$newPackageId`""
$gradle = $gradle -replace "namespace = `"dev.imranr.obtainium`"", "namespace = `"$newPackageId`""
Set-Content $gradlePath $gradle

# 3. Update main.dart and other files (Branding/Class names)
$filesToUpdate = Get-ChildItem -Path "lib" -Filter "*.dart" -Recurse
foreach ($file in $filesToUpdate) {
    $content = Get-Content $file.FullName
    $content = $content -replace "Obtainium", $newName
    $content = $content -replace "obtainium", "servastore"
    Set-Content $file.FullName $content
}

# 4. Update strings in settings_provider.dart
$settingsPath = "lib/providers/settings_provider.dart"
if (Test-Path $settingsPath) {
    $settings = Get-Content $settingsPath
    $settings = $settings -replace "dev.imranr.obtainium", $newPackageId
    Set-Content $settingsPath $settings
}

Write-Host "Whitelabeling complete! Now run 'flutter pub get'."
