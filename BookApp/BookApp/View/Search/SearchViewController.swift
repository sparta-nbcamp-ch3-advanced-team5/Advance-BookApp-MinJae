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
    private let disposeBag = DisposeBag()
    private let viewModel = SearchViewModel()
    
    init() {
        self.searchResultView = BookListCollectionView(section: .search)
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
        searchBar.delegate = self
    }
    
    private func bind() {
        searchResultView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let book = self?.viewModel.item[indexPath.row]
                self?.present(BookDetailViewController(book: book!), animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchedBooks
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, books in
                owner.searchResultView.apply(at: .search, to: books)
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        viewModel.fetchBooks(query: text)
    }
}
