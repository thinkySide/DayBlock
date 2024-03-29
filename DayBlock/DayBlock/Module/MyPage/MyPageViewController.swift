//
//  MyPageViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/12/23.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    let viewManager = MyPageView()
    let trackingData = TrackingDataStore.shared
    let settingData = SettingDataStore()
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    // MARK: - Setup Method
    private func setupUI() {
        
        /// 지금까지 생산한 총 생산량 + 오늘의 생산량 + 연속일
        let totalTodayBurningView = viewManager.totalTodayBurningView
        
        let totalOutput = trackingData.totalOutput()
        totalTodayBurningView.totalInfoIcon.valueLabel.value.text = totalOutput
        
        let todayOutput = trackingData.todayAllOutput()
        totalTodayBurningView.todayInfoIcon.valueLabel.value.text = todayOutput
        
        let burningCount = trackingData.burningCount()
        totalTodayBurningView.burningInfoIcon.valueLabel.value.text = burningCount
    }
    
    private func setupTableView() {
        let usageTableView = viewManager.usageSettingView.tableView
        usageTableView.register(SettingViewTableViewCell.self, forCellReuseIdentifier: SettingViewTableViewCell.cellID)
        usageTableView.dataSource = self
        usageTableView.delegate = self
        usageTableView.tag = 1
        
        let devloperTableView = viewManager.developerSettingView.tableView
        devloperTableView.register(SettingViewTableViewCell.self, forCellReuseIdentifier: SettingViewTableViewCell.cellID)
        devloperTableView.dataSource = self
        devloperTableView.delegate = self
        devloperTableView.tag = 2
    }
    
    private func setupNavigation() {
        configureBackButton()
        
        // 네비게이션바의 Appearance를 설정
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationController?.navigationBar.tintColor = .white
        navigationItem.scrollEdgeAppearance = navigationBarAppearance
        navigationItem.standardAppearance = navigationBarAppearance
        navigationItem.compactAppearance = navigationBarAppearance
        navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension MyPageViewController: UITableViewDataSource & UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 { return settingData.usageData().count }
        else if tableView.tag == 2 { return settingData.developerData().count }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewTableViewCell.cellID, for: indexPath) as? SettingViewTableViewCell else {
            return UITableViewCell()
        }
        
        // 일반 설정
        if tableView.tag == 1 {
            let setting = settingData.usageData()[indexPath.row]
            cell.label.text = setting.name
        }
        
        // 개발자 설정
        if tableView.tag == 2 {
            let setting = settingData.developerData()[indexPath.row]
            cell.label.text = setting.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 셀 클릭 시, 바로 비활성화되는 애니메이션 추가
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 셀 클릭 이벤트 설정
        // if tableView.tag == 1 && indexPath.row == 0 { shareAPPCellTapped() }
        if tableView.tag == 1 && indexPath.row == 0 { helpCellTapped() }
        if tableView.tag == 1 && indexPath.row == 1 { emailContactCellTapped() }
        if tableView.tag == 1 && indexPath.row == 2 { resetAllDataCellTapped() }
        
        if tableView.tag == 2 && indexPath.row == 0 { developerInfoCellTapped() }
        if tableView.tag == 2 && indexPath.row == 1 { openLicenseCellTapped() }
    }
}

// MARK: - Cell Touch Event Method
extension MyPageViewController {
    
    /// 도움말 셀 버튼 탭 시 호출되는 메서드입니다.
    func helpCellTapped() {
        let onboardingVC = OnboardingViewController(mode: .help)
        onboardingVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
    /// APP 공유 셀 버튼 탭 시 호출되는 메서드입니다.
    func shareAPPCellTapped() {
        let activityViewController = UIActivityViewController(activityItems: ["https://github.com/thinkySide/DayBlock"], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [
            .addToReadingList, .assignToContact, .saveToCameraRoll, .markupAsPDF
        ]
        self.present(activityViewController, animated: true)
    }
    
    /// 초기화 셀 버튼 탭 시 호출되는 메서드입니다.
    func resetAllDataCellTapped() {
        let resetVC = ResetDataViewController()
        resetVC.delegate = self
        resetVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(resetVC, animated: true)
    }
    
    /// 개발자 정보 셀 버튼 탭 시 호출되는 메서드입니다.
    func developerInfoCellTapped() {
        let developerVC = DeveloperInfoViewController()
        developerVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(developerVC, animated: true)
    }
    
    /// 오픈소스 셀 버튼 탭 시 호출되는 메서드입니다.
    func openLicenseCellTapped() {
        let openLicenseVC = OpenLicenseViewController()
        openLicenseVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(openLicenseVC, animated: true)
    }
}

// MARK: - ResetDataViewControllerDelegate
extension MyPageViewController: ResetDataViewControllerDelegate {
    
    /// 데이터 초기화 완료 후 실행되는 메서드입니다.
    func resetDataViewController(didFinishResetData: ResetDataViewController) {
        showToast(toast: viewManager.resetToastView, isActive: true)
        Vibration.success.vibrate()
    }
}
