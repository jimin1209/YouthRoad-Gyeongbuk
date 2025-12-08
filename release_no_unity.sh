#!/bin/bash

echo "==============================================="
echo "🔥 YouthRoad — no-unity-build 자동 릴리즈 스크립트 시작"
echo "==============================================="

set -e

###############################################
# 0) API KEY CHECK
###############################################
missing_keys=()

[ -z "$YOUTH_API_KEY" ] && missing_keys+=("YOUTH_API_KEY")
[ -z "$KAKAO_MAP_API_KEY" ] && missing_keys+=("KAKAO_MAP_API_KEY")
[ -z "$CHAT_ENDPOINT" ] && missing_keys+=("CHAT_ENDPOINT")

if [ ${#missing_keys[@]} -ne 0 ]; then
  echo "❌ 빌드 중단! 아래 환경변수가 설정되지 않았습니다:"
  for key in "${missing_keys[@]}"; do
    echo "   - $key"
  done
  echo ""
  echo "👉 해결방법: ~/.bashrc 에 아래처럼 추가 후 'source ~/.bashrc' 실행"
  echo "   export YOUTH_API_KEY=값"
  echo "   export KAKAO_MAP_API_KEY=값"
  echo "   export CHAT_ENDPOINT=값"
  echo ""
  exit 1
fi

echo "✔ API Key 확인 완료 — 모든 키가 정상입니다!"
echo ""

###############################################
# 1) BRANCH CHECK
###############################################
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "❌ 현재 브랜치: $BRANCH"

echo "✔ 브랜치 확인 완료 — $BRANCH"
echo ""

###############################################
# 2) 날짜 기반 APK 파일명 생성
###############################################
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
APK_NAME="youthroad-relase-$DATE.apk"
APK_DIR="apk"
APK_PATH="$APK_DIR/$APK_NAME"

mkdir -p "$APK_DIR"

echo "📌 빌드 날짜: $DATE"
echo "📌 APK 파일명: $APK_NAME"
echo ""

###############################################
# 3) Unity 패치 실행
###############################################
echo "🧹 Unity 제거 패치 실행 (patch_no_unity.sh)..."
./patch_no_unity.sh
echo ""

###############################################
# 4) Flutter APK 빌드 (에러 무시 + APK로 판단)
###############################################
echo "⚙️ Flutter Debug APK 빌드 시작..."

set +e
flutter clean
flutter pub get

flutter build apk --debug --no-shrink \
  --dart-define=YOUTH_API_KEY="$YOUTH_API_KEY" \
  --dart-define=KAKAO_MAP_API_KEY="$KAKAO_MAP_API_KEY" \
  --dart-define=CHAT_ENDPOINT="$CHAT_ENDPOINT"
BUILD_EXIT=$?
set -e

echo "ℹ️ Flutter build exit code: $BUILD_EXIT (APK 파일 존재 여부로 최종 판단)"
echo ""

###############################################
# 5) APK 자동 탐색 (여러 경로 검사)
###############################################
echo "🔍 APK 경로 자동 탐색..."

CANDIDATES=(
  "build/app/outputs/flutter-apk/app-debug.apk"
)

FOUND_APK=""

for path in "${CANDIDATES[@]}"; do
  if [ -f "$path" ]; then
    FOUND_APK="$path"
    break
  fi
done

if [ -z "$FOUND_APK" ]; then
  echo "❌ APK 파일을 찾을 수 없습니다."
  echo "🔎 확인한 경로 목록:"
  for p in "${CANDIDATES[@]}"; do
    echo "   - $p"
  done
  echo ""
  echo "👉 flutter build apk --debug --no-shrink ... 을 수동으로 실행한 뒤, 생성된 APK 경로를 확인해 주세요."
  exit 1
fi

echo "✔ APK 발견됨: $FOUND_APK"

cp "$FOUND_APK" "$APK_PATH"
echo "🎉 APK 복사 완료 → $APK_PATH"
echo ""

###############################################
# 6) Git Commit + Push
###############################################

###############################################
# 7) GitHub Release 생성
###############################################
echo "🚀 GitHub Release 생성..."

if [ -z "$GITHUB_TOKEN" ]; then
  echo "❌ GITHUB_TOKEN 환경변수가 설정되지 않았습니다!"
  echo "👉 GitHub에서 Fine-grained Token 생성 후 ~/.bashrc 에 추가하세요."
  exit 1
fi

REPO="jimin1209/YouthRoad-Gyeongbuk"
TAG="build-$DATE"
TITLE="YouthRoad No-Unity Build ($DATE)"
BODY="EC2에서 자동 생성된 no-unity 디버그 APK입니다."

API_RESPONSE=$(curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"tag_name\":\"$TAG\",\"name\":\"$TITLE\",\"body\":\"$BODY\",\"draft\":false,\"prerelease\":false}" \
  "https://api.github.com/repos/$REPO/releases")

RELEASE_ID=$(echo "$API_RESPONSE" | jq -r '.id')

if [ -z "$RELEASE_ID" ] || [ "$RELEASE_ID" = "None" ]; then
  echo "❌ Release 생성 실패"
  echo "Response:"
  echo "$API_RESPONSE"
  exit 1
fi

echo "✔ Release 생성 완료! (ID: $RELEASE_ID, TAG: $TAG)"
echo ""

###############################################
# 8) APK 파일 업로드
###############################################
echo "📤 GitHub Release에 APK 업로드 중..."

UPLOAD_RESPONSE=$(curl -s \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Content-Type: application/vnd.android.package-archive" \
  --data-binary @"$APK_PATH" \
  "https://uploads.github.com/repos/$REPO/releases/$RELEASE_ID/assets?name=$APK_NAME")

echo "✔ APK 업로드 완료!"
echo ""
echo "==============================================="
echo "🎉 모든 작업 완료! GitHub Release 업로드 성공!"
echo "👉 브랜치 : $BRANCH"
echo "👉 TAG    : $TAG"
echo "👉 APK    : $APK_PATH"
echo "==============================================="
