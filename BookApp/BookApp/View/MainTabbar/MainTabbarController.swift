//
//  MainTabbarController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainTabbarController: UITabBarController {
    
    private let addButtonTapEvents = PublishSubject<Void>()
    private let searchViewController = SearchViewController()
    private let myBookViewController = MyBookViewController()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bind()
    }
    // UI 구성 (설정 변경, View 추가, 레이아웃 설정)
    private func setupUI() {
        searchViewController.tabBarItem.title = "검색 탭"
        myBookViewController.tabBarItem.title = "담은 책 리스트 탭"
        self.viewControllers = [searchViewController, myBookViewController]
    }
    
    // 바인딩
    private func bind() {
        // 마이북페이지에서 추가버튼 클릭 시 검색페이지로 이동 및 검색바 활성화
        myBookViewController.myBookCollectionView.addButtonEvents
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, event in
                owner.selectedIndex = 0
                owner.searchViewController.activeSearchbar()
            }.disposed(by: disposeBag)
    }

}

