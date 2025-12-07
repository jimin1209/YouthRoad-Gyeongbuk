#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Write-Host "📦 1) Starting Flutter APK build..."

flutter clean

flutter build apk --debug --no-shrink `
  --dart-define=YOUTH_CENTER_KEY="efa8db16-c085-43b4-b48f-70d9d46367bd" `
  --dart-define=YOUTH_API_KEY="yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0" `
  --dart-define=KAKAO_MAP_API_KEY="e56be9363d2fd5a9cecd3264a29d40fc" `
  --dart-define=KAKAO_REST_API_KEY="416a3356e5061f181be8671e56f1367f" `
  --dart-define=CHAT_ENDPOINT="https://youthroad-chat-proxy.vercel.app/api/chat"

# Flutter-generated APK path
$apkSource = "build/app/outputs/flutter-apk/app-debug.apk"

if (-Not (Test-Path $apkSource)) {
    Write-Host "❌ APK was not generated at: $apkSource"
    exit 1
}

# Target path for storing stable APK
$distDir = "dist/apk"
$apkTarget = "$distDir/app-debug.apk"

Write-Host "📂 2) Copying APK to dist/apk ..."

# Ensure dist/apk exists
if (-Not (Test-Path $distDir)) {
    New-Item -ItemType Directory -Path $distDir | Out-Null
}

# Copy only if source and target differ
Copy-Item $apkSource $apkTarget -Force
Write-Host "✔ APK copied → $apkTarget"

Write-Host "🚀 3) Launching Flutter with generated APK..."

flutter run `
  --use-application-binary="$apkTarget"
