# ===========================
# YouthRoad Build & Run (Unity + Flutter)
# ===========================

Write-Host "📦 1) Starting Flutter APK build..." -ForegroundColor Cyan
flutter build apk --debug --no-shrink `
  --dart-define=YOUTH_API_KEY=yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0 `
  --dart-define=KAKAO_MAP_API_KEY=aa0f9f3d74d04efb792ef3af8fb1029a `
  --dart-define=CHAT_ENDPOINT=https://youthroad-chat-proxy.vercel.app/api/chat

# APK path
$apkSource = "android\app\build\outputs\apk\debug\app-debug.apk"

if (!(Test-Path $apkSource)) {
    Write-Host "❌ APK was not generated." -ForegroundColor Red
    exit 1
}

# Final APK copy location
$apkTargetDir = "android\build\app\outputs\flutter-apk"
$apkTarget = "$apkTargetDir\app-debug.apk"

Write-Host "📂 2) Copying APK..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $apkTargetDir | Out-Null
Copy-Item $apkSource $apkTarget -Force

Write-Host "✔ APK copy complete → $apkTarget" -ForegroundColor Green

Write-Host "🚀 3) Launching Flutter with custom APK..." -ForegroundColor Cyan

flutter run `
  --use-application-binary="$apkTarget" `
  --dart-define=YOUTH_API_KEY=yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0 `
  --dart-define=KAKAO_MAP_API_KEY=aa0f9f3d74d04efb792ef3af8fb1029a `
  --dart-define=CHAT_ENDPOINT=https://youthroad-chat-proxy.vercel.app/api/chat

