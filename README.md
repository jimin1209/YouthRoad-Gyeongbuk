📌 목적

feature/no-unity-build 브랜치는 Unity 없이 Flutter만 빌드하기 위한 전용 브랜치입니다.

회사 EC2 / CI에서 Unity 설치 없이 빌드됨

Unity 관련 모든 코드/플러그인 제거

Android Gradle Plugin(AGP) 8.x 호환

main 브랜치의 Unity 기능은 유지

언제든 main의 최신 변경을 merge하여 최신화 가능

자동 패치 스크립트로 유지보수 부담 0%

📌 브랜치 전략
main

Unity 포함

flutter_unity_widget 포함

unityLibrary 존재

feature/no-unity-build

Unity 100% 제거

flutter_unity_widget 비활성화

Unity route 제거

Gradle/AGP 패치 적용

EC2 빌드 성공 보장

1️⃣ settings.gradle 수정
✔ Unity 제거
// include(":unityLibrary")
// project(":unityLibrary").projectDir = file("unityLibrary")

✔ isar_flutter_libs 로컬 모듈 include
include(":isar_flutter_libs")
project(":isar_flutter_libs").projectDir = file("/home/ssm-user/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android")

2️⃣ isar_flutter_libs 패치
📁 경로
~/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android/

✔ build.gradle 최종 버전
group 'dev.isar.isar_flutter_libs'
version '1.0'

apply plugin: 'com.android.library'

android {
    namespace "isar.flutter.libs"
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 24
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    implementation "androidx.startup:startup-runtime:1.1.1"
}

✔ AndroidManifest.xml

삭제:

package="dev.isar.isar_flutter_libs"

3️⃣ flutter_unity_widget 제거

pubspec.yaml:

# flutter_unity_widget: 2022.2.1

4️⃣ app/build.gradle — Unity 관련 코드 제거

삭제해야 하는 예:

implementation project(":unityLibrary")
jniLibs.srcDirs += ['../unityLibrary/src/main/jniLibs']

packagingOptions {
    pickFirst '**/libunity.so'
    pickFirst '**/libmain.so'
}

5️⃣ App Router Unity 제거

파일: lib/navigation/app_router.dart

import '../ui/screens/unity/unity_screen.dart'; // 삭제

// Unity route block 삭제

6️⃣ EC2 Flutter 빌드 명령어
flutter build apk --debug --no-shrink \
  --dart-define=YOUTH_API_KEY=xxxxx \
  --dart-define=KAKAO_MAP_API_KEY=xxxxx \
  --dart-define=CHAT_ENDPOINT=https://youthroad-chat-proxy.vercel.app/api/chat

7️⃣ ⭐ 자동 패치 스크립트 (merge 후 실행)
📁 위치 (추천)
scripts/patch_no_unity.sh

📄 스크립트 내용
#!/bin/bash

echo "==============================================="
echo "🔥 YouthRoad — no-unity-build 자동 패치 스크립트 시작"
echo "==============================================="

BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [ "$BRANCH" != "no-unity-build" ] && [ "$BRANCH" != "feature/no-unity-build" ]; then
  echo "❌ 현재 브랜치: $BRANCH"
  echo "⚠️ 이 스크립트는 no-unity-build 전용입니다."
  exit 1
fi

echo "✔ 현재 브랜치: $BRANCH"
echo "✔ Unity 관련 요소 자동 제거 시작..."

sed -i '/flutter_unity_widget/d' pubspec.yaml
sed -i '/unity_screen.dart/d' lib/navigation/app_router.dart
sed -i '/UnityScreen/d' lib/navigation/app_router.dart
sed -i '/unityLibrary/d' android/app/build.gradle
sed -i '/libunity.so/d' android/app/build.gradle
sed -i '/libmain.so/d' android/app/build.gradle
sed -i '/jniLibs.srcDirs/d' android/app/build.gradle
sed -i '/unityLibrary/d' android/settings.gradle

ISAR_PATH=$(ls -d ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android 2>/dev/null)

if [ -d "$ISAR_PATH" ]; then
  sed -i '/package=/d' $ISAR_PATH/src/main/AndroidManifest.xml

  cat > $ISAR_PATH/build.gradle <<EOF
group 'dev.isar.isar_flutter_libs'
version '1.0'

apply plugin: 'com.android.library'

android {
    namespace "isar.flutter.libs"
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 24
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }
}

repositories {
    google()
    mavenCentral()
}

dependencies {
    implementation "androidx.startup:startup-runtime:1.1.1"
}
EOF
fi

echo "🧹 Flutter clean + pub get..."
flutter clean
flutter pub get

echo "==============================================="
echo "🎉 자동 패치 완료 — Unity 없는 빌드 환경 준비됨!"
echo "==============================================="

8️⃣ ⭐ main → no-unity-build 최신화 절차 (중요)

main에서 작업한 뒤 최신화가 필요할 때:

git checkout no-unity-build
git fetch origin
git merge origin/main --no-ff
./scripts/patch_no_unity.sh


바로 빌드:

flutter build apk ...

📌 빌드 상태 요약
기능	상태
Unity 기능	❌ 제거
flutter_unity_widget	❌ 비활성화
isar libs	✔ 패치됨
Gradle/AGP	✔ 정상
Kakao Map	✔ 정상
Youth API	✔ 정상
AI Chat	✔ 정상
EC2 Build	완전 성공

## 테스트 실행 가이드

이 프로젝트의 테스트는 Flutter 환경이 준비되어 있어야 실행할 수 있습니다.

1. Flutter SDK가 PATH에 등록되어 있는지 확인합니다. (`flutter --version`)
2. 의존성을 최신화합니다. (`flutter pub get`)
3. 단위 테스트를 실행합니다. (`flutter test`)

CI나 로컬 머신에 Flutter가 없으면 위 명령이 동작하지 않으므로, 사전에 SDK를 설치한 뒤 테스트를 수행해야 합니다.
