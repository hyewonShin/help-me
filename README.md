<p align="center">
  <img src="assets/images/logo.svg" alt="App Logo" width="300">
</p>
<br/><br/>


Flutter로 제작된 재능 마켓 플랫폼입니다. 사용자는 제공 가능한 재능을 등록하거나, 필요한 재능을 요청할 수 있습니다. 등록된 재능과 요청은 각각 **마이페이지** 에서 확인할 수 있습니다.

---

## 📌 **주요 기능**

### 1. **재능 등록 및 요청**

- **재능 등록**: 사용자가 제공하고 싶은 재능을 등록할 수 있습니다.
- **재능 요청**: 필요한 재능을 요청할 수 있는 페이지를 제공합니다.
- 등록 및 요청 시 **입력값 검증(validation)** 을 수행하여 데이터 무결성을 보장합니다.

### 2. **데이터 관리**

- `path_provider`를 이용하여 **JSON 파일**에서 데이터를 로드 및 저장합니다.
- 앱 상태에 데이터를 등록하고 사용하는 구조로 설계되었습니다.

### 3. **기능별 페이지 구성**

#### **재능 제공 페이지 (`give_screen`)**

- 여러 사용자들이 작성한 재능 기부 데이터 목록이 표시됩니다.
- 각 항목은 다음 정보를 포함합니다:

  - `image`, `user`, `title`, `desc`, `price`

```
{
    "give_id": 4,
    "user_id": 3,
    "title": "코딩 가르쳐 드립니다.",
    "desc": "별내동 GPT입니다. 코딩은 자신있습니다.",
    "price": 50000,
    "image": "https://img.jpg"
  },
```

- **장바구니에 담기**기능과 **구매** 기능이 제공됩니다.

#### **재능 요청 페이지 (`ask_screen`)**

- 여러 사용자들이 작성한 재능 요청 데이터 목룍이 표시됩니다.
- 각 항목은 다음 정보를 포함합니다:

  - `title`, `user`, `desc`, `price`

```
{
    "ask_id": 12,
    "user_id": 2,
    "title": "고양이 언어 가르쳐 주실 분.",
    "desc": "사례는 톡톡히 하겠습니다. 저는 완전 초보예요. 물개입니다. 수영은 자신있습니다.",
    "price": 20000
  },
```

- 사용자가 작성한 요청은 **마이페이지**에서 확인 가능합니다.

#### **마이 페이지 (`mypage_screen`)**

- 사용자 고유 정보가 표시됩니다.
- 각 항목은 다음 정보를 포함합니다:
  - `user_id`, `name`, `give`

```
{
   "user_id": 1,
   "name": "솜사탕구름",
   "give": [
     { "give_id": 4, "quantity": 2 },
     { "give_id": 5, "quantity": 1 },
     { "give_id": 2, "quantity": 1 }
   ]
 },
```

- 사용자가 작성한 요청은 **마이페이지**에서 확인 가능합니다.

---

## 🛠️ **기술 스택**

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: `setState`
- **Data Handling**: JSON 파일 연동 (`path_provider` 사용)
- **UI Components**:
  - `ListView.builder`를 활용한 동적 목록 생성
  - `GestureDetector`로 사용자 액션 처리
  - `SingleChildScrollView`로 스크롤 처리
- **Validation**: 사용자 입력값 검증 및 예외 처리
- **Intl**: 금액 포맷터 (원화 뒤에서 셋째 자리마다 컴마 표시 등)

---

## 📂 **프로젝트 구조**

```
lib/
├── main.dart
├── screens/
│ ├── give/
│ │ ├── give_screen.dart
│ │ ├── give_detail.dart
│ │ ├── give_submit.dart
│ ├── ask/
│ │ ├── ask_screen.dart
│ │ ├── ask_detail.dart
│ │ ├── ask_submit.dart
│ ├── mypage/
│ │ ├── data_service.dart
│ │ ├── models.dart
│ │ ├── mypage_ask_list.dart
│ │ ├── mypage_give_list.dart
│ │ ├── mypage_screen.dart
├── constant/
│ ├── colors.dart
├── mock_data/
│ ├── give.json
│ ├── ask.json
│ ├── users.json
├── util/
│ ├── load_data_from_document.dart
│ ├── save_json_to_file.dart
├── widget/
│ ├── submit_button.dart
│ ├── textfield.dart
```

---

## 🚀 **설치 및 실행**

### 1. **Flutter 설치**

Flutter가 설치되어 있지 않다면 [Flutter 설치 가이드](https://docs.flutter.dev/get-started/install)를 참고하세요.

- **프로젝트 클론**

```
git clone git@github.com:Team-NP/help-me.git
cd help-me
```

- **의존성 설치**

```
flutter pub get
```

## 🏂 **향후 개선 방향**

### 1. **상태관리 도구 도입**

- `Provider`, `GetX` 등의 도구를 도입해서 상태 관리를 조금 더 효율적으로 관리할 수 있습니다.

### 2. **데이터베이스 연동**

- Firebase 등을 연동하여 향후 서비스 확장 가능성을 높입니다.
