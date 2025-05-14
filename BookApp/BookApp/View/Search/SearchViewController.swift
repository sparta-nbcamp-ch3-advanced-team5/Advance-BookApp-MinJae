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
    private let popupView = SearchPopupView()
    
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
        // 검색결과 컬렉션 뷰의 셀 선택 이벤트 바인딩
        searchResultView.rx.itemSelected
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, indexPath in
                var book: Book?
                if indexPath.section == 0 {
                    book = owner.viewModel.recentBooksArray[indexPath.row]
                } else if indexPath.section == 1 {
                    book = owner.viewModel.fetchedBooksArray[indexPath.row]
                }
                if book == nil { return }
                let detailVC = BookDetailViewController(book: book!)
                detailVC.delegate = self
                owner.present(detailVC, animated: true)
                owner.viewModel.appendRecentBook(&book!)
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchedBooks
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { owner, books in
                owner.searchResultView.apply(at: .search, to: books)
            })
            .disposed(by: disposeBag)
        
        viewModel.recentBooks
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe { owner, books in
                let fetchedBooks = owner.viewModel.fetchedBooksArray
                let recentBooks = owner.viewModel.recentBooksArray
                owner.searchResultView.apply(at: .recent, to: fetchedBooks, recentItem: recentBooks)
            }.disposed(by: disposeBag)
    }

    private func setupUI() {
        [searchBar, searchResultView, popupView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(searchBar.snp.bottom)
        }
        
        popupView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(5)
        }
    }
    
    func activeSearchbar() {
        searchBar.becomeFirstResponder()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let text = searchBar.text else { return }
        viewModel.fetchBooks(query: text)
    }
}

extension SearchViewController: BookDetailViewControllerDelegate {
    func addButtonTapped(book: Book) {
        popupView.configureLabelText(title: book.title)
        popupView.isHidden = false
        popupView.snp.updateConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        UIView.animate(withDuration: 2.0) { [unowned self] in
            self.view.layoutIfNeeded()
        } completion: { bool in
            self.popupView.isHidden = true
            self.popupView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
        }
        
    }
}
