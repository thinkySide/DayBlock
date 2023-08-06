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

---

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

---

<br>

### **Day 37 - 23.04.06**

- **BlockPreview 내부 PaintBlock 클래스 생성**   
기존의 UIView로 만들어져있던 각각의 블럭을 재사용을 위해 `PaintBlock` 클래스로 만들었습니다.   
그 과정에서 인스턴스 생성 시점에 따른 frameSize가 설정되지 않아, 배경색상이 정확히 반영되지 않는 오류를 발견해 해결했습니다.   

- **PaintBlock 상태에 따른 Switch**   
열거형을 활용하여 블럭이 반만 찼을 때, 모두 찼을 때 등의 케이스를 구분해 메서드로 구현했습니다.

- **Group 선택 버튼 디자인**   
`GroupSelectButton` 클래스를 만들어 navigation titleView에 적용했습니다.   
추후 터치 시 그룹 간 전환 기능을 추가 할 예정입니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/230411129-0049dcdd-c637-4223-902e-8483b98141ef.png">

---

<br>

### **Day 38 - 23.04.07**

- **블럭 추가 버튼 컬렉션뷰 마지막에 생성**   
`blockDataList`의 count 보다 1개 많은 컬렉션 뷰를 생성 후,   
마지막 인덱스에 블럭 추가 셀을 삽입했습니다.   
셀의 재사용으로 인한 오류를 막기 위해 `prepareForReuse` 메서드에 기본값을 설정했습니다.   

- **블럭 추가 화면 생성 + 탭바 숨기기**   
`hidesBottomBarWhenPushed` 메서드를 활용해 push시 TabBar를 숨겨주었습니다.

- **MainTextFieldView 컴포넌트화**   
blockPreview에 이어 2번째 컴포넌트를 생성했습니다.   
그 과정 속에서 제약을 확실하게 걸지 않으면 디버깅이 어려운 점을 발견해,   
init메서드에 print문을 찍으며 오류를 잡아냈습니다.   

<img width="300" src="https://user-images.githubusercontent.com/113565086/230638454-51d49dca-df1d-450c-9f7f-3c40315fdb7b.png">

---

<br>

### **Day 39 - 23.04.08**

- SelectForm 컴포넌트화 

- **SelectForm 스타일 열거형 정의**     
그룹 선택, 색상, 아이콘 SelectForm을 미리 지정한 style에 맞게 변경 가능하도록   
열거형과 메서드를 생성했습니다. `ofType(_ label: String, _ type: SelectType)`

- **TrackingMode 화면 디자인**       
 trackingButton 클릭 시 전환되는 화면을 구성했습니다.   
 추후 애니메이션을 적용시킬 예정입니다.

- ContentsBlock 컴포넌트화

<img width="300" src="https://user-images.githubusercontent.com/113565086/230752253-00def2c7-be44-4e40-b409-648bcde0b76e.png">

---

<br>

### **Day 40 - 23.04.09**

- **ContentsBlock 커스텀 생성자 사용**   
ContentsBlock을 컴포넌트화 하기 위해 .middle, .large 사이즈로 나눠 생성할 수 있도록 했습니다.   
기존 UIView의 생성자를 재정의해서 사용하는 것이 아닌, 커스텀 생성자를 만들어 구현했습니다.   
[문제 해결 기록 : 유동적인 사이즈의 컴포넌트 생성하기](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/27.md)

- **HomeViewDelegate 생성**    
트래킹 모드 진입 시, TabBarController를 숨기기 위해 커스텀 Delegate 패턴을 활용해 구현했습니다.

- **TrackingMode 사이즈 조정**   
trackingTimeLabel을 trackingBlock과 trackingButton 가운데에 배치하기 위해 제약조건을 업데이트했습니다.   
[문제 해결 기록 : 두개 View 사이 정가운데에 View 배치하기](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/28.md)

**+ 프로젝트 기간 점검**   
환경 셋팅, MVC 패턴 구성, 메인화면 레이아웃 잡기 목표를 가지고 계획했던 23.04.09 기준 진행상황은 예정보다 약 20% 정도 더 진행되었습니다. 트래킹, 블럭 추가 화면의 디자인이 거의 마무리되었기 때문에 남는 시간은 CoreData 관련 공부, 리팩토링에 집중할 계획입니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/230778508-5ab590e9-d78c-4607-a5c9-43f64ee0c00b.png">

---

<br>

### **Day 42 - 23.04.11**

- **TimeTracker 구조체 생성 및 View에 연결**   
`String(format: "%02d:%02d:%02d")` 메서드를 활용해 TimeTracker 값을 표시했습니다.

- **TimeTracker progressView 연결**   
현재 second에 기본 블럭 단위 30분(1800)과 나누어 progressView에 적용했습니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/231180512-ad2a6f35-b802-493d-a6fd-4511017bc35c.png">

---

<br>

### **Day 43 - 23.04.12**

- **TimeTracker Paused 상태 추가**   
Paused 상태일 때 타이머와 `progressView`가 멈추도록 구현했습니다.

- **stopTacker BarButtonItem 추가**    
오른쪽 상단 종료 버튼 아이템을 추가했습니다.   
추후 클릭 이벤트 발생 시, 한번 더 종료를 확인하는 alert창을 추가할 예정입니다.

- **TrackingMode 블럭 매치**   
스크롤된 크기를 이용해 현재 포커싱된 블럭의 인덱스를 구한 후,   
TrackingMode 진입 시 해당 블럭의 인덱스로 접근하는 기능을 추가했습니다.   

- **GroupSelectBarButtonItem 위치 변경**   
가운데 위치하고 있던 `groupSelectBarButtonItem`의 위치를 왼쪽 정렬했습니다.   
그 과정에서 시각 보정을 위해 왼쪽 `layoutMargin` 속성을 사용했습니다.   
[문제 해결 기록 : UIStackView에 ContentsInset 주기](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/30.md)

- **블럭 추가화면 작업명 TextField 글자수 제한 로직 추가**   
`UITextFieldDelegate`의 `shouldChangeCharactersIn` 메서드를 사용해 글자수 제한 로직을 추가했습니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/231484013-bff3254d-51d9-45f0-92ad-8aae75cd14d1.png">

---

<br>

### **Day 45 - 23.04.14**

- SelectForm Tap 제스처 추가 및 화면 연결

<img width="300" src="https://user-images.githubusercontent.com/113565086/232178664-59a41743-a52e-43fd-92bc-9cbfb66ce4c0.png">

---

<br>

### **Day 46 - 23.04.15**

- **블럭 추가 버튼 focusing 상태에서 trackingButton 비활성화**   
프로퍼티 옵저버를 활용해 blockIndex(현재 인덱스)일 때 `trackingButton`을 비활성화 했습니다.   

- **텍스트 붙여넣기 비활성화**   
기존 구현 방향은 최대 글자수 18자를 넘긴 상태로 붙여넣기 할 시, 18자만큼만 잘려 붙여지는 기능이었지만   
기능 구현에 어려움을 겪어 일정상 붙여넣기 비활성화 기능으로 대체했습니다.   
추후 업데이트 진행 예정입니다.   

<img width="300" src="https://user-images.githubusercontent.com/113565086/232209393-87321587-d12a-498b-8789-f4bc55763225.png">

---

<br>

### **Day 46 - 23.04.15**

- **CustomBottomModal 추가**   
아래에서 반만 올라오는 `CustomBottomModal`을 추가했습니다.   
애플에서 공식적으로 지원하는 `UISheetPresentationController`를 사용할 수도 있었지만,   
iOS 15.0 부터 지원하는 기능이기 때문에 해당 방법을 선택했습니다. [참고 레퍼런스](https://thecosmos.tistory.com/4)

- ConfirmButton 컴포넌트화

**+ 프로젝트 기간 점검**   
금일까지 블럭 추가에 필요한 모든 화면을 구성하는 것이 계획이었지만 달성하지 못했습니다.   
`BlockManager` 의 효과적인 설계를 위해 해당 기능개발 기간을 2일에서 7일로 연장하기로 결정했습니다. ~04.21   
전주 계획까지는 순조롭게 진행이 되었었지만 점점 커지다보니 개발 속도가 느려지고 있는 것이 주요한 이유로 예상됩니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/232316401-ea1c258e-ef05-4f4f-b582-5671d10863ef.png">

---

<br>

### **Day 48 - 23.04.17**

- **BlockManager 구조 변경(싱글톤)**   
화면 간 효과적인 업데이트를 위해 `BlockManager'를 싱글톤 구조로 변경했습니다.   
현재 블럭 검색은 배열의 앞부분부터 찾을 때까지 돌기 때문에 추후 더 효과적인 알고리즘 구현이 필요합니다.

- SelectGroupVIew TableView 기본값 선택

<img width="300" src="https://user-images.githubusercontent.com/113565086/232637830-77b2b851-15cf-45a8-bf95-f6c68652a8d0.png">

---

<br>

### **Day 50 - 23.04.19**

- ActionButton, ActionStackView 컴포넌트화  

<img width="300" src="https://user-images.githubusercontent.com/113565086/233085913-e5e678ed-075c-454d-b400-35de7611b452.png">

---

<br>

### **Day 52 - 23.04.21**

- **CreateGroup ConfirmBarButtonItem 커스텀**   
[문제 해결 기록 : UIBarButtonItem의 title font 커스텀하기](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/34.md)

- **그룹 전환 기능 추가**   
현재 CreateBlockView와 HomeView와 공유하며 사용하고 있기 때문에 클래스 내 분기처리가 필요합니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/233672788-a6f60046-5e70-4087-b059-b62985687259.png">

---

<br>

### **Day 54 - 23.04.23**

- **그룹 전환 기능 수정**   
createBlockViewController의 시점을 조정하여 그룹 전환 기능 수정 완료했습니다.

- SelectColor CollectionView 셋팅

- **ColorManager 생성**   
색상 선택을 위한 컬러 팔레트를 50개 추가하였습니다.

- Color 선택 시 업데이트

- **Group Color 사용**   
기존 블럭마다 개별 컬러를 가지고 있었지만, 그룹마다 컬러를 지정하는 것이    
더 효과적을 것으로 판단해 전체적인 구조를 개선함과 동시에 수정했습니다.

**+ 프로젝트 기간 점검**   
원래 일정대로라면 오늘 통계 페이지를 모두 완성했어야 합니다. 조정된 일정을 반영하였음에도 불구하고 기능 개발에 시간이 더 필요할 것으로 판단해   
데드라인을 늘리는 방법과, 기능 개발을 대폭 축소해 배포하는 단계로 나누어 선택이 필요합니다.    
첫 APP 개발이라 기능 개발에 소요되는 시간을 정확히 계산하지 못한게 아쉬움으로 남습니다.

<img width="300" src="https://user-images.githubusercontent.com/113565086/233845089-86e8aafc-4f03-4dce-9001-bb7772d9c95e.png">

---

<br>

### **Day 65 - 23.05.04**

**+ 프로젝트 기간 점검**   
개발 기간을 더 연장하게 되었습니다.   
목표로 두고 있던 애플 디벨로퍼 아카데미 지원서 작성 및 회사 프로젝트를 위해 전체 일정을 미루기로 했습니다.   
데드라인 일정을 번복하는 것은 좋지 않습니다. 이번 일을 계기로 이후 계획을 세울 때는 더욱 신중히 세우고자 합니다.

---

<br>

### **Day 70 - 23.05.09**

- **타이머 카운트 버그 수정**   
1800초(30분) 이상 부터 트래킹이 정상적으로 진행되지 않는 오류를 수정했습니다.

- **CustomDelegate 파일 생성**   
기존 클래스 위에 protocol 생성 후 관리하는 방식에서, CustomDelegate 파일을 생성해 하나로 관리하는 방식으로 변경했습니다.

- SelectColor 구현

- **TrackingButton 상태값 버그 수정**   
TrackingButton 활성화 문제로 그룹 전환 시 0번째 인덱스로 전환되도록 수정했습니다.

- **SFSymbol Manger 생성**   
현재 거의 모든 symbol을 가지고와 SymbolManager를 생성했습니다.
.fill 상태의 아이콘만 가지고 왔으며, 추후 카테고리별로 그룹핑 해 아이콘 제공 예정입니다.

- SelectIcon 구현

- CreateBlock BarButtonItem 추가

- **Create New Block 기능 추가**   
새 블럭 생성 기능을 추가했습니다. 또한 자잘한 trackingButton 활성화 오류를 수정했습니다.

<img width="300" src="https://github.com/thinkySide/Connecting-the-Stars/assets/113565086/d9d38fd2-a365-4f72-9c60-406a14365758">

---

<br>

### **Day 71 - 23.05.10**

- HomeView 블럭 터치 시 화면 전환 이벤트 추가   
블럭 터치 시, 해당 아이템으로 화면 전환이 되는 기능을 추가했습니다.   
또한 개별 블럭 터치 이벤트를 만들기 위해 포커싱 되지 않았을 때는 셀이 눌리지 않도록 구현해두었습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/128d0f01-ea04-4a38-a279-0c3ca4184505">

---

<br>

### **Day 72 - 23.08.05**

- 다시 프로젝트 시작   
회사 프로젝트를 마무리하고, 다시 개인 프로젝트로 복귀했습니다. 시간이 많이 지나 코드를 다시 천천히 뜯어보며 파악할 시간을 가졌습니다.

- **CoreData 구현**   
핵심 비즈니스 로직인 `Group`, `Block` 데이터를 저장하기 위한 CoreData를 구현하였습니다. 처음 구현해보는 기능이었기에 시행착오가 꽤나 길어졌지만, 관계형 설정을 통해 해결했습니다. 우선 기본적인 데이터를 읽고(READ) 생성하는(CREATE) 기능만을 구현해두었고, 추후 수정과 삭제 기능을 추가할 예정입니다.

[문제 해결 기록 : CoreData 저장이 안되는 문제](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/46.md)

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/3bf10332-7d94-4034-8348-d8ccd58ce9fd">

---

<br>

### **Day 73 - 23.08.06**

- **BlockCollectionViewCell 뒤집기 모드 구현**   
블럭을 삭제, 편집하기 위한 뒤집기 모드를 구현했습니다. 현재 클릭 시 셀의 UI를 업데이트 후 Closure를 이용한 버튼 연결까지 완료했습니다. 부드러운 전환을 위한 Alpha값을 이용한 애니메이션을 추가했습니다. 추후 CoreData와 연결해 삭제 및 편집 기능 추가 예정입니다.

<img width="300" src="https://github.com/thinkySide/BppleForImageData/assets/113565086/9ec2e980-4383-4614-8451-85e18f81827e">

---

<br>