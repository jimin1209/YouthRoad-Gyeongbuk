# ===========================
# YouthRoad Build & Run (Unity + Flutter)
# ===========================

Write-Host "📦 1) Flutter APK 빌드 시작..." -ForegroundColor Cyan
flutter build apk --debug --no-shrink `
  --dart-define=YOUTH_API_KEY=yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0 `
  --dart-define=KAKAO_MAP_API_KEY=e56be9363d2fd5a9cecd3264a29d40fc `
  --dart-define=CHAT_ENDPOINT=https://worker.youthroad-chat.workers.dev

# APK 경로
$apkSource = "android\app\build\outputs\apk\debug\app-debug.apk"

if (!(Test-Path $apkSource)) {
    Write-Host "❌ APK가 생성되지 않았습니다." -ForegroundColor Red
    exit 1
}

# Flutter 공식 APK 경로
$apkTargetDir = "android\build\app\outputs\flutter-apk"
$apkTarget = "$apkTargetDir\app-debug.apk"

Write-Host "📂 2) APK 복사 중..." -ForegroundColor Cyan
New-Item -ItemType Directory -Force -Path $apkTargetDir | Out-Null
Copy-Item $apkSource $apkTarget -Force

Write-Host "✔ APK 복사 완료 → $apkTarget" -ForegroundColor Green

Write-Host "🚀 3) Flutter 바이너리 실행..." -ForegroundColor Cyan

flutter run `
  --use-application-binary="$apkTarget" `
  --dart-define=YOUTH_API_KEY=yAlMhwGFZps7vHtbsjnbsL6Cpha6bHqaPDSScV6pgU0 `
  --dart-define=KAKAO_MAP_API_KEY=e56be9363d2fd5a9cecd3264a29d40fc `
  --dart-define=CHAT_ENDPOINT=https://worker.youthroad-chat.workers.dev
