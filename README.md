# 🧱 DayBlock
하루 24개의 블럭을 가치있게 쌓아나가는 방법,   
DayBlock 데이블럭과 함께해요!

"내가 얼마나 생산성 있는 시간들을 보냈을까?"   

우리 모두는 하루를 다양한 시간으로 채워가고 있어요.   
그중 기록하고 싶은 시간들을 블럭으로 만들고 쌓아가다 보면   
노력과 열정의 흔적을 데이블럭에서 확인할 수 있을 거에요.   

[APP Store 링크](https://apps.apple.com/us/app/dayblock-%EB%8D%B0%EC%9D%B4%EB%B8%94%EB%9F%AD/id6474824210)
[Figma 디자인 링크](https://www.figma.com/file/1W0dsnAboHaLJt829E4ZwI/DayBlock-%EB%8D%B0%EC%9D%B4%EB%B8%94%EB%9F%AD?type=design&node-id=0%3A1&mode=design&t=ZbIwzUuW5BItmx6t-1)

<br>

## 📅 프로젝트 일정표
- 프로젝트 시작일 : `23.03.01(수)`
- 프로젝트 마감일 : `24.01.11(목)`

<br>

## ⭐️ 서비스 핵심 목표

- 하루 24개의 블럭을 어떻게 활용했는지 `직관적인 시각적 피드백` 전달하기
- `생산성 업무에 온전히 집중`할 수 있도록 핵심 정보 위주로 전달하기
- 어떤 생산성을 발휘했는지 `확인 및 동기부여`가 가능한 통계 리포트 제공하기

<br>

## 📝 기능 정의

### 핵심 기능
- 1시간=1블럭 / 30분=0.5블럭 단위로 생산성 트래킹 ✅
- 반복적으로 진행하는 생산성 작업을 블럭 템플릿으로 생성 및 등록 ✅
- 현재까지 생산한 블럭 저장 및 그룹/날짜별 통계 리포트 제공 ✅

### 추가 예정 기능
- 반복 블럭 시간 설정 후 Push 알림 발송 (습관 만들기에 도움주기)
- 블럭 생성 후 애니메이션 효과로 블럭 쌓기 (마이크로인터랙션 추가로 긍정적인 반응 이끌어내기) ✅
- 통계 리포트 내 황금블럭 전환율 보기 추가 (일반 블럭 및 생산선 블럭 구분으로 효율 계산) ✅
- 친구 추가를 이용한 활동 공유 (서로의 활동 공유로 동기부여 제공)

<br>

## 프로젝트 회고 - 24.01.12 작성   
대략 10개월간의 프로젝트가 끝이 났습니다. 사실 처음엔 이렇게 오래 걸릴 줄 몰랐습니다.(그도 그럴 것이 처음 일정표에는 3개월 만에 끝낼 거라 자신만만하게 작성해뒀었음,,) 개인 프로젝트였기에 날짜에 쫓기지 않았고, 추가하고 싶은 기능을 넣으며 재밌게 진행했지만 돌아보니 아쉬운 점도 분명 있던 것 같습니다. 프로젝트를 마무리하며 이러한 내용들을 복기할 수 있도록 회고를 작성해 보려 합니다.

첫 번째로 개발을 빠르게 시작해야겠다는 생각이 앞서, 기획을 소홀히 했던 부분이었습니다. UX/UI 디자이너로 활동하며 스스로에게 항상 강조했던 게 탄탄한 기획 부분이었는데, 정작 제가 개발을 진행하며 이를 소홀히 했던 게 아이러니하기도 한 것 같습니다. 콘셉트나 로직들이 "이런 느낌으로 가자~" 정도로 정해져 있다 보니 초반에는 전혀 문제없이 진행되는 듯했지만, 규모가 조금씩 커지자 "이런 부분은 이렇게 하면 안 됐었네,,"라며 다시 돌아가 수정하는 일이 빈번해졌습니다. 개발자의 입장에서 다시 한번 기획의 중요성을 느낄 수 있었습니다.

두 번째로 디자인 패턴의 중요성을 뒤늦게 깨달은 점이었습니다. 처음엔 규모가 큰 편이 아니기에 MVC 패턴으로 어느 정도 관리가 될 수 있겠다고 생각했었습니다. 하지만 개발을 진행할수록 학문적으로만 배웠던 MVC 패턴의 문제점을 직접 마주하게 되었고(ViewController가 비대해짐), 나중엔 기존 메서드 수정 및 신규 메서드 추가에도 애를 먹게 되었습니다. 또한 현재 코드에는 싱글톤이 여러 개 생성되어 수정 및 테스트가 어렵고, 모듈화도 적절히 되어 있지 않은 문제점도 존재합니다. 첫 프로젝트였기에 일단은 개발해보자! 라는 마음에 좋은 코드를 작성하지 못한 것에 대한 아쉬움이 있지만, 그만큼 발생할 수 있는 문제점을 피부로 느낄 수 있었고 앞으로도 실수하지 않을 좋은 레퍼런스가 될 것이라 믿고있습니다.

앞으로의 계획은 우선 사용자 피드백을 받아 버그 수정 및 UX를 개선하려 합니다. (수많은 트래킹, 블럭, 그룹 관리를 위한 테스트를 해봤지만 언제나 버그는 존재했기에,,!) 이와 함께 조금씩 모듈화 및 RxSwift를 이용한 MVVM 패턴으로 리팩토링을 진행할 계획입니다. 물론 네트워킹, BM 도입 등 기능 추가도 정말 하고 싶지만,, 근본적인 제 기능을 다 했을 때 건드리는 게 옳다고 생각하기에 시간을 두고 천천히 한 걸음씩 나아가려 합니다.

마지막으로 느낀 점을 종합 정리해 보자면, 정말 옛날부터 하고 싶었던 "내 생각을 구체화시켜 서비스로 출시해 보겠다"라는 뜻을 이뤄 감회가 새롭습니다. 이게 제 개발 인생의 시작점이자 밑거름이 된다 생각하고 성장해나가고 싶습니다. 감사합니다!

---

<br>

## 🧑‍💻 개발 일지   
Day01 ~ Day30일은 기획 및 UI디자인을 진행했습니다.

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

### **Day 74 - 23.08.07**

- **BlockEntity 삭제, 수정 기능 추가**   
CoreData와 연동되어 BlockEntity를 삭제할 수 있는 기능을 추가했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/41412dd4-2670-41a4-9452-6c44cc0abf5a">

---

<br>

### **Day 75 - 23.08.08**

- **BlockEntity 삭제 확인 팝업 추가**   
UX 향상을 위한 Block 삭제 전 확인 팝업을 추가했습니다.


<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/41a1d123-11b4-4c3b-947f-e9461cf4b590">

---

<br>

### **Day 76 - 23.08.13**

- **블럭 그룹 간 이동 기능 개발**   
A그룹에서 B그룹으로 이동할 수 있도록 코어데이터를 조작해 기능을 구현했습니다.

- **Group 컨트롤을 위한 CustomUIMenu 추가**
Group 생성, 편집, 삭제 기능 화면으로의 이동을 위한 CustomUIMenu 컴포넌트를 추가했습니다. 애플이 지원하는 기존의 UIMenu를 사용할 수도 있었지만, 서비스의 전체적인 톤앤매너와 맞지 않다고 판단해 Custom으로 제작했습니다.

<img width="300" src="https://github.com/thinkySide/Cheat-Sheet/assets/113565086/dae1d58b-00ea-455a-bb74-580114d8eba6">

---

<br>

### **Day 77 - 23.08.17**

- **그룹 편집 기능 추가**   
그룹 삭제 및 편집이 가능한 페이지를 추가했습니다. 고민해볼 사항은 현재 그룹 삭제를 하기 위해서는 Depth가 불필요하게 깊어진다고 판단되어 추후 수정해볼 예정입니다.      

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/0b85afb4-bb0e-438f-b9ad-8a4d56a55956">

---

<br>

### **Day 78 - 23.08.21**

- **CollectionView 스크롤 문제 해결**   
Select는 되지만, Scroll이 되지 않았던 문제를 해결했습니다. View 업데이트와 관련된 이슈로 `viewDidLayoutSubviews` 메서드를 이용해 해결했습니다.

    [문제 해결 기록 : UICollectionView 선택된 item으로 스크롤이 안되는 문제](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/35.md)

- 그룹 편집 시, UI 업데이트 되지 않던 문제 수정   
NotificationCenter를 활용해 그룹이 업데이트 되는 시점에 맞춰 HomeViewController의 UI를 업데이트 해주었습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/6c784f0b-70c4-46d9-b2bb-1f6e39d0ea22">

---

<br>

### **Day 79 - 23.08.23**

- **TrackingBlock LongPressGesture 애니메이션 추가**   
트래킹이 끝나고 지금까지 생산한 블럭을 저장하는 이벤트인 `LongPressGesture Animation`을 추가했습니다. 하지만 처음 사용하는 사용자에게 해당 이벤트는 직관적이지 않다고 판단해 초기 온보딩 진행 및 안내 버튼을 추가할 예정입니다.

    [문제 해결 기록 : LongPress Animation 만들기](https://github.com/thinkySide/Cheat-Sheet/blob/main/Solution/50.md)

- 그룹 수정 시 블럭 생성 UI 화면 업데이트가 되지 않는 버그 수정   
`NotificationCenter`를 활용해 블럭 생성 화면에서 UI 업데이트가 되지 않는 버그를 수정했습니다.


<img width="300" src="https://github.com/thinkySide/Cheat-Sheet/assets/113565086/92639e36-cbc8-4e16-992e-09e1ba747d7e">

---

<br>

### **Day 80 - 23.08.28**

- **그룹 내 동일한 작업명 블럭 있을 시 생성 및 이동 제한**   
블럭 식별을 위해 그룹 내 동일한 작업명의 블럭의 생성을 제한시키는 규칙을 만들었고, 이를 로직에 적용했습니다. 사용자에게 동일한 작업명은 사용이 불가능 하다는 피드백을 빠르게 주고자 TextField 입력 중 출력되도록 구현했습니다.

- **동일한 그룹명 생성 및 편집 제한**   
그룹 식별을 위해 동일한 그룹명 생성을 제한시키는 규칙을 만들었고, 이를 로직에 적용했습니다. 블럭 생성 제한 경험과 동일하게 구현했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/506552dc-ae3d-4f2a-bea8-dbc8588b4420">

---

<br>

### **Day 81 - 23.08.31**

- **아이콘, 컬러 선택 CollectionView Inset 조정**   
작은 화면을 가진 디바이스에서 모서리쪽 테두리가 잘리는 현상을 수정했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/506552dc-ae3d-4f2a-bea8-dbc8588b4420">

---

<br>

### **Day 82 - 23.09.05**

- **Tracking 타임 특정**   
0초부터 86,400초를 기준으로 현재 어떤 블럭을 트래킹할지 설정하고 관리하는 TrackingManager 싱글톤 클래스를 구현했습니다.

- **Tracking Animation 추가**   
현재 트래킹 되고 있다는 것을 시각적으로 알리기 위해, 1초 간격으로 무한히 반복하는 애니메이션을 추가했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/bb7f290c-1b3f-4b1b-94bc-222a742257f0">

---

<br>

### **Day 83 - 23.09.12**

- **TrackingCompleteView 퍼블리싱**   
트래킹 완료 화면 UI 디자인 및 퍼블리싱을 완료했습니다.


<img width="300" src="https://github.com/thinkySide/Cheat-Sheet/assets/113565086/cdac6ee1-5e9b-4063-82fd-a0166413092b">

---

<br>

### **Day 84 - 23.09.27**

- **TrackingData CoreData 로직 구현**   
트래킹 데이터 저장을 위한 로직을 재구성했습니다. Group - Block - TrackingDate - TrackingTime 순으로 이어진 데이터 타입을 생성하고, 이를 CRUD 할 수 있게 구현했습니다. 가장 시간이 오래 걸린 구현 작업이었던 것 같습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/47a67a92-d26c-43ee-bd28-6324e9f57786b">

---

<br>

### **Day 85 - 23.10.18**

- **트래킹 모드 테스트를 위한 세팅**   
30분 단위로 트래킹이 되고 해당 시간에 맞게 트래킹 데이터가 저장되다보니 이를 테스트 하기 위해 30분 이상의 시간이 매번 소요되었습니다. 하여 간단한 애니메이션 및 동작 테스트를 원활히 할 수 있도록 테스트 데이터 셋과 시간을 설정해 빠른 테스트를 가능하도록 구현했습니다.

- **백그라운드 및 앱 종료되었을 때 트래킹 모드 기능 구현**   
백그라운드 및 앱이 종료되었을 때도 트래킹 시간이 갈 수 있도록 기능을 구현했습니다. 백그라운드는 기존 데이터가 날아가지 않아 비교적 쉬웠지만, 앱이 종료되었을 때는 UserDefaults 데이터를 사용해 설정해주어야할 부분이 많아 예상 보다 개발 시간이 늘어났습니다.

- **그룹 간  이동 기능 구현**   
그룹 리스트 페이지에서 Drag&Drop 기능으로 위치 변경 기능을 구현했습니다. TableView의 Delegate 메서드를 이용해 쉽게 구현할 수 있었지만, 코어데이터의 순서도 변경해줘야하는 로직을 위해 order 프로퍼티를 추가했고, Request를 날릴 때 `NSSortDescriptor`를 사용하여 오름차순 정렬 로직을 적용했습니다.

- **관리소 UI 디자인**   
그룹 및 블럭의 정보를 확인하고 순서, 정보 등을 수정할 수 있는 관리소 페이지의 UI 디자인을 완료했습니다.

<img width="400" src="https://github.com/thinkySide/DayBlock/assets/113565086/06f8a4f5-9e5c-4c39-896c-5e1da7643871">

---

<br>

### **Day 86 - 23.10.19**

- **ManageBlockViewController 퍼블리싱**   
블럭 및 그룹 관리 페이지를 위한 퍼블리싱을 완료했습니다. UITableView의 Header, Footer 기능을 활용하여 구현했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/b79981e6-a1e6-4e04-a5f3-aeec140bab6c">

---

<br>

### **Day 87 - 23.10.23**

- **ManageBlockViewController 셀 이동 로직 구현**   
블럭 셀을 이동해 순서를 바꾸는 기능을 구현했습니다. CoreData에서 순서를 보장해주지 않아 order 프로퍼티를 만들어 업데이트해주는 식으로 진행했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/8ab5a30b-8a3f-4f27-8492-5a4abdefb048">

---

<br>

### **Day 88 - 23.12.06**

- **RepositoryViewController 구현**   
외주 개발을 마친 후 다시 본격적인 개인 APP 작업에 들어갔습니다. 해당 날짜에 어떤 트래킹 블럭을 생산했는지 확인이 가능한 `RepositoryViewController`를 구성했습니다. `FSCalendar`를 사용해 달력 기능을 구현했습니다. 각각의 셀 커스텀을 위해 여러가지 메서드들을 활용했습니다. 추가로 `SummaryView` 배치했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/e94133fc-d58e-41c7-b554-6fd78ee744a1">

---

<br>

### **Day 89 - 23.12.08**

- **RepositoryViewController 트래킹 데이터 연결 완료**   
트래킹 데이터에 따라 UI 업데이트를 진행했습니다. 해당 날짜의 트래킹 데이터를 시작 시간이 빠른 순서 정렬로 출력하였고, 생산한 블럭 타입의 개수마다 색상을 적용해 시각화했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/f0075d66-8c4b-4935-aaa8-83fc9358e347">

---

<br>

### **Day 90 - 23.12.13**

- **MyPageViewController 퍼블리싱**   
`MyPageViewController`를 생성했습니다. 전체 생산량, 오늘 생산량, 연속 생산량을 시각화해 보여주고 각종 설정 및 정보를 확인 할 수 있는 TableView를 생성했습니다. 두개 이상의 `UITableViewDelegate`를 두개의 테이블에 적용하기 위해 `tag` 속성을 사용해 구분했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/6c5f3625-b7c9-42be-87a8-4191f7a81444">

---

<br>

### **Day 91 - 23.12.14**

- **초기화 기능 구현**   
모든 그룹, 블럭, 트래킹 데이터를 삭제하는 초기화 기능을 구현했습니다. 위험도가 높은 행동인만큼, 총 3번 탭을 통해 초기화 할 수 있게 UX를 구성했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/b0923e7e-109e-4156-ad95-cf86f5ddf59e">

- **이메일 문의 기능 구현**   
각종 문의 제보를 받기 위한 이메일 문의 기능을 구현했습니다. 기본 메일 앱 사용 불가 시, 경고 메시지를 출력하도록 구현했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/94848405-86b3-442a-a9cf-53b08381ea29">

- **햅틱 피드백 구현**   
UX 향상을 위해 각종 성공, 경고 및 중요 탭 이벤트에 햅틱(진동) 이벤트를 구현했습니다.

- **온보딩 UI 디자인**   
APP 초기 설치 시 사용 방법 안내를 위한 온보딩 페이지 디자인을 완료했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/08084b90-d0fb-4ac2-ab97-335eed4c27c7">

---

<br>

### **Day 92 - 23.12.18**

- **온보딩 로직 구현**   
온보딩은 최초 1회 실행되며, 도움말에서 해당 내용을 다시 열람할 수 있게 구현했습니다.

- **트래킹 완료 애니메이션 업데이트**   
기존 단조로웠던 애니메이션을 여러가지 효과를 더해 사용에 재미를 더했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/b265f2ec-e98e-4403-920c-bed50f4209ca">

---

<br>

### **Day 93 - 24.01.03**

- **백그라운드 환경에서의 트래킹 로직 수정**   
APP이 종료되었을 때와, background로 전환되었을 때 트래킹이 정상적으로 수집되지 않는 현상을 수정했습니다. 기존 실제 시간에 맞춘 테스트 환경을 개선하고자, 디바이스의 날짜 및 시간 설정을 조정해 테스트 하는 방식으로 변경했습니다.

- **트래킹 보드 업데이트**   
기존 트래킹 보드 로직은 완전히 변경했습니다. "18:00", "18:30"의 실제 시간 형식으로 트래킹 보드를 조정했던 기존 방식에서, 3500, 8700과 같은 현재 일자를 기준으로 한 초를 쓰는 방식으로 변경했고, 직관적인 업데이트를 위해 메서드를 변경 및 추가했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/a635c8a6-c9b9-4597-902a-28229af2ec63">

---

<br>

### **Day 94 - 24.01.05**

- **SFSymbol 섹션 추가**   
원활한 아이콘 선택을 위해 애플이 제공하는 카테고리에 맞춰 섹션 기능을 추가했습니다.

- **백그라운드 + 일시정지 환경에서 트래킹 중단 기능 추가**   
백그라운드에 나간 상태에서 일시정지 시간이 12시간 이상 경과 시, 트래킹을 종료하는 기능을 추가했습니다.

- **기본 그룹 수정 기능 추가**   
기존 기본 그룹은 완전 수정 불가로 지정해놓았지만, 자유로운 커스텀을 위해 그룹명 및 색상을 바꿀 수 있도록 업데이트했습니다.

- **Grayscale 컬러 세트 추가**   
Grayscale 컬러 세트를 추가했습니다.

- **타임라인뷰 점유율 및 총 생산량 라벨 추가**   
선택한 날짜의 총 생산량과 하루 기준 몇퍼센트의 블럭을 생산했는지 표시해주는 라벨을 추가했습니다.

<img width="300" src="https://github.com/thinkySide/DayBlock/assets/113565086/d679c6ad-3352-4d49-a936-3deb68944f0a">

---

<br>

### **Day 95 - 24.01.11**

- **개인정보처리방침 작성**  
앱스토어 심사 제출을 위해서는 개인정보처리방침이 필수적으로 필요하다 하여 구글링을 통해 작성, Github에 업로드했습니다.   
[Privacy Policy 개인정보처리방침](https://github.com/thinkySide/DayBlock/blob/main/PrivacyPolicy.md)

- **심사 제출 및 승인 완료**   
개인정보처리방침, 앱스크린샷, 각종 정보를 기입 후 심사를 제출했고, 대략 5~6시간 만에 승인이 되었습니다.