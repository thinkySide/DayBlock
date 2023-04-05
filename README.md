# 🧱 DayBlock
하루는 24개의 블럭으로 이루어져있습니다.    
그 중 몇개의 블럭을 황금 블럭으로 만들 수 있을까요?   
당신만의 블럭 공장을 설계하고, 가동해보세요!

<br>

## 📅 프로젝트 일정표
- 프로젝트 시작일 : `23.03.01(수)`
- 배포 예정일 : `23.05.20(토)`
<img src="https://user-images.githubusercontent.com/113565086/228855918-9a999e10-1714-43fa-ba6c-17cf1586b4c5.png">

<br>

## ⭐️ 서비스 핵심 목표

- 하루 24개의 블럭을 어떻게 활용했는지 `직관적인 시각적 피드백` 전달하기
- `생산성 업무에 온전히 집중`할 수 있도록 핵심 정보 위주로 전달하기
- 어떤 생산성을 발휘했는지 `확인 및 동기부여`가 가능한 통계 리포트 제공하기

<br>

## 📝 기능 정의

### 핵심 기능
- 1시간=1블럭 / 30분=0.5블럭 단위로 생산성 트래킹
- 반복적으로 진행하는 생산성 작업을 블럭 템플릿으로 생성 및 등록
- 현재까지 생산한 블럭 저장 및 그룹/날짜별 통계 리포트 제공

### 추가 기능
- 반복 블럭 시간 설정 후 Push 알림 발송 (습관 만들기에 도움주기)
- 블럭 생성 후 애니메이션 효과로 블럭 쌓기 (마이크로인터랙션 추가로 긍정적인 반응 이끌어내기)
- 통계 리포트 내 황금블럭 전환율 보기 추가 (일반 블럭 및 생산선 블럭 구분으로 효율 계산)
- 친구 추가를 이용한 활동 공유 (서로의 활동 공유로 동기부여 제공)

<br>

## 🧑‍💻 개발 일지

### **Day 31 - 23.03.31**

- **Github 연동**   
Repository를 만들고, README 페이지를 생성했습니다.

- **Code base 레이아웃 환경 세팅**   
Storyboard 사용 대신 `Code Base 레이아웃`을 사용합니다.

- **View/Controller 분리**   
가장 익숙한 `MVC` 패턴을 이용해 전체 구조를 잡을 예정입니다.

- **커스텀 폰트 추가**   
Pretendard, Poppins 폰트를 추가했습니다.

- **컬러 등록**   
GrayScale 컬러를 NameSpace에 등록했습니다.

- HomeView 메인 라벨 추가
- UINavigationController 추가

<img width="300" src="https://user-images.githubusercontent.com/113565086/229175142-f9953d52-920d-4a49-9b09-1d42c0af1225.png">

---

<br>

### **Day 33 - 23.04.02**

- **Block Preview 컴포넌트 추가**    
`BlockPreview` 는 앞으로 많이 사용하게 될 예정이기에 컴포넌트화 시켰습니다.   
총 24개의 블럭을 각각의 `UIView`로 구성했습니다.

- UITabBarController 추가   

<img width="300" src="https://user-images.githubusercontent.com/113565086/229357605-5766c3c0-8d80-470b-843d-9f70886e36e3.png">

---

<br>

### **Day 34 - 23.04.03**

- **Block, Group 모델 추가**   
Block, Group의 필요 데이터에 맞게 Struct를 생성했습니다.

- **UICollectionView 셋팅**   
`CollectionView`를 이용해 블럭 선택창 틀을 잡았습니다.   

- **BlockCollectionView에 캐러셀 이펙트 추가**   
처음 구현해보는 `Carousel Effect`가 어려웠지만 레퍼런스를 참고해 구현했습니다.   
핵심은 보이지 않는 레이아웃용 블럭 사이즈를 크게 잡고,    
`scrollViewWillEndDragging` 메서드를 활용해 몇번째 블럭인지 index값을 구해 포커싱 하는 방식입니다.   
캐러셀 이펙트는 다양한 레이아웃에 활용될 것으로 예상하기에, 꼼꼼히 돌아볼 예정입니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/229537564-0c05dbff-76cc-4417-abd2-db93c1a675d0.png">

<br>

### **Day 35 - 23.04.04**

- BlockCollectionViewCell 디자인

- **TabBarActiveStackView 디자인 및 컴포넌트화**   
현재 어떤 View에 위치해 있는지 시각적으로 알려주는 컴포넌트를 TabBar 상단에 추가했습니다.   
class로 만들어 추가해주고, 간단한 메서드를 만들어 페이지에 따라 switch 될 수 있게 구현했습니다.   

- MessageLabel, TrackingButton 추가

- **BlockDataManager 추가 및 TestData로 테스트**   
BlockGroup 안에 Block을 넣어 관리하는 구조로 구성했습니다.   
테스트 데이터로 구현은 성공하였으나, BlockGroup 이름을 어떻게 관리해야할지는 더 고민해야 할 부분입니다.   

<img width="300" src="https://user-images.githubusercontent.com/113565086/229819118-59407ef9-0dd0-438b-8732-9a921129c464.png">

<br>

### **Day 36 - 23.04.05**

- **현재 날짜, 요일, 시간 구하기**   
`dateFormatter`를 활용해 현재 날짜 및 시간 정보를 불러왔습니다.

- **날짜 및 시간 실시간 업데이트**   
`Timer`를 활용해 1초 간격으로 날짜 및 시간 정보를 업데이트 합니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/230119913-3163ffe5-adcc-48f4-9a2e-e4cf4572071b.png">