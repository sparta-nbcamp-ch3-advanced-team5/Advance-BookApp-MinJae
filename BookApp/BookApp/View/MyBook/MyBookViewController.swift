//
//  MyBookViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit
import RxSwift

final class MyBookViewController: UIViewController {

    private let myBookCollectionView = BookListCollectionView(section: .myBook)
    private let viewModel = MyBookViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchMyBooks()
    }
    
    private func setupUI() {
        view.addSubview(myBookCollectionView)
        
        myBookCollectionView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        viewModel.myBooks
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe{ owner, books in
                owner.myBookCollectionView.apply(at: .myBook, to: books)
            }
            .disposed(by: disposeBag)
    }
}
