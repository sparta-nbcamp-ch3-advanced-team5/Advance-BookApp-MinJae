//
//  SearchViewController.swift
//  BookApp
//
//  Created by MJ Dev on 5/11/25.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class SearchViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let searchResultView: BookListCollectionView
    private let item: [Book] = [Book(title: "세이노의 가르침", author: "세이노", price: "14000")]
    private let disposeBag = DisposeBag()
    
    init() {
        self.searchResultView = BookListCollectionView(section: .search, item: item)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bind()
    }
    
    private func bind() {
        searchResultView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let book = self?.item[indexPath.row]
                self?.present(BookDetailViewController(book: book!), animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        [searchBar, searchResultView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(searchBar.snp.bottom)
        }
    }
}

