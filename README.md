# 🧭 Youth App (Flutter + Unity 예정)

Flutter 기반으로 개발하는 청년 정책/지역 서비스 앱입니다.  
현재는 Flutter 구조만 구성되어 있으며, 이후 Unity 3D 씬을 Android 내에 임베드해  
상호작용 기능을 제공할 예정입니다.

---

## 📌 Project Information

- **Framework:** Flutter 3.22.2  
- **Language:** Dart  
- **Supported Platforms:** Android, iOS, Web, Windows  
- **Unity Integration:** Unity 2022.3 LTS (설치 후 `unityLibrary` 폴더 통합 예정)  
- **Primary IDE:** VS Code / Rider  
- **Backup IDE:** Visual Studio 2022  

---

## 📁 Current Project Structure

(2025-11-17 기준)

```
youth_app/
 ├─ android/             # Android native project (Unity library가 여기로 들어올 예정)
 ├─ ios/                 # iOS project
 ├─ linux/               # Flutter Linux desktop support
 ├─ macos/               # Flutter macOS desktop support
 ├─ windows/             # Flutter Windows desktop support
 ├─ web/                 # Web support
 ├─ lib/                 # Flutter Dart source code
 ├─ build/               # Build output (ignored by Git)
 ├─ .idea/               # IDE config files (ignored)
 ├─ .dart_tool/          # Flutter tool cache (ignored)
 ├─ pubspec.yaml         # Flutter dependencies
 ├─ pubspec.lock         # Locked dependency versions
 ├─ .gitignore           # Flutter + Unity + Rider + VS 통합 무시 규칙
 └─ README.md            # (바로 이 파일)
```

> Unity Export 후, 아래 폴더가 추가될 예정입니다:

```
unityLibrary/
 ├─ build.gradle
 ├─ src/
 ├─ libs/
 ├─ assets/
 └─ jniLibs/
```

---

## 🚀 Getting Started

### 1. Clone Repository
```bash
git clone https://github.com/jimin1209/youth_app.git
cd youth_app
```

### 2. Install Flutter Packages
```bash
flutter pub get
```

### 3. Run on Emulator / Device
```bash
flutter run
```

---

## 🎨 Flutter Screens (현재 개발 예정 목록)
- 앱 런치 → 간단한 로딩 애니메이션 (Custom)
- 지역 선택 화면
- 추천 정책 리스트
- 감성 UI 기반 메인 홈

---

## 🎮 Unity Integration (설치 후 진행)
Unity 2022.3 LTS 설치 후:

1. Build Settings → Android  
2. Export Project → `unityLibrary/` 생성  
3. `unityLibrary/` 전체를 `android/`에 병합  
4. Flutter에서 UnityView 띄우기 설정  
5. Unity ↔ Flutter 메시지 통신 연결  

(퓨와 함께 계속 진행 예정)

---

## 🛠 Tech Stack

### **Flutter**
- Dart 3.x  
- Material 3  
- Provider/Bloc 등 상태관리 (선택 예정)

### **Unity (예정)**
- Unity 2022.3 LTS  
- OpenGLES3  
- Android IL2CPP  
- Unity as Library 방식

### **Development Tools**
- VS Code (Flutter)  
- Rider (Unity C# 메인 IDE)  
- Android Studio (Gradle/Native 디버깅)  
- VS 2022 (백업)

---

## 📌 Git Rules
프로젝트에는 **Flutter, Unity, Rider, VS**가 섞이므로  
.gitignore가 충돌 없이 작동하도록 최적화됨.

Git에는 오직 **필요한 코드만 clean하게 올라가도록 구성**되어 있습니다.

---

## © Developer
**최지민 (ChoiDeborah)**  
Flutter × Unity 기반 프로젝트 개발

## 🛠 Tech Stack

### **Languages & Frameworks**
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Unity](https://img.shields.io/badge/Unity-000000?style=for-the-badge&logo=unity&logoColor=white)

### **Tools**
![Android Studio](https://img.shields.io/badge/Android%20Studio-3DDC84?style=for-the-badge&logo=androidstudio&logoColor=white)
![VS Code](https://img.shields.io/badge/VS%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white)
![Rider](https://img.shields.io/badge/JetBrains%20Rider-000000?style=for-the-badge&logo=jetbrains&logoColor=white)
![Visual Studio](https://img.shields.io/badge/Visual%20Studio-5C2D91?style=for-the-badge&logo=visualstudio&logoColor=white)
