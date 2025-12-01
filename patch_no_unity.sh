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

########################################
# pubspec.yaml — Unity 플러그인 제거
########################################
echo "🧹 pubspec.yaml Unity 플러그인 제거..."
sed -i '/flutter_unity_widget/d' pubspec.yaml

########################################
# App Router — Unity import 및 route 제거
########################################
echo "🧹 Unity import / route 제거..."
sed -i '/unity_screen.dart/d' lib/navigation/app_router.dart
sed -i '/UnityScreen/d' lib/navigation/app_router.dart

########################################
# android/app/build.gradle — Unity 관련 블록 제거
########################################
echo "🧹 android/app/build.gradle Unity 설정 제거..."
sed -i '/unityLibrary/d' android/app/build.gradle
sed -i '/libunity.so/d' android/app/build.gradle
sed -i '/libmain.so/d' android/app/build.gradle
sed -i '/jniLibs.srcDirs/d' android/app/build.gradle

########################################
# android/settings.gradle — unityLibrary include 제거
########################################
echo "🧹 settings.gradle에서 unityLibrary 제거..."
sed -i '/unityLibrary/d' android/settings.gradle

########################################
# isar_flutter_libs 패치 재적용
########################################
echo "🔧 isar_flutter_libs 패치 적용..."

ISAR_PATH=$(ls -d ~/.pub-cache/hosted/pub.dev/isar_flutter_libs-3.1.0+1/android 2>/dev/null)

if [ -d "$ISAR_PATH" ]; then
  echo "✔ isar 위치: $ISAR_PATH"

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

else
  echo "❌ isar_flutter_libs-3.1.0+1 폴더를 찾을 수 없습니다."
fi

########################################
# flutter clean / pub get
########################################
echo "🧹 flutter clean + pub get..."
flutter clean
flutter pub get

echo "==============================================="
echo "🎉 완전 자동 패치 완료 — Unity 없는 빌드 환경 준비됨!"
echo "==============================================="
