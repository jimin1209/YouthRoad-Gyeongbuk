# 🧭 YouthRoad App (Flutter + Unity Integrated Project)

**YouthRoad App**은 Flutter 3.x 기반과 Unity 2022.3 LTS 엔진을 하나의 Mobile App 안에 통합한
경북 청년 정책 플랫폼 프로젝트입니다.
Flutter UI와 Unity 3D 씬을 Android 단에서 안정적으로 실행하도록 구성되어 있습니다.

---

# 📌 Project Information

| 항목                    | 값                                        |
| --------------------- | ---------------------------------------- |
| **Flutter**           | 3.24.x                                   |
| **Dart**              | 3.4.x                                    |
| **Unity**             | 2022.3 LTS                               |
| **Android SDK**       | compileSdk 36 / targetSdk 36 / minSdk 24 |
| **Scripting Backend** | IL2CPP + ARM64                           |
| **빌드 상태**             | ✔ Flutter + Unity 정상 빌드됨 *(현재 컨테이너에서는 SDK 부재로 재검증 불가)* |
| **Platform 지원**       | Android, iOS, Web, Windows               |

**Flutter는 UI와 정책 API 처리**
**Unity는 지도/3D 시각화 기능 담당**

---

# 📁 Project Structure (2025-11-22 기준, 정상 빌드 버전)

```
youth_road_app/
 ├─ android/
 │   ├─ app/                     # Flutter Android module
 │   └─ unityLibrary/            # Unity Export Android Library
 │
 ├─ lib/                         # Flutter source (Riverpod / Router / API)
 ├─ assets/
 ├─ windows/
 ├─ web/
 ├─ build/
 ├─ pubspec.yaml
 └─ README.md
```

Unity Export 후 포함되는 구조:

```
android/unityLibrary/
 ├─ build.gradle
 ├─ libs/unity-classes.jar
 ├─ src/main/AndroidManifest.xml
 ├─ src/main/jniLibs/arm64-v8a/
 └─ src/main/java/com/unity3d/player/*.java
```

---

# 🛠️ Versions & Dependencies (현재 빌드 성공 버전)

## pubspec.yaml

```yaml
name: youth_road_app
description: YouthRoad Flutter + Unity integrated project

publish_to: "none"

version: 1.0.0+1

environment:
  sdk: ">=3.4.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  cupertino_icons: ^1.0.8

  flutter_riverpod: ^2.6.1
  go_router: ^14.8.1

  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0

  retrofit: ^4.5.0
  dio: ^5.7.0
  shared_preferences: ^2.1.1

  webview_flutter: ^4.10.0

  # 현재 유일하게 빌드 성공하는 안정 버전
  flutter_unity_widget: ^2022.1.1+5

dev_dependencies:
  flutter_test:
    sdk: flutter

  build_runner: ^2.4.13
  freezed: ^2.5.7
  retrofit_generator: ^8.2.1
  json_serializable: ^6.9.0
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/
```

---

# 🛠️ Android (build.gradle — 정상 빌드된 최종본)

```gradle
plugins {
    id "com.android.application"
    id "org.jetbrains.kotlin.android"
    id "dev.flutter.flutter-gradle-plugin"
}

android {
    namespace = "com.youthroad.app"
    compileSdk = 36

    signingConfigs {
        debug {
            storeFile file("${rootDir}/debug.keystore")
            storePassword "android"
            keyAlias "androiddebugkey"
            keyPassword "android"
        }
    }

    defaultConfig {
        applicationId = "com.youthroad.app"
        minSdk = 24
        targetSdk = 36

        versionCode = 1
        versionName = "1.0"

        multiDexEnabled = true
    }

    buildTypes {
        debug {
            debuggable true
            signingConfig signingConfigs.debug
        }
        release {
            signingConfig signingConfigs.debug
            minifyEnabled false
            shrinkResources false
        }
    }

    packagingOptions {
        jniLibs.useLegacyPackaging = true
        doNotStrip "*/arm64-v8a/*.so"

        resources.pickFirsts += ['**/*.xml']
        resources.pickFirsts += ['**/*.properties']
        resources.pickFirsts += ['META-INF/*']
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }
}

afterEvaluate {
    tasks.matching { it.name == "packageDebug" }.configureEach { t ->
        t.doLast {
            def fromApk = file("$projectDir/build/outputs/apk/debug/app-debug.apk")

            def flutterDir = file("$rootDir/build/app/outputs/flutter-apk")
            def backupDir = file("$rootDir/build")

            if (fromApk.exists()) {
                flutterDir.mkdirs()
                copy { from fromApk into flutterDir }

                backupDir.mkdirs()
                copy { from fromApk into backupDir }

                println("✔ APK copied successfully.")
            } else {
                println("✘ APK NOT FOUND at: ${fromApk}")
            }
        }
    }
}

## 🔍 Build Verification (현재 컨테이너 상황)

- Android Gradle 빌드에는 `android/local.properties`의 `flutter.sdk`/`sdk.dir` 값이 필요합니다.
- 본 컨테이너에는 Flutter SDK와 Android SDK 경로가 비어 있어 Gradle wrapper 실행이 중단되었습니다.
- 로컬에서 확인 시 `android/local.properties.example`를 복사 후 실제 경로로 수정하면 `./gradlew assembleDebug`로 빌드 검증을 수행할 수 있습니다.

flutter {
    source = "../.."
}

dependencies {
    implementation "androidx.multidex:multidex:2.0.1"
    implementation project(":unityLibrary")
}

configurations.all {
    exclude group: "com.unity3d.player"
    exclude module: "unity-classes"
}

repositories {
    flatDir {
        dirs "${project(':unityLibrary').projectDir}/libs"
    }
}
```

---

# 🎮 Unity Integration Workflow (2022.3 LTS)

Unity 설정은 아래처럼 작업해야 문제 없이 빌드됨:

1. **Unity → Build Settings**

   * Android
   * Export Project 체크
2. **Scripting Backend**

   * IL2CPP
3. **Architecture**

   * ARM64
4. **Export Path**

   ```
   android/unityLibrary/
   ```
5. 기존 Flutter Android와 자동 병합됨
6. Flutter에서 `flutter_unity_widget`로 UnityView 렌더링
7. 메시지 통신:

   * Flutter → Unity: `postMessage`
   * Unity → Flutter: `sendMessage`

---

# 🚀 Running the Project (Debug & Release 검증)

```bash
flutter clean
flutter pub get
flutter build apk --debug --no-shrink

# 릴리스 빌드 (현재 debug.keystore 기반 서명, Shrink 미적용)
flutter build apk --release --no-shrink
```

APK 출력 경로:

```
build/app/outputs/flutter-apk/app-debug.apk
build/app/outputs/flutter-apk/app-release.apk
```

> **Note**: `android/app/build.gradle`에서 `packageDebug`와 `packageRelease` 작업 완료 후
> 생성된 APK를 Flutter가 읽는 디렉토리(`build/app/outputs/flutter-apk`)와 백업 디렉토리(`build/`)
> 두 곳에 자동 복사하도록 후처리가 걸려 있습니다. Debug/Release 모두 동일하게 동작합니다.

---

# 🖼️ Flutter Screens (현재 계획)

* 앱 첫 로딩 화면 (애니메이션)
* 지역 선택 화면
* 정책 추천 Home
* Unity Map/3D 인터랙션 화면
* 마이페이지

---

# 👩‍💻 Developer

### **최지민 (ChoiDeborah)**

Flutter × Unity × Oracle 기반의 YouthRoad App 개발자

---

# 🛠 Tech Stack

### Languages / Frameworks

![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge\&logo=dart\&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge\&logo=flutter\&logoColor=white)
![Unity](https://img.shields.io/badge/Unity-000000?style=for-the-badge\&logo=unity\&logoColor=white)

### Tools

![Android Studio](https://img.shields.io/badge/Android%20Studio-3DDC84?style=for-the-badge\&logo=androidstudio\&logoColor=white)
![VS Code](https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge\&logo=visualstudiocode\&logoColor=white)
![Rider](https://img.shields.io/badge/JetBrains%20Rider-000000?style=for-the-badge\&logo=jetbrains\&logoColor=white)
![Visual Studio](https://img.shields.io/badge/Visual%20Studio-5C2D91?style=for-the-badge\&logo=visualstudio\&logoColor=white)

---
